-- ====================================================================
--                 MOE V1.0 - FINAL FIXED EDITION
--           COPY PASTE FORMAT DARI REMOTE FINDER (PASTI MUNCUL!)
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")  -- ✅ HARUS INI!
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
    pcall(function() Events.favorite = Net:RemoteEvent("RE/FavoriteItem") end)
    pcall(function() Events.sell = Net:RemoteFunction("RF/SellAllItems") end)
    pcall(function() Events.equip = Net:RemoteEvent("RE/EquipToolFromHotbar") end)
    print("✅ Remote OK")
else
    warn("⚠️ Remote dummy")
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
--                     GUI SETUP (PERSIS REMOTE FINDER)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui  -- PAKE CoreGui yang udah bener
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ====================================================================
--                     MAIN FRAME (COPY EXACTLY)
-- ====================================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 450)  -- Ukuran nyaman
Main.Position = UDim2.new(0.5, -190, 0.5, -225)  -- Tengah
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  -- Dark
Main.BorderSizePixel = 0
Main.Active = true  -- ✅ PENTING!
Main.Draggable = true  -- ✅ PENTING!
Main.Parent = GUI

-- Title Bar (biar mirip Remote Finder)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 MOE V1.0"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button (X) - PERSIS Remote Finder
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

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

-- ====================================================================
--                     MENU BUTTONS (4 MENU)
-- ====================================================================
local MenuBar = Instance.new("Frame")
MenuBar.Size = UDim2.new(0.9, 0, 0, 40)
MenuBar.Position = UDim2.new(0.05, 0, 0, 50)
MenuBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MenuBar.BorderSizePixel = 0
MenuBar.Parent = Main

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 6)
menuCorner.Parent = MenuBar

local menus = {"Fishing", "Favorite", "Shop", "Teleport"}
local activeMenu = "Fishing"
local menuButtons = {}
local pages = {}

for i, name in ipairs(menus) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 0, 30)
    btn.Position = UDim2.new((i-1) * 0.25, 2, 0.5, -15)
    btn.BackgroundColor3 = name == activeMenu and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = MenuBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    menuButtons[name] = btn
    
    -- Create page frame
    local page = Instance.new("Frame")
    page.Size = UDim2.new(0.9, 0, 0, 320)
    page.Position = UDim2.new(0.05, 0, 0, 100)
    page.BackgroundTransparency = 1
    page.Visible = (name == activeMenu)
    page.Parent = Main
    pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        activeMenu = name
        for _, b in pairs(menuButtons) do
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
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
local yPos = 10

-- Toggle Instant Fishing
local instantToggle = createToggle(fishingPage, "Instant Fishing", yPos, false)
yPos = yPos + 40

-- Toggle Blatant Mode
local blatantToggle = createToggle(fishingPage, "Blatant Mode", yPos, false)
yPos = yPos + 40

-- Auto Equip
local equipToggle = createToggle(fishingPage, "Auto Equip Rod", yPos, true)
yPos = yPos + 45

-- Delay info
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, -10, 0, 20)
delayLabel.Position = UDim2.new(0, 5, 0, yPos)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "⚡ Default delays: Cast 1.5s | Reel 0.3s"
delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = fishingPage

-- ====================================================================
--                     FAVORITE PAGE
-- ====================================================================
local favPage = pages["Favorite"]
yPos = 10

local favToggle = createToggle(favPage, "Auto Favorite", yPos, false)
yPos = yPos + 40

-- Favorite By
local favByLabel = Instance.new("TextLabel")
favByLabel.Size = UDim2.new(1, -10, 0, 20)
favByLabel.Position = UDim2.new(0, 5, 0, yPos)
favByLabel.BackgroundTransparency = 1
favByLabel.Text = "Favorite by: Rarity"
favByLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
favByLabel.Font = Enum.Font.Gotham
favByLabel.TextSize = 12
favByLabel.TextXAlignment = Enum.TextXAlignment.Left
favByLabel.Parent = favPage

yPos = yPos + 25

local rarityLabel = Instance.new("TextLabel")
rarityLabel.Size = UDim2.new(1, -10, 0, 20)
rarityLabel.Position = UDim2.new(0, 5, 0, yPos)
rarityLabel.BackgroundTransparency = 1
rarityLabel.Text = "Min Rarity: Mythic"
rarityLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
rarityLabel.Font = Enum.Font.Gotham
rarityLabel.TextSize = 12
rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
rarityLabel.Parent = favPage

-- ====================================================================
--                     SHOP PAGE
-- ====================================================================
local shopPage = pages["Shop"]
yPos = 10

local baitBtn = Instance.new("TextButton")
baitBtn.Size = UDim2.new(1, -10, 0, 35)
baitBtn.Position = UDim2.new(0, 5, 0, yPos)
baitBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
baitBtn.Text = "🎣 Buy Bait"
baitBtn.TextColor3 = Color3.new(1, 1, 1)
baitBtn.Font = Enum.Font.Gotham
baitBtn.TextSize = 14
baitBtn.BorderSizePixel = 0
baitBtn.Parent = shopPage

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = baitBtn

yPos = yPos + 45

local rodBtn = Instance.new("TextButton")
rodBtn.Size = UDim2.new(1, -10, 0, 35)
rodBtn.Position = UDim2.new(0, 5, 0, yPos)
rodBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rodBtn.Text = "🎣 Buy Fishing Rod"
rodBtn.TextColor3 = Color3.new(1, 1, 1)
rodBtn.Font = Enum.Font.Gotham
rodBtn.TextSize = 14
rodBtn.BorderSizePixel = 0
rodBtn.Parent = shopPage

local rodCorner = Instance.new("UICorner")
rodCorner.CornerRadius = UDim.new(0, 6)
rodCorner.Parent = rodBtn

-- ====================================================================
--                     TELEPORT PAGE
-- ====================================================================
local tpPage = pages["Teleport"]
yPos = 10

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -10, 0, 40)
tpBtn.Position = UDim2.new(0, 5, 0, yPos)
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpBtn.Text = "🚀 Teleport to Spawn"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
tpBtn.BorderSizePixel = 0
tpBtn.Parent = tpPage

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn

yPos = yPos + 50

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -10, 0, 35)
saveBtn.Position = UDim2.new(0, 5, 0, yPos)
saveBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
saveBtn.Text = "💾 Save Position"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
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
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 13)
    btnCorner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        btn.Text = state and "ON" or "OFF"
    end)
    
    return {frame = frame, btn = btn, state = state}
end

-- ====================================================================
--                     FISHING LOGIC
-- ====================================================================
local isFishing = false

task.spawn(function()
    while true do
        if instantToggle and instantToggle.state and not isFishing then
            isFishing = true
            
            if blatantToggle and blatantToggle.state then
                pcall(function()
                    if Events.charge then Events.charge:InvokeServer() end
                    task.wait(0.3)
                    if Events.charge then Events.charge:InvokeServer() end
                    task.wait(0.5)
                    for i = 1, 3 do
                        if Events.fishing then Events.fishing:InvokeServer() end
                        task.wait(0.1)
                    end
                end)
            else
                pcall(function()
                    if Events.charge then Events.charge:InvokeServer() end
                    task.wait(1.5)
                    if Events.fishing then Events.fishing:InvokeServer() end
                end)
            end
            
            task.wait(0.5)
            isFishing = false
        end
        task.wait(0.1)
    end
end)

print("✅ MOE V1.0 LOADED!")
print("📍 GUI di tengah layar - Klik X tutup, - minimize")
