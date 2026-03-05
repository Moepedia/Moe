-- REMOTE LOGGER SEDERHANA
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

print("🔍 MULAI LOGGING - SILAHKAN FISHING MANUAL")
print("==========================================")

-- Daftar remote yang mau dipantau
local remoteNames = {
    "RF/ChargeFishingRod",
    "RF/Request Fishing MinigameStarted",
    "RE/Fishing MinigameChanged",
    "RF/CatchFishCompleted",
    "RE/Fish Caught"
}

-- Pantau satu per satu
for _, name in ipairs(remoteNames) do
    local remote = Net[name]
    if remote then
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                print("📥 EVENT:", name)
                local args = {...}
                for i, arg in ipairs(args) do
                    print("   Arg", i, ":", typeof(arg), tostring(arg))
                end
            end)
        else
            print("📤 FUNCTION SIAP:", name)
        end
    else
        print("❌ REMOTE TIDAK ADA:", name)
    end
end

print("🟢 Silahkan fishing manual sekarang!")
