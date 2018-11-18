local wibox           = require ("wibox")
local awful           = require ("awful")
local naughty         = require ("naughty")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup
local util            = require ("config.util")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local APW             = require("apw/widget")
local vars            = require ("config.vars")

local pulseaudio = {}

local audiolayout_path = os.getenv ("HOME") .. "/.audiolayout"

pulseaudio.get_widget = function (theme)

    function pulseaudio.get_current_sink ()
        local pfile = io.popen ("pacmd list-sinks | awk '/  \\* index\\: ./ {y=\"oui\";next} y==\"oui\" {print;exit}' | sed 's/^.*name\\: <\\(.*\\)>.*$/\\1/'")
        local line = pfile:read "*l"
        pfile:close ()
        return line
    end

    function pulseaudio.get_name ()
        local pfile = io.popen (
            "pacmd list-sinks | awk '/" ..
                pulseaudio.get_current_sink () ..
                "/ {y=1;next} y && /active port/ {print;exit}' |"..
                " sed 's/.*<\\(.*\\)>/\\1/' | sed 's/-/ /g'")
        local line = pfile:read "*l"
        pfile:close ()
        return line
    end

    local pulse_notification
    function pulseaudio.show_status()
        awful.spawn.easy_async(
            "bash -c \"pacmd list-sinks | awk \\\"/" ..
                "$(pacmd list-sinks | awk '/  \\* index\\: ./ {y=1;next} y==1 {print;exit}' | sed 's/^.*name\\: <\\(.*\\)>.*$/\\1/')" ..
                "/ {y=1;next} y && /active port/ {print;exit}\\\" |"..
                " sed 's/.*<\\(.*\\)>/\\1/' | sed 's/-/ /g'\""
            ,
            function(stdout, _, _, _)
                stdout = stdout:gsub("\n","")
                pulse_notification = naughty.notify{
                    text =  stdout,
                    title = "Pulse status",
                    timeout = 5, hover_timeout = 0.5,
                    width = 200,
                }
            end
        )
    end

    function pulseaudio.is_muted ()
        local pfile = io.popen (
            "bash -c \"pacmd list-sinks | awk \\\"/" ..
                "$(pacmd list-sinks | awk '/  \\* index\\: ./ {y=1;next} y==1 {print;exit}' | sed 's/^.*name\\: <\\(.*\\)>.*$/\\1/')" ..
                "/ {y=1;next} /muted/ && y {print;exit}\\\" | sed 's/^.*\\(yes\\|no\\).*$/\\1/' \""
        )
        local line = pfile:read "*l"
        pfile:close ()
        return line == "yes"
    end

    pulseaudio.icon = wibox.widget.imagebox (theme.widget_vol)

    pulseaudio.text_updater = function (widget, stdout)

        local _, left, right = stdout:match ("(.*): .*(..%d)%%.*(..%d)%%.*")

        if left == nil or right == nil
        then return
        end

        local volume = math.floor((tonumber (left) + tonumber (right)) / 2)
        local color = theme.fg_normal
        local icon = theme.widget_vol

        if volume == 0 then
            color = "#000000"
            icon = theme.widget_vol_no
        elseif volume < 50 then
            icon = theme.widget_vol_low
        end

        if pulseaudio.is_muted () then
            color = "#ff0000"
            icon = theme.widget_vol_mute
        end

        pulseaudio.icon:set_image (icon)
        widget:set_markup(markup.fontfg(theme.font, color,
                                        tostring (volume).."%"))
    end

    pulseaudio.text = awful.widget.watch (
        "bash -c \"pacmd list-sinks | awk \\\"/" ..
            "$(pacmd list-sinks | awk '/  \\* index\\: ./ {y=1;next} y==1 {print;exit}' | sed 's/^.*name\\: <\\(.*\\)>.*$/\\1/')" ..
            "/ {y=1;next} /volume/ && y {print;exit}\\\"\"",
        1, pulseaudio.text_updater)

    pulseaudio.update = function ()
        local stdout = util.simple_exec (
            "bash -c \"pacmd list-sinks | awk \\\"/" ..
            "$(pacmd list-sinks | awk '/  \\* index\\: ./ {y=1;next} y==1 {print;exit}' | sed 's/^.*name\\: <\\(.*\\)>.*$/\\1/')" ..
            "/ {y=1;next} /volume/ && y {print;exit}\\\"\""
        )
        pulseaudio.text_updater (pulseaudio.text, stdout)
    end

    local pulse_widget = wibox.widget {
        pulseaudio.icon,
        {
            pulseaudio.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    pulse_widget:connect_signal("mouse::enter", function()
                                    pulseaudio.show_status() end)
    pulse_widget:connect_signal("mouse::leave", function()
                                    naughty.destroy(pulse_notification) end)

    local audiolayout = util.scandir (audiolayout_path)

    pulseaudio.switcher = function (cmd, sink)
        return function ()
            local line = util.simple_exec (cmd)
            local err = true
            if line == nil or line == "" then
                err = false
            end
            local message
            local color_bg
            local color_fg
            local title
            if err then
                title = "Error while switching sink..."
                message = string.format ("Could not find sink %s", sink)
                color_bg = "#F06060"
                color_fg = "#EEE9EF"
            else
                title = "Success !"
                message = string.format ("Sink switched to %s", sink)
                color_bg = theme.bg_normal
                color_fg = theme.fg_normal
            end
            naughty.notify{
                text =  message,
                title = title,
                bg = color_bg,
                fg = color_fg,
                timeout = 5, hover_timeout = 0.5,
                width = 200,
            }
        end
    end

    local menu_content = {}
    for _, layout in pairs (audiolayout)
    do
        local layout_name = layout:match ("(.-)%.([^.]+)$")
        layout_name = layout_name:gsub ("_", " ")
        local layout_exe = string.format ("bash -c '%s/%s 2>&1'", audiolayout_path,
                                          layout)
        menu_content[#menu_content + 1] = {layout_name, pulseaudio.switcher (layout_exe, layout_name)}
    end

    menu_content[#menu_content + 1] = {
        "restart",
        "bash -c 'pulseaudio -k && pulseaudio --start'"
    }

    pulseaudio.menu = awful.menu {
        items =  menu_content
    }

    pulse_widget:buttons (
        my_table.join(
            awful.button({ }, 1, function ()
                    APW.ToggleMute ()
                    pulseaudio.update ()
            end),
            awful.button({ }, 3, function ()
                    pulseaudio.menu:toggle ()
                    -- print ("Pouet")
                    -- pulseaudio.update ()
            end),
            awful.button({ }, 4, function ()
                    APW.Up ()
                    pulseaudio.update ()
            end),
            awful.button({ }, 5, function ()
                    APW.Down ()
                    pulseaudio.update ()
            end)
    ))

    return pulse_widget

end

return pulseaudio
