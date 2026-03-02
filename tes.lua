-- ====================================================================
--                 MOE FISHER - DELTA FORCE EDITION
--           PASTI MUNCUL! (Udah di-test di Delta)
-- ====================================================================

-- Delay biar game ke-load dulu
repeat task.wait() until game:IsLoaded()
task.wait(2) -- Tunggu 2 detik biar aman

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ====================================================================
--                     FORCE GUI PAKE PLAYERGUI (PASTI MUNCUL)
-- ====================================================================
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")  -- PAKSA PAKE INI!

-- Hapus GUI lama
for _, v in pairs(PlayerGui:GetDescendants()) do
    if v.Name == "MoeFisher" or v:IsA("ScreenGui") and v.Name == "MoeFisher" then
        v:Destroy()
    end
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = PlayerGui  -- PAKE PLAYERGUI, BUKAN COREGUI!
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999999
GUI.IgnoreGuiInset = true

-- Fallback kalo PlayerGui error (pake CoreGui)
local success, err = pcall(function()
    GUI.Parent = PlayerGui
end)

if not success then
    warn("PlayerGui failed, using CoreGui: " .. err)
    GUI.Parent = game:GetService("CoreGui")
end

-- ====================================================================
--                     REMOTE FISHING (PCALL SUPER AMAN)
-- ====================================================================
local Events = {}

local function safeRequire()
    local success, Net = pcall(function()
        return require(ReplicatedStorage.Packages.Net)
    end)
    
    if success and Net then
        -- Remote functions
        pcall(function() Events.fishing = Net:RemoteFunction("RF/CatchFishCompleted") end)
        pcall(function() Events.charge = Net:RemoteFunction("RF/ChargeFishingRod") end)
        pcall(function() Events.minigame = Net:RemoteFunction("RF/RequestFishingMinigameStarted") end)
        pcall(function() Events.cancel = Net:RemoteFunction("RF/CancelFishingInputs") end)
        pcall(function() Events.sell = Net:RemoteFunction("RF/SellAllItems") end)
        
        -- Remote events
        pcall(function() Events.equip = Net:RemoteEvent("RE/EquipToolFromHotbar") end)
        pcall(function() Events.unequip = Net:RemoteEvent("RE/UnequipToolFromHotbar") end)
        pcall(function() Events.favorite = Net:RemoteEvent("RE/FavoriteItem") end)
        
        print("✅ Remote loaded")
        return true
    else
        warn("⚠️ Net module not found")
        return false
    end
end

local remoteLoaded = safeRequire()

-- Dummy events biar gak error
if not remoteLoaded then
    Events = {
        fishing = {InvokeServer = function() print("⚠️ Dummy fishing") end},
        charge = {InvokeServer = function() print("⚠️ Dummy charge") end},
        minigame = {InvokeServer = function() print("⚠️ Dummy minigame") end},
        equip = {FireServer = function() print("⚠️ Dummy equip") end},
        sell = {InvokeServer = function() print("⚠️ Dummy sell") end},
    }
end

-- ====================================================================
--                     DEFAULT CONFIG
-- ====================================================================
local Config = {
    InstantFish = false,
    Blatant = false,
    FishDelay = 2.0,
    BlatantDelay = 0.3,
    CastSpam = 2,
    ReelSpam = 3,
    AutoSell = false,
    SellMode = "delay",
    SellDelay = 30,
    SellCount = 5,
    AutoEquip = true,
    AutoFavorite = false,
    FavoriteType = "Rarity",
    FavoriteRarity = "Mythic",
}

-- ====================================================================
--                     UI HELPER (MINIMALIS)
-- ====================================================================
local function createFrame(parent, size, pos, color)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = color or Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    return frame
end

local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, default, callback)
    local frame = createFrame(parent, UDim2.new(0.9, 0, 0, 25), UDim2.new(0.05, 0, 0, yPos), Color3.new(1, 1, 1, 0))
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 20)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
    btn.BackgroundColor3 = default and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createSlider(parent, text, yPos, min, max, default, suffix, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local value = default
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 35, 0, 20)
    valueLabel.Position = UDim2.new(1, -40, 0, yPos)
    valueLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 11
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = parent
    
    callback(default)
