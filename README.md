# ImmortalWrt 多设备固件自动编译项目

[![编译 ImmortalWrt 多设备固件](https://github.com/gitshang5018/Build-ImmortalWrt-Multi-Device/actions/workflows/build.yml/badge.svg)](https://github.com/gitshang5018/Build-ImmortalWrt-Multi-Device/actions/workflows/build.yml)

这是一个基于 GitHub Actions 的 ImmortalWrt 固件自动编译项目，旨在为多款主流路由设备提供高性能、高定制化的开源固件。

## 🚀 支持设备

目前已适配并支持以下五款核心设备的中文显示与自动编译：

| 设备 ID | 中文显示名称 | 处理器架构 | 说明 |
| :--- | :--- | :--- | :--- |
| `ax6600` | **雅典娜AX6600** | IPQ60xx | 京东云二代顶级旗舰 |
| `jdc_ax1800` | **亚瑟AX1800** | IPQ60xx | 京东云初代旗舰 |
| `n5105` | **X86** | x86_64 | 软路由及工控机通用 |
| `mt7621` | **歌华链** | MT7621 | 经典主流刷机神器 |
| `r619ac` | **竞斗云2.0** | IPQ40xx | 性价比极高的全能路由 |
| `wyse3040` | **wyse3040** | x86_64 | 瘦客户机专用 |

## ✨ 项目特点

- **全自动构建**：利用 GitHub Actions 实现云端编译，无需本地搭建环境。
- **中文化标识**：在编译界面与 Release 分发页面均采用友好的中文设备名称。
- **适配驱动优化**：包含针对 MT7621 WiFi 启动修复、网络加速自动适配等脚本。
- **高频更新**：自动集成最新版本的固件源码及热门插件包。
- **自动化发布**：编译完成后自动清理旧 Release 并分发最新的固件产物。

## 🛠️ 如何使用

### 1. 编译固件
1. 进入本仓库的 **Actions** 标签页。
2. 在左侧选择 `编译 ImmortalWrt 多设备固件`。
3. 点击右侧的 `Run workflow`。
4. 在下拉列表中选择您要编译的特定设备，或选择 `all` 针对所有设备进行编译。

### 2. 下载固件
编译完成后，可在仓库顶部的 **Releases** 栏目找到对应设备的最新版本进行下载。

## 📁 目录结构

- `.github/workflows/`: 包含构建（build.yml）和发布（release.yml）的逻辑。
- `configs/`: 存放各设备的 `.config` 编译配置文件。
- `.github/scripts/`: 存放用于驱动适配、日志分析和环境修复的增强脚本。

## ⚖️ 声明

- 本项目基于开源项目 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 构建。
- 请在遵守相关法律法规的前提下使用固件。编译产生的固件仅供测试和学习使用，因刷机导致的任何硬件损失由使用者自行承担。

---
**Build with ❤️ by [gitshang5018](https://github.com/gitshang5018)**