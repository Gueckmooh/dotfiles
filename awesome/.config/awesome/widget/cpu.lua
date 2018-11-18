local wibox           = require ("wibox")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local cpu = {}

function cpu.get_widget (theme)

    cpu.get_usage = function ()
        local pfile = io.popen (
            "grep 'cpu ' /proc/stat | "..
                "awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | "..
                "sed 's/\\(.*\\)\\..*/\\1/'")
        local line = pfile:read "*l"
        pfile:close ()
        return tonumber (line)
    end

    cpu.text = awful.widget.watch (
        "echo",
        10,
        function (widget)
            local usage = cpu.get_usage ()
            local color = theme.fg_normal
            widget:set_markup (markup.fontfg (theme.font, color,
                                              tostring (usage) .. "%"))
        end
    )

    cpu.icon = wibox.widget.imagebox (theme.widget_cpu)

    local cpu_widget = wibox.widget {
        cpu.icon,
        {
            cpu.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    return cpu_widget

end

return cpu
