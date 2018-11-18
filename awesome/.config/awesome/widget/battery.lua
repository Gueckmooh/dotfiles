local wibox           = require ("wibox")
local awful           = require ("awful")
local naughty         = require ("naughty")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup

local battery = {}

battery.get_widget = function (theme)

    local battery_icon = wibox.widget.imagebox (theme.widget_battery)
    local last_battery_check = 0

    local battery_notification
    local function show_battery_status()
        awful.spawn.easy_async([[bash -c 'acpi']],
            function(stdout, _, _, _)
                battery_notification = naughty.notify{
                    text =  stdout,
                    title = "Battery status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
        )
    end

    local function show_battery_warning()
        naughty.notify{
            -- icon = HOME .. "/.config/awesome/nichosi.png",
            -- icon_size=100,
            text = "Huston, we have a problem",
            title = "Battery is dying",
            timeout = 5, hover_timeout = 0.5,
            position = "top_right",
            bg = "#F06060",
            fg = "#EEE9EF",
            width = 300,
        }
    end

    local battery_text = awful.widget.watch (
        "bash -c 'echo $(acpi) $(acpi -a)'",
        10,
        function (widget, stdout)
            local _, status, charge_str, sect =
                string.match(stdout, '(.+): (%a+), (%d?%d?%d)%%,.* Adapter 0: (%a+.%a+)')
            local battery_info = {
                status = status,
                charge = tonumber(charge_str),
                charging = sect == "on-line"
            }
            local color = theme.fg_normal
            if battery_info.charging then
                battery_icon:set_image (theme.widget_ac)
            else
                battery_icon:set_image (theme.widget_battery)
                if battery_info.charge < 15 then
                    if os.difftime(os.time(), last_battery_check) > 300
                    then
                        show_battery_warning ()
                        last_battery_check = os.time ()
                    end
                    color =  "#FF8466"
                end
            end
            widget:set_markup(markup.fontfg(theme.font, color,
                                            tostring (battery_info.charge).."%"))
        end
    )

    local battery_widget = wibox.widget {
        battery_icon,
        {
            battery_text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    battery_widget:connect_signal("mouse::enter", function()
                                      show_battery_status() end)
    battery_widget:connect_signal("mouse::leave", function()
                                      naughty.destroy(battery_notification) end)

    return battery_widget
end

return battery
