return {
    "lewis6991/gitsigns.nvim",
    init = function()
        vim.keymap.set('n', '<leader>go', function()
            local file = vim.api.nvim_buf_get_name(0)
            local line = vim.api.nvim_win_get_cursor(0)[1]
            local notify_err = function(msg)
                vim.schedule(function()
                    vim.notify(msg, vim.log.levels.ERROR)
                end)
            end
            if file == '' then
                notify_err('buffer has no file')
                return
            end
            local name = vim.fs.basename(file)
            local dir = vim.fs.dirname(file)
            vim.system(
                { 'git', 'ls-files', '--error-unmatch', name },
                { cwd = dir },
                function(out)
                    if out.code ~= 0 then
                        notify_err(('%s is not tracked in git'):format(name))
                        return
                    end
                    vim.system(
                        { 'gh', 'browse', ('%s:%d'):format(name, line) },
                        { cwd = dir },
                        function(gh_out)
                            if gh_out.code ~= 0 then
                                notify_err(gh_out.stderr)
                            end
                        end
                    )
                end
            )
        end, { desc = "Open line in GitHub" })
    end,
    opts = {
        on_attach = function(bufnr)
            local gs = require('gitsigns')
            local map = function(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end
            map('n', '<leader>gn', function() gs.nav_hunk('next') end, { desc = "Next git hunk" })
            map('n', '<leader>gN', function() gs.nav_hunk('prev') end, { desc = "Prev git hunk" })
        end
    }
}
