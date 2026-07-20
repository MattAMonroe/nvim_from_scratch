-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
        { "<Leader>e", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    },
    opts = {
        close_if_last_window = true,
        enable_diagnostics = false,
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
            commands = {
                open = function(state)
                    local fs_commands = require("neo-tree.sources.filesystem.commands")
                    local node = state.tree:get_node()
                    if node.type ~= "file" or not node.path:lower():match("%.html?$") then
                        fs_commands.open(state)
                        return
                    end
                    vim.ui.select({ "Editor", "Browser" }, {
                        prompt = "Open " .. vim.fn.fnamemodify(node.path, ":t") .. " in:",
                    }, function(choice)
                        if choice == "Editor" then
                            fs_commands.open(state)
                        elseif choice == "Browser" then
                            vim.fn.jobstart({ "open", node.path }, { detach = true })
                        end
                    end)
                end,
            },
            filtered_items = {
                hide_by_name = {
                    ".urc",
                    ".urcignore",
                },
                hide_by_pattern = {
                    "*.code-workspace",
                    "__*__",
                    "*.uasset",
                    "*.umap"
                },
                always_show = {
                    ".gitignore",
                    ".github",
                    ".dap_config.lua"
                },
            },
            window = {
                mappings = {
                    ["<Leader>e"] = "close_window",
                },
                fuzzy_finder_mappings = {
                    ["<esc>"] = "noop",
                },
            },
        },
    },
}
