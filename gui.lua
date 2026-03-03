-- Moe V1.0 GUI for FISH IT - WORKING VERSION
-- Dengan remote hash yang benar dari hasil scan

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== FUNGSI GET REMOTE DENGAN HASH =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromHash(folder, hashName)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then
            return rf:FindFirstChild(hashName)
        end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then
            return re:FindFirstChild(hashName)
        end
    end
    return nil
end

-- ===== REMOTE REFERENCES DENGAN HASH =====
local Remote = {
    -- Fishing
    ChargeRod = getRemoteFromHash("RF", "aae67692fc443eb0cd6545ac1a4069ced9a4285e239b3e6b7d323b7d17070b5a"),
    CatchFish = getRemoteFromHash("RF", "c8b2a8521a1070700a600023e08f1c66ee4f92703846a87dc75c0d0d2999b762"),
    FishingMinigame = getRemoteFromHash("RE", "609e281eb1fbf03c9f0721e7dde16b73b4d06ff1fec785fe4db2dfe51e9a0caa"),
    
    -- Bait
    PurchaseBait = getRemoteFromHash("RF", "749e74fbc5fc3d196df3235c7e0e96639484e875de7bfe82629d1b86a0c6f01d"),
    EquipBait = getRemoteFromHash("RE", "55a2c14da700896b9e9aed3b7e18c550a7ae5b43f1a5715012d08695da66744e"),
    
    -- Rod
    PurchaseRod = getRemoteFromHash("RF", "631361fdb4712a1bbd2df65a1c5fd948e6f85e5f30ef746c022a4ba1bf5c3399"),
    EquipRodSkin = getRemoteFromHash("RE", "bbeb56f30d491f113e3b3ed28b781b1d62cf54a8acc66ab53a287d4b928fc60e"),
    
    -- Weather
    PurchaseWeather = getRemoteFromHash("RF", "f7df2819493cf037d3870073bcb17495569565c5a08c7bd2b3632f440a361335"),
    WeatherCommand = getRemoteFromHash("RE", "33e2a9e4854072028b2dc6cb66fe1365ad2d0bebf72421f844ccb80e780e2f4f"),
    
    -- Teleport
    SubmarineTP = getRemoteFromHash("RE", "928d8de8e3eb5606c1f8fa132ea864651b7ffccf657712dc901b41140245bf1e"),
    SubmarineTP2 = getRemoteFromHash("RF", "eb65137a3cc2db9807aa5611a637c52a60fde0b7aaf4f6c44c3f8f862615f624"),
    BoatTeleport = getRemoteFromHash("RE", "77b7094cc914d16aa1726af03e8689b57f7e5832c9756e3f7dfac310e8de1a54"),
    
    -- Quest
    ClaimDailyLogin = getRemoteFromHash("RF", "91f555bbe3531dd9d8461f63f1b5ed9fdfe8275e29df3d6b4bf50d016c58cf6e"),
    ClaimBounty = getRemoteFromHash("RF", "970dc117e86b893579c095f746bfd11bb5ad743effa48a4b11f9b3acaab40e1b"),
    ClaimEventReward = getRemoteFromHash("RE", "3205d5ea83639e08c73e6c8a2605acf32e604bd7785761e488cbf47971cd9021"),
    
    -- Sell
    SellAll = getRemoteFromHash("RF", "478362a898e12ac6421d7a6b918dab8385b48c04cfaba211fdb6dd48111107e6"),
    SellItem = getRemoteFromHash("RF", "61ac0f04b309d722f1df60502b90edcd4bca7cd395c192e06bc5497d5ce0b598"),
}

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== MAIN FRAME (650x400) =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 1, 0)
title.Position = UDim2.new(0, 38, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

-- Minimize button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -60, 0.5, -12.5)
minButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minButton

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundTransparency = 1
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, 0, 1, 0)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatLogoCorner = Instance.new("UICorner")
floatLogoCorner.CornerRadius = UDim.new(0, 25)
floatLogoCorner.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo

-- Minimize functions
minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 130, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- ===== RIGHT CONTENT AREA =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

-- Content title
local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 25)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Fishing Features"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 14
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- Scrolling frame for features
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENTS =====
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "Instant Fishing")
    createButton(featuresContainer, "CHARGE ROD", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
            notify("Fishing", "Rod charged")
        end
    end)
    
    createButton(featuresContainer, "CATCH FISH", function()
        if Remote.CatchFish then
            Remote.CatchFish:FireServer()
            notify("Fishing", "Fish caught")
        end
    end)
    
    createLabel(featuresContainer, "Blatant Mode")
    createButton(featuresContainer, "BYPASS MINIGAME", function()
        if Remote.FishingMinigame then
            Remote.FishingMinigame:FireServer(true)
            notify("Fishing", "Minigame bypassed")
        end
    end)
    
    createLabel(featuresContainer, "Auto Sell")
    createButton(featuresContainer, "SELL ALL NOW", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            notify("Fishing", "All items sold")
        end
    end)
