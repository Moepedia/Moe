-- SIMPLE EQUIP ROD - TESTING ONLY
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cari Net
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- Remote Equip (dari hasil debug)
local EquipRemote = Net["RE/EquipItem"]

-- GUI sederhana
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleEquip"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
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

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 2)
close.BackgroundColor3 = Color3.new(0.8, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = title
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 35)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Equip button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 30)
btn.Position = UDim2.new(0.1, 0, 0, 70)
btn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
btn.Text = "EQUIP ROD"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.Parent = frame

-- Fungsi equip
btn.MouseButton1Click:Connect(function()
    status.Text = "Mencari rod..."
    status.TextColor3 = Color3.new(1, 1, 0)
    
    -- Cari rod di backpack
    local rod = nil
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():match("rod") then
            rod = tool
            break
        end
    end
    
    if not rod then
        status.Text = "❌ Rod tidak ditemukan!"
        status.TextColor3 = Color3.new(1, 0, 0)
        return
    end
    
    status.Text = "Equipping " .. rod.Name .. "..."
    
    -- Coba equip via remote
    if EquipRemote then
        local success = pcall(function()
            EquipRemote:FireServer(rod)
        end)
        
        if success then
            task.wait(0.5)
            -- Cek apakah rod sudah di tangan
            local equipped = false
            if player.Character then
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == rod.Name then
                        equipped = true
                        break
                    end
                end
            end
            
            if equipped then
                status.Text = "✅ Equip berhasil!"
                status.TextColor3 = Color3.new(0, 1, 0)
            else
                -- Fallback manual
                rod.Parent = player.Character
                status.Text = "✅ Equip manual!"
                status.TextColor3 = Color3.new(0, 1, 0)
            end
        else
            -- Fallback manual
            rod.Parent = player.Character
            status.Text = "✅ Equip manual!"
            status.TextColor3 = Color3.new(0, 1, 0)
        end
    else
        -- Remote tidak ada, manual
        rod.Parent = player.Character
        status.Text = "✅ Equip manual!"
        status.TextColor3 = Color3.new(0, 1, 0)
    end
end)