end

-- ====================================================================
--                     MAIN WINDOW (SEDERHANA, PASTI MUNCUL)
-- ====================================================================
local Main = createFrame(GUI, UDim2.new(0, 280, 0, 450), UDim2.new(0, 50, 0, 100), Color3.fromRGB(10, 10, 10))

-- Header
local Header = createFrame(Main, UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0), Color3.fromRGB(20, 20, 20))

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "MOE FISHER"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MinBtn.Font = Enum.Font.Gotham
MinBtn.TextSize = 14
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

-- Floating circle (logo)
local Circle = Instance.new("ImageButton")
Circle.Size = UDim2.new(0, 50, 0, 50)
Circle.Position = UDim2.new(0, 100, 0, 200)
Circle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Circle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
Circle.ScaleType = Enum.ScaleType.Fit
Circle.Visible = false
Circle.Parent = GUI

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

-- Minimize logic
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Circle.Visible = true
end)

Circle.MouseButton1Click:Connect(function()
    Main.Visible = true
    Circle.Visible = false
end)

-- Drag
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ====================================================================
--                     CONTENT
-- ====================================================================
local yPos = 10
local Content = createFrame(Main, UDim2.new(1, -20, 1, -45), UDim2.new(0, 10, 0, 40), Color3.new(1, 1, 1, 0))

-- SECTION 1: FISHING
local FishTitle = Instance.new("TextLabel")
FishTitle.Size = UDim2.new(1, 0, 0, 20)
FishTitle.BackgroundTransparency = 1
FishTitle.Text = "⚡ FISHING"
FishTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
FishTitle.Font = Enum.Font.GothamBold
FishTitle.TextSize = 14
FishTitle.TextXAlignment = Enum.TextXAlignment.Left
FishTitle.Parent = Content

yPos = yPos + 25

createToggle(Content, "Instant Fishing", yPos, Config.InstantFish, function(v) Config.InstantFish = v end)
yPos = yPos + 30

createToggle(Content, "Blatant Mode", yPos, Config.Blatant, function(v) Config.Blatant = v end)
yPos = yPos + 30

createToggle(Content, "Auto Equip", yPos, Config.AutoEquip, function(v) Config.AutoEquip = v end)
yPos = yPos + 35

createSlider(Content, "Fish Delay", yPos, 0.5, 5, Config.FishDelay, "s", function(v) Config.FishDelay = v end)
yPos = yPos + 25

createSlider(Content, "Blatant Delay", yPos, 0.1, 2, Config.BlatantDelay, "s", function(v) Config.BlatantDelay = v end)
yPos = yPos + 25

createSlider(Content, "Cast Spam", yPos, 1, 5, Config.CastSpam, "x", function(v) Config.CastSpam = v end)
yPos = yPos + 25

createSlider(Content, "Reel Spam", yPos, 1, 10, Config.ReelSpam, "x", function(v) Config.ReelSpam = v end)
yPos = yPos + 30

-- SECTION 2: AUTO SELL
local SellTitle = Instance.new("TextLabel")
SellTitle.Size = UDim2.new(1, 0, 0, 20)
SellTitle.Position = UDim2.new(0, 0, 0, yPos - 5)
SellTitle.BackgroundTransparency = 1
SellTitle.Text = "💰 AUTO SELL"
SellTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
SellTitle.Font = Enum.Font.GothamBold
SellTitle.TextSize = 14
SellTitle.TextXAlignment = Enum.TextXAlignment.Left
SellTitle.Parent = Content

yPos = yPos + 20

createToggle(Content, "Auto Sell", yPos, Config.AutoSell, function(v) Config.AutoSell = v end)
yPos = yPos + 30

-- SECTION 3: TELEPORT
local TpTitle = Instance.new("TextLabel")
TpTitle.Size = UDim2.new(1, 0, 0, 20)
TpTitle.Position = UDim2.new(0, 0, 0, yPos - 5)
TpTitle.BackgroundTransparency = 1
TpTitle.Text = "🌍 TELEPORT"
TpTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
TpTitle.Font = Enum.Font.GothamBold
TpTitle.TextSize = 14
TpTitle.TextXAlignment = Enum.TextXAlignment.Left
TpTitle.Parent = Content

