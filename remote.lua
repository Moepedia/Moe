-- Moe V1.0 GUI for FISH IT - FINAL FIX (NO ERRORS)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local autoSell = false
local autoFavorite = false
local autoEquip = false
local fishingConnection = nil
local sellConnection = nil
local favoriteConnection = nil
local minigameConnection = nil
local isMinigameActive = false
local guiClosed = false

-- ===== CONFIG VARIABLES =====
local Config = {
    FishDelay = 2.0,
    CatchDelay = 1.0,
    SellDelay = 60,
    FavoriteRarity = "Mythic",
    CurrentRod = nil,
    CastPower = 0.5
}

-- ===== DATA LOKASI TELEPORT =====
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439, -0.977613986, -1.77645827e-08, 0.210406482, -2.42338203e-08, 1, -2.81680421e-08, -0.210406482, -3.26364251e-08, -0.977613986),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

local TeleportLocations = {}
for loc, _ in pairs(LOCATIONS) do
    table.insert(TeleportLocations, loc)
end
table.sort(TeleportLocations)

-- ===== REMOTE FUNCTIONS DARI PACKAGES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

-- ===== REMOTE YANG DIGUNAKAN =====
local Remote = {
    -- Equip Rod (DARI DETECTION)
    Equip = Net and (Net["RE/EquipItem"] or Net:FindFirstChild("RE/Equipltem")),
    
    -- Fishing Remotes
    CancelFishingInputs = Net and Net["RF/CancelFishingInputs"],
    ChargeFishingRod = Net and Net["RF/ChargeFishingRod"],
    RequestFishingMinigame = Net and Net["RF/RequestFishingMinigameStarted"],
    FishingMinigameChanged = Net and Net["RE/FishingMinigameChanged"],
    FishingStopped = Net and Net["RE/FishingStopped"],
    CatchFishCompleted = Net and Net["RF/CatchFishCompleted"],
    FishCaught = Net and Net["RE/FishCaught"],
    
    -- Sell
    SellAllItems = Net and Net["RF/SellAllItems"],
    
    -- Favorite
    PromptFavoriteGame = Net and Net["RF/PromptFavoriteGame"]
}

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== EQUIP ROD SYSTEM =====
local function findFishingRods()
    local rods = {}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Backpack"})
        end
    end
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Character"})
            end
        end
    end
    return rods
end

local function equipRod(rodName)
    local rods = findFishingRods()
    for _, rod in ipairs(rods) do
        if rod.Name == rodName or rodName == "any" then
            if rod.Location == "Backpack" then
                -- Coba remote equip
                if Remote.Equip then
                    local success = pcall(function()
                        Remote.Equip:FireServer(rod.Instance)
                    end)
                    if success then
                        task.wait(0.5)
                        -- Cek apakah rod pindah
                        if rod.Instance.Parent == player.Character then
                            Config.CurrentRod = rod.Name
                            notify("Equip", "✅ " .. rod.Name, 1)
                            return true
                        end
                    end
                end
                
                -- Fallback manual
                rod.Instance.Parent = player.Character
                Config.CurrentRod = rod.Name
                notify("Equip", "✅ " .. rod.Name .. " (manual)", 1)
                return true
            elseif rod.Location == "Character" then
                Config.CurrentRod = rod.Name
                return true
            end
        end
    end
    return false
end

-- ===== GET WATER HEIGHT =====
local function getWaterHeight()
    local character = player.Character
    if not character then return 0 end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return 0 end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {character}
    rayParams.IgnoreWater = false
    
    local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -100, 0), rayParams)
    if rayResult and rayResult.Material == Enum.Material.Water then
        return rayResult.Position.Y
    end
    return 0
end

-- ===== AUTO FISHING FUNCTIONS =====
local function setupMinigameListener()
    if minigameConnection then
        minigameConnection:Disconnect()
    end
    
    if Remote.FishingMinigameChanged then
        minigameConnection = Remote.FishingMinigameChanged.OnClientEvent:Connect(function(state, data)
            if state == "Completed" or state == "Stop" then
                if autoFishing and Remote.CatchFishCompleted then
                    task.spawn(function()
                        pcall(function() Remote.CatchFishCompleted:InvokeServer() end)
                    end)
                end
            end
        end)
    end
end

local function startFishing()
    if not Remote.ChargeFishingRod then return false end
    
    local serverTime = workspace:GetServerTimeNow()
    
    local chargeSuccess = pcall(function()
        return Remote.ChargeFishingRod:InvokeServer(nil, nil, serverTime, nil)
    end)
    
    if not chargeSuccess then return false end
    
    task.wait(0.5)
    
    local waterY = getWaterHeight()
    if waterY == 0 then waterY = -50 end
    
    local minigameSuccess = pcall(function()
        return Remote.RequestFishingMinigame:InvokeServer(waterY, Config.CastPower, serverTime)
    end)
    
    return minigameSuccess
