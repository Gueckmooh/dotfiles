local vars = require ("config.vars")
local util = require ("config.util")

local autorun = {}

autorun.list = {
    vars.unclutter_command,
    vars.network_command,
    vars.pulse_command,
    vars.compton_command,
    vars.autolock_command,
    vars.redshift_command,
    "tap-to-click enable",
    "emacs --daemon",
    "mpd",
}

util.run_once (autorun.list)

return autorun