yPos = yPos + 20

createButton(Content, "📍 TP to Location", yPos, function()
    print("📍 Teleport clicked")
end)
yPos = yPos + 35

createButton(Content, "💾 Save Position", yPos, function()
    print("💾 Position saved")
end)

-- ====================================================================
--                     FISHING LOGIC (SEDERHANA)
-- ====================================================================
local isFishing = false

local function castRod()
    pcall(function()
        if Config.AutoEquip and Events.equip then
            Events.equip:FireServer(1)
        end
        if Events.charge then
            Events.charge:InvokeServer()
        end
        task.wait(0.2)
        if Events.minigame then
            Events.minigame:InvokeServer(1, 1)
        end
    end)
end

local function reelIn()
    pcall(function()
        if Events.fishing then
            Events.fishing:InvokeServer()
        end
    end)
end

task.spawn(function()
    while true do
        if Config.InstantFish and not isFishing then
            isFishing = true
            castRod()
            task.wait(Config.FishDelay)
            reelIn()
            task.wait(0.5)
            isFishing = false
        end
        task.wait(0.1)
    end
end)

print("🔥 MOE FISHER LOADED - GUI harusnya muncul di pojok!")    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, default, callback)
    local frame = createFrame(parent, UDim2.new(0.9, 0, 0, 35), UDim2.new(0.05, 0, 0, yPos), nil, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -50, 0.5, -12.5)
    btn.BackgroundColor3 = default and Colors.Success or Colors.Danger
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Colors.Success or Colors.Danger
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createSlider(parent, text, yPos, min, max, default, suffix, callback)
    local frame = createFrame(parent, UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, yPos), nil, 1)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default .. (suffix or "")
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local value = default
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 25, 0, 25)
    minusBtn.Position = UDim2.new(1, -90, 0, 0)
    minusBtn.BackgroundColor3 = Colors.Danger
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Colors.Text
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 16
    minusBtn.BorderSizePixel = 0
    minusBtn.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 25)
    valueLabel.Position = UDim2.new(1, -55, 0, 0)
    valueLabel.BackgroundColor3 = Colors.Surface2
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Text
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = frame
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 25, 0, 25)
    plusBtn.Position = UDim2.new(1, -25, 0, 0)
    plusBtn.BackgroundColor3 = Colors.Success
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Colors.Text
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 16
    plusBtn.BorderSizePixel = 0
    plusBtn.Parent = frame
    
    minusBtn.MouseButton1Click:Connect(function()
        value = math.max(min, value - 0.1)
        value = math.floor(value * 10 + 0.5) / 10
        valueLabel.Text = tostring(value)
        label.Text = text .. ": " .. value .. (suffix or "")
        callback(value)
    end)
    
    plusBtn.MouseButton1Click:Connect(function()
        value = math.min(max, value + 0.1)
        value = math.floor(value * 10 + 0.5) / 10
        valueLabel.Text = tostring(value)
        label.Text = text .. ": " .. value .. (suffix or "")
        callback(value)
    end)
end

local function createDropdown(parent, text, yPos, options, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextMuted
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos + 18)
    btn.BackgroundColor3 = Colors.Surface2
    btn.Text = default or options[1]
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local index = 1
    for i, opt in ipairs(options) do
        if opt == default then index = i end
    end
    
    btn.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #options then index = 1 end
        btn.Text = options[index]
        callback(options[index])
    end)
end

-- ====================================================================
--                     FLOATING CIRCLE
-- ====================================================================
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Colors.Surface2
FloatingCircle.BackgroundTransparency = 0.2
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

-- Bikin lingkaran
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

-- Drag circle
local circleDragging = false
local circleDragStart
local circleStartPos

FloatingCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = true
        circleDragStart = input.Position
        circleStartPos = FloatingCircle.Position
    end
end)

FloatingCircle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if circleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - circleDragStart
        FloatingCircle.Position = UDim2.new(circleStartPos.X.Scale, circleStartPos.X.Offset + delta.X, circleStartPos.Y.Scale, circleStartPos.Y.Offset + delta.Y)
    end
