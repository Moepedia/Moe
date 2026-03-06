-- AUTO FISH V7.0 - PAKAI HASH REMOTE
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Net path
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- HASH REMOTE (dari hasil rspy)
local Remote = {
    Equip = Net["RE/2398ce3474f69652a94da482fed3730b7dd467ebc7cb7df8d19f71673ee211af"],
    Charge = Net["RF/b8e8ac720a467490635b5d0ed389b56e4cff73bc96f689c9d5e7c6f97be9ee3d"],
    Minigame = Net["RF/ab3de34afc9bab685fd7b7c4de2a47c8fcd612c746cd28d43128b6e6a7ac8ffa"],
    Catch = Net["RF/08a640ee5a04090c8dfeceddd9dec1b6d1a18afe1b98a10b8a05cfac92a497c7"],
    Cancel = Net["RF/CancelFishingInputs"]  -- masih pake nama biasa
}

-- Auto equip rod
local function autoEquip()
    -- Panggil remote equip
    if Remote.Equip then
        pcall(function()
            Remote.Equip:FireServer(1)
            print("✅ Equip remote called")
        end)
    end
    
    -- Fallback: equip manual lewat backpack
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            tool.Parent = LocalPlayer.Character
            print("✅ Equipped: " .. tool.Name)
            return true
        end
    end
    print("❌ No fishing rod found!")
    return false
end

-- Cast function
local function cast()
    local serverTime = workspace:GetServerTimeNow()
    
    -- 1. Charge (persiapan) - tanpa parameter
    local chargeSuccess = pcall(function()
        return Remote.Charge:InvokeServer()
    end)
    
    if not chargeSuccess then 
        print("❌ Charge failed")
        return false 
    end
    
    task.wait(0.3)
    
    -- 2. Request minigame (lempar) - dengan parameter
    local waterY = -50  -- default, nanti bisa diperbaiki dengan raycast
    local power = 0.5
    
    local minigameSuccess = pcall(function()
        return Remote.Minigame:InvokeServer(waterY, power, serverTime)
    end)
    
    return minigameSuccess
end

-- Catch function
local function catchFish()
    pcall(function()
        Remote.Catch:InvokeServer()
        print("✅ Catch called")
    end)
end

-- Cancel fishing
local function cancelFishing()
    pcall(function()
        Remote.Cancel:InvokeServer(true)
    end)
end

-- Main loop
local autoFishing = false
local connection = nil

local function startAutoFishing()
    if autoFishing then return end
    
    if not autoEquip() then 
        print("❌ Gagal equip rod")
        return
    end
    
    autoFishing = true
    print("🎣 AUTO FISHING STARTED!")
    
    connection = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        cancelFishing()
        task.wait(0.2)
        
        if cast() then
            task.wait(2)  -- Tunggu "ikan"
            catchFish()
        end
        
        task.wait(1)
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
    cancelFishing()
    print("🛑 AUTO FISHING STOPPED!")
end

-- GUI SEDERHANA
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishV7"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🎣 AUTO FISH V7 (HASH)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0.35, 0)
btn.Position = UDim2.new(0.1, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.new(0, 0.6, 0)
btn.Text = "START"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = btn

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0.25, 0)
status.Position = UDim2.new(0, 0, 0.8, 0)
status.BackgroundTransparency = 1
status.Text = "⏹️ Stopped"
status.TextColor3 = Color3.new(1, 0.3, 0.3)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    stopAutoFishing()
    gui:Destroy()
end)

-- Toggle button
btn.MouseButton1Click:Connect(function()
    if not autoFishing then
        startAutoFishing()
        btn.Text = "STOP"
        btn.BackgroundColor3 = Color3.new(0.8, 0, 0)
        status.Text = "🎣 Fishing..."
        status.TextColor3 = Color3.new(0.3, 1, 0.3)
    else
        stopAutoFishing()
        btn.Text = "START"
        btn.BackgroundColor3 = Color3.new(0, 0.6, 0)
        status.Text = "⏹️ Stopped"
        status.TextColor3 = Color3.new(1, 0.3, 0.3)
    end
end)

print("✅ AUTO FISH V7 READY!")
