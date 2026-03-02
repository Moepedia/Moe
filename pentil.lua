-- ====================================================================
--                 MOE V1.0 - FINAL EDITION
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                     REMOTE FISHING (LENGKAP DARI SCAN)
-- ====================================================================
local Events = {}

local success, Net = pcall(function()
    return require(ReplicatedStorage.Packages.Net)
end)

if success and Net then
    -- Fishing Remotes
    pcall(function() Events.fishing = Net:RemoteFunction("RF/CatchFishCompleted") end)
    pcall(function() Events.charge = Net:RemoteFunction("RF/ChargeFishingRod") end)
    pcall(function() Events.minigame = Net:RemoteFunction("RF/RequestFishingMinigameStarted") end)
    pcall(function() Events.cancel = Net:RemoteFunction("RF/CancelFishingInputs") end)
    
    -- Favorite & Sell
    pcall(function() Events.favorite = Net:RemoteEvent("RE/FavoriteItem") end)
    pcall(function() Events.sell = Net:RemoteFunction("RF/SellAllItems") end)
    
    -- Equip
    pcall(function() Events.equip = Net:RemoteEvent("RE/EquipToolFromHotbar") end)
    pcall(function() Events.unequip = Net:RemoteEvent("RE/UnequipToolFromHotbar") end)
    
    -- Teleport & Boat
    pcall(function() Events.submarine = Net:RemoteEvent("RE/SubmarineTP") end)
    pcall(function() Events.spawnBoat = Net:RemoteFunction("RF/SpawnBoat") end)
    
    -- Shop
    pcall(function() Events.purchaseRod = Net:RemoteFunction("RF/PurchaseFishingRod") end)
    pcall(function() Events.purchaseBait = Net:RemoteFunction("RF/PurchaseBait") end)
    pcall(function() Events.purchaseItem = Net:RemoteFunction("RF/PurchaseMarketItem") end)
    
    print("✅ Remote fishing loaded")
else
    warn("⚠️ Net module not found, using dummy events")
    Events = {
        fishing = {InvokeServer = function() end},
        charge = {InvokeServer = function() end},
        minigame = {InvokeServer = function() end},
        favorite = {FireServer = function() end},
        sell = {InvokeServer = function() end},
        equip = {FireServer = function() end},
    }
end

-- ====================================================================
--                     DEFAULT CONFIG
-- ====================================================================
local Config = {
    InstantFish = false,
    Blatant = false,
    AutoFavorite = false,
    FavoriteRarity = "Mythic",
    FavoriteType = "Rarity",
    AutoBuyBait = false,
    TeleportLocation = "Spawn",
}

-- DARK THEME - Hitam putih transparan
local Colors = {
    Bg = Color3.fromRGB(10, 10, 10),      -- Background utama (hitam)
    Bg2 = Color3.fromRGB(18, 18, 18),      -- Surface (sedikit terang)
    Bg3 = Color3.fromRGB(25, 25, 25),      -- Untuk kontras
    Border = Color3.fromRGB(40, 40, 40),   -- Garis border
    Text = Color3.fromRGB(220, 220, 220),  -- Text putih soft
    Text2 = Color3.fromRGB(150, 150, 150), -- Text abu
    Success = Color3.fromRGB(45, 45, 45),  -- ON (abu tua)
    Danger = Color3.fromRGB(30, 30, 30),   -- OFF (abu lebih tua)
    Accent = Color3.fromRGB(60, 60, 60),   -- Hover
}

-- ====================================================================
--                     GUI SETUP (FAST LOAD)
-- ====================================================================
if CoreGui:FindFirstChild("MoeV1") then
    CoreGui.MoeV1:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeV1"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999
GUI.IgnoreGuiInset = true

-- ====================================================================
--                     FLOATING CIRCLE (MINIMIZED MODE)
-- ====================================================================
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Colors.Bg2
FloatingCircle.BackgroundTransparency = 0.2
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

-- ====================================================================
--                     MAIN WINDOW
-- ====================================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)  -- Tengah
Main.BackgroundColor3 = Colors.Bg
Main.BackgroundTransparency = 0.05  -- Sedikit transparan
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Border tipis
local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 0, 1, 0)
Border.BackgroundColor3 = Colors.Border
Border.BackgroundTransparency = 0.7
Border.BorderSizePixel = 0
Border.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Colors.Bg2
Header.BackgroundTransparency = 0.05
Header.BorderSizePixel = 0
Header.Parent = Main

-- Logo kecil
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0.5, -15)
Logo.BackgroundTransparency = 1
Logo.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
Logo.Parent = Header

-- Title "Moe V1.0"
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Moe V1.0"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
MinBtn.BackgroundColor3 = Colors.Bg3
MinBtn.Text = "−"
MinBtn.TextColor3 = Colors.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Minimize function
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- ====================================================================
--                     MENU BUTTONS (4 MENU)
-- ====================================================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(1, -20, 0, 40)
MenuFrame.Position = UDim2.new(0, 10, 0, 55)
MenuFrame.BackgroundColor3 = Colors.Bg2
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.Parent = Main

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 8)
menuCorner.Parent = MenuFrame

