# 绿珠 · LuZhu.nvim

> 红树摇歌扇，绿珠飘舞衣。

> 君不见绿珠潭水流东海，绿珠红粉沉光彩。

绿珠，既取中国古代美人之名，也寄寓绿意凝成珍宝的温润与珍贵。以低饱和潭绿、玉青与珠白，呈现安静清晰的 Neovim 深色主题。

![绿珠预览](assets/luzhu.png)

需要 **Neovim 0.10+** 与支持真彩色的终端，无插件依赖。

- 绢灰注释斜体，珠白变量明亮，碧玉关键字加粗。
- 支持 Treesitter、LSP 语义高亮、诊断、diff 与终端色。
- 适配 Telescope、nvim-cmp、blink.cmp、Neo-tree、nvim-tree、which-key、gitsigns 等插件。
- 支持透明背景、非活动窗口变暗与高亮覆盖。

## 安装

使用 lazy.nvim：

```lua
{
  "wsgggws/LuZhu.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("luzhu")
  end,
}
```

使用 LazyVim 时，注册主题插件，并设置：

```lua
return {
  { "wsgggws/LuZhu.nvim", lazy = true },
  { "LazyVim/LazyVim", opts = { colorscheme = "luzhu" } },
}
```

本地安装可将仓库名替换为 `dir = vim.fn.expand("~/github/LuZhu.nvim")`。
安装后也可执行 `:colorscheme luzhu`。主题会自动启用 `termguicolors`。

## 配置

`setup()` 可省略；自定义时在加载主题之前调用：

```lua
require("luzhu").setup({
  transparent = false,
  dim_inactive = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
  },
  palette = {},
  highlights = {},
})
vim.cmd.colorscheme("luzhu")
```

例如关闭注释斜体、覆盖高亮：

```lua
require("luzhu").setup({
  styles = { comments = { italic = false } },
  highlights = function(p)
    return { CursorLineNr = { fg = p.jade, bold = true } }
  end,
})
```

修改配置后重新执行 `:colorscheme luzhu`。完整选项见 `:help luzhu`。

## 色彩

取潭水的深静、珠玉的温润与罗绢钗饰的光泽，为每种颜色赋予与绿珠相衬的名字。

| 名称 | 角色 | 色值 |
| --- | --- | --- |
| 潭绿 | 正文背景 | `#1D3229` |
| 深潭 | 深层背景 | `#182A22` |
| 碧潭 | 浮层背景 | `#243B2E` |
| 翠影 | 当前行 | `#293F30` |
| 翠帷 | 选区 | `#41634A` |
| 珠白 | 正文与变量 | `#DCE8D5` |
| 绢灰 | 注释 | `#A6A5A2` |
| 碧玉 | 关键字 | `#89C79B` |
| 玉青 | 函数 | `#99CEBE` |
| 绢黄 | 参数 | `#D7C5A0` |
| 柳芽 | 类型 | `#A8C38B` |
| 碧绫 | 字符串 | `#C6D8A3` |
| 钗金 | 数字与常量 | `#C5AD78` |
| 红粉 | 错误 | `#D29580` |
| 金缕 | 警告 | `#D1B77F` |
| 水碧 | 信息 | `#9BBDB5` |
| 青佩 | 提示 | `#A2BC8E` |

潭绿衬珠白，绢灰收敛注释，碧玉点明关键字；玉青函数、绢黄参数与碧绫字符串各有层次，钗金与红粉作少量点染。完整色板与配置键见 [palette.lua](lua/luzhu/palette.lua)。

## 其他配色

Alfred 使用独立身份，`LuZhu Dark Large` 可与 `QingShan Dark Large` 同时保留。

[extras/](extras/README.md) 提供 WezTerm、tmux、fzf、bat、Git diff（delta）、Alfred 与 slides 的同色板主题文件，随色板同步更新。导入与重载方法见各工具说明。已配置本机统一切换函数时，执行 `switch_all_theme luzhu`；更新配色文件后执行 `switch_all_theme luzhu --refresh`。个人安装与切换脚本在各自配置目录维护。

## 预览

```sh
nvim -u scripts/preview.lua
```

开发与截图方法见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可

[MIT](LICENSE)
