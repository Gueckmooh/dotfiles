---------------------------
-- Default awesome theme --
---------------------------

local awful = require ("awful")
local wibox = require ("wibox")
local gears = require ("gears")
local naughty = require ("naughty")
local layout = require ("config.layout")
local menu  = require ("config.menu")
local util = require ("config.util")
local xresources      = require("beautiful.xresources")
local dpi             = xresources.apply_dpi
local lain            = require ("lain")
local markup          = lain.util.markup
local separators      = lain.util.separators
local arrow           = separators.arrow_left
local client          = client

local theme = {}

theme.name = "powerarrow"
-- theme.dir = os.getenv ("HOME") .. "/.config/awesome/themes/" .. theme.name
theme.dir = "/home/brignone/git/yet_another_awesome_config/themes/" .. theme.name -- CONFIG

theme.font          = "sans 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 0
theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.dir .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = theme.dir .. "/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.dir .. "/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.dir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.dir .. "/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = theme.dir .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme.dir .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.dir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.dir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.dir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.dir .. "/titlebar/maximized_focus_active.png"

-- {{{ Select a random wallpaper in the "wallpapers" directory
theme.wallpaper_dir = theme.dir .. "/wallpapers"
theme.wallpaper = util.get_wall(theme.dir .. "/wallpapers")
-- }}}

theme.font                                      = "xos4 Terminus 9"

theme.fg_normal                                 = "#FEFEFE"
theme.fg_focus                                  = "#32D6FF"
theme.fg_urgent                                 = "#C83F11"
theme.bg_normal                                 = "#222222"
theme.bg_focus                                  = "#1E2320"
theme.bg_urgent                                 = "#3F3F3F"
theme.taglist_fg_focus                          = "#00CCFF"
theme.tasklist_bg_focus                         = "#222222"
theme.tasklist_fg_focus                         = "#00CCFF"
theme.border_width                              = 1
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#6F6F6F"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"

theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = 16
theme.menu_width                                = 140

theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/layouts/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/layouts/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/layouts/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/layouts/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/layouts/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/layouts/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/layouts/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/layouts/floating.png"

theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_music_no_cover                     = theme.dir .. "/icons/no_cover.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.widget_scissors                           = theme.dir .. "/icons/scissors.png"
theme.widget_pacman                             = theme.dir .. "/icons/pacman.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 7
theme.max_useless_gap                           = 7
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

theme.arrows = {}
theme.arrows.color = {}
theme.arrows.color[1] = "#777E76"
theme.arrows.color[2] = "#8DAA9A"
theme.arrows.color[3] = "#b23998"
theme.arrows.color[4] = "#CB755B"
theme.arrows.color[5] = "#4B3B51"
theme.arrows.color[6] = "#4B696D"
theme.arrows.color[7] = "#777E76"
theme.arrows.color[8] = "#343434"
theme.arrows.color[9] = "alpha"