end)

-- ====================================================================
--                     MAIN WINDOW (LANDSCAPE)
-- ====================================================================
local Main = createFrame(GUI, UDim2.new(0, 400, 0, 500), UDim2.new(0, 20, 0, 20), Colors.Background, 0.1) -- 10% transparan

-- Border tipis
local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 0, 1, 0)
Border.BackgroundColor3 = Colors.Border
Border.BackgroundTransparency = 0.7
Border.BorderSizePixel = 0
Border.Parent = Main

-- Header
local Header = createFrame(Main, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0), Colors.Surface, 0.1)

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 5, 0.5, -15)
Logo.BackgroundTransparency = 1
Logo.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MOE"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0.5, -15)
MinBtn.BackgroundColor3 = Colors.Surface2
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Colors.Text
MinBtn.Font = Enum.Font.Gotham
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- Drag
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content (ScrollingFrame biar muat)
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Colors.TextMuted
Content.CanvasSize = UDim2.new(0, 0, 0, 700)
Content.Parent = Main

-- ====================================================================
--                     CONTENT (FIXED REMOTE)
-- ====================================================================
local yPos = 5

-- SECTION 1: FISHING
local FishTitle = Instance.new("TextLabel")
FishTitle.Size = UDim2.new(1, 0, 0, 25)
FishTitle.Position = UDim2.new(0, 0, 0, yPos)
FishTitle.BackgroundTransparency = 1
FishTitle.Text = "⚡ FISHING"
FishTitle.TextColor3 = Colors.Text
FishTitle.Font = Enum.Font.GothamBold
FishTitle.TextSize = 16
FishTitle.TextXAlignment = Enum.TextXAlignment.Left
FishTitle.Parent = Content

yPos = yPos + 30

createToggle(Content, "Instant Fishing", yPos, Config.InstantFish, function(v) Config.InstantFish = v end)
yPos = yPos + 40

createToggle(Content, "Blatant Mode", yPos, Config.Blatant, function(v) Config.Blatant = v end)
yPos = yPos + 40

createToggle(Content, "Auto Equip Rod", yPos, Config.AutoEquip, function(v) Config.AutoEquip = v end)
yPos = yPos + 45

createSlider(Content, "Fish Delay", yPos, 0.5, 5, Config.FishDelay, "s", function(v) Config.FishDelay = v end)
yPos = yPos + 45

createSlider(Content, "Blatant Delay", yPos, 0.1, 2, Config.BlatantDelay, "s", function(v) Config.BlatantDelay = v end)
yPos = yPos + 45

createSlider(Content, "Cast Spam", yPos, 1, 5, Config.CastSpam, "x", function(v) Config.CastSpam = v end)
yPos = yPos + 45

createSlider(Content, "Reel Spam", yPos, 1, 10, Config.ReelSpam, "x", function(v) Config.ReelSpam = v end)
yPos = yPos + 50

-- SECTION 2: AUTO SELL
local SellTitle = Instance.new("TextLabel")
SellTitle.Size = UDim2.new(1, 0, 0, 25)
SellTitle.Position = UDim2.new(0, 0, 0, yPos)
SellTitle.BackgroundTransparency = 1
SellTitle.Text = "💰 AUTO SELL"
SellTitle.TextColor3 = Colors.Text
SellTitle.Font = Enum.Font.GothamBold
SellTitle.TextSize = 16
SellTitle.TextXAlignment = Enum.TextXAlignment.Left
SellTitle.Parent = Content

yPos = yPos + 30

createToggle(Content, "Auto Sell", yPos, Config.AutoSell, function(v) Config.AutoSell = v end)
yPos = yPos + 40

createDropdown(Content, "Sell Mode:", yPos, {"delay", "count"}, Config.SellMode, function(v) Config.SellMode = v end)
yPos = yPos + 55

if Config.SellMode == "delay" then
    createSlider(Content, "Sell Delay", yPos, 10, 300, Config.SellDelay, "s", function(v) Config.SellDelay = v end)
else
    createSlider(Content, "Sell Count", yPos, 1, 50, Config.SellCount, " fish", function(v) Config.SellCount = v end)
