-- Moe V1.0 GUI for FISH IT - LEFT MENU STYLE (650x400)
-- Dengan path remote yang benar dari folder Packages

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== DATA LOKASI TELEPORT =====
local TeleportLocations = {
    "Spawn",
    "Sisyphus Statue",
    "Coral Reefs",
    "Esoteric Depths",
    "Crater Island",
    "Lost Isle",
    "Weather Machine",
    "Tropical Grove",
    "Mount Hallow",
    "Treasure Room",
    "Kohana",
    "Underground Cellar",
    "Ancient Jungle",
    "Sacred Temple"
}

-- ===== DATA BAIT =====
local BaitNames = {
    "Starter Bait",
    "Topwater Bait",
    "Luck Bait",
    "Midnight Bait",
    "Nature Bait",
    "Chroma Bait",
    "Royal Bait",
    "Dark Matter Bait",
    "Corrupt Bait",
    "Aether Bait",
    "Floral Bait",
    "Singularity Bait"
}

-- ===== DATA ROD =====
local RodNames = {
    "Starter Rod",
    "Luck Rod",
    "Carbon Rod",
    "Toy Rod",
    "Grass Rod",
    "Damascus Rod",
    "Ice Rod",
    "Lava Rod",
    "Lucky Rod",
    "Midnight Rod",
    "Steampunk Rod",
    "Chrome Rod",
    "Fluorescent Rod",
    "Astral Rod",
    "Hazmat Rod",
    "Ares Rod",
    "Angler Rod",
    "Ghostfinn Rod",
    "Bamboo Rod",
    "Element Rod",
    "Diamond Rod"
}

-- ===== DATA WEATHER =====
local WeatherNames = {
    "Wind",
    "Cloudy",
    "Snow",
    "Storm",
    "Radiant",
    "Shark Hunt"
}

-- ===== DATA QUEST =====
local QuestData = {
    {
        name = "Ghostfinn Rod",
        requirements = {
            "Catch 300 Rare/Epic fish in Treasure Room",
            "Catch 3 Mythic at Sisyphus Statue",
            "Catch 1 Secret at Sisyphus Statue",
            "Earn 1M coins"
        },
        locations = {"Treasure Room", "Sisyphus Statue"}
    },
    {
        name = "Element Rod",
        requirements = {
            "Own Ghostfinn Rod",
            "Catch 1 Secret at Ancient Jungle",
            "Catch 1 Secret at Sacred Temple",
            "Create 3 Transcended Stones"
        },
        locations = {"Ancient Jungle", "Sacred Temple"}
    },
    {
        name = "Diamond Rod",
        requirements = {
            "Own Element Rod",
            "Catch SECRET Fish at Coral Reefs",
            "Catch SECRET Fish at Tropical Grove",
            "Bring Lary a Mutated Gemstone Ruby",
            "Bring Lary a Lochness Monster",
            "Catch 1000 Fish while using PERFECT throw"
        },
        locations = {"Coral Reefs", "Tropical Grove"}
    }
}

-- ===== REMOTE FUNCTIONS DARI PACKAGES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromPackages(folder, name)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then
            return rf:FindFirstChild(name)
        end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then
            return re:FindFirstChild(name)
        end
    end
    
    return nil
end

local Remote = {
    -- Fishing
    ChargeRod = getRemoteFromPackages("RF", "ChargeFishingRod"),
    CatchFish = getRemoteFromPackages("RF", "CatchFishCompleted"),
    FishingMinigame = getRemoteFromPackages("RE", "FishingMinigameChanged"),
    FishingStopped = getRemoteFromPackages("RE", "FishingStopped"),
    
    -- Bait
    PurchaseBait = getRemoteFromPackages("RF", "PurchaseBait"),
    EquipBait = getRemoteFromPackages("RE", "EquipBait"),
    
    -- Rod
    PurchaseRod = getRemoteFromPackages("RF", "PurchaseFishingRod"),
    EquipRodSkin = getRemoteFromPackages("RE", "EquipRodSkin"),
    
    -- Weather
    PurchaseWeather = getRemoteFromPackages("RF", "PurchaseWeatherEvent"),
    WeatherCommand = getRemoteFromPackages("RE", "WeatherCommand"),
    
    -- Teleport
    SubmarineTP = getRemoteFromPackages("RE", "SubmarineTP"),
    SubmarineTP2 = getRemoteFromPackages("RF", "SubmarineTP2"),
    BoatTeleport = getRemoteFromPackages("RE", "BoatTeleport"),
    
    -- Quest
    ClaimDailyLogin = getRemoteFromPackages("RF", "ClaimDailyLogin"),
    ClaimBounty = getRemoteFromPackages("RF", "ClaimBounty"),
    ClaimEventReward = getRemoteFromPackages("RE", "ClaimEventReward"),
    
    -- Sell
    SellAll = getRemoteFromPackages("RF", "SellAllItems"),
    SellItem = getRemoteFromPackages("RF", "SellItem"),
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
local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.FillDirection = Enum.FillDirection.Vertical
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.Parent = dropdownFrame
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdownFrame
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdownFrame.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)
    
    return frame
