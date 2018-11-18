local wibox           = require ("wibox")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local temp = {}

temp.get_widget = function (theme)

    temp.icon = wibox.widget.imagebox (theme.widget_temp)
    temp.text = awful.widget.watch (
        "bash -c \"acpi -t | sed 's/.* \\([0-9]*\\)\\.[0-9]* .*/\\1/'\"",
        10,
        function (widget, stdout)
            local temperature = tonumber (stdout)
            local color = theme.fg_normal
            if temperature >= 80 then
                color = "#ff0000"
            end
            widget:set_markup(markup.fontfg(theme.font, color,
                                            tostring (temperature) .. "°C"))
        end
    )

    local temp_widget = wibox.widget {
        temp.icon,
        {
            temp.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    return temp_widget
end

return temp