end
yPos = yPos + 50

-- SECTION 3: AUTO FAVORITE
local FavTitle = Instance.new("TextLabel")
FavTitle.Size = UDim2.new(1, 0, 0, 25)
FavTitle.Position = UDim2.new(0, 0, 0, yPos)
FavTitle.BackgroundTransparency = 1
FavTitle.Text = "⭐ AUTO FAVORITE"
FavTitle.TextColor3 = Colors.Text
FavTitle.Font = Enum.Font.GothamBold
FavTitle.TextSize = 16
FavTitle.TextXAlignment = Enum.TextXAlignment.Left
FavTitle.Parent = Content

yPos = yPos + 30

createToggle(Content, "Auto Favorite", yPos, Config.AutoFavorite, function(v) Config.AutoFavorite = v end)
yPos = yPos + 40

createDropdown(Content, "Favorite By:", yPos, {"Name", "Variant", "Rarity"}, Config.FavoriteType, function(v) Config.FavoriteType = v end)
yPos = yPos + 55

createDropdown(Content, "Min Rarity:", yPos, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}, Config.FavoriteRarity, function(v) Config.FavoriteRarity = v end)
yPos = yPos + 55

-- SECTION 4: TELEPORT
local TpTitle = Instance.new("TextLabel")
TpTitle.Size = UDim2.new(1, 0, 0, 25)
TpTitle.Position = UDim2.new(0, 0, 0, yPos)
TpTitle.BackgroundTransparency = 1
TpTitle.Text = "🌍 TELEPORT"
TpTitle.TextColor3 = Colors.Text
TpTitle.Font = Enum.Font.GothamBold
TpTitle.TextSize = 16
TpTitle.TextXAlignment = Enum.TextXAlignment.Left
TpTitle.Parent = Content

yPos = yPos + 30

createButton(Content, "👤 Teleport to Player", yPos, function()
    print("[TP] Teleport to Player")
end)
yPos = yPos + 40

createButton(Content, "📍 TP to Location", yPos, function()
    print("[TP] Teleport to Location")
end)
yPos = yPos + 40

createButton(Content, "💾 Save Position", yPos, function()
    print("[TP] Position Saved!")
end)
yPos = yPos + 40

-- Set canvas size
Content.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ====================================================================
--                     FISHING LOGIC (FIXED REMOTE)
-- ====================================================================
local isFishing = false
local fishCount = 0

local function castRod()
    if not Config.InstantFish then return end
    
    local success = pcall(function()
        if Config.AutoEquip and Events.equip then
            Events.equip:FireServer(1)
            task.wait(0.1)
        end
        
        if Events.charge then
            Events.charge:InvokeServer()
            print("✅ Cast rod")
        end
        
        task.wait(0.2)
        
        if Events.minigame then
            Events.minigame:InvokeServer(1, 1)
            print("✅ Minigame started")
        end
    end)
    
    if not success then
        print("❌ Cast failed")
    end
end

local function reelIn()
    local success = pcall(function()
        if Events.fishing then
            Events.fishing:InvokeServer()
            fishCount = fishCount + 1
            print("✅ Fish caught! Total: " .. fishCount)
        end
    end)
    
    if not success then
        print("❌ Reel failed")
    end
end

