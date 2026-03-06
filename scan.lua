-- CEK ISI INVENTORY
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)

local PlayerData = Replion.Client:GetReplion("Data")
local rods = PlayerData:GetExpect({ "Inventory", "Fishing Rods" })

print("📦 RODS IN INVENTORY:")
for i, rod in ipairs(rods) do
    print(i .. ". ID: " .. rod.Id)
    print("   UUID: " .. rod.UUID)
    print("   Favorited: " .. tostring(rod.Favorited))
    print("---")
end
