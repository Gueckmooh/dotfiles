local wibox           = require ("wibox")
local naughty         = require ("naughty")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local fs = {}

fs.get_widget = function (theme)

    fs.to_GiB = function (val)
        local g = val / (1024*1024)
        if g > 5 then
            g = math.ceil (g)
        end
        return g
    end

    fs.to_MiB = function (val)
        local g = val / (1024)
        if g > 5 then
            g = math.ceil (g)
        end
        return g
    end

    fs.get_usage = function ()
        local pfile = io.popen (
            [[df | awk '/\/home/ {print $2 " : " $3 " : " $4 " : " $5}']]
        )
        local line = pfile:read "*l"
        pfile:close ()

        -- 723913560 : 460425044 : 226645972 : 68%
        local max, current, free, percent =
            line:match ('(%d+) : (%d+) : (%d+) : (%d+)%%')
        return tonumber(max), tonumber(current), tonumber(free), tonumber(percent)
    end

    local fs_notification
    function fs.show_status()
        awful.spawn.easy_async([[echo]],
            function(_, _, _, _)
                local max, current, free, _ = fs.get_usage ()
                max, current = fs.to_GiB (max), fs.to_GiB (current)
                local M = false
                if fs.to_GiB(free) < 1 then
                    free = fs.to_MiB (free)
                    M = true
                else
                    free = fs.to_GiB (free)
                end
                local message = string.format (
                    "Home partition : %d/%dGB - %d%s remaining",
                    current, max, free, M and "MB" or "GB"
                )
                fs_notification = naughty.notify{
                    text =  message,
                    title = "File system status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
        )
    end

    fs.text = awful.widget.watch (
        "echo",
        10,
        function (widget)
            local _, _, _, percent = fs.get_usage ()
            local color = theme.fg_normal
            if percent > 95 then color = "#ff0000" end
            widget:set_markup (markup.fontfg (theme.font, color,
                                              tostring (math.floor(percent)) .. "%"))
        end
    )

    fs.icon = wibox.widget.imagebox (theme.widget_hdd)

    local fs_widget = wibox.widget {
        fs.icon,
        {
            fs.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    fs_widget:connect_signal("mouse::enter", function()
                                      fs.show_status() end)
    fs_widget:connect_signal("mouse::leave", function()
                                      naughty.destroy(fs_notification) end)

    return fs_widget

end

return fs
