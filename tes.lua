-- ====================================================================
--                 MOE FISHER - FIXED FOR DELTA
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")  -- ✅ FORMAT YANG BENER
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                     REMOTE FISHING
-- ====================================================================
local Events = {}

local success, Net = pcall(function()
    return require(ReplicatedStorage.Packages.Net)
end)

if success and Net then
    pcall(function() Events.fishing = Net:RemoteFunction("RF/CatchFishCompleted") end)
    pcall(function() Events.charge = Net:RemoteFunction("RF/ChargeFishingRod") end)
    pcall(function() Events.minigame = Net:RemoteFunction("RF/RequestFishingMinigameStarted") end)
    pcall(function() Events.equip = Net:RemoteEvent("RE/EquipToolFromHotbar") end)
    pcall(function() Events.unequip = Net:RemoteEvent("RE/UnequipToolFromHotbar") end)
    pcall(function() Events.favorite = Net:RemoteEvent("RE/FavoriteItem") end)
    pcall(function() Events.sell = Net:RemoteFunction("RF/SellAllItems") end)
    
    print("✅ Remote fishing: RF/CatchFishCompleted, RF/ChargeFishingRod")
else
    warn("⚠️ Net module not found")
    Events = {
        fishing = {InvokeServer = function() end},
        charge = {InvokeServer = function() end},
        minigame = {InvokeServer = function() end},
        equip = {FireServer = function() end},
        sell = {InvokeServer = function() end},
    }
end

-- ====================================================================
--                     GUI SETUP (COPY PASTE DARI REMOTE FINDER)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui  -- PAKE CoreGui yang udah di-define di atas
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (copy styling dari Remote Finder)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 500)
Main.Position = UDim2.new(0.5, -190, 0.5, -250)  -- Tengah
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  -- Dark theme
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "🎣 MOE FISHER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- Tombol Minimize (ke floating circle)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Main

-- Floating Circle (logo)
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

-- Bikin lingkaran
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

-- Minimize function
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

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

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ====================================================================
--                     FITUR-FITUR (SEDERHANA DULU)
-- ====================================================================
local yPos = 5

-- Fungsi toggle
local function createToggle(parent, text, yPos, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -50, 0.5, -12.5)
    btn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    return {frame = frame, btn = btn, state = default}
end

-- SECTION 1: FISHING
local fishTitle = Instance.new("TextLabel")
fishTitle.Size = UDim2.new(1, 0, 0, 25)
fishTitle.Position = UDim2.new(0, 0, 0, yPos)
fishTitle.BackgroundTransparency = 1
fishTitle.Text = "⚡ FISHING"
fishTitle.TextColor3 = Color3.new(0.3, 0.8, 1)
fishTitle.Font = Enum.Font.GothamBold
fishTitle.TextSize = 16
fishTitle.TextXAlignment = Enum.TextXAlignment.Left
fishTitle.Parent = Content

yPos = yPos + 30

local instantToggle = createToggle(Content, "Instant Fishing", yPos, false)
yPos = yPos + 40

local blatantToggle = createToggle(Content, "Blatant Mode", yPos, false)
yPos = yPos + 40

local equipToggle = createToggle(Content, "Auto Equip Rod", yPos, true)
yPos = yPos + 45

-- SECTION 2: AUTO SELL
local sellTitle = Instance.new("TextLabel")
sellTitle.Size = UDim2.new(1, 0, 0, 25)
sellTitle.Position = UDim2.new(0, 0, 0, yPos)
sellTitle.BackgroundTransparency = 1
sellTitle.Text = "💰 AUTO SELL"
sellTitle.TextColor3 = Color3.new(0.3, 1, 0.3)
sellTitle.Font = Enum.Font.GothamBold
sellTitle.TextSize = 16
sellTitle.TextXAlignment = Enum.TextXAlignment.Left
sellTitle.Parent = Content

yPos = yPos + 30

local sellToggle = createToggle(Content, "Auto Sell", yPos, false)
yPos = yPos + 40

-- SECTION 3: AUTO FAVORITE
local favTitle = Instance.new("TextLabel")
favTitle.Size = UDim2.new(1, 0, 0, 25)
favTitle.Position = UDim2.new(0, 0, 0, yPos)
favTitle.BackgroundTransparency = 1
favTitle.Text = "⭐ AUTO FAVORITE"
favTitle.TextColor3 = Color3.new(1, 0.8, 0.3)
favTitle.Font = Enum.Font.GothamBold
favTitle.TextSize = 16
favTitle.TextXAlignment = Enum.TextXAlignment.Left
favTitle.Parent = Content

yPos = yPos + 30

local favToggle = createToggle(Content, "Auto Favorite", yPos, false)
yPos = yPos + 40

-- SECTION 4: TELEPORT
local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0, 25)
tpTitle.Position = UDim2.new(0, 0, 0, yPos)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "🌍 TELEPORT"
tpTitle.TextColor3 = Color3.new(0.3, 0.8, 1)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 16
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.Parent = Content

yPos = yPos + 30

-- ====================================================================
--                     FISHING LOGIC
-- ====================================================================
local isFishing = false
local fishCount = 0

local function castRod()
    pcall(function()
        if equipToggle.state and Events.equip then
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
            fishCount = fishCount + 1
            print("🐟 Fish caught! Total: " .. fishCount)
        end
    end)
end

-- Fishing loop
task.spawn(function()
    while true do
        if instantToggle.state and not isFishing then
            isFishing = true
            
            if blatantToggle.state then
                for i = 1, 2 do
                    castRod()
                    task.wait(0.3)
                end
                task.wait(0.5)
                for i = 1, 3 do
                    reelIn()
                    task.wait(0.1)
                end
            else
                castRod()
                task.wait(2)
                reelIn()
            end
            
            task.wait(0.5)
            isFishing = false
        end
        task.wait(0.1)
    end
end)

-- Auto sell
task.spawn(function()
    while true do
        if sellToggle.state and Events.sell then
            pcall(function()
                Events.sell:InvokeServer()
                print("💰 Auto sold items")
            end)
        end
        task.wait(30)
    end
end)

-- Event handlers untuk toggle
instantToggle.btn.MouseButton1Click:Connect(function()
    instantToggle.state = not instantToggle.state
    instantToggle.btn.BackgroundColor3 = instantToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    instantToggle.btn.Text = instantToggle.state and "ON" or "OFF"
end)

blatantToggle.btn.MouseButton1Click:Connect(function()
    blatantToggle.state = not blatantToggle.state
    blatantToggle.btn.BackgroundColor3 = blatantToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    blatantToggle.btn.Text = blatantToggle.state and "ON" or "OFF"
end)

equipToggle.btn.MouseButton1Click:Connect(function()
    equipToggle.state = not equipToggle.state
    equipToggle.btn.BackgroundColor3 = equipToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    equipToggle.btn.Text = equipToggle.state and "ON" or "OFF"
end)

sellToggle.btn.MouseButton1Click:Connect(function()
    sellToggle.state = not sellToggle.state
    sellToggle.btn.BackgroundColor3 = sellToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    sellToggle.btn.Text = sellToggle.state and "ON" or "OFF"
end)

favToggle.btn.MouseButton1Click:Connect(function()
    favToggle.state = not favToggle.state
    favToggle.btn.BackgroundColor3 = favToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    favToggle.btn.Text = favToggle.state and "ON" or "OFF"
end)

print("✅ Moe Fisher loaded!")
print("📍 GUI di tengah layar - Klik X buat tutup, 🗕 buat minimize")    btn.TextColor3 = Colors.Text
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
             