local menus = {"Fishing", "Favorite", "Shop", "Teleport"}
local activeMenu = "Fishing"
local menuButtons = {}
local pages = {}

for i, name in ipairs(menus) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 0, 30)
    btn.Position = UDim2.new((i-1) * 0.25, 2, 0.5, -15)
    btn.BackgroundColor3 = name == activeMenu and Colors.Accent or Colors.Bg3
    btn.Text = name
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = MenuFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    menuButtons[name] = btn
    
    -- Create page
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 0, 290)
    page.Position = UDim2.new(0, 10, 0, 105)
    page.BackgroundTransparency = 1
    page.Visible = (name == activeMenu)
    page.Parent = Main
    pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        activeMenu = name
        for _, b in pairs(menuButtons) do
            b.BackgroundColor3 = Colors.Bg3
        end
        btn.BackgroundColor3 = Colors.Accent
        
        for _, p in pairs(pages) do
            p.Visible = false
        end
        page.Visible = true
    end)
end

-- ====================================================================
--                     FISHING PAGE
-- ====================================================================
local fishingPage = pages["Fishing"]
local yPos = 5

-- Toggle Instant Fishing
local instantToggle = createToggle(fishingPage, "Instant Fishing", yPos, Config.InstantFish)
yPos = yPos + 40

-- Toggle Blatant Mode
local blatantToggle = createToggle(fishingPage, "Blatant Mode", yPos, Config.Blatant)
yPos = yPos + 40

-- Auto Equip
local equipToggle = createToggle(fishingPage, "Auto Equip Rod", yPos, true)
yPos = yPos + 40

-- Delay Slider
createSlider(fishingPage, "Cast Delay", yPos, 0.5, 3, 1.5, "s")
yPos = yPos + 45

createSlider(fishingPage, "Reel Delay", yPos, 0.1, 1, 0.3, "s")

-- ====================================================================
--                     FAVORITE PAGE
-- ====================================================================
local favPage = pages["Favorite"]
yPos = 5

local favToggle = createToggle(favPage, "Auto Favorite", yPos, Config.AutoFavorite)
yPos = yPos + 40

-- Favorite Type
local typeLabel = Instance.new("TextLabel")
typeLabel.Size = UDim2.new(1, -10, 0, 20)
typeLabel.Position = UDim2.new(0, 5, 0, yPos)
typeLabel.BackgroundTransparency = 1
typeLabel.Text = "Favorite By:"
typeLabel.TextColor3 = Colors.Text2
typeLabel.Font = Enum.Font.Gotham
typeLabel.TextSize = 12
typeLabel.TextXAlignment = Enum.TextXAlignment.Left
typeLabel.Parent = favPage

yPos = yPos + 20

local typeBtn = Instance.new("TextButton")
typeBtn.Size = UDim2.new(1, -10, 0, 30)
typeBtn.Position = UDim2.new(0, 5, 0, yPos)
typeBtn.BackgroundColor3 = Colors.Bg3
typeBtn.Text = "Rarity"
typeBtn.TextColor3 = Colors.Text
typeBtn.Font = Enum.Font.Gotham
typeBtn.TextSize = 14
typeBtn.BorderSizePixel = 0
typeBtn.Parent = favPage

local typeCorner = Instance.new("UICorner")
typeCorner.CornerRadius = UDim.new(0, 6)
typeCorner.Parent = typeBtn

yPos = yPos + 40

-- Rarity Dropdown
local rarityLabel = Instance.new("TextLabel")
rarityLabel.Size = UDim2.new(1, -10, 0, 20)
rarityLabel.Position = UDim2.new(0, 5, 0, yPos)
rarityLabel.BackgroundTransparency = 1
rarityLabel.Text = "Min Rarity:"
rarityLabel.TextColor3 = Colors.Text2
rarityLabel.Font = Enum.Font.Gotham
rarityLabel.TextSize = 12
rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
rarityLabel.Parent = favPage

yPos = yPos + 20

local rarityBtn = Instance.new("TextButton")
rarityBtn.Size = UDim2.new(1, -10, 0, 30)
rarityBtn.Position = UDim2.new(0, 5, 0, yPos)
rarityBtn.BackgroundColor3 = Colors.Bg3
rarityBtn.Text = "Mythic"
rarityBtn.TextColor3 = Colors.Text
rarityBtn.Font = Enum.Font.Gotham
rarityBtn.TextSize = 14
rarityBtn.BorderSizePixel = 0
rarityBtn.Parent = favPage

local rarityCorner = Instance.new("UICorner")
rarityCorner.CornerRadius = UDim.new(0, 6)
rarityCorner.Parent = rarityBtn

-- ====================================================================
--                     SHOP PAGE
-- ====================================================================
local shopPage = pages["Shop"]
yPos = 5

-- Buy Bait
local baitBtn = Instance.new("TextButton")
baitBtn.Size = UDim2.new(1, -10, 0, 40)
baitBtn.Position = UDim2.new(0, 5, 0, yPos)
baitBtn.BackgroundColor3 = Colors.Bg3
baitBtn.Text = "🎣 Buy Bait (x10)"
baitBtn.TextColor3 = Colors.Text
baitBtn.Font = Enum.Font.GothamBold
baitBtn.TextSize = 14
baitBtn.BorderSizePixel = 0
baitBtn.Parent = shopPage

