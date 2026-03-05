-- TEST PARAMETER REMOTE
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local Remote = {
    Charge = Net["RF/ChargeFishingRod"],
    Minigame = Net["RF/Request Fishing MinigameStarted"],
    Catch = Net["RF/CatchFishCompleted"]
}

print("🔍 TEST PARAMETER REMOTE")
print("=========================")

-- Test 1: Charge dengan berbagai parameter
print("\n1. TEST CHARGE FISHING ROD:")
local params = {
    {nil, nil, workspace:GetServerTimeNow(), nil},
    {workspace:GetServerTimeNow()},
    {0},
    {}
}

for i, p in ipairs(params) do
    local success, result = pcall(function()
        return Remote.Charge:InvokeServer(unpack(p))
    end)
    print("   Parameter set " .. i .. ": " .. (success and "✅" or "❌"))
end

-- Test 2: Minigame dengan berbagai parameter
print("\n2. TEST REQUEST MINIGAME:")
local minigameParams = {
    {-50, 0.5, workspace:GetServerTimeNow()},
    {0, 0.5, workspace:GetServerTimeNow()},
    {workspace:GetServerTimeNow()},
    {}
}

for i, p in ipairs(minigameParams) do
    local success, result = pcall(function()
        return Remote.Minigame:InvokeServer(unpack(p))
    end)
    print("   Parameter set " .. i .. ": " .. (success and "✅" or "❌"))
end

-- Test 3: Catch (harusnya tanpa parameter)
print("\n3. TEST CATCH FISH COMPLETED:")
local success, result = pcall(function()
    return Remote.Catch:InvokeServer()
end)
print("   Tanpa parameter: " .. (success and "✅" or "❌"))

-- Test 4: Coba catch dengan parameter
local success2, result2 = pcall(function()
    return Remote.Catch:InvokeServer(1)
end)
print("   Dengan parameter: " .. (success2 and "✅" or "❌"))
