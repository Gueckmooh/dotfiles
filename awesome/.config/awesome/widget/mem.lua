local wibox           = require ("wibox")
local naughty         = require ("naughty")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local mem = {}

mem.get_widget = function (theme)


    mem.get_usage = function ()
        local pfile = io.popen (
            [[free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\\n", $3,$2,$3*100/$2 }']]
        )
        local line = pfile:read "*l"
        pfile:close ()

        -- Memory Usage: 977/7870MB (12.41%)
        local current, max, percent = line:match ('Memory Usage: (%d+)/(%d+)MB .(%d+.%d+)%%.')
        return tonumber(current), tonumber(max), tonumber(percent)
    end

    local mem_notification
    function mem.show_status()
        awful.spawn.easy_async([[echo]],
            function(_, _, _, _)
                local current, max, _ = mem.get_usage ()
                mem_notification = naughty.notify{
                    text =  tostring(current)..'/'..tostring(max).."MB",
                    title = "Memory status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
        )
    end

    mem.text = awful.widget.watch (
        "echo",
        10,
        function (widget)
            local _, _, percent = mem.get_usage ()
            local color = theme.fg_normal
            widget:set_markup (markup.fontfg (theme.font, color,
                                              tostring (math.floor(percent)) .. "%"))
        end
    )

    mem.icon = wibox.widget.imagebox (theme.widget_mem)

    local mem_widget = wibox.widget {
        mem.icon,
        {
            mem.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    mem_widget:connect_signal("mouse::enter", function()
                                      mem.show_status() end)
    mem_widget:connect_signal("mouse::leave", function()
                                      naughty.destroy(mem_notification) end)

    return mem_widget

end

return mem
