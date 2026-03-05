-- FIX ERROR - JALANKAN INI DULU!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("✅ Basic services loaded")

-- Test simple notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Test",
    Text = "Script berjalan!",
    Duration = 2
})

-- Cek apakah Net exists
local Packages = ReplicatedStorage:FindFirstChild("Packages")
if Packages then
    local Net = Packages:FindFirstChild("_Index") and 
                Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
                Packages._Index["sleitnick_net@0.2.0"].net
    
    if Net then
        print("✅ Net ditemukan!")
        
        -- Cek remote-remote penting
        local remotes = {
            "RF/CatchFishCompleted",
            "RF/ChargeFishingRod", 
            "RF/RequestFishingMinigameStarted",
            "RE/FishCaught"
        }
        
        for _, remoteName in ipairs(remotes) do
            local remote = Net[remoteName]
            if remote then
                print("✅ " .. remoteName .. " ada")
            else
                print("❌ " .. remoteName .. " TIDAK ADA")
            end
        end
    else
        print("❌ Net tidak ditemukan")
    end
else
    print("❌ Packages tidak ditemukan")
end