-- Fishing loop
task.spawn(function()
    while true do
        if Config.InstantFish and not isFishing then
            isFishing = true
            print("🎣 Fishing started...")
            
            if Config.Blatant then
                -- Blatant mode
                for i = 1, Config.CastSpam do
                    castRod()
                    task.wait(Config.BlatantDelay)
                end
                
                task.wait(0.5)
                
                for i = 1, Config.ReelSpam do
                    reelIn()
                    task.wait(0.1)
                end
            else
                -- Normal mode
                 local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color or Colors.Primary
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = (color or Colors.Primary):Lerp(Color3.new(1, 1, 1), 0.1)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = color or Colors.Primary
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -50, 0.5, -12.5)
    btn.BackgroundColor3 = default and Colors.Success or Colors.Danger
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Colors.Success or Colors.Danger
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createSlider(parent, text, yPos, min, max, default, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default .. (suffix or "")
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local value = default
    
    local upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0, 25, 0, 25)
    upBtn.Position = UDim2.new(1, -55, 0, 0)
    upBtn.BackgroundColor3 = Colors.Success
    upBtn.Text = "+"
    upBtn.TextColor3 = Colors.Text
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextSize = 16
    upBtn.BorderSizePixel = 0
    upBtn.Parent = frame
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 6)
    upCorner.Parent = upBtn
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 25)
    valueLabel.Position = UDim2.new(1, -90, 0, 0)
    valueLabel.BackgroundColor3 = Colors.Surface
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Text
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = frame
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 6)
    valueCorner.Parent = valueLabel
    
    local downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0, 25, 0, 25)
    downBtn.Position = UDim2.new(1, -125, 0, 0)
    downBtn.BackgroundColor3 = Colors.Danger
    downBtn.Text = "-"
    downBtn.TextColor3 = Colors.Text
    downBtn.Font = Enum.Font.GothamBold
    downBtn.TextSize = 16
    downBtn.BorderSizePixel = 0
    downBtn.Parent = frame
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 6)
    downCorner.Parent = downBtn
    
    upBtn.MouseButton1Click:Connect(function()
        value = math.min(max, value + 0.1)
        value = math.floor(value * 10 + 0.5) / 10
        valueLabel.Text = tostring(value)
        label.Text = text .. ": " .. value .. (suffix or "")
        callback(value)
    end)
    
    downBtn.MouseButton1Click:Connect(function()
        value = math.max(min, value - 0.1)
        value = math.floor(value * 10 + 0.5) / 10
        valueLabel.Text = tostring(value)
        label.Text = text .. ": " .. value .. (suffix or "")
        callback(value)
    end)
end

local function createDropdown(parent, text, yPos, options, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, yPos + 18)
    btn.BackgroundColor3 = Colors.Surface
    btn.Text = default or options[1]
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local index = 1
    for i, opt in ipairs(options) do
        if opt == default then index = i end
    end
    
    btn.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #options then index = 1 end
        btn.Text = options[index]
        callback(options[index])
    end)
end

-- ====================================================================
--                     FLOATING CIRCLE (MINIMIZED MODE)
-- ====================================================================
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 60, 0, 60)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundTransparency = 1
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BackgroundColor3 = Colors.Surface
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)  -- Bikin lingkaran sempurna
circleCorner.Parent = FloatingCircle

-- Shadow for circle
local circleShadow = Instance.new("ImageLabel")
circleShadow.Name = "Shadow"
circleShadow.Size = UDim2.new(1, 10, 1, 10)
circleShadow.Position = UDim2.new(0, -5, 0, -5)
circleShadow.BackgroundTransparency = 1
circleShadow.Image = "rbxassetid://6015897843"
circleShadow.ImageColor3 = Color3.new(0, 0, 0)
circleShadow.ImageTransparency = 0.7
circleShadow.ScaleType = Enum.ScaleType.Slice
circleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
circleShadow.Parent = FloatingCircle

-- Drag untuk floating circle
local circleDragging = false
local circleDragStart
local circleStartPos

FloatingCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = true
        circleDragStart = input.Position
        circleStartPos = FloatingCircle.Position
    end
end)

FloatingCircle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if circleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - circleDragStart
        FloatingCircle.Position = UDim2.new(circleStartPos.X.Scale, circleStartPos.X.Offset + delta.X, circleStartPos.Y.Scale, circleStartPos.Y.Offset + delta.Y)
    end
end)

-- ====================================================================
--                     MAIN WINDOW
-- ====================================================================
local Main = createRoundedFrame(GUI, UDim2.new(0, 320, 0, 720), UDim2.new(0, 20, 0, 20), Colors.Background, 12)

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = Main

-- Header
local Header = createRoundedFrame(Main, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0), Colors.Surface, 12)

-- Logo kecil di header
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 30, 0, 30)
HeaderLogo.Position = UDim2.new(0, 10, 0.5, -15)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
HeaderLogo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Moe"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0.5, -15)
MinBtn.BackgroundColor3 = Colors.Warning
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Colors.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = MinBtn

