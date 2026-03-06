-- ====================================================================
--     AUTO FISH V8.0 - HASH DETECTOR EDITION
--     Dengan GUI Lengkap & Auto Detect Remote
-- ====================================================================

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishV8"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== NET PATH =====
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- ===== AUTO DETECT HASH REMOTES =====
local Remote = {
    Equip = nil,
    Charge = nil,
    Minigame = nil,
    Catch = nil,
    Cancel = nil,
    MinigameEvent = nil,
    FishCaught = nil,
    SellAll = nil,
    Favorite = nil
}

-- Fungsi untuk mencari remote berdasarkan pola
local function findRemoteByPattern(pattern)
    local results = {}
    for _, obj in ipairs(Net:GetChildren()) do
        if obj.Name:lower():match(pattern:lower()) then
            table.insert(results, obj)
        end
    end
    return results
end

-- Deteksi semua remote
print("🔍 Mendeteksi hash remote...")

-- 1. Cari Equip Tool (RemoteEvent)
local equipCandidates = findRemoteByPattern("equip")
for _, remote in ipairs(equipCandidates) do
    if remote:IsA("RemoteEvent") and not Remote.Equip then
        Remote.Equip = remote
        print("✅ Equip ditemukan: " .. remote.Name)
    end
end

-- 2. Cari Charge (RemoteFunction)
local chargeCandidates = findRemoteByPattern("charge")
for _, remote in ipairs(chargeCandidates) do
    if remote:IsA("RemoteFunction") and not Remote.Charge then
        Remote.Charge = remote
        print("✅ Charge ditemukan: " .. remote.Name)
    end
end

-- 3. Cari Minigame Request (RemoteFunction)
local minigameCandidates = findRemoteByPattern("minigame")
for _, remote in ipairs(minigameCandidates) do
    if remote:IsA("RemoteFunction") and not Remote.Minigame then
        Remote.Minigame = remote
        print("✅ Minigame ditemukan: " .. remote.Name)
    end
end

-- 4. Cari Catch (RemoteFunction)
local catchCandidates = findRemoteByPattern("catch")
for _, remote in ipairs(catchCandidates) do
    if remote:IsA("RemoteFunction") and not Remote.Catch then
        Remote.Catch = remote
        print("✅ Catch ditemukan: " .. remote.Name)
    end
end

-- 5. Cari Cancel (RemoteFunction)
local cancelCandidates = findRemoteByPattern("cancel")
for _, remote in ipairs(cancelCandidates) do
    if remote:IsA("RemoteFunction") and not Remote.Cancel then
        Remote.Cancel = remote
        print("✅ Cancel ditemukan: " .. remote.Name)
    end
end

-- 6. Cari Minigame Event (RemoteEvent)
local minigameEventCandidates = findRemoteByPattern("minigame")
for _, remote in ipairs(minigameEventCandidates) do
    if remote:IsA("RemoteEvent") and not Remote.MinigameEvent then
        Remote.MinigameEvent = remote
        print("✅ MinigameEvent ditemukan: " .. remote.Name)
    end
end

-- 7. Cari FishCaught (RemoteEvent)
local fishCaughtCandidates = findRemoteByPattern("fish")
for _, remote in ipairs(fishCaughtCandidates) do
    if remote:IsA("RemoteEvent") and not Remote.FishCaught and remote.Name:match("Caught") then
        Remote.FishCaught = remote
        print("✅ FishCaught ditemukan: " .. remote.Name)
    end
end

-- 8. Cari Sell All (RemoteFunction)
local sellCandidates = findRemoteByPattern("sell")
for _, remote in ipairs(sellCandidates) do
    if remote:IsA("RemoteFunction") and not Remote.SellAll and remote.Name:match("All") then
        Remote.SellAll = remote
        print("✅ SellAll ditemukan: " .. remote.Name)
    end
end

-- 9. Cari Favorite (RemoteEvent)
local favCandidates = findRemoteByPattern("favorite")
for _, remote in ipairs(favCandidates) do
    if remote:IsA("RemoteEvent") and not Remote.Favorite then
        Remote.Favorite = remote
        print("✅ Favorite ditemukan: " .. remote.Name)
    end
end

-- ===== NOTIFY FUNCTION =====
local function notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Fish",
        Text = msg,
        Duration = 2
    })
end