local baitCorner = Instance.new("UICorner")
baitCorner.CornerRadius = UDim.new(0, 8)
baitCorner.Parent = baitBtn

yPos = yPos + 45

-- Buy Fishing Rod
local rodBtn = Instance.new("TextButton")
rodBtn.Size = UDim2.new(1, -10, 0, 40)
rodBtn.Position = UDim2.new(0, 5, 0, yPos)
rodBtn.BackgroundColor3 = Colors.Bg3
rodBtn.Text = "🎣 Buy Fishing Rod"
rodBtn.TextColor3 = Colors.Text
rodBtn.Font = Enum.Font.GothamBold
rodBtn.TextSize = 14
rodBtn.BorderSizePixel = 0
rodBtn.Parent = shopPage

local rodCorner = Instance.new("UICorner")
rodCorner.CornerRadius = UDim.new(0, 8)
rodCorner.Parent = rodBtn

yPos = yPos + 45

-- Auto Buy Bait Toggle
local autoBaitToggle = createToggle(shopPage, "Auto Buy Bait", yPos, false)

-- ====================================================================
--                     TELEPORT PAGE
-- ====================================================================
local tpPage = pages["Teleport"]
yPos = 5

-- Locations list
local locations = {"Spawn", "Sisyphus", "Coral", "Esoteric", "Crater", "Lost Isle", "Weather", "Grove", "Hallow", "Treasure", "Kohana", "Cellar", "Jungle", "Temple"}

local locLabel = Instance.new("TextLabel")
locLabel.Size = UDim2.new(1, -10, 0, 20)
locLabel.Position = UDim2.new(0, 5, 0, yPos)
locLabel.BackgroundTransparency = 1
locLabel.Text = "Select Location:"
locLabel.TextColor3 = Colors.Text2
locLabel.Font = Enum.Font.Gotham
locLabel.TextSize = 12
locLabel.TextXAlignment = Enum.TextXAlignment.Left
locLabel.Parent = tpPage

yPos = yPos + 20

local locBtn = Instance.new("TextButton")
locBtn.Size = UDim2.new(1, -10, 0, 35)
locBtn.Position = UDim2.new(0, 5, 0, yPos)
locBtn.BackgroundColor3 = Colors.Bg3
locBtn.Text = locations[1]
locBtn.TextColor3 = Colors.Text
locBtn.Font = Enum.Font.Gotham
locBtn.TextSize = 14
locBtn.BorderSizePixel = 0
locBtn.Parent = tpPage

local locCorner = Instance.new("UICorner")
locCorner.CornerRadius = UDim.new(0, 6)
locCorner.Parent = locBtn

local locIndex = 1
locBtn.MouseButton1Click:Connect(function()
    locIndex = locIndex + 1
    if locIndex > #locations then locIndex = 1 end
    locBtn.Text = locations[locIndex]
end)

yPos = yPos + 45

-- Teleport button
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -10, 0, 45)
tpBtn.Position = UDim2.new(0, 5, 0, yPos)
tpBtn.BackgroundColor3 = Colors.Accent
tpBtn.Text = "🚀 TELEPORT NOW"
tpBtn.TextColor3 = Colors.Text
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16
tpBtn.BorderSizePixel = 0
tpBtn.Parent = tpPage

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn

yPos = yPos + 55

-- Save position
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -10, 0, 35)
saveBtn.Position = UDim2.new(0, 5, 0, yPos)
saveBtn.BackgroundColor3 = Colors.Bg3
saveBtn.Text = "💾 Save Current Position"
saveBtn.TextColor3 = Colors.Text
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 14
saveBtn.BorderSizePixel = 0
saveBtn.Parent = tpPage

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- ====================================================================
--                     HELPER FUNCTIONS
-- ====================================================================
function createToggle(parent, text, yPos, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
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
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 13)
    btnCorner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Colors.Success or Colors.Danger
        btn.Text = state and "ON" or "OFF"
    end)
    
    return {frame = frame, btn = btn, state = state}
end

function createSlider(parent, text, yPos, min, max, default, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default .. suffix
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
    minusBtn.Text = "−"
    minusBtn.TextColor3 = Colors.Text
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 16
    minusBtn.BorderSizePixel = 0
    minusBtn.Parent = frame
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 6)
    minusCorner.Parent = minusBtn
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 25)
    valueLabel.Position = UDim2.new(1, -55, 0, 0)
    valueLabel.BackgroundColor3 = Colors.Bg3
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Text
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = frame
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 6)
    valueCorner.Parent = valueLabel
    
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
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 6)
    plusCorner.Parent = plusBtn
    
    minusBtn.MouseButton1Click:Connect(function()
        value = math.max(min, value - 0.1)
        value = math.floor(value * 10 + 0.5) / 10
        valueLabel.Text = tostring(value)
        label.Text = text .. ": " .. value .. suffix
    end)
    
    plusBtn.MouseButton1Cl
