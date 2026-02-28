# MistPlayer

MistPlayer 是一个为 Arch Linux / Wayland / Hyprland 设计的本地媒体播放器 MVP，目标是“克制、长期可用、低学习成本”的播放体验：

- 雾白半透明材质（compositor 支持 blur 时自动获得磨砂效果）
- 海报感构图（主视觉 + 控制核心 + 次级信息区）
- Qt 6 + QML + Qt Multimedia 原生技术栈

## 设计概念（实现对应）

- **Hyprland 玻璃感**：应用窗口透明背景 + 半透明雾白层；若系统提供 blur，背景自然磨砂；若不提供，仍是可读的雾白界面。
- **Apple / 工业设计秩序**：统一圆角系统、低噪点边框、层级清晰、控件密度克制。
- **东方留白与海报节奏**：左侧主视觉与播放核心，右侧安静的队列与最近打开，保留呼吸空间。

## 功能（MVP）

- 打开本地音频/视频文件
- 播放 / 暂停 / 上一首 / 下一首
- 进度条拖动
- 音量控制
- 播放队列
- 最近打开
- 拖拽文件到窗口打开
- 常用快捷键（Open / Space / Ctrl+Left / Ctrl+Right）

## Arch Linux 依赖安装（pacman）

```bash
sudo pacman -S --needed base-devel cmake ninja gcc qt6-base qt6-declarative qt6-multimedia qt6-wayland qt6-svg qt6-tools
```

## 构建

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

## 运行

```bash
./build/mistplayer
```


## 使用 makepkg -sfci 一步安装（推荐 Arch）

在项目根目录执行：

```bash
makepkg -sfci
```

说明：

- 当前 `PKGBUILD` 已改为从**当前目录本地 Git 源**打包（`git+file://$startdir`），因此可以直接在本仓库里 `makepkg -sfci`。
- `-s` 自动安装缺失依赖；`-f` 强制重打包；`-c` 构建后清理；`-i` 构建成功后安装。

## Wayland / Hyprland 建议

- 在 Hyprland 中为该窗口启用 blur（按你的 hyprland.conf 规则）。
- 即使未启用 blur，MistPlayer 也会以半透明雾白材质显示，不退化为纯硬色块。

## 项目结构

```text
.
├── CMakeLists.txt
├── PKGBUILD
├── README.md
├── assets/icons/
├── qml/
│   ├── Main.qml
│   ├── components/
│   └── theme/Theme.qml
└── src/
    ├── main.cpp
    ├── playercontroller.{h,cpp}
    └── playlistmodel.{h,cpp}
```
