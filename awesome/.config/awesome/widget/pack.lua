local wibox           = require ("wibox")
local naughty         = require ("naughty")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup
local vars            = require ("config.vars")
local util            = require ("config.util")
local startup         = require ("config.startup")

local pack = {}

pack.get_widget = function (theme)

    pack.get_update = function ()
        local pfile = io.popen (
            vars.checkupdate
        )
        local upgradables = util.get_lines (pfile)
        pfile:close ()
        return upgradables
    end

    local pack_notification
    function pack.show_status()
        awful.spawn.easy_async([[echo]],
            function(_, _, _, _)
                local upgradables = pack.get_update ()
                local message = #upgradables .. " package(s) to upgrade"
                for i = 1, math.min (5, #upgradables)
                do
                    message = message .. "\n"..upgradables[i]
                end
                if #upgradables > 5 then
                    message = message .. "\nAnd " .. #upgradables - 5 .. " more..."
                end
                pack_notification = naughty.notify{
                    text =  message,
                    title = "Package status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
        )
    end

    pack.nb = #(pack.get_update ())

    function pack.show_warning()
        naughty.notify{
            -- icon = HOME .. "/.config/awesome/nichosi.png",
            -- icon_size=100,
            title = "A stranger.. From the outside ! OOooo",
            text = "New packages available\n" .. pack.nb ..
                " packages upgradable.",
            timeout = 5, hover_timeout = 0.5,
            position = "top_right",
            bg = theme.bg_normal,
            fg = "#EEE9EF",
            width = 300,
        }
    end

    startup.register (function () if pack.nb ~= 0 then pack.show_warning () end end)

    pack.text = awful.widget.watch (
        "echo",
        300,
        function (widget)
            local upgradables = pack.get_update ()
            local color = theme.fg_normal
            local message = ""
            if #upgradables ~= 0 then message = tostring(#upgradables) end
            if #upgradables ~= 0 and #upgradables ~= pack.nb then
                pack.show_warning ()
                pack.nb = #upgradables
            end
            widget:set_markup (markup.fontfg (theme.font, color,
                                              message))
        end
    )

    pack.icon = wibox.widget.imagebox (theme.widget_pacman)

    local pack_widget = wibox.widget {
        pack.icon,
        {
            pack.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    pack_widget:connect_signal("mouse::enter", function()
                                      pack.show_status() end)
    pack_widget:connect_signal("mouse::leave", function()
                                      naughty.destroy(pack_notification) end)

    return pack_widget

end

return pack
