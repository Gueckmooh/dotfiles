local wibox           = require ("wibox")
local naughty         = require ("naughty")
local awful           = require ("awful")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup
local vars            = require ("config.vars")
local escape_f        = require("awful.util").escape
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local helpers         = require("lain.helpers")
local util            = require ("config.util")

local mpd = {}

mpd.port = "6601"
mpd.host = "127.0.0.1"

local shell = "bash"

local cover_pattern = "*\\.(jpg|jpeg|png|gif)$"

mpd.cover = nil

local modkey = "Mod4"

mpd.get_infos = function ()
    local pfile = io.popen (
        shell .. " -c " ..
            [["echo -e 'status\ncurrentsong\nclose\n' | curl --connect-timeout 1 -fsm 3 telnet://]] ..
            mpd.host .. ':' .. mpd.port .. '"'
    )
    local plines = pfile:read "*a"
    pfile:close ()
    local mpd_infos =  {
        random_mode  = false,
        single_mode  = false,
        repeat_mode  = false,
        consume_mode = false,
        pls_pos      = "N/A",
        pls_len      = "N/A",
        state        = "N/A",
        file         = "N/A",
        name         = "N/A",
        artist       = "N/A",
        title        = "N/A",
        album        = "N/A",
        genre        = "N/A",
        track        = "N/A",
        date         = "N/A",
        time         = "N/A",
        elapsed      = "N/A"
    }

    for line in string.gmatch(plines, "[^\n]+") do
        for k, v in string.gmatch(line, "([%w]+):[%s](.*)$") do
            if     k == "state"          then mpd_infos.state        = v
            elseif k == "file"           then mpd_infos.file         = v
            elseif k == "Name"           then mpd_infos.name         = escape_f(v)
            elseif k == "Artist"         then mpd_infos.artist       = escape_f(v)
            elseif k == "Title"          then mpd_infos.title        = escape_f(v)
            elseif k == "Album"          then mpd_infos.album        = escape_f(v)
            elseif k == "Genre"          then mpd_infos.genre        = escape_f(v)
            elseif k == "Track"          then mpd_infos.track        = escape_f(v)
            elseif k == "Date"           then mpd_infos.date         = escape_f(v)
            elseif k == "Time"           then mpd_infos.time         = v
            elseif k == "elapsed"        then mpd_infos.elapsed      = string.match(v, "%d+")
            elseif k == "song"           then mpd_infos.pls_pos      = v
            elseif k == "playlistlength" then mpd_infos.pls_len      = v
            elseif k == "repeat"         then mpd_infos.repeat_mode  = v ~= "0"
            elseif k == "single"         then mpd_infos.single_mode  = v ~= "0"
            elseif k == "random"         then mpd_infos.random_mode  = v ~= "0"
            elseif k == "consume"        then mpd_infos.consume_mode = v ~= "0"
            end
        end
    end
    return mpd_infos
end

-- local mpd_infos = mpd.get_infos ()

-- for a, b in pairs (mpd_infos)
-- do
--     print (a .. " : ")
--     print (b)
-- end

mpd.get_widget = function (theme)

    mpd.icon = wibox.widget.imagebox (theme.widget_music)

    mpd.already_extracted = {}

    mpd.extract_image = function (infos)
        if mpd.already_extracted[infos.file] ~= nil then
            if util.simple_exec ("test -f " .. mpd.already_extracted[infos.file] ..
                                     "&& echo oui") ~= nil
            then
                return mpd.already_extracted[infos.file]
            else
                mpd.already_extracted[infos.file] = nil
            end
        end
        local realpath = string.format("%s/%s", vars.music_dir, infos.file)
        local _, file, _ = infos.file:match("(.-)([^/]-([^%.]+))$")
        file, _ = file:match ("(.-)%.([^.]+)$")
        local pfile = io.popen ("exiftool \"".. realpath .."\" | awk '/Picture .* \\(Binary/'")
        local line = pfile:read "*l"
        pfile:close ()
        if line == nil then
            return nil
        end
        local file_ext = util.simple_exec ("exiftool \"".. realpath ..
                                          "\" | awk -v FS=/ '/Picture MIME Type/ {print $NF}'")
        local filename = util.simple_exec ("mktemp -u | sed 's/$/." .. file_ext .. "/' "..
                                               "| sed 's/\\/tmp\\//\\/tmp\\/%f/'")
        os.execute (
            "exiftool -b -Picture -w+! \'" .. filename .. "\' -r \"" .. realpath .. "\""
        )
        filename = filename:gsub ("%%f", file)
        mpd.already_extracted[infos.file] = filename
        return filename
    end

    local mpd_warning
    function mpd.show_warning(infos)
        naughty.destroy(mpd_warning)
        if string.match(infos.file, ".*/") ~= nil then
            local path   = string.format("%s/%s", vars.music_dir, string.match(infos.file, ".*/"))
            local cover  = string.format("find '%s' -maxdepth 1 -type f | egrep -i -m1 '%s'",
                                         path:gsub("'", "'\\''"), cover_pattern)
            local pfile = io.popen (shell .. " -c " .. '"' .. cover .. '"')
            local current_icon = pfile:read "*l"
            pfile:close ()
            if current_icon ~= nil then
                mpd.cover = current_icon:gsub("\n", "")
                if #mpd.cover == 0 then mpd.cover = nil end
            else
                mpd.cover = theme.widget_music_no_cover
            end
            if mpd.cover == nil then
                current_icon = mpd.extract_image (infos)
                if current_icon ~= nil then
                    mpd.cover = current_icon
                end
            end
        else
            mpd.cover = theme.widget_music_no_cover
        end
        local message
        if infos.title ~= "N/A" then
            message = string.format (
                "%s (%s) - %s\n"..
                    "%s",
                infos.artist, infos.album, infos.date,
                infos.title
            )
        else
            message = string.format (
                "%s",
                infos.file
            )
        end
        mpd_warning = naughty.notify{
            icon = mpd.cover,
            icon_size=100,
            title = "Now playing",
            text = message,
            timeout = 5, hover_timeout = 0.5,
            position = "top_right",
            bg = theme.bg_normal,
            fg = theme.fg_normal,
            width = 300,
        }
    end


    local mpd_notification
    function mpd.status(infos)
        awful.spawn.easy_async([[true]],
            function(_, _, _, _)
                if infos.state ~= "N/A" and infos.state ~= "stop" then
                    if string.match(infos.file, ".*/") ~= nil then
                        local path   = string.format("%s/%s", vars.music_dir, string.match(infos.file, ".*/"))
                        local cover  = string.format("find '%s' -maxdepth 1 -type f | egrep -i -m1 '%s'",
                                                     path:gsub("'", "'\\''"), cover_pattern)
                        local pfile = io.popen (shell .. " -c " .. '"' .. cover .. '"')
                        local current_icon = pfile:read "*l"
                        pfile:close ()
                        if current_icon ~= nil then
                            mpd.cover = current_icon:gsub("\n", "")
                            if #mpd.cover == 0 then mpd.cover = nil end
                        else
                            mpd.cover = theme.widget_music_no_cover
                        end
                        if mpd.cover == nil then
                            current_icon = mpd.extract_image (infos)
                            if current_icon ~= nil then
                                mpd.cover = current_icon
                            end
                        end
                    else
                        mpd.cover = theme.widget_music_no_cover
                    end
                    local message
                    if infos.title ~= "N/A" then
                        message = string.format (
                            "%s (%s) - %s\n"..
                                "%s",
                            infos.artist, infos.album, infos.date,
                            infos.title
                        )
                    else
                        message = string.format (
                            "%s",
                            infos.file
                        )
                    end
                    mpd_notification = naughty.notify{
                        icon = mpd.cover,
                        icon_size=100,
                        title = "Now playing",
                        text = message,
                        timeout = 5, hover_timeout = 0.5,
                        position = "top_right",
                        bg = theme.bg_normal,
                        fg = theme.fg_normal,
                        width = 300,
                    }
                end
            end
        )
    end



    local currently_playing = ""

    mpd.text_updater = function (widget)
        local mpd_infos = mpd.get_infos ()
        local color1 = "#FF8466"
        local color2 = theme.fg_normal
        if mpd_infos.state == "play"
        then
            if mpd_infos.title ~= "N/A" then
                widget:set_markup (markup.fontfg (theme.font, color2,
                                                  markup (color1, mpd_infos.artist)
                                                      .. " " .. mpd_infos.title))
            else
                local filename = mpd_infos.file
                if mpd_infos.file:len() > 24 then
                    filename = mpd_infos.file:sub (0, 20) .. "..."
                end
                widget:set_markup (markup.fontfg (theme.font, color2, filename))
            end
            mpd.icon:set_image (theme.widget_music_on)
            if currently_playing ~= mpd_infos.file then
                mpd.show_warning (mpd_infos)
                currently_playing = mpd_infos.file
            end
        elseif mpd_infos.state == "pause"
        then
            widget:set_markup (markup.fontfg (theme.font, color2, "Paused"))
            mpd.icon:set_image (theme.widget_music_pause)
        else
            widget:set_text ("")
            mpd.icon:set_image (theme.widget_music)
            currently_playing = ""
        end
    end
    mpd.text = awful.widget.watch (
        "true",
        1, mpd.text_updater)

    local mpd_widget = wibox.widget {
        mpd.icon,
        {
            mpd.text,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
    }

    mpd.update = function ()
        mpd.text_updater (mpd.text)
    end

    mpd_widget:connect_signal("mouse::enter", function()
                                      mpd.status(mpd.get_infos ()) end)
    mpd_widget:connect_signal("mouse::leave", function()
                                  naughty.destroy(mpd_notification) end)
    mpd_widget:buttons (
        my_table.join(
            awful.button({ }, 1, function ()
                    if mpd.get_infos ().state == "N/A" then
                        awful.spawn.with_shell ("mpd")
                    else
                        if mpd.get_infos ().state == "play" then
                            awful.spawn.with_shell(vars.terminal .. " -e 'ncmpcpp -s visualizer'")
                        else
                            awful.spawn.with_shell(vars.terminal .. " -e 'ncmpcpp'")
                        end
                    end
                    mpd.update ()
            end),
            awful.button({  }, 3, function ()
                    awful.spawn.with_shell("mpc -p " .. mpd.port .. " toggle")
                    -- theme.mpd.update()
                    mpd.update ()
            end),
            awful.button({ modkey }, 1, function ()
                    awful.spawn.with_shell("mpc -p " .. mpd.port .. " prev")
                    -- theme.mpd.update()
                    mpd.update ()
            end),
            awful.button({ modkey }, 3, function ()
                    awful.spawn.with_shell("mpc -p " .. mpd.port .. " next")
                    -- theme.mpd.update()
                    mpd.update ()
        end)
    ))

    return mpd_widget

end


return mpd