end

-- Bait Menu
local function showBait()
    clearFeatures()
    contentTitle.Text = "Bait Shop"
    
    createLabel(featuresContainer, "Buy Bait")
    createButton(featuresContainer, "BUY STARTER BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer("Starter Bait", 1)
            notify("Bait", "Purchased Starter Bait")
        end
    end)
    
    createButton(featuresContainer, "BUY LUCK BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer("Luck Bait", 1)
            notify("Bait", "Purchased Luck Bait")
        end
    end)
    
    createButton(featuresContainer, "BUY CORRUPT BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer("Corrupt Bait", 1)
            notify("Bait", "Purchased Corrupt Bait")
        end
    end)
    
    createLabel(featuresContainer, "Equip Bait")
    createButton(featuresContainer, "EQUIP CURRENT BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer()
            notify("Bait", "Bait equipped")
        end
    end)
end

-- Rod Menu
local function showRod()
    clearFeatures()
    contentTitle.Text = "Rod Shop"
    
    createLabel(featuresContainer, "Buy Rod")
    createButton(featuresContainer, "BUY STARTER ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer("Starter Rod", 1)
            notify("Rod", "Purchased Starter Rod")
        end
    end)
    
    createButton(featuresContainer, "BUY CARBON ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer("Carbon Rod", 1)
            notify("Rod", "Purchased Carbon Rod")
        end
    end)
    
    createButton(featuresContainer, "BUY LUCKY ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer("Lucky Rod", 1)
            notify("Rod", "Purchased Lucky Rod")
        end
    end)
    
    createLabel(featuresContainer, "Rod Skin")
    createButton(featuresContainer, "EQUIP ROD SKIN", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer()
            notify("Rod", "Skin equipped")
        end
    end)
end

-- Weather Menu
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    createLabel(featuresContainer, "Activate Weather")
    createButton(featuresContainer, "SET CLEAR", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Clear")
            notify("Weather", "Weather set to Clear")
        end
    end)
    
    createButton(featuresContainer, "SET RAIN", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Rain")
            notify("Weather", "Weather set to Rain")
        end
    end)
    
    createButton(featuresContainer, "SET STORM", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Storm")
            notify("Weather", "Weather set to Storm")
        end
    end)
    
    createButton(featuresContainer, "SET SHARK HUNT", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Shark Hunt")
            notify("Weather", "Shark Hunt activated")
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "Teleport Options")
    createButton(featuresContainer, "TELEPORT TO SPAWN", function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer("Spawn")
            notify("Teleport", "Teleported to Spawn")
        end
    end)
    
    createButton(featuresContainer, "TELEPORT TO TREASURE", function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer("Treasure Room")
            notify("Teleport", "Teleported to Treasure Room")
        end
    end)
    
    createButton(featuresContainer, "BOAT TELEPORT", function()
        if Remote.BoatTeleport then
            Remote.BoatTeleport:FireServer()
            notify("Teleport", "Boat teleported")
        end
    end)
end

-- Quest Menu
local function showQuest()
    clearFeatures()
    contentTitle.Text = "Quests"
    
    createLabel(featuresContainer, "Daily Quests")
    createButton(featuresContainer, "CLAIM DAILY LOGIN", function()
        if Remote.ClaimDailyLogin then
            Remote.ClaimDailyLogin:FireServer()
            notify("Quest", "Daily login claimed")
        end
    end)
    
    createButton(featuresContainer, "CLAIM BOUNTY", function()
        if Remote.ClaimBounty then
            Remote.ClaimBounty:FireServer()
            notify("Quest", "Bounty claimed")
        end
    end)
    
    createButton(featuresContainer, "CLAIM EVENT REWARD", function()
        if Remote.ClaimEventReward then
            Remote.ClaimEventReward:FireServer()
            notify("Quest", "Event reward claimed")
        end
    end)
end

-- ===== CREATE LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Bait", func = showBait},
    {name = "Rod", func = showRod},
    {name = "Weather", func = showWeather},
    {name = "Teleport", func = showTeleport},
    {name = "Quest", func = showQuest}
}

local currentMenu = ""

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.1
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        currentMenu = btnData.name
        btnData.func()
    end)
end

-- Show Fishing menu by default
task.wait(0.1)
showFishing()

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Moe V1.0 GUI Loaded - Working with remote hashes")