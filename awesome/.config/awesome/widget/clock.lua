local wibox           = require ("wibox")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local clock = {}

clock.get_widget = function (theme)

    local clock_text = awful.widget.watch(
        -- "date +'%a %d %b %R'", 60,
        "date +'%R'", 5,
        function(widget, stdout)
            widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, stdout))
        end
    )

    local clock_widget = wibox.widget {
        {
            clock_text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    return clock_widget

end

return clock
