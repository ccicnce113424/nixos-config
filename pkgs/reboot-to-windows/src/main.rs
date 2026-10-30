#![no_main]
#![no_std]

use uefi::prelude::*;
use uefi::runtime::{self, ResetType, VariableAttributes, VariableVendor};
use uefi::{CStr16, Status};

const WINDOWS_BOOT_MANAGER: &CStr16 = uefi::cstr16!("Windows Boot Manager");

const UPPERCASE_DIGITS: &[u8; 16] = b"0123456789ABCDEF";
const LOWERCASE_DIGITS: &[u8; 16] = b"0123456789abcdef";

/// `Boot####` variable name as UCS-2, including the trailing NUL.
fn boot_variable_name(id: u16, uppercase: bool) -> [u16; 9] {
    let mut name = [0u16; 9];
    name[..4].copy_from_slice(&(*b"Boot").map(u16::from));

    let digits = if uppercase {
        UPPERCASE_DIGITS
    } else {
        LOWERCASE_DIGITS
    };
    for (index, shift) in [12, 8, 4, 0].into_iter().enumerate() {
        name[4 + index] = u16::from(digits[usize::from((id >> shift) & 0xf)]);
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

    units
        .by_ref()
        .zip(WINDOWS_BOOT_MANAGER.to_u16_slice().iter().copied())
        .all(|(actual, expected)| actual == expected)
        && units.next() == Some(0)
}

fn find_windows_boot_option() -> Option<u16> {
    let (order, _) =
        runtime::get_variable_boxed(uefi::cstr16!("BootOrder"), &VariableVendor::GLOBAL_VARIABLE)
            .ok()?;

    let (chunks, _) = order.as_chunks::<2>();
    for chunk in chunks {
        let id = u16::from_le_bytes(*chunk);

        for uppercase in [true, false] {
            let buffer = boot_variable_name(id, uppercase);
            let Ok(name) = CStr16::from_u16_with_nul(&buffer) else {
                continue;
            };
            let Ok((option, _)) =
                runtime::get_variable_boxed(name, &VariableVendor::GLOBAL_VARIABLE)
            else {
                continue;
            };

            if is_windows_boot_manager(&option) {
                return Some(id);
            }
        }
    }

    None
}

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize uefi helpers");

    uefi::println!("reboot-to-windows: looking for a \"Windows Boot Manager\" entry...");

    let Some(target) = find_windows_boot_option() else {
        uefi::println!("reboot-to-windows: no firmware entry named \"Windows Boot Manager\".");
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

    uefi::println!("reboot-to-windows: BootNext=0x{target:04X}, resetting the system.");
    runtime::reset(ResetType::WARM, Status::SUCCESS, None)
}
