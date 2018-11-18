local wibox           = require ("wibox")
local awful           = require ("awful")
local naughty         = require ("naughty")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local screenshot = {}

screenshot.get_widget = function (theme)

    screenshot.show_warning = function (filename)
        naughty.notify{
            title = "Screenshot taken",
            text = "File " .. filename,
            timeout = 5, hover_timeout = 0.5,
            position = "top_right",
            bg = theme.bg_normal,
            fg = theme.fg_normal,
            width = 300,
        }
    end

    return nil

end

return screenshot
