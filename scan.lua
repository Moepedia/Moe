-- EQUIP ROD VIA DATA INVENTORY
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local Replion = require(ReplicatedStorage.Packages.Replion)

-- Remote yang benar (dari RodShopController)
local EquipItem = Net["RE/EquipItem"]  -- 🔥 INI!

-- Dapatkan data player
local PlayerData = Replion.Client:GetReplion("Data")

-- Ambil daftar rod
local rods = PlayerData:GetExpect({ "Inventory", "Fishing Rods" })

print("🎣 DITEMUKAN " .. #rods .. " ROD:")
for i, rod in ipairs(rods) do
    print(i .. ". ID: " .. rod.Id .. " | UUID: " .. rod.UUID)
end

-- Fungsi equip
local function equipRod(index)
    index = index or 1  -- default rod pertama
    local rod = rods[index]
    
    if not rod then
        print("❌ Rod tidak ditemukan di index " .. index)
        return false
    end
    
    print("\n⚡ Equipping rod " .. index .. ":")
    print("   ID: " .. rod.Id)
    print("   UUID: " .. rod.UUID)
    
    local success = pcall(function()
        EquipItem:FireServer(rod.UUID, "Fishing Rods")
    end)
    
    if success then
        print("✅ Equip remote called!")
        return true
    else
        print("❌ Equip failed")
        return false
    end
end

-- GUI SEDERHANA
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "EquipGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🎣 EQUIP ROD"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 2)
close.BackgroundColor3 = Color3.new(0.8, 0, 0)
close.Text = "X"
close.Parent = title
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Scrolling frame untuk list rod
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -80)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
scroll.CanvasSize = UDim2.new(0, 0, 0, #rods * 35)
scroll.ScrollBarThickness = 5
scroll.Parent = frame

-- List rod
for i, rod in ipairs(rods) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (i-1) * 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
    btn.Text = i .. ". " .. rod.Id
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = scroll
    
    btn.MouseButton1Click:Connect(function()
        equipRod(i)
    end)
end

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 30)
status.Position = UDim2.new(0, 5, 1, -35)
status.BackgroundTransparency = 1
status.Text = "Klik rod untuk equip"
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.Parent = frame

print("\n✅ GUI READY! Klik rod di list untuk equip")
