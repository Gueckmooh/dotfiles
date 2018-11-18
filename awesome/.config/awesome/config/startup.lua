local startup = {}

startup.functions = {}

startup.register = function (f)
    startup.functions[#startup.functions+1] = f
end

startup.run = function ()
    for _, f in pairs (startup.functions)
    do
        if type(f) == "function"
        then
            f ()
        end
    end
end

return startup