-- ===== EQUIP ROD FUNCTION =====
local function equipRod()
    if not Remote.Equip then 
        print("❌ No equip remote")
        return false 
    end
    
    -- Coba equip dengan parameter 1
    local success = pcall(function()
        Remote.Equip:FireServer(1)
    end)
    
    if success then
        print("✅ Equip remote called")
        task.wait(0.5)
        
        -- Cek apakah rod sudah di tangan
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                    notify("Equipped: " .. tool.Name)
                    return true
                end
            end
        end
    end
    
    -- Fallback: manual equip
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():match("rod") then
            tool.Parent = player.Character
            notify("Equipped (manual): " .. tool.Name)
            return true
        end
    end
    
    notify("No fishing rod found!")
    return false
end

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local fishingConnection = nil
local minigameConnection = nil
local autoSell = false
local autoFavorite = false

-- ===== CONFIG =====
local Config = {
    FishDelay = 2,
    CatchDelay = 1,
    SellDelay = 60,
    FavoriteRarity = "Mythic"
}

-- ===== MINIGAME LISTENER =====
if Remote.MinigameEvent then
    Remote.MinigameEvent.OnClientEvent:Connect(function(state, data)
        print("🎣 Minigame state:", state)
        if state == "Completed" or state == "Stop" then
            if autoFishing and Remote.Catch then
                pcall(function() Remote.Catch:InvokeServer() end)
                print("✅ Fish caught!")
            end
        end
    end)
end

-- ===== CAST FUNCTION =====
local function cast()
    if not Remote.Charge or not Remote.Minigame then return false end
    
    local serverTime = workspace:GetServerTimeNow()
    
    -- Charge
    local chargeSuccess = pcall(function()
        return Remote.Charge:InvokeServer(nil, nil, serverTime, nil)
    end)
    
    if not chargeSuccess then return false end
    
    task.wait(0.3)
    
    -- Minigame
    local minigameSuccess = pcall(function()
        return Remote.Minigame:InvokeServer(-50, 0.5, serverTime)
    end)
    
    return minigameSuccess
end

-- ===== CANCEL =====
local function cancelFishing()
    if Remote.Cancel then
        pcall(function() Remote.Cancel:InvokeServer(true) end)
    end
end

-- ===== SELL ALL =====
local function sellAll()
    if Remote.SellAll then
        pcall(function() Remote.SellAll:InvokeServer() end)
        notify("Sold all items!")
    end
end

-- ===== FAVORITE =====
local function favoriteItem()
    if Remote.Favorite then
        pcall(function() Remote.Favorite:FireServer() end)
        notify("Favorite toggled")
    end
end

-- ===== MAIN FISHING LOOP =====
local function startFishing()
    if autoFishing then return end
    
    if not equipRod() then return end
    
    autoFishing = true
    notify("Auto Fishing Started")
    
    fishingConnection = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        
        cancelFishing()
        task.wait(0.2)
        
        if cast() then
            task.wait(Config.FishDelay)
        end
    end)
end

local function stopFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    cancelFishing()
    notify("Auto Fishing Stopped")
end

-- ===== GUI =====
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 350)
frame.Position = UDim2.new(0.5, -225, 0.5, -175)
frame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.new(0.15, 0.15, 0.17)
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎣 AUTO FISH V8 (HASH DETECTOR)"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    stopFishing()
    gui:Destroy()
end)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

-- Remote status
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 80)
statusText.BackgroundTransparency = 1
statusText.Text = "📡 REMOTE STATUS:\n" ..
    "Equip: " .. (Remote.Equip and "✅" or "❌") .. "\n" ..
    "Charge: " .. (Remote.Charge and "✅" or "❌") .. "\n" ..
    "Minigame: " .. (Remote.Minigame and "✅" or "❌") .. "\n" ..
    "Catch: " .. (Remote.Catch and "✅" or "❌")
statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.Parent = content

-- Auto Fish Toggle
local fishToggle = Instance.new("TextButton")
fishToggle.Size = UDim2.new(0.45, 0, 0, 40)
fishToggle.Position = UDim2.new(0, 0, 0, 90)
fishToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
fishToggle.Text = "START FISHING"
fishToggle.TextColor3 = Color3.new(1, 1, 1)
fishToggle.Font = Enum.Font.GothamBold
fishToggle.Parent = content

local fishCorner = Instance.new("UICorner")
fishCorner.CornerRadius = UDim.new(0, 6)
fishCorner.Parent = fishToggle

fishToggle.MouseButton1Click:Connect(function()
    if not autoFishing then
        startFishing()
        fishToggle.Text = "STOP FISHING"
        fishToggle.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    else
        stopFishing()
        fishToggle.Text = "START FISHING"
        fishToggle.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
    end
end)

