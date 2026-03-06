-- DEBUG AUTO FISH - CEK REMOTE MANUAL
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Net path
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- HASH REMOTE (dari hasil rspy)
local Remote = {
    Equip = Net["RE/2398ce3474f69652a94da482fed3730b7dd467ebc7cb7df8d19f71673ee211af"],
    Charge = Net["RF/b8e8ac720a467490635b5d0ed389b56e4cff73bc96f689c9d5e7c6f97be9ee3d"],
    Minigame = Net["RF/ab3de34afc9bab685fd7b7c4de2a47c8fcd612c746cd28d43128b6e6a7ac8ffa"],
    Catch = Net["RF/08a640ee5a04090c8dfeceddd9dec1b6d1a18afe1b98a10b8a05cfac92a497c7"]
}

-- GUI untuk debug
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔍 DEBUG AUTO FISH"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 40)
status.Position = UDim2.new(0, 5, 0, 35)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 0)
status.TextWrapped = true
status.Parent = frame

local yPos = 80

-- Tombol Equip
local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0.9, 0, 0, 30)
equipBtn.Position = UDim2.new(0.05, 0, 0, yPos)
equipBtn.Text = "1. EQUIP ROD"
equipBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
equipBtn.Parent = frame
yPos = yPos + 35

-- Tombol Charge
local chargeBtn = Instance.new("TextButton")
chargeBtn.Size = UDim2.new(0.9, 0, 0, 30)
chargeBtn.Position = UDim2.new(0.05, 0, 0, yPos)
chargeBtn.Text = "2. CHARGE"
chargeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
chargeBtn.Parent = frame
yPos = yPos + 35

-- Tombol Minigame
local minigameBtn = Instance.new("TextButton")
minigameBtn.Size = UDim2.new(0.9, 0, 0, 30)
minigameBtn.Position = UDim2.new(0.05, 0, 0, yPos)
minigameBtn.Text = "3. MINIGAME"
minigameBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
minigameBtn.Parent = frame
yPos = yPos + 35

-- Tombol Catch
local catchBtn = Instance.new("TextButton")
catchBtn.Size = UDim2.new(0.9, 0, 0, 30)
catchBtn.Position = UDim2.new(0.05, 0, 0, yPos)
catchBtn.Text = "4. CATCH"
catchBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
catchBtn.Parent = frame

-- Fungsi update status
local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or Color3.new(1, 1, 1)
end

-- Equip
equipBtn.MouseButton1Click:Connect(function()
    setStatus("Equipping...", Color3.new(1, 1, 0))
    local success = pcall(function()
        Remote.Equip:FireServer(1)
    end)
    setStatus(success and "✅ Equip success" or "❌ Equip failed", 
              success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))
end)

-- Charge
chargeBtn.MouseButton1Click:Connect(function()
    setStatus("Charging...", Color3.new(1, 1, 0))
    local success = pcall(function()
        local result = Remote.Charge:InvokeServer()
        print("Charge result:", result)
    end)
    setStatus(success and "✅ Charge success" or "❌ Charge failed", 
              success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))
end)

-- Minigame
minigameBtn.MouseButton1Click:Connect(function()
    setStatus("Requesting minigame...", Color3.new(1, 1, 0))
    local serverTime = workspace:GetServerTimeNow()
    local success = pcall(function()
        local result = Remote.Minigame:InvokeServer(-50, 0.5, serverTime)
        print("Minigame result:", result)
    end)
    setStatus(success and "✅ Minigame success" or "❌ Minigame failed", 
              success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))
end)

-- Catch
catchBtn.MouseButton1Click:Connect(function()
    setStatus("Catching...", Color3.new(1, 1, 0))
    local success = pcall(function()
        local result = Remote.Catch:InvokeServer()
        print("Catch result:", result)
    end)
    setStatus(success and "✅ Catch success" or "❌ Catch failed", 
              success and Color3.new(0, 1, 0) or Color3.new(1, 0, 0))
end)

print("🔍 DEBUG GUI READY - Klik tombol urut!")
