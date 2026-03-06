-- SIMPLE EQUIP TEST
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local EquipRemote = Net["RE/EquipToolFromHotbar"]

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0.4, 0)
btn.Position = UDim2.new(0.1, 0, 0.3, 0)
btn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
btn.Text = "EQUIP ROD"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0.3, 0)
status.Position = UDim2.new(0, 0, 0.7, 0)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 0)
status.Parent = frame

btn.MouseButton1Click:Connect(function()
    status.Text = "Equipping..."
    local success = pcall(function()
        EquipRemote:FireServer(1)
    end)
    if success then
        status.Text = "✅ Equip called!"
        status.TextColor3 = Color3.new(0, 1, 0)
    else
        status.Text = "❌ Equip failed!"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -25, 0, 5)
close.BackgroundColor3 = Color3.new(0.8, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = frame
close.MouseButton1Click:Connect(function() gui:Destroy() end)