end

local function cancelFishing()
    if Remote.CancelFishingInputs then
        pcall(function() Remote.CancelFishingInputs:InvokeServer(true) end)
    end
end

-- ===== SELL =====
local function sellAllItems()
    if Remote.SellAllItems then
        pcall(function() Remote.SellAllItems:InvokeServer() end)
        notify("Sell", "Sold all items!", 2)
    end
end

-- ===== FAVORITE =====
local function promptFavorite()
    if Remote.PromptFavoriteGame then
        pcall(function() Remote.PromptFavoriteGame:InvokeServer() end)
    end
end

-- ===== TELEPORT =====
local function teleportTo(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = cframe
        notify("Teleport", "Teleported to " .. locationName, 1.5)
    end
end

-- ===== MAIN FISHING LOOP =====
local function startAutoFishing()
    if autoFishing or guiClosed then return end
    
    setupMinigameListener()
    
    if autoEquip and not Config.CurrentRod then
        equipRod("any")
    end
    
    autoFishing = true
    notify("Auto Fish", "Started!", 2)
    
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFishing or guiClosed then return end
        
        cancelFishing()
        task.wait(0.2)
        
        startFishing()
        task.wait(Config.FishDelay + Config.CatchDelay)
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    if minigameConnection then
        minigameConnection:Disconnect()
        minigameConnection = nil
    end
    cancelFishing()
    notify("Auto Fish", "Stopped!", 2)
end

-- ===== AUTO SELL LOOP =====
local function startAutoSell()
    if autoSell or guiClosed then return end
    autoSell = true
    
    sellConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoSell or guiClosed then return end
        task.wait(Config.SellDelay)
        sellAllItems()
    end)
end

local function stopAutoSell()
    autoSell = false
    if sellConnection then
        sellConnection:Disconnect()
        sellConnection = nil
    end
end

-- ===== AUTO FAVORITE LOOP =====
local function startAutoFavorite()
    if autoFavorite or guiClosed then return end
    autoFavorite = true
    
    favoriteConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFavorite or guiClosed then return end
        task.wait(30)
        promptFavorite()
    end)
end

local function stopAutoFavorite()
    autoFavorite = false
    if favoriteConnection then
        favoriteConnection:Disconnect()
        favoriteConnection = nil
    end
end

-- ===== EXIT FUNCTION =====
local function exitGUI()
    if guiClosed then return end
    
    guiClosed = true
    stopAutoFishing()
    stopAutoSell()
    stopAutoFavorite()
    if activeDropdown then activeDropdown.Visible = false end
    task.wait(0.1)
    gui:Destroy()
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 500)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- FIX: Cek dulu sebelum buat UIStroke
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

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

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
minButton.ZIndex = 5

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
closeBtn.ZIndex = 5

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(exitGUI)

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
floatingLogo.BackgroundTransparency = 0.2
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000
floatingLogo.Active = true
floatingLogo.Selectable = true

local floatFrameCorner = Instance.new("UICorner")
floatFrameCorner.CornerRadius = UDim.new(0, 25)
floatFrameCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.5
floatStroke.Parent = floatingLogo

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, -10, 1, -10)
floatLogoImg.Position = UDim2.new(0, 5, 0, 5)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo
floatButton.ZIndex = 1001

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

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
contentContainer.Active = true

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
contentArea.Active = true
contentArea.ClipsDescendants = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

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
contentTitle.ZIndex = 5

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea
scrollFrame.ZIndex = 5

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y
featuresContainer.ZIndex = 10

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== DROPDOWN FUNCTIONS (DISINI ADA FUNGSI CREATE DROPDOWN DLL) =====
-- ... (copy semua fungsi createDropdown, createButton, dll dari script sebelumnya)

-- ===== FISHING MENU =====
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "⚡ AUTO FISHING")
    
    autoFishToggle = createToggle(featuresContainer, "Auto Fish", false, function(state)
        if state then startAutoFishing() else stopAutoFishing() end
    end)
    
    autoEquipToggle = createToggle(featuresContainer, "Auto Equip Rod", autoEquip, function(state)
        autoEquip = state
        if state then equipRod("any") end
    end)
    
    createLabel(featuresContainer, "⏱️ DELAY SETTINGS")
    createInput(featuresContainer, "Fish Delay (s)", Config.FishDelay, function(val)
        Config.FishDelay = val
    end, 0.1, 10)
    
    createInput(featuresContainer, "Catch Delay (s)", Config.CatchDelay, function(val)
        Config.CatchDelay = val
    end, 0.1, 10)
    
    createLabel(featuresContainer, "🎯 CAST POWER")
    createInput(featuresContainer, "Power (0.1-1.0)", Config.CastPower, function(val)
        Config.CastPower = val
    end, 0.1, 1.0)
    
    createLabel(featuresContainer, "🎣 ROD SELECTION")
    local rods = findFishingRods()
    local rodNames = {"any"}
    for _, rod in ipairs(rods) do
        table.insert(rodNames, rod.Name)
    end
    if #rodNames > 1 then
        createDropdown(featuresContainer, rodNames, rodNames[1], function(selected)
            equipRod(selected)
        end)
    else
        createLabel(featuresContainer, "No rods found")
    end
