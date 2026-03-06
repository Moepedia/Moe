-- DEBUG EQUIP - CEK SLOT & EQUIP
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- Remote
local EquipRemote = Net["RE/EquipToolFromHotbar"]

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🔍 DEBUG EQUIP"
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

-- Log area
local log = Instance.new("TextLabel")
log.Size = UDim2.new(1, -10, 0, 150)
log.Position = UDim2.new(0, 5, 0, 35)
log.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
log.Text = "Ready..."
log.TextColor3 = Color3.new(0, 1, 0)
log.Font = Enum.Font.Gotham
log.TextSize = 11
log.TextWrapped = true
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top
log.Parent = frame

local function addLog(msg)
    log.Text = log.Text .. "\n" .. msg
    task.wait()
    log.TextYAlignment = Enum.TextYAlignment.Top
end

-- Tombol-tombol
local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(0.45, 0, 0, 30)
btn1.Position = UDim2.new(0.02, 0, 0, 190)
btn1.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
btn1.Text = "EQUIP SLOT 1"
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.Parent = frame

local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(0.45, 0, 0, 30)
btn2.Position = UDim2.new(0.52, 0, 0, 190)
btn2.BackgroundColor3 = Color3.new(0.8, 0.5, 0)
btn2.Text = "CHECK HOTBAR"
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.Parent = frame

-- CEK HOTBAR
btn2.MouseButton1Click:Connect(function()
    addLog("\n🔍 CHECKING HOTBAR...")
    
    -- Cek di character (yang dipegang)
    if player.Character then
        for i, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                addLog("✅ Dipegang: " .. tool.Name)
            end
        end
    end
    
    -- Cek di backpack
    addLog("\n📦 BACKPACK:")
    local rods = {}
    for i, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            addLog("  " .. i .. ". " .. tool.Name)
            if tool.Name:lower():match("rod") then
                table.insert(rods, tool)
            end
        end
    end
    
    if #rods > 0 then
        addLog("\n🎣 RODS FOUND:")
        for i, rod in ipairs(rods) do
            addLog("  " .. i .. ". " .. rod.Name)
        end
    else
        addLog("\n❌ NO RODS FOUND!")
    end
end)

-- EQUIP SLOT 1
btn1.MouseButton1Click:Connect(function()
    addLog("\n⚡ EQUIP SLOT 1...")
    
    -- Coba equip
    local success = pcall(function()
        EquipRemote:FireServer(1)
    end)
    
    if success then
        addLog("✅ Equip called")
        
        task.wait(0.5)
        
        -- Cek apakah rod pindah
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                    addLog("✅ ROD EQUIPPED: " .. tool.Name)
                    return
                end
            end
        end
        addLog("❌ Rod tidak pindah ke tangan")
    else
        addLog("❌ Equip failed")
    end
end)

addLog("Klik CHECK HOTBAR dulu")
