--[[

    Awesome WM configuration
    Module config
    theme.lua

--]]

local beautiful = require ("beautiful")
local awful     = require ("awful")
local keys      = require ("config.keys")
local wibox     = require ("wibox")

local theme     = {}

local screen    = screen
local client    = client
local awesome   = awesome

theme.list_themes = {
    "default",
    "powerarrow"
}

theme.name = theme.list_themes[2]

-- theme.name      = "powerarrow"
-- theme.name      = "default"
-- theme.directory     = os.getenv ("HOME") .. "/.config/awesome/themes"
theme.directory     = os.getenv ("HOME") .. "/git/yet_another_awesome_config/themes" -- CONFIG
theme.path          = string.format ("%s/%s/theme.lua", theme.directory, theme.name)

-- local theming = require (theme.path)

beautiful.init (theme.path)

theme.awesome_icon = beautiful.awesome_icon

awful.screen.connect_for_each_screen(
    function (s)
        beautiful.at_screen_connect (s)
    end
)

screen.connect_signal("property::geometry", beautiful.set_wallpaper)

--[[
  ____ _ _            _
 / ___| (_) ___ _ __ | |_ ___
| |   | | |/ _ \ '_ \| __/ __|
| |___| | |  __/ | | | |_\__ \
 \____|_|_|\___|_| |_|\__|___/

--]]

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientkeys,
                     buttons = keys.clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
    -- {{{ Configure the box on the top of clients
    awful.titlebar(c) : setup {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c), -- Remove the icon
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

return theme
