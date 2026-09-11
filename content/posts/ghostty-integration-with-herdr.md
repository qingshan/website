+++
title = "集成 Ghostty 和 Herdr 打造 AI Agent 终端"
date = 2026-09-10T20:30:00-07:00
type = "post"
description = "将 Ghostty 和 Herdr 深度集成到自己的工作流之中，用一个终端承载所有的 AI 编程 Agent，整合各自的优点，打造出一个顺心应手、高效率、可定制的 Agent 终端。"
[taxonomies]
tags = ["macOS", "Linux", "Terminal", "Ghostty", "Herdr"]
+++

Ghostty 是一个使用平台原生 UI 和 GPU 加速渲染的跨平台终端仿真器：在 macOS 上使用 Swift 和 Metal，在 Linux 上使用 GTK。它专注于性能、原生体验以及开箱即用的合理默认值。

Herdr 是一个面向 AI 编程 Agent 的终端工作区管理器（terminal workspace manager）。和其它终端复用软件一样，它由一个后台 server 持有真正的终端进程，client 连接上来负责渲染，因此 detach、关闭终端窗口或者断开 SSH 都不会中断里面正在运行的进程。与 tmux 不同的是，Herdr 是鼠标优先、并且能感知 Agent 的：它会识别运行在窗格里的编码 Agent，并在侧边栏展示每个 Agent 的状态。

把 Ghostty 和 Herdr 深度集成到自己的工作流之中：Ghostty 启动的时候直接 `exec herdr`，快捷键则通过 herdr 的 prefix 发送给它，让 Ghostty 负责窗口与渲染、Herdr 负责工作区与 Agent，两者配合构建出一个顺心应手、高效率、可定制的 AI Agent 终端。