-- Equip Button
local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0.45, 0, 0, 40)
equipBtn.Position = UDim2.new(0.55, 0, 0, 90)
equipBtn.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
equipBtn.Text = "EQUIP ROD"
equipBtn.TextColor3 = Color3.new(1, 1, 1)
equipBtn.Font = Enum.Font.GothamBold
equipBtn.Parent = content

local equipCorner = Instance.new("UICorner")
equipCorner.CornerRadius = UDim.new(0, 6)
equipCorner.Parent = equipBtn

equipBtn.MouseButton1Click:Connect(function()
    equipRod()
end)

-- Delay settings
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.5, 0, 0, 25)
delayLabel.Position = UDim2.new(0, 0, 0, 140)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Fish Delay:"
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = content

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.4, 0, 0, 25)
delayInput.Position = UDim2.new(0.5, 0, 0, 140)
delayInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
delayInput.Text = tostring(Config.FishDelay)
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.Font = Enum.Font.Gotham
delayInput.Parent = content

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 4)
delayCorner.Parent = delayInput

delayInput.FocusLost:Connect(function()
    local val = tonumber(delayInput.Text) or 2
    Config.FishDelay = math.clamp(val, 0.5, 10)
    delayInput.Text = tostring(Config.FishDelay)
end)

-- Auto Sell Toggle
local sellToggle = Instance.new("TextButton")
sellToggle.Size = UDim2.new(0.45, 0, 0, 35)
sellToggle.Position = UDim2.new(0, 0, 0, 175)
sellToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
sellToggle.Text = "AUTO SELL: OFF"
sellToggle.TextColor3 = Color3.new(1, 1, 1)
sellToggle.Font = Enum.Font.GothamBold
sellToggle.Parent = content

local sellCorner = Instance.new("UICorner")
sellCorner.CornerRadius = UDim.new(0, 6)
sellCorner.Parent = sellToggle

sellToggle.MouseButton1Click:Connect(function()
    autoSell = not autoSell
    sellToggle.Text = autoSell and "AUTO SELL: ON" or "AUTO SELL: OFF"
    sellToggle.BackgroundColor3 = autoSell and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.3, 0.3, 0.3)
end)

-- Auto Favorite Toggle
local favToggle = Instance.new("TextButton")
favToggle.Size = UDim2.new(0.45, 0, 0, 35)
favToggle.Position = UDim2.new(0.55, 0, 0, 175)
favToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
favToggle.Text = "AUTO FAV: OFF"
favToggle.TextColor3 = Color3.new(1, 1, 1)
favToggle.Font = Enum.Font.GothamBold
favToggle.Parent = content

local favCorner = Instance.new("UICorner")
favCorner.CornerRadius = UDim.new(0, 6)
favCorner.Parent = favToggle

favToggle.MouseButton1Click:Connect(function()
    autoFavorite = not autoFavorite
    favToggle.Text = autoFavorite and "AUTO FAV: ON" or "AUTO FAV: OFF"
    favToggle.BackgroundColor3 = autoFavorite and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.3, 0.3, 0.3)
end)

-- Sell All Now button
local sellNowBtn = Instance.new("TextButton")
sellNowBtn.Size = UDim2.new(1, 0, 0, 40)
sellNowBtn.Position = UDim2.new(0, 0, 0, 220)
sellNowBtn.BackgroundColor3 = Color3.new(0.8, 0.5, 0)
sellNowBtn.Text = "SELL ALL NOW"
sellNowBtn.TextColor3 = Color3.new(1, 1, 1)
sellNowBtn.Font = Enum.Font.GothamBold
sellNowBtn.Parent = content

local sellNowCorner = Instance.new("UICorner")
sellNowCorner.CornerRadius = UDim.new(0, 6)
sellNowCorner.Parent = sellNowBtn

sellNowBtn.MouseButton1Click:Connect(sellAll)

-- Favorite Now button
local favNowBtn = Instance.new("TextButton")
favNowBtn.Size = UDim2.new(1, 0, 0, 40)
favNowBtn.Position = UDim2.new(0, 0, 0, 270)
favNowBtn.BackgroundColor3 = Color3.new(0.8, 0.3, 0.8)
favNowBtn.Text = "FAVORITE ITEM"
favNowBtn.TextColor3 = Color3.new(1, 1, 1)
favNowBtn.Font = Enum.Font.GothamBold
favNowBtn.Parent = content

local favNowCorner = Instance.new("UICorner")
favNowCorner.CornerRadius = UDim.new(0, 6)
favNowCorner.Parent = favNowBtn

favNowBtn.MouseButton1Click:Connect(favoriteItem)

-- Drag functionality
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ AUTO FISH V8 LOADED - GUI READY")
notify("Auto Fish V8 Ready!")
