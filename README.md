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

| 名称 | 角色 | 色值 | 色样 |
| --- | --- | --- | --- |
| 潭绿 | 正文背景 | `#1D3229` | ![#1D3229](assets/swatches/bg.svg) |
| 深潭 | 深层背景 | `#182A22` | ![#182A22](assets/swatches/bg_dark.svg) |
| 碧潭 | 浮层背景 | `#243B2E` | ![#243B2E](assets/swatches/bg_float.svg) |
| 翠影 | 当前行 | `#293F30` | ![#293F30](assets/swatches/bg_highlight.svg) |
| 翠帷 | 选区 | `#41634A` | ![#41634A](assets/swatches/bg_visual.svg) |
| 珠白 | 正文与变量 | `#DCE8D5` | ![#DCE8D5](assets/swatches/fg.svg) |
| 绢灰 | 注释 | `#A6A5A2` | ![#A6A5A2](assets/swatches/comment.svg) |
| 碧玉 | 关键字 | `#89C79B` | ![#89C79B](assets/swatches/keyword.svg) |
| 玉青 | 函数 | `#99CEBE` | ![#99CEBE](assets/swatches/jade.svg) |
| 绢黄 | 参数 | `#D7C5A0` | ![#D7C5A0](assets/swatches/sand.svg) |
| 柳芽 | 类型 | `#A8C38B` | ![#A8C38B](assets/swatches/bamboo.svg) |
| 碧绫 | 字符串 | `#C6D8A3` | ![#C6D8A3](assets/swatches/string.svg) |
| 钗金 | 数字与常量 | `#C5AD78` | ![#C5AD78](assets/swatches/gold.svg) |
| 红粉 | 错误 | `#D29580` | ![#D29580](assets/swatches/red.svg) |
| 金缕 | 警告 | `#D1B77F` | ![#D1B77F](assets/swatches/yellow.svg) |
| 水碧 | 信息 | `#9BBDB5` | ![#9BBDB5](assets/swatches/blue.svg) |
| 青佩 | 提示 | `#A2BC8E` | ![#A2BC8E](assets/swatches/hint.svg) |

潭绿衬珠白，绢灰收敛注释，碧玉点明关键字；玉青函数、绢黄参数与碧绫字符串各有层次，钗金与红粉作少量点染。完整色板与配置键见 [palette.lua](lua/luzhu/palette.lua)。

## 其他配色

其他工具的配色文件见 [extras/](extras/README.md)。

## 预览

```sh
nvim -u scripts/preview.lua
```

开发与截图方法见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可

[MIT](LICENSE)
