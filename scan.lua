-- CEK REMOTE - PASTI JALAN
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("🔍 MULAI CEK REMOTE...")
print("==========================")

-- Cari Packages
local Packages = ReplicatedStorage:FindFirstChild("Packages")
if not Packages then
    print("❌ Packages TIDAK DITEMUKAN!")
    return
end
print("✅ Packages ditemukan")

-- Cari Net
local Index = Packages:FindFirstChild("_Index")
if not Index then
    print("❌ _Index TIDAK DITEMUKAN!")
    return
end

local NetFolder = Index:FindFirstChild("sleitnick_net@0.2.0")
if not NetFolder then
    print("❌ sleitnick_net@0.2.0 TIDAK DITEMUKAN!")
    return
end

local Net = NetFolder:FindFirstChild("net")
if not Net then
    print("❌ net TIDAK DITEMUKAN!")
    return
end
print("✅ Net ditemukan!")

-- Daftar remote yang mau dicek
local remotesToCheck = {
    "RF/CancelFishingInputs",
    "RF/ChargeFishingRod",
    "RF/RequestFishingMinigameStarted",
    "RF/CatchFishCompleted",
    "RE/FishCaught",
    "RE/FishingMinigameChanged"
}

print("\n📡 CEK REMOTE SATU PER SATU:")
print("--------------------------")

for _, remoteName in ipairs(remotesToCheck) do
    local remote = Net:FindFirstChild(remoteName)
    if remote then
        print("✅ " .. remoteName .. " - " .. remote.ClassName)
    else
        print("❌ " .. remoteName .. " - TIDAK DITEMUKAN")
    end
end

print("\n✅ CEK SELESAI!")
