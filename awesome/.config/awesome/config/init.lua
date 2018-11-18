--[[

    Awesome WM configuration
    Module config
    init.lua

--]]

local config = {
    keys    = require ("config.keys"),
    layout  = require ("config.layout"),
    menu    = require ("config.menu"),
    vars    = require ("config.vars"),
    autorun = require ("config.autorun"),
    theme   = require ("config.theme"),
    startup = require ("config.startup"),
}

for _, mod in pairs (config)
do
    if type (mod) == "table" then
        mod.vars = config.vars
    end
end


config.init = function ()
    for _, mod in pairs (config)
    do
        if type (mod) == "table" and mod.__init and
        type(mod.__init) == "function" then
            mod.__init (config.vars)
        end
    end
end


return config
