-- ====================================================================
--                 MOE V1.0 - ANTI-KICK EDITION
--           GUI MUNCUL DULU, REMOTE DIPANGGIL BELAKANGAN
-- ====================================================================

-- Tunggu game loading
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                     ANTI-KICK SYSTEM
-- ====================================================================
-- Block semua remote yang mencurigakan
local oldNamecall = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod and getnamecallmethod() or ""
    
    -- Kalo ini remote function/event, block dulu sampe GUI jadi
    if self:IsA("RemoteFunction") or self:IsA("RemoteEvent") then
        if self.Name:find("Kick") or self.Name:find("Ban") or self.Name:find("AntiCheat") then
            return nil
        end
    end
    
    return oldNamecall and oldNamecall(self, ...)
end)

-- ====================================================================
--                     GUI LANGSUNG MUNCUL (PERSIS REMOTE FINDER)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999999

-- Main Frame - PERSIS REMOTE FINDER
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 450)
Main.Position = UDim2.new(0.5, -190, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Title Bar - PERSIS REMOTE FINDER
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "📋 MOE V1.0"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button - PERSIS REMOTE FINDER
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

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

-- Floating Circle
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- Loading Message - Biar keliatan GUI langsung kerja
local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(0.9, 0, 0, 30)
LoadingLabel.Position = UDim2.new(0.05, 0, 0, 90)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "⏳ Loading features..."
LoadingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.TextSize = 14
LoadingLabel.Parent = Main

-- ====================================================================
--                     REMOTE DIPANGGIL SETELAH GUI JADI
-- ====================================================================
task.spawn(function()
    -- Kasih waktu GUI tampil dulu
    task.wait(2)
    
    LoadingLabel.Text = "✅ Features loaded!"
    task.wait(0.5)
    LoadingLabel.Visible = false
    
    -- Baru panggil remote
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
    end
    
    -- ====================================================================
    --                     MENU BUTTONS (BARU DIBUAT)
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
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
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
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
            btn.Text = state and "ON" or "OFF"
        end)
        
        return {frame = frame, btn = btn, state = state}
    end
    
    local instantToggle = createToggle(fishingPage, "Instant Fishing", yPos, false)
    yPos = yPos + 40
    
    local blatantToggle = createToggle(fishingPage, "Blatant Mode", yPos, false)
    yPos = yPos + 40
    
    local equipToggle = createToggle(fishingPage, "Auto Equip Rod", yPos, true)
    yPos = yPos + 45
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -10, 0, 30)
    infoLabel.Position = UDim2.new(0, 5, 0, yPos)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "⚡ Click ON to start fishing"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = fishingPage
    
    -- ====================================================================
    --                     FAVORITE PAGE (SIMPLE)
    -- ====================================================================
    local favPage = pages["Favorite"]
    yPos = 10
    
    local favToggle = createToggle(favPage, "Auto Favorite", yPos, false)
    yPos = yPos + 40
    
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
    --                     SHOP PAGE (SIMPLE)
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
    
    -- ====================================================================
    --                     TELEPORT PAGE (SIMPLE)
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
    
    -- ====================================================================
    --                     FISHING LOGIC (START AFTER GUI)
    -- ====================================================================
    local isFishing = false
    
    local function castRod()
        if not Events.charge then return end
        pcall(function()
            Events.charge:InvokeServer()
        end)
    end
    
    local function reelIn()
        if not Events.fishing then return end
        pcall(function()
            Events.fishing:InvokeServer()
        end)
    end
    
    task.spawn(function()
        while true do
            if instantToggle and instantToggle.state and not isFishing then
                isFishing = true
                
                if blatantToggle and blatantToggle.state then
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
                    task.wait(1.5)
                    reelIn()
                end
                
                task.wait(0.5)
                isFishing = false
            end
            task.wait(0.1)
        end
    end)
end)

print("✅ GUI MUNCUL! Tunggu 2 detik buat load features...")
local function humanizeDelay(base)
    return base + (math.random(-200, 200) / 1000)  -- Tambah random ±0.2 detik
end

-- ====================================================================
--                     GUI SETUP (DI TEMPAT AMAN)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = math.huge

-- ====================================================================
--                     MAIN FRAME
-- ====================================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 450)
Main.Position = UDim2.new(0.5, -190, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BackgroundTransparency = 0.1  -- Biar transparan dikit
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() GUI.Enabled = false end)  -- Jangan destroy, cuma hide

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar

-- Floating Circle
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FloatingCircle.BackgroundTransparency = 0.2
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- ====================================================================
--                     MENU BUTTONS
-- ====================================================================
local MenuBar = Instance.new("Frame")
MenuBar.Size = UDim2.new(0.9, 0, 0, 40)
MenuBar.Position = UDim2.new(0.05, 0, 0, 50)
MenuBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
    btn.BackgroundColor3 = name == activeMenu and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
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
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- Toggles dengan callback yang aman
function createToggle(parent, text, yPos, default, callback)
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
    btn.BackgroundColor3 = default and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(120, 60, 60)
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
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(120, 60, 60)
        btn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return {frame = frame, btn = btn, state = state}
end

-- Fishing toggles
local instantToggle = createToggle(fishingPage, "Instant Fishing", yPos, false)
yPos = yPos + 40

local blatantToggle = createToggle(fishingPage, "Blatant Mode", yPos, false)
yPos = yPos + 40

local equipToggle = createToggle(fishingPage, "Auto Equip Rod", yPos, true)
yPos = yPos + 45

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 40)
infoLabel.Position = UDim2.new(0, 5, 0, yPos)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "⚡ Humanized mode aktif\nRandom delays biar aman"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = fishingPage

-- ====================================================================
--                     FISHING LOGIC (HUMANIZED)
-- ====================================================================
local isFishing = false

local function safeCast()
    if not Events.charge then return end
    pcall(function()
        -- Random delay biar ga keliatan bot
        task.wait(getRandomDelay(0.1, 0.3))
        Events.charge:InvokeServer()
    end)
end

local function safeReel()
    if not Events.fishing then return end
    pcall(function()
        task.wait(getRandomDelay(0.1, 0.2))
        Events.fishing:InvokeServer()
    end)
end

-- Fishing loop dengan humanized delays
task.spawn(function()
    while true do
        if instantToggle and instantToggle.state and not isFishing then
            isFishing = true
            
            if blatantToggle and blatantToggle.state then
                -- Blatant tapi tetap random
                for i = 1, math.random(2, 3) do
                    safeCast()
                    task.wait(getRandomDelay(0.2, 0.4))
                end
                
                task.wait(getRandomDelay(0.5, 0.8))
                
                for i = 1, math.random(3, 4) do
                    safeReel()
                    task.wait(getRandomDelay(0.1, 0.2))
                end
            else
                -- Normal mode dengan random
                safeCast()
                task.wait(getRandomDelay(1.8, 2.5))  -- Random delay biar natural
                safeReel()
            end
            
            task.wait(getRandomDelay(0.5, 1.0))
            isFishing = false
        end
        task.wait(getRandomDelay(0.1, 0.3))
    end
end)

-- ====================================================================
--                     ANTI-DETECTION TIPS
-- ====================================================================
print("✅ MOE V1.0 - Anti-Detection Mode")
print("🛡️ Anti-kick aktif | Humanized delays")
print("⚠️ TETAP HATI-HATI! Tidak ada jaminan 100% aman")