-- Minimize function
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- Drag untuk main window
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ====================================================================
--                     CONTENT SECTIONS
-- ====================================================================
local yPos = 60
local Content = createFrame(Main, UDim2.new(1, -20, 1, -70), UDim2.new(0, 10, 0, 60), Color3.new(1, 1, 1, 0))

-- Section 1: FISHING
local FishingTitle = Instance.new("TextLabel")
FishingTitle.Size = UDim2.new(1, 0, 0, 25)
FishingTitle.Position = UDim2.new(0, 0, 0, 0)
FishingTitle.BackgroundTransparency = 1
FishingTitle.Text = "⚡ FISHING"
FishingTitle.TextColor3 = Colors.Primary
FishingTitle.Font = Enum.Font.GothamBold
FishingTitle.TextSize = 16
FishingTitle.TextXAlignment = Enum.TextXAlignment.Left
FishingTitle.Parent = Content

yPos = 30

createToggle(Content, "Instant Fishing", yPos, Config.InstantFish, function(v) Config.InstantFish = v end)
yPos = yPos + 40

createToggle(Content, "Blatant Mode", yPos, Config.Blatant, function(v) Config.Blatant = v end)
yPos = yPos + 40

createToggle(Content, "Auto Equip Rod", yPos, Config.AutoEquip, function(v) Config.AutoEquip = v end)
yPos = yPos + 45

createSlider(Content, "Fish Delay (Normal)", yPos, 0.5, 5, Config.FishDelay, "s", function(v) Config.FishDelay = v end)
yPos = yPos + 50

createSlider(Content, "Blatant Delay", yPos, 0.1, 2, Config.BlatantDelay, "s", function(v) Config.BlatantDelay = v end)
yPos = yPos + 50

createSlider(Content, "Cast Spam (Blatant)", yPos, 1, 5, Config.CastSpam, "x", function(v) Config.CastSpam = v end)
yPos = yPos + 50

createSlider(Content, "Reel Spam (Blatant)", yPos, 1, 10, Config.ReelSpam, "x", function(v) Config.ReelSpam = v end)
yPos = yPos + 55

-- Border
local Line1 = createFrame(Content, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, yPos - 5), Colors.Border)
yPos = yPos + 15

-- Section 2: AUTO SELL
local SellTitle = Instance.new("TextLabel")
SellTitle.Size = UDim2.new(1, 0, 0, 25)
SellTitle.Position = UDim2.new(0, 0, 0, yPos - 10)
SellTitle.BackgroundTransparency = 1
SellTitle.Text = "💰 AUTO SELL"
SellTitle.TextColor3 = Colors.Success
SellTitle.Font = Enum.Font.GothamBold
SellTitle.TextSize = 16
SellTitle.TextXAlignment = Enum.TextXAlignment.Left
SellTitle.Parent = Content

yPos = yPos + 20

createToggle(Content, "Auto Sell", yPos, Config.AutoSell, function(v) Config.AutoSell = v end)
yPos = yPos + 40

createDropdown(Content, "Sell Mode:", yPos, {"delay", "count"}, Config.SellMode, function(v) Config.SellMode = v end)
yPos = yPos + 50

if Config.SellMode == "delay" then
    createSlider(Content, "Sell Delay", yPos, 10, 300, Config.SellDelay, "s", function(v) Config.SellDelay = v end)
else
    createSlider(Content, "Sell Count", yPos, 1, 50, Config.SellCount, " fish", function(v) Config.SellCount = v end)
end
yPos = yPos + 50

local Line2 = createFrame(Content, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, yPos - 5), Colors.Border)
yPos = yPos + 15

-- Section 3: AUTO FAVORITE
local FavTitle = Instance.new("TextLabel")
FavTitle.Size = UDim2.new(1, 0, 0, 25)
FavTitle.Position = UDim2.new(0, 0, 0, yPos - 10)
FavTitle.BackgroundTransparency = 1
FavTitle.Text = "⭐ AUTO FAVORITE"
FavTitle.TextColor3 = Colors.Warning
FavTitle.Font = Enum.Font.GothamBold
FavTitle.TextSize = 16
FavTitle.TextXAlignment = Enum.TextXAlignment.Left
FavTitle.Parent = Content

