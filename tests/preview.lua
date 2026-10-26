-- Run: nvim --headless -u scripts/preview.lua -c 'luafile tests/preview.lua'
-- Exercise the standalone preview without a Tree-sitter parser.
vim.treesitter.start = function()
  error("preview test: parser intentionally unavailable")
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, err = xpcall(function()
      assert(vim.g.colors_name == "qingshan", "preview colorscheme")
      assert(vim.bo.filetype == "lua", "preview filetype detection")
      assert(vim.bo.syntax == "lua", "Vim syntax fallback")
      assert(vim.fn.synIDattr(vim.fn.synID(16, 1, 1), "name") ~= "", "Vim syntax actually highlights code")
      assert(#vim.api.nvim_list_wins() == 2, "code and palette windows")
      assert(#vim.diagnostic.get(0) == 3, "diagnostic fixtures")
    end, debug.traceback)
    if not ok then
      io.stderr:write(err .. "\n")
      vim.cmd("cquit 1")
    else
      io.stdout:write("QingShan preview: Vim syntax fallback passed\n")
      vim.cmd("qa!")
    end
  end,
})
