--[[

    Awesome WM configuration
    Module config
    menu.lua

--]]

local awful           = require ("awful")
local menubar         = require ("menubar")
local hotkeys_popup   = require ("awful.hotkeys_popup").widget
local wibox           = require ("wibox")
local vars            = require ("config.vars")

local client          = client
local awesome         = awesome
local root            = root

local debian          = {}

debian.menu           = require("debian.menu")

local menu            = {}

local modkey = "Mod4"

menu.awesomemenu = menu.awesomemenu or
    {
        { "hotkeys", function() return false, hotkeys_popup.show_help end},
        { "manual", vars.terminal .. " -e man awesome" },
        { "edit config", vars.editor_cmd .. " " .. awesome.conffile },
        { "restart", awesome.restart },
        { "quit", function() awesome.quit() end}
    }

menu.mainmenu = menu.mainmenu or
    awful.menu({ items = {
                     { "awesome", menu.awesomemenu }, --, theme.awesome_icon },
                     { "Debian", debian.menu.Debian_menu.Debian },
                     { "open terminal", vars.terminal }
                         }
    })

menu.textclock = wibox.widget.textclock()


-- {{{ Taglist
menu.taglist_buttons = awful.util.table.join(
    -- Left click to switch to tag
    awful.button({ }, 1, function(t) t:view_only() end),

    -- Super + Left click to move client to tag
    awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
    end),

    -- Right click to toggle viewing tag
    awful.button({ }, 3, awful.tag.viewtoggle),

    -- Super + Right click to toggle client in tag
    awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
    end),

    -- Scroll to switch tag
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Task list
menu.tasklist_buttons = awful.util.table.join(
    -- Left click to focus client
    awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
    end),

    -- Right click to show menu
    awful.button({ }, 3, client_menu_toggle_fn()),

    -- Scroll to switch client
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)
-- }}}


-- {{{ Real config, do not touch
menubar.utils.terminal = vars.terminal

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menu.mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

return menu