> **强烈推荐**直接使用我的 [dotfiles](https://github.com/qingshan/dotfiles) 仓库来搭建整套环境。本文用到的 Ghostty、Herdr 配置，以及配套的 Alacritty、tmux、fish、字体和脚本都整理在里面，克隆之后执行 `make` 就能完成安装，macOS 桌面环境再执行一次 `make desktop` 即可。

## 特性

此次深度集成，拥有 Ghostty 和 Herdr 各自的优点。拥有以下特性：
- 快速便捷的、人体工学设计的快捷键。
- 鼠标优先：窗格、选项卡、工作区、分割线都可以点击、拖拽和右键操作。
- Agent 感知：侧边栏实时展示每个 Agent 的状态（`working` / `blocked` / `done`）。
- 所有新建的窗格、选项卡使用当前的工作目录。
- 会话持久化：detach 或者关闭窗口之后，Agent 继续在后台运行。
- 本地会话与 SSH 远程会话一视同仁。
- 脚本与 Agent 可以通过 CLI 和 socket API 以编程方式驱动。
- 灵活的脚本定制化。

## 安装

可以通过各种包管理器来安装 Ghostty 和 Herdr，并安装配套所需要的字体和工具。Ghostty 支持 macOS 和 Linux，Herdr 支持 macOS、Linux 和 Windows。目前已在 macOS 顺畅使用，以下安装步骤以 macOS 为平台。

### 一键安装（强烈推荐）

与其一个个手动安装和配置，**强烈推荐**直接使用我的 [dotfiles](https://github.com/qingshan/dotfiles) 仓库。它已经把 Ghostty、Herdr 以及配套的字体、fish、脚本和快捷键全部整理好，只需要三条命令：

```bash
git clone https://github.com/qingshan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

macOS 桌面环境再执行一次桌面相关的安装：

```bash
make desktop
```

下面的步骤是手动安装的详细过程，如果你想自己动手，或者只打算安装其中的一部分，可以继续往下看。

### Ghostty 安装

```bash
brew install --cask ghostty
```

### Herdr 安装

```bash
curl -fsSL https://herdr.dev/install.sh | sh
herdr
```

Herdr 也支持 Homebrew、mise 和 Nix 安装，细节可以参考[官方安装文档](https://herdr.dev/docs/install/)。

### 字体安装

我选择打过 Nerd Font 字体补丁的 JetBrains Mono 作为终端的默认字体。

```bash
brew install font-jetbrains-mono
brew install font-jetbrains-mono-nerd-font
```

### Fish 安装

我选择 fish 作为终端的默认交互式 Shell。（可选，可修改配置使用其他 Shell）

```bash
brew install fish
```

### 配套脚本安装

快捷命令、项目菜单等弹出窗口依赖一些可执行的脚本文件，放到 PATH 路径中即可。可以参考我的脚本目录：[`bin`](https://github.com/qingshan/dotfiles/tree/main/bin)。

## 配置

下面的配置都来自我的 [dotfiles](https://github.com/qingshan/dotfiles) 仓库，**强烈推荐**直接使用仓库里的版本，而不是手工复制粘贴，这样可以第一时间拿到后续的更新。

### Ghostty 配置

Ghostty 默认使用的配置文件路径 `~/.config/ghostty/config`，使用简单的 `key = value` 格式。
我正在使用的配置文件：[config](https://github.com/qingshan/dotfiles/blob/main/ghostty/config)。
运行下面的命令可以把我的配置文件自动下载并使用：

```bash
curl -fLo ~/.config/ghostty/config --create-dirs \
    https://raw.githubusercontent.com/qingshan/dotfiles/main/ghostty/config
```

### Herdr 配置

Herdr 默认使用的配置文件路径 `~/.config/herdr/config.toml`。
我正在使用的配置文件：[config.toml](https://github.com/qingshan/dotfiles/blob/main/herdr/config.toml)。
运行下面的命令可以把我的配置文件自动下载并使用：

```bash
curl -fLo ~/.config/herdr/config.toml --create-dirs \
    https://raw.githubusercontent.com/qingshan/dotfiles/main/herdr/config.toml
```

## 使用

绑定快捷键使用 <kbd>Command</kbd>、<kbd>Command</kbd> + <kbd>Shift</kbd> 或者 <kbd>Command</kbd> + <kbd>Alt</kbd> 作为修饰键。部分快捷键与 iTerm2.app 和 Terminal.app 的绑定对应，部分快捷键与我的 i3 的绑定对应。与[集成 Alacritty 和 Tmux](@/posts/alacritty-integration-with-tmux.md) 保持同一套肌肉记忆，只是分割窗格、切换工作区等少数按键的语义有所不同。

### 基本操作

新建
- <kbd>Command</kbd> + <kbd>T</kbd> 新建选项卡
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> 新建选项卡，并从命令列表中选择要执行的命令
- <kbd>Command</kbd> + <kbd>N</kbd> 新建工作区
- <kbd>Command</kbd> + <kbd>D</kbd> 上下分割窗格
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> 左右分割窗格

关闭
- <kbd>Command</kbd> + <kbd>W</kbd> 关闭窗格
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> 关闭选项卡
- <kbd>Command</kbd> + <kbd>Q</kbd> 分离（detach）当前的 herdr 会话

访问窗格
- <kbd>Command</kbd> + <kbd>B</kbd> 切换回上一次访问的窗格
- <kbd>Command</kbd> + <kbd>H</kbd> 访问左边的窗格
- <kbd>Command</kbd> + <kbd>J</kbd> 访问下面的窗格
- <kbd>Command</kbd> + <kbd>K</kbd> 访问上面的窗格
- <kbd>Command</kbd> + <kbd>L</kbd> 访问右边的窗格

访问选项卡
- <kbd>Command</kbd> + <kbd>1</kbd> 到 <kbd>Command</kbd> + <kbd>9</kbd> 按数字切换选项卡
- <kbd>Command</kbd> + <kbd>[</kbd> 切换到上一个选项卡
- <kbd>Command</kbd> + <kbd>]</kbd> 切换到下一个选项卡

访问工作区与 Agent
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>[</kbd> 切换到上一个工作区
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>]</kbd> 切换到下一个工作区
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> 到 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>9</kbd> 聚焦侧边栏中第 1 到 9 个 Agent

### 布局操作

调整窗格大小
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> 向左边的窗格推进
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>J</kbd> 向下面的窗格推进
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>K</kbd> 向上面的窗格推进
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>L</kbd> 向右边的窗格推进

交换窗格
- <kbd>Command</kbd> + <kbd>Alt</kbd> + <kbd>H</kbd> 与左边的窗格交换位置
- <kbd>Command</kbd> + <kbd>Alt</kbd> + <kbd>J</kbd> 与下面的窗格交换位置
- <kbd>Command</kbd> + <kbd>Alt</kbd> + <kbd>K</kbd> 与上面的窗格交换位置
- <kbd>Command</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd> 与右边的窗格交换位置

缩放窗格
- <kbd>Command</kbd> + <kbd>Return</kbd> 或者 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>Return</kbd> 缩放当前窗格。

### 查找与跳转

- <kbd>Command</kbd> + <kbd>F</kbd>：进入复制模式，从上往下的方向查找关键词。
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd>：进入复制模式，从下往上的方向查找关键词。
- <kbd>Command</kbd> + <kbd>G</kbd>：grep 项目里的文件内容，选择结果后用 vim 打开对应的文件与行。
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>G</kbd>：打开窗格选择器，跳转到指定的窗格。

### 命令菜单

- <kbd>Command</kbd> + <kbd>R</kbd>：弹出项目菜单，用单键触发 build / run / test 等命令，输出到右侧窗格。
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd>：从完整的项目命令列表中选择命令，并在右侧窗格执行。
- <kbd>Command</kbd> + <kbd>P</kbd>：弹出应用菜单。
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>：与应用菜单相同。

### 字体操作

- <kbd>Command</kbd> + <kbd>=</kbd>：调整更大的字体
- <kbd>Command</kbd> + <kbd>-</kbd>：调整更小的字体
- <kbd>Command</kbd> + <kbd>0</kbd>：恢复默认大小的字体

### 复制与粘贴

- <kbd>Command</kbd> + <kbd>C</kbd>：复制选中的文本。
- <kbd>Command</kbd> + <kbd>V</kbd>：从系统剪贴板粘贴。
- <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd>：从选区粘贴。

开启 `copy-on-select` 之后，用鼠标选中文本就会自动复制到系统剪贴板，和 tmux 的鼠标模式一致。

### 滚动与选择

- <kbd>Command</kbd> + <kbd>Up</kbd> 或者 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>Up</kbd>：跳到上一个命令提示符。
- <kbd>Command</kbd> + <kbd>Down</kbd> 或者 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>Down</kbd>：跳到下一个命令提示符。
- <kbd>Command</kbd> + <kbd>PageUp</kbd> / <kbd>PageDown</kbd>：上翻 / 下翻一页。
- <kbd>Command</kbd> + <kbd>Home</kbd> / <kbd>End</kbd>：滚动到顶部 / 底部。
- <kbd>Shift</kbd> + 方向键、<kbd>Shift</kbd> + <kbd>PageUp</kbd> / <kbd>PageDown</kbd>、<kbd>Shift</kbd> + <kbd>Home</kbd> / <kbd>End</kbd>：调整文本选区。

### 快速终端

- <kbd>Command</kbd> + <kbd>Esc</kbd>：全局呼出或者隐藏快速终端（quick terminal），即使 Ghostty 不在前台也可以使用。

### Herdr 快捷键前缀

Herdr 的快捷键前缀默认是 `Ctrl-b`，我把它重新定义成了 <kbd>Ctrl</kbd> + <kbd>\\</kbd>，和 tmux 保持一致。上面的快捷键都是把前缀 <kbd>Ctrl</kbd> + <kbd>\\</kbd> 加上动作键发送给 Herdr，因此不需要真的按前缀。
在 Herdr 里直接按 <kbd>Ctrl</kbd> + <kbd>\\</kbd> 再按 <kbd>?</kbd> 可以查看当前生效的全部绑定。

## 配置说明

### 配置终端类型

```ini
term = xterm-256color
```

### 配置字体

指定使用 JetBrains Mono 字体，字体大小设置为 14 点数。

```ini
font-family = Jetbrains Mono
font-size = 14
font-thicken = true
font-thicken-strength = 255
font-feature = +zero,-liga,-calt
```

`font-thicken` 打开字体的加粗渲染，`+zero` 使用带斜杠的 0，`-liga` 关闭连字，`-calt` 关闭上下文替换。

### 配置窗口

```ini
fullscreen = non-native
initial-window = true
quit-after-last-window-closed = true
window-save-state = never
confirm-close-surface = false
```

`fullscreen = non-native` 使用不独占桌面的全屏模式，效果类似 Alacritty 的 `SimpleFullscreen`。

### 配置 Shell

Ghostty 启动的时候直接 `exec herdr`，把整个终端的生命周期都交给 Herdr。

```ini
shell-integration = none
initial-command = /bin/zsh -lc 'exec herdr'
```

这里关闭了 Ghostty 的 shell 集成，因为交互式 Shell 由 Herdr 里的 fish 提供，不需要 Ghostty 再注入一遍。

### 配置 macOS

```ini
macos-option-as-alt = true
```

把 Option 键作为 Alt（Meta）键使用，所有以 <kbd>Alt</kbd> 和 <kbd>Alt</kbd> + <kbd>Shift</kbd> 为修饰键的按键都映射为 Esc 前缀键码。

### 配置快速终端

```ini
quick-terminal-position = bottom
quick-terminal-autohide = false
quick-terminal-animation-duration = 0
```

```ini
keybind = global:super+escape=toggle_quick_terminal
```

快速终端固定在屏幕底部，没有动画，切换的时候不会有闪烁。`global:` 前缀表示这是一个全局快捷键。想让快速终端覆盖全屏应用，可以再执行：

```bash
defaults write com.mitchellh.ghostty TerminalDefaultLevel -int 3
```

### 配置快捷键映射

因为 Herdr 的很多常用操作都是 `prefix` 加一个按键，所以直接用 Ghostty 的 `keybind` 把 <kbd>Command</kbd> 组合映射成对应的控制字符，就可以绕过手动输入前缀。

```ini
keybind = clear
keybind = super+t=text:\x1cc
keybind = super+d=text:\x1c"
```

`keybind = clear` 会清空 Ghostty 的全部默认绑定，避免与自定义绑定冲突。`\x1c` 就是 Herdr 的前缀 `Ctrl+\`，`\x1cc` 相当于按下前缀再按 `c`（新建选项卡），`\x1c"` 相当于按下前缀再按 `"`（上下分割窗格）。

甚至 Vim 指令：

```ini
keybind = super+s=text:\x1b:w\x0a
keybind = super+shift+s=text:\x1b:wa\x0a
```

### Herdr 配置说明

Herdr 的配置文件相对简单，主要是按键绑定、界面和命令弹窗。

```toml
[keys]
prefix = "ctrl+\\"
detach = "prefix+d"

# workspace
new_workspace = "prefix+shift+w"
previous_workspace = "prefix+shift+["
next_workspace = "prefix+shift+]"
focus_agent = "prefix+shift+1..9"

# tab
switch_tab = "prefix+1..9"
previous_tab = "prefix+p"
next_tab = "prefix+n"
new_tab = "prefix+c"

# pane
split_horizontal = "prefix+%"
split_vertical = "prefix+\""
close_pane = "prefix+x"
last_pane = "prefix+;"

focus_pane_left = "prefix+h"
focus_pane_down = "prefix+j"
focus_pane_up = "prefix+k"
focus_pane_right = "prefix+l"
```

`prefix` 定义快捷键前缀，`detach` 定义分离会话的按键，下面的分组分别对应工作区、选项卡和窗格的操作。Herdr 的按键命名和 tmux 基本一致，所以两边可以用同一套肌肉记忆。

除了按键，还可以用 `[[keys.command]]` 定义弹出窗口，把自定义脚本挂到快捷键上：

```toml
[[keys.command]]
key = "prefix+shift+g"
type = "popup"
command = "tmux-grep | xargs -r tmux-vim"
description = "grep files"
width = "80%"
height = "80%"
```

界面相关的配置放在 `[ui]` 里：

```toml
[ui]
agent_panel_sort = "spaces"
pane_borders = true
hide_tab_bar_when_single_tab = true
confirm_close = false

window_title = "{hostname}: {workspace}"
status_indicators = "symbols"
```

`agent_panel_sort = "spaces"` 让侧边栏按工作区分组排列 Agent，`window_title` 则把主机名和工作区显示在窗口标题上。

## 奖励

### 在两个终端之间切换

我把 Ghostty 和 Alacritty 做成了互补的关系：Ghostty 跑 Herdr 用来做 AI Agent 终端，Alacritty 跑 tmux 作为默认终端；平时用 Ghostty 的快速终端随手开 shell。

- 在 Ghostty 里按 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> 打开 Alacritty。
- 在 Alacritty 里按 <kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> 打开 Ghostty。
- 按 <kbd>Command</kbd> + <kbd>Esc</kbd> 呼出 Ghostty 的快速终端。

### 会话持久化与远程

Herdr 由后台 server 持有终端进程，所以分离会话之后 Agent 会继续运行。

```bash
herdr                      # 启动或连接默认会话
herdr --remote devbox      # 通过 SSH 连接远程 Herdr
herdr server stop          # 真正停止整个 server
```

### Agent 集成

Herdr 会自动识别窗格里的编码 Agent，并在侧边栏展示状态。安装对应集成之后，还可以获得生命周期状态或者原生的会话恢复能力：

```bash
herdr integration install claude
herdr integration status
herdr agent list
```

## 后续

- [ ] 把 Agent 的状态同步到 macOS 的通知中心，blocked 的时候直接提醒。
- [ ] 用 Herdr 的 socket API 写一个脚本，一键为当前工作区拉起常用的 Agent 组合。

## 参考资料

- [我的 dotfiles 仓库](https://github.com/qingshan/dotfiles)
- [Herdr 官方网站](https://herdr.dev/)
- [Herdr 概念模型](https://herdr.dev/docs/concepts/)
- [Herdr 键盘操作](https://herdr.dev/docs/keyboard/)
- [Herdr 配置参考](https://herdr.dev/docs/configuration/)
- [Ghostty 官方网站](https://ghostty.org/)
- [集成 Alacritty 和 Tmux 打造超级终端](@/posts/alacritty-integration-with-tmux.md)