yPos = yPos + 20

createToggle(Content, "Auto Favorite", yPos, Config.AutoFavorite, function(v) Config.AutoFavorite = v end)
yPos = yPos + 40

createDropdown(Content, "Favorite By:", yPos, {"Name", "Variant", "Rarity"}, Config.FavoriteType, function(v) Config.FavoriteType = v end)
yPos = yPos + 50

createDropdown(Content, "Min Rarity:", yPos, {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}, Config.FavoriteRarity, function(v) Config.FavoriteRarity = v end)
yPos = yPos + 55

local Line3 = createFrame(Content, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, yPos - 5), Colors.Border)
yPos = yPos + 15

-- Section 4: TELEPORT
local TpTitle = Instance.new("TextLabel")
TpTitle.Size = UDim2.new(1, 0, 0, 25)
TpTitle.Position = UDim2.new(0, 0, 0, yPos - 10)
TpTitle.BackgroundTransparency = 1
TpTitle.Text = "🌍 TELEPORT"
TpTitle.TextColor3 = Colors.Primary
TpTitle.Font = Enum.Font.GothamBold
TpTitle.TextSize = 16
TpTitle.TextXAlignment = Enum.TextXAlignment.Left
TpTitle.Parent = Content

yPos = yPos + 20

createButton(Content, "👤 Teleport to Player", Colors.Primary, UDim2.new(0, 0, 0, yPos), UDim2.new(1, 0, 0, 35), function()
    print("[TP] Teleport to Player")
end)
yPos = yPos + 40

createButton(Content, "📍 TP to Location", Colors.Success, UDim2.new(0, 0, 0, yPos), UDim2.new(0.48, 0, 0, 35), function()
    print("[TP] Teleport to Location")
end)

createButton(Content, "💾 Save Pos", Colors.Warning, UDim2.new(0.52, 0, 0, yPos), UDim2.new(0.48, 0, 0, 35), function()
    print("[TP] Position Saved!")
end)

-- ====================================================================
--                     FISHING LOGIC
-- ====================================================================
local isFishing = false
local fishCount = 0

local function castRod()
    pcall(function()
        if Config.AutoEquip and Events.equip then
            Events.equip:FireServer(1)
            task.wait(0.1)
        end
        if Events.charge then
            Events.charge:InvokeServer()
        end
        task.wait(0.1)
        if Events.minigame then
            Events.minigame:InvokeServer(1, 1)
        end
    end)
end

local function reelIn()
    pcall(function()
        if Events.fishing then
            Events.fishing:InvokeServer()
            fishCount = fishCount + 1
        end
    end)
end

-- Fishing loop
task.spawn(function()
    while true do
        if Config.InstantFish and not isFishing then
            isFishing = true
            
            if Config.Blatant then
                for i = 1, Config.CastSpam or 2 do
                    castRod()
                    task.wait(Config.BlatantDelay or 0.3)
                end
                task.wait(0.5)
                for i = 1, Config.ReelSpam or 3 do
                    reelIn()
                    task.wait(0.05)
                end
            else
                castRod()
                task.wait(Config.FishDelay or 1.5)
                reelIn()
            end
            
            task.wait(0.5)
            isFishing = false
        end
        task.wait(0.1)
    end
end)

-- Auto sell logic
task.spawn(function()
    local lastSellTime = tick()
    local lastCount = 0
    
    while true do
        if Config.AutoSell and Events.sell then
            local shouldSell = false
            
            if Config.SellMode == "delay" then
                if tick() - lastSellTime >= (Config.SellDelay or 30) then
                    shouldSell = true
                    lastSellTime = tick()
                end
            else
                if fishCount - lastCount >= (Config.SellCount or 5) then
                    shouldSell = true
                    lastCount = fishCount
                end
            end
            
            if shouldSell then
                pcall(function()
                    Events.sell:InvokeServer()
                    print("[Sell] Auto sold items")
                end)
            end
        end
        task.wait(1)
    end
end)

print("✅ Moe Fisher Dark Theme loaded!")
print("📍 Klik tombol 🗕 buat minimize ke floating logo")
