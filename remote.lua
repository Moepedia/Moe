-- AUTO FISH - FIXED VERSION
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Net path
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- Remote functions
local Remote = {
    Cancel = Net["RF/CancelFishingInputs"],
    Charge = Net["RF/ChargeFishingRod"],
    Minigame = Net["RF/RequestFishingMinigameStarted"],
    MinigameEvent = Net["RE/FishingMinigameChanged"],
    Catch = Net["RF/CatchFishCompleted"],
    FishCaught = Net["RE/FishCaught"]
}

-- Variables
local autoFishing = false
local connection = nil

-- Listener untuk minigame
Remote.MinigameEvent.OnClientEvent:Connect(function(state, data)
    if state == "Completed" or state == "Stop" then
        -- Auto catch saat minigame selesai
        pcall(function()
            Remote.Catch:InvokeServer()
            print("✅ Ikan didapat!")
        end)
    end
end)

-- Listener untuk fish caught (notifikasi)
Remote.FishCaught.OnClientEvent:Connect(function(fishData)
    print("🎣 Dapat ikan:", fishData)
end)

-- Fungsi casting
local function cast()
    local serverTime = workspace:GetServerTimeNow()
    
    -- Charge (parameter 1 work)
    local chargeSuccess = pcall(function()
        return Remote.Charge:InvokeServer(nil, nil, serverTime, nil)
    end)
    
    if not chargeSuccess then return false end
    
    task.wait(0.3)
    
    -- Minigame (parameter 1 work)
    local minigameSuccess = pcall(function()
        return Remote.Minigame:InvokeServer(-50, 0.5, serverTime)
    end)
    
    return minigameSuccess
end

-- Start auto fishing
local function startAutoFishing()
    if autoFishing then return end
    autoFishing = true
    print("🎣 AUTO FISHING STARTED!")
    
    connection = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        -- Cancel fishing sebelumnya
        pcall(function()
            Remote.Cancel:InvokeServer(true)
        end)
        task.wait(0.2)
        
        -- Cast
        cast()
        task.wait(2) -- Delay antar casting
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
    pcall(function()
        Remote.Cancel:InvokeServer(true)
    end)
    print("🛑 AUTO FISHING STOPPED!")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🎣 AUTO FISH"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
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

print("✅ AUTO FISH READY! Tekan START untuk mulai")
notify = function(t, msg) 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = t or "Auto Fish",
        Text = msg or "",
        Duration = 2
    })
end
notify("Auto Fish", "Ready! Tekan START")
