-- SIMPLE REMOTE SPY (TANPA HOOK)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local remotes = {
    "RF/ChargeFishingRod",
    "RF/RequestFishingMinigameStarted", 
    "RF/CatchFishCompleted",
    "RE/FishingMinigameChanged",
    "RE/FishCaught"
}

print("🔍 SPY AKTIF - FISHING MANUAL SEKARANG!")
print("=========================================")

for _, name in ipairs(remotes) do
    local remote = Net[name]
    if remote then
        if remote:IsA("RemoteEvent") then
            -- Untuk RemoteEvent, kita bisa connect listener
            remote.OnClientEvent:Connect(function(...)
                print("📥 EVENT:", name)
                local args = {...}
                for i, arg in ipairs(args) do
                    print("   Arg" .. i .. ":", typeof(arg), tostring(arg))
                end
            end)
            print("✅ Listening:", name)
        else
            print("✅ RemoteFunction siap:", name)
            -- Untuk RemoteFunction, kita gak bisa spy return value tanpa hook
        end
    else
        print("❌ Tidak ditemukan:", name)
    end
end
