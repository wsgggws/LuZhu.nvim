# /// script
# requires-python = ">=3.10"
# dependencies = ["pynvim>=0.5,<0.7", "Pillow>=10,<13"]
# ///
"""Render Neovim's real RGB UI grid, including syntax and diagnostic fixtures.

Run: uv run scripts/screenshot.py
Only this optional development script needs Python packages. The theme does not.
"""

import argparse
import math
from pathlib import Path

import pynvim
from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent.parent


def find_font(explicit, candidates):
    if explicit:
        return Path(explicit)
    for candidate in candidates:
        if Path(candidate).is_file():
            return Path(candidate)
    raise SystemExit("No suitable font found; pass --font and --cjk-font.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "assets" / "luzhu.png")
    parser.add_argument("--font", help="Monospaced TTF/TTC font path")
    parser.add_argument("--cjk-font", help="Chinese TTF/TTC font path")
    parser.add_argument("--columns", type=int, default=144)
    parser.add_argument("--rows", type=int, default=44)
    parser.add_argument("--font-size", type=int, default=18)
    args = parser.parse_args()
    mono = find_font(args.font, [
        "/System/Library/Fonts/Menlo.ttc",
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
        "C:/Windows/Fonts/consola.ttf",
    ])
    cjk = find_font(args.cjk_font, [
        "/System/Library/Fonts/STHeiti Light.ttc",
        "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
        "/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc",
        "C:/Windows/Fonts/msyh.ttc",
    ])
    fonts = {(False, False): ImageFont.truetype(str(mono), args.font_size)}
    # Font collections (e.g. Menlo) contain real bold/italic faces.
    for index in range(16):
        try:
            face = ImageFont.truetype(str(mono), args.font_size, index=index)
        except OSError:
            break
        style = face.getname()[1].lower()
        fonts[("bold" in style, "italic" in style or "oblique" in style)] = face
    chinese = ImageFont.truetype(str(cjk), args.font_size)
    regular = fonts[(False, False)]
    cell_width = math.ceil(regular.getlength("M"))
    ascent, descent = regular.getmetrics()
    cell_height = ascent + descent + 7
    margin = 24
    cells = []
    attrs = {0: {}}
    default_fg, default_bg = 0xD9E2D1, 0x202F2B
    cursor = None
    captured = False
    nvim = pynvim.attach("child", argv=[
        "nvim", "--embed", "--clean", "-u", str(ROOT / "scripts" / "preview.lua"),
    ])

    def notify(name, args):
        nonlocal cells, default_fg, default_bg, cursor, captured
        if name == "luzhu_capture":
            captured = True
            nvim.stop_loop()
            return
        if name == "luzhu_timeout":
            nvim.stop_loop()
            return
        if name != "redraw":
            return
        for event, *updates in args:
            for update in updates:
                if event == "default_colors_set":
                    default_fg, default_bg = update[:2]
                elif event == "hl_attr_define":
                    attrs[update[0]] = update[1]
                elif event == "grid_resize" and update[0] == 1:
                    _, width, height = update
                    cells = [[(" ", 0)] * width for _ in range(height)]
                elif event == "grid_clear" and update[0] == 1:
                    cells = [[(" ", 0)] * len(row) for row in cells]
                elif event == "grid_line" and update[0] == 1:
                    _, row, col, values, *_ = update
                    highlight = 0
                    for value in values:
                        text = value[0]
                        if len(value) > 1:
                            highlight = value[1]
                        repeat = value[2] if len(value) > 2 else 1
                        for _ in range(repeat):
                            cells[row][col] = (text, highlight)
                            col += 1
                elif event == "grid_scroll" and update[0] == 1:
                    _, top, bottom, left, right, rows, cols = update
                    old = [row[:] for row in cells]
                    for row in range(top, bottom):
                        for col in range(left, right):
                            sr, sc = row + rows, col + cols
                            cells[row][col] = old[sr][sc] if top <= sr < bottom and left <= sc < right else (" ", 0)
                elif event == "grid_cursor_goto" and update[0] == 1:
                    cursor = update[1:3]

    try:
        nvim.ui_attach(args.columns, args.rows, rgb=True, ext_linegrid=True)
        nvim.exec_lua("""
          local channel = ...
          vim.defer_fn(function()
            vim.cmd('redraw!')
            vim.rpcnotify(channel, 'luzhu_capture')
          end, 250)
          vim.defer_fn(function() vim.rpcnotify(channel, 'luzhu_timeout') end, 5000)
        """, nvim.channel_id)
        nvim.run_loop(None, notify)
        if not captured or not cells:
            raise RuntimeError("Neovim did not produce a complete UI frame")
        errors = nvim.exec_lua("return vim.v.errmsg")
        if errors:
            raise RuntimeError(f"Neovim preview failed: {errors}")
    finally:
        try:
            nvim.command("qa!")
        except (EOFError, OSError):
            pass
        nvim.close()

    def color(value):
        return f"#{value:06x}"

    picture = Image.new("RGB", (args.columns * cell_width + margin * 2, args.rows * cell_height + margin * 2), color(default_bg))
    draw = ImageDraw.Draw(picture)
    # Background pass precedes text so wide glyphs are not painted over.
    for row, line in enumerate(cells):
        for col, (_, highlight) in enumerate(line):
            attr = attrs.get(highlight, {})
            fg, bg = attr.get("foreground", default_fg), attr.get("background", default_bg)
            if attr.get("reverse"):
                fg, bg = bg, fg
            x, y = margin + col * cell_width, margin + row * cell_height
            draw.rectangle((x, y, x + cell_width - 1, y + cell_height - 1), fill=color(bg))
    for row, line in enumerate(cells):
        for col, (text, highlight) in enumerate(line):
            if not text:
                continue
            attr = attrs.get(highlight, {})
            fg, bg = attr.get("foreground", default_fg), attr.get("background", default_bg)
            if attr.get("reverse"):
                fg, bg = bg, fg
            x, y = margin + col * cell_width, margin + row * cell_height
            face = chinese if any(ord(c) > 0x2E7F for c in text) else fonts.get((bool(attr.get("bold")), bool(attr.get("italic"))), regular)
            draw.text((x, y + ascent + 2), text, font=face, fill=color(fg), anchor="ls")
            special = color(attr.get("special", fg))
            if attr.get("underline"):
                draw.line((x, y + cell_height - 4, x + cell_width, y + cell_height - 4), fill=special)
            if attr.get("undercurl"):
                points = [(x + offset, y + cell_height - 4 + (offset % 4 < 2)) for offset in range(cell_width + 1)]
                draw.line(points, fill=special)
            if attr.get("strikethrough"):
                draw.line((x, y + cell_height // 2, x + cell_width, y + cell_height // 2), fill=color(fg))
    if cursor:
        row, col = cursor
        x, y = margin + col * cell_width, margin + row * cell_height
        draw.rectangle((x, y, x + cell_width - 1, y + cell_height - 1), outline=color(default_fg))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    picture.save(args.output)
    print(f"Saved Neovim RGB grid: {args.output} ({picture.width}x{picture.height})")


if __name__ == "__main__":
    main()