end

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

local function createInfoBox(parent, title, content)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 5, 0, 3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 0)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -10, 0, 25)
    contentLabel.Position = UDim2.new(0, 5, 0, 23)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    contentLabel.TextSize = 11
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = frame
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
    
    createLabel(featuresContainer, "Select Bait")
    
    local selectedBait = BaitNames[1]
    
    createDropdown(featuresContainer, BaitNames, BaitNames[1], function(selected)
        selectedBait = selected
        notify("Bait", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "BUY SELECTED BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer(selectedBait, 1)
            notify("Bait", "Purchased " .. selectedBait)
        end
    end)
    
    createButton(featuresContainer, "EQUIP SELECTED BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer(selectedBait)
            notify("Bait", "Equipped " .. selectedBait)
        end
    end)
end

-- Rod Menu
local function showRod()
    clearFeatures()
    contentTitle.Text = "Rod Shop"
    
    createLabel(featuresContainer, "Select Rod")
    
    local selectedRod = RodNames[1]
    
    createDropdown(featuresContainer, RodNames, RodNames[1], function(selected)
        selectedRod = selected
        notify("Rod", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "BUY SELECTED ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer(selectedRod, 1)
            notify("Rod", "Purchased " .. selectedRod)
        end
    end)
    
    createButton(featuresContainer, "EQUIP ROD SKIN", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer(selectedRod)
            notify("Rod", "Skin equipped")
        end
    end)
end

-- Weather Menu
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    createLabel(featuresContainer, "Select Weather")
    
    local selectedWeather = WeatherNames[1]
    
    createDropdown(featuresContainer, WeatherNames, WeatherNames[1], function(selected)
        selectedWeather = selected
        notify("Weather", "Selected: " .. selected)
    end)
    
    createButton(featuresContainer, "ACTIVATE WEATHER", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer(selectedWeather)
            notify("Weather", "Activated " .. selectedWeather)
        end
    end)
    
    createLabel(featuresContainer, "Weather Slots")
    createButton(featuresContainer, "BUY SLOT 1", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(1, selectedWeather)
            notify("Weather", "Slot 1 set to " .. selectedWeather)
        end
    end)
    
    createButton(featuresContainer, "BUY SLOT 2", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(2, selectedWeather)
            notify("Weather", "Slot 2 set to " .. selectedWeather)
        end
    end)
    
    createButton(featuresContainer, "BUY SLOT 3", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(3, selectedWeather)
            notify("Weather", "Slot 3 set to " .. selectedWeather)
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "Teleport to Location")
    
    local selectedLoc = TeleportLocations[1]
    
    createDropdown(featuresContainer, TeleportLocations, TeleportLocations[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT (SUBMARINE)", function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer(selectedLoc)
            notify("Teleport", "Teleported to " .. selectedLoc)
        elseif Remote.SubmarineTP2 then
            Remote.SubmarineTP2:InvokeServer(selectedLoc)
            notify("Teleport", "Teleported to " .. selectedLoc)
        end
    end)
    
    createButton(featuresContainer, "TELEPORT (BOAT)", function()
        if Remote.BoatTeleport then
            Remote.BoatTeleport:FireServer(selectedLoc)
            notify("Teleport", "Boat teleported")
        end
    end)
    
    createLabel(featuresContainer, "Teleport to Player")
    
    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players, p.Name)
        end
    end
    
    if #players > 0 then
        local selectedPlayer = players[1]
        
        createDropdown(featuresContainer, players, players[1], function(selected)
            selectedPlayer = selected
        end)
        
        createButton(featuresContainer, "TELEPORT TO PLAYER", function()
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    notify("Teleport", "Teleported to " .. selectedPlayer)
                end
            end
        end)
    else
        createLabel(featuresContainer, "No other players online")
    end
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
    
    createLabel(featuresContainer, "Special Quests")
    
    for _, quest in ipairs(QuestData) do
        local reqText = table.concat(quest.requirements, " • ")
        createInfoBox(featuresContainer, quest.name, reqText)
        
        for _, loc in ipairs(quest.locations) do
            createButton(featuresContainer, "TELEPORT TO " .. loc, function()
                if Remote.SubmarineTP then
                    Remote.SubmarineTP:FireServer(loc)
                    notify("Quest", "Teleported to " .. loc)
                end
            end)
        end
    end
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

print("Moe V1.0 GUI Loaded - Left Menu Style 650x400")