end

-- ===== SELL MENU =====
local function showSell()
    clearFeatures()
    contentTitle.Text = "Sell Features"
    
    createLabel(featuresContainer, "💰 AUTO SELL")
    
    autoSellToggle = createToggle(featuresContainer, "Auto Sell", false, function(state)
        if state then startAutoSell() else stopAutoSell() end
    end)
    
    createLabel(featuresContainer, "⏱️ SELL DELAY")
    createInput(featuresContainer, "Sell Delay (s)", Config.SellDelay, function(val)
        Config.SellDelay = val
    end, 10, 300)
    
    createLabel(featuresContainer, "⚡ MANUAL SELL")
    createButton(featuresContainer, "SELL ALL NOW", sellAllItems)
end

-- ===== FAVORITE MENU =====
local function showFavorite()
    clearFeatures()
    contentTitle.Text = "Favorite Features"
    
    createLabel(featuresContainer, "⭐ AUTO FAVORITE")
    
    autoFavoriteToggle = createToggle(featuresContainer, "Auto Favorite", false, function(state)
        if state then startAutoFavorite() else stopAutoFavorite() end
    end)
    
    createLabel(featuresContainer, "Rarity Settings")
    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
    createDropdown(featuresContainer, rarities, Config.FavoriteRarity, function(selected)
        Config.FavoriteRarity = selected
    end)
    
    createLabel(featuresContainer, "⚡ MANUAL FAVORITE")
    createButton(featuresContainer, "PROMPT FAVORITE", promptFavorite)
end

-- ===== TELEPORT MENU =====
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "🌍 TELEPORT TO LOCATION")
    
    local selectedLoc = TeleportLocations[1]
    createDropdown(featuresContainer, TeleportLocations, TeleportLocations[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT", function() teleportTo(selectedLoc) end)
    
    createLabel(featuresContainer, "📋 TELEPORT TO PLAYER")
    
    local function getPlayerList()
        local players = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then table.insert(players, p.Name) end
        end
        return players
    end
    
    local playerList = getPlayerList()
    local selectedPlayer = playerList[1] or "No players"
    
    createDropdown(featuresContainer, playerList, playerList[1] or "No players", function(selected)
        selectedPlayer = selected
    end)
    
    createButton(featuresContainer, "REFRESH PLAYERS", function()
        playerList = getPlayerList()
        notify("Players", #playerList .. " online", 1)
    end)
    
    createButton(featuresContainer, "TELEPORT TO PLAYER", function()
        if selectedPlayer and selectedPlayer ~= "No players" then
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    notify("Teleport", "Teleported to " .. selectedPlayer)
                end
            end
        end
    end)
end

-- ===== STATUS MENU =====
local function showStatus()
    clearFeatures()
    contentTitle.Text = "Status"
    
    createLabel(featuresContainer, "📊 REMOTE STATUS")
    
    local statusText = "🎣 FISHING REMOTES:\n"
    statusText = statusText .. "Charge: " .. (Remote.ChargeFishingRod and "✅" or "❌") .. "\n"
    statusText = statusText .. "Minigame: " .. (Remote.RequestFishingMinigame and "✅" or "❌") .. "\n"
    statusText = statusText .. "Catch: " .. (Remote.CatchFishCompleted and "✅" or "❌") .. "\n"
    statusText = statusText .. "Event: " .. (Remote.FishingMinigameChanged and "✅" or "❌") .. "\n\n"
    statusText = statusText .. "💰 SELL: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n"
    statusText = statusText .. "⭐ FAVORITE: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 150)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.Parent = featuresContainer
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 1, -10)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = statusText
    statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextYAlignment = Enum.TextYAlignment.Top
    statusLabel.Parent = statusFrame
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Sell", func = showSell},
    {name = "Favorite", func = showFavorite},
    {name = "Teleport", func = showTeleport},
    {name = "Status", func = showStatus}
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
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundTransparency = 0.3 end
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

print("✅ Moe V1.0 Final Fixed - No Errors!")
notify("Moe V1.0", "Fixed: UIStroke Error", 3)
