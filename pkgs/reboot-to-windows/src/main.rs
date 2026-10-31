#![no_main]
#![no_std]

use uefi::prelude::*;
use uefi::runtime::{self, ResetType, VariableAttributes, VariableVendor};
use uefi::{CStr16, Status};

const WINDOWS_BOOT_MANAGER: &str = "Windows Boot Manager";

fn boot_variable_name(id: u16) -> [u16; 9] {
    const HEX_DIGITS: &[u8; 16] = b"0123456789abcdef";

    let mut name = [0u16; 9];
    for (slot, byte) in name[..4].iter_mut().zip(b"Boot") {
        *slot = u16::from(*byte);
    }
    for (i, slot) in name[4..8].iter_mut().enumerate() {
        let shift = 12 - (i * 4);
        *slot = u16::from(HEX_DIGITS[usize::from((id >> shift) & 0xf)]);
    }
    name
}

fn is_windows_boot_manager(option: &[u8]) -> bool {
    // EFI_LOAD_OPTION: u32 attributes, u16 file path length, then the
    // NUL-terminated UCS-2 description.
    const OFFSET: usize = 6;

    let Some(rest) = option.get(OFFSET..) else {
        return false;
    };

    let (chunks, _) = rest.as_chunks::<2>();
    let mut units = chunks.iter().map(|chunk| u16::from_le_bytes(*chunk));

    // Keep the expected string on the left of `zip`: when it is exhausted,
    // `units` is not advanced, so the NUL check below still sees the
    // terminator. (The other order consumes the NUL and breaks the check.)
    WINDOWS_BOOT_MANAGER
        .encode_utf16()
        .zip(units.by_ref())
        .all(|(expected, actual)| expected == actual)
        && units.next() == Some(0)
}

fn find_windows_boot_option() -> Option<u16> {
    // BootOrder is a UINT16 array; 64 bytes covers 32 entries.
    let mut order_buf = [0u8; 64];
    let Ok((order, _)) = runtime::get_variable(
        uefi::cstr16!("BootOrder"),
        &VariableVendor::GLOBAL_VARIABLE,
        &mut order_buf,
    ) else {
        return None;
    };

    let (chunks, _) = order.as_chunks::<2>();
    for chunk in chunks {
        let id = u16::from_le_bytes(*chunk);
        let buffer = boot_variable_name(id);

        let Ok(name) = CStr16::from_u16_with_nul(&buffer) else {
            continue;
        };

        // Windows Boot Manager entries are typically a few hundred bytes.
        let mut option_buf = [0u8; 1024];
        let Ok((option, _)) =
            runtime::get_variable(name, &VariableVendor::GLOBAL_VARIABLE, &mut option_buf)
        else {
            continue;
        };

        if is_windows_boot_manager(option) {
            return Some(id);
        }
    }

    None
}

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize uefi helpers");

    uefi::println!("reboot-to-windows: looking for a \"{WINDOWS_BOOT_MANAGER}\" entry...");

    let Some(target) = find_windows_boot_option() else {
        uefi::println!("reboot-to-windows: no firmware entry named \"{WINDOWS_BOOT_MANAGER}\".");
        return Status::NOT_FOUND;
    };

    let attributes = VariableAttributes::NON_VOLATILE
        | VariableAttributes::BOOTSERVICE_ACCESS
        | VariableAttributes::RUNTIME_ACCESS;

    if let Err(err) = runtime::set_variable(
        uefi::cstr16!("BootNext"),
        &VariableVendor::GLOBAL_VARIABLE,
        attributes,
        &target.to_le_bytes(),
    ) {
        uefi::println!("reboot-to-windows: failed to write BootNext: {err:?}");
        return Status::DEVICE_ERROR;
    }

    uefi::println!("reboot-to-windows: BootNext=0x{target:04x}, resetting the system.");
    runtime::reset(ResetType::WARM, Status::SUCCESS, None)
}
