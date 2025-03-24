-- NoFall
local mt = getrawmetatable(game)
local oldMeta = mt.__namecall

-- Function to make metatables writeable (for bypassing the protection)
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Check if method is "FireServer" and the arguments match our criteria
    if method == "FireServer" and #args == 1 and typeof(args[1]) == "table" then
        -- Check if Config is FallDamage
        if args[1]["Config"] == "FallDamage" then
            return false  -- Block the remote event
        end
    end

    -- Call the original method if the condition is not met
    return oldMeta(self, ...)
end)

-- Make the metatable read-only again to avoid further modifications
setreadonly(mt, true)