theme.arrows.color[#theme.arrows.color + 1] =  "#343434"

theme.bg_systray = theme.arrows.color[#theme.arrows.color]

-- theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.launcher =
    awful.widget.launcher({
            image = theme.awesome_icon,
            menu = menu.mainmenu
    })

-- {{{ Change gaps if there is more than one screen
-- client.connect_signal("manage", function(c)
--     local scr = awful.screen.focused ()
--     local all_clients = scr.clients
--     if #all_clients > 1 then
--         scr.selected_tag.gap = theme.max_useless_gap
--     else
--         scr.selected_tag.gap = 0
--     end
--         awful.layout.arrange(scr)
-- end)

-- client.connect_signal("unmanage", function(c)
--     local scr = awful.screen.focused ()
--     local all_clients = scr.clients
--     if #all_clients > 1 then
--         scr.selected_tag.gap = theme.max_useless_gap
--     else
--         scr.selected_tag.gap = 0
--     end
--         awful.layout.arrange(scr)
-- end)

-- tag.connect_signal("tagged", function(t)
--     local scr = t.screen
--     local all_clients = scr.clients
--     print (#all_clients)
--     if #all_clients > 1 then
--         scr.selected_tag.gap = theme.max_useless_gap
--     else
--         scr.selected_tag.gap = 0
--     end
--         awful.layout.arrange(scr)
-- end)

-- tag.connect_signal("untagged", function(t)
--     local scr = t.screen
--     local all_clients = scr.clients
--     print (#all_clients)
--     if #all_clients > 1 then
--         scr.selected_tag.gap = theme.max_useless_gap
--     else
--         scr.selected_tag.gap = 0
--     end
--         awful.layout.arrange(scr)
-- end)
-- }}}

--[[
__        ___     _            _
\ \      / (_) __| | __ _  ___| |_ ___
 \ \ /\ / /| |/ _` |/ _` |/ _ \ __/ __|
  \ V  V / | | (_| | (_| |  __/ |_\__ \
   \_/\_/  |_|\__,_|\__, |\___|\__|___/
                    |___/
--]]

-------------------- {{{ Clock }}} ---------------------------------------------

local clock = require ("widget.clock")
local clock_widget = clock.get_widget (theme)

-------------------- {{{ End Clock }}} -----------------------------------------

-------------------- {{{ Battery }}} -------------------------------------------

local battery = require ("widget.battery")
local battery_widget = battery.get_widget (theme)

-------------------- {{{ End Battery }}} ---------------------------------------

-------------------- {{{ Pulse Audio }}} ---------------------------------------

local pulse = require ("widget.pulseaudio")
local pulse_widget = pulse.get_widget (theme)

-------------------- {{{ End Pulse Audio }}} -----------------------------------


-------------------- {{{ Heat }}} ----------------------------------------------

local temp = require ("widget.temperature")
local temp_widget = temp.get_widget (theme)

-------------------- {{{ End Heat }}} ------------------------------------------

-------------------- {{{ CPU }}} -----------------------------------------------

local cpu = require ("widget.cpu")
local cpu_widget = cpu.get_widget (theme)

-------------------- {{{ End CPU }}} -------------------------------------------

-------------------- {{{ MEM }}} -----------------------------------------------

local mem = require ("widget.mem")
local mem_widget = mem.get_widget (theme)

-------------------- {{{ End MEM }}} -------------------------------------------

-------------------- {{{ FS }}} ------------------------------------------------

local fs = require ("widget.fs")
local fs_widget = fs.get_widget (theme)

-------------------- {{{ End FS }}} --------------------------------------------

-------------------- {{{ PACK }}} ----------------------------------------------

local pack = require ("widget.pack")
local pack_widget = pack.get_widget (theme)

-------------------- {{{ End PACK }}} ------------------------------------------

-------------------- {{{ MPD }}} ----------------------------------------------

local mpd = require ("widget.mpd")
local mpd_widget = mpd.get_widget (theme)

-------------------- {{{ End MPD }}} ------------------------------------------

-------------------- {{{ SCREENSHOT }}} ----------------------------------------

local screenshot = require ("widget.screenshot")
local screenshot_widget = screenshot.get_widget (theme)

-------------------- {{{ End SCREENSHOT }}} ------------------------------------

function theme.set_wallpaper(s)
    -- Wallpaper
    if theme.wallpaper then
        local wallpaper = theme.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

theme.at_screen_connect = function (s)
    -- Wallpaper
    theme.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(layout.tags, s, layout.default_layout)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, menu.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, menu.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            theme.launcher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),

            --------------------------------------------------------------------
            arrow("alpha", theme.arrows.color[#theme.arrows.color]),
            wibox.container.background(
                wibox.container.margin (wibox.widget.systray (), 3, 3),
                theme.arrows.color[#theme.arrows.color]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[10], theme.arrows.color[9]),
            wibox.container.background(
                wibox.container.margin (mpd_widget, 8, 3),
                theme.arrows.color[9]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[9], theme.arrows.color[8]),
            wibox.container.background(
                wibox.container.margin (pack_widget, 8, 3),
                theme.arrows.color[8]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[8], theme.arrows.color[7]),
            wibox.container.background(
                wibox.container.margin (fs_widget, 3, 3),
                theme.arrows.color[7]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[7], theme.arrows.color[6]),
            wibox.container.background(
                wibox.container.margin (mem_widget, 3, 3),
                theme.arrows.color[6]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[6], theme.arrows.color[5]),
            wibox.container.background(
                wibox.container.margin (cpu_widget, 3, 3),
                theme.arrows.color[5]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[5], theme.arrows.color[4]),
            wibox.container.background(
                wibox.container.margin (temp_widget, 3, 3),
                theme.arrows.color[4]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[4], theme.arrows.color[3]),
            wibox.container.background(
                wibox.container.margin (pulse_widget, 3, 3),
                theme.arrows.color[3]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[3], theme.arrows.color[2]),
            wibox.container.background(
                wibox.container.margin (battery_widget, 3, 3),
                theme.arrows.color[2]),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            arrow(theme.arrows.color[2], theme.arrows.color[1]),
            wibox.container.background(clock_widget, theme.arrows.color[1]),
            arrow(theme.arrows.color[1], "alpha"),
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            s.mylayoutbox,
        },
    }
end



return theme
