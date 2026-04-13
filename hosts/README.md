# hosts.nix 可用选项（简版）

这个文件说明 [hosts/hosts.nix](hosts.nix) 里每个主机条目可配置的字段。

## 顶层结构

每个主机建议按下面结构声明：

```nix
{
  my-host = {
    system = "x86_64-linux";
    runtime = {
      profile = "desktop";
      homeManager = {
        enable = true;
      };
      features = [ "plasma" "browsers" ];
      users = [ "ccicnce113424" ];
    };
    hostCfg = {
      locale = "CN";
      cpu.intel = true;
      gpu.nvidia = true;
      vm.enable = false;
      vm.vbox = false;
      vm.vmware = false;
    };
  };
}
```

## 字段说明

### system

- 类型: string
- 当前使用值: `"x86_64-linux"`
- 用途: 选择系统架构，驱动 `withSystem` 和 nixpkgs 实例化。

### runtime.profile

- 类型: enum string
- 当前可选: `"desktop"` / `"minimal"` / `"vm-test"`
- 含义: 选择 profile 栈。

### runtime.homeManager

- `enable` (bool)
- 含义: 控制是否接入 home-manager。

### runtime.features

可用 feature 列表项（string）：

- `"plasma"`
- `"image"`
- `"gaming"`
- `"obs"`
- `"vbox"`
- `"virtManager"`
- `"wine"`
- `"browsers"`

说明：浏览器栈仅在 features 里显式包含 `"browsers"` 时启用；`"plasma"` 不会自动追加浏览器。

### runtime.users

- 类型: list of enum
- 当前 enum 值: `[ "ccicnce113424" ]`
- 含义: 启用哪些用户模块与 home 配置。

### hostCfg

`hostCfg` 是主机能力/事实声明，会映射到 `config.hostCfg`。

可用项：

- `locale` (enum)
  - 当前可选: `"CN"`
- `cpu.intel` / `cpu.amd` (bool)
- `gpu.nvidia` / `gpu.amdgpu` / `gpu.nouveau` (bool)
- `vm.enable` (bool)
- `vm.vbox` / `vm.vmware` (bool, 通常配合 `vm.enable = true`)

## 兼容性提示

- `profile = "..."` 顶层字段目前不再驱动模块行为（历史遗留）。
- 推荐统一使用 `runtime.profile = "..."`。
