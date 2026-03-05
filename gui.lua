-- Moe V1.0 GUI for FISH IT - FINAL FIXED VERSION

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

-- ===== REMOTE FUNCTIONS DARI FISHINGCONTROLLER =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

local Remote = {
    -- Fishing Remotes (dari FishingController)
    CancelFishingInputs = Net and Net["RF/CancelFishingInputs"],
    ChargeFishingRod = Net and Net["RF/ChargeFishingRod"],
    RequestFishingMinigame = Net and Net["RF/RequestFishingMinigameStarted"],
    FishingMinigameChanged = Net and Net["RE/FishingMinigameChanged"],
    FishingStopped = Net and Net["RE/FishingStopped"],
    UpdateChargeState = Net and Net["RE/UpdateChargeState"],
    CatchFishCompleted = Net and Net["RF/CatchFishCompleted"],
    FishCaught = Net and Net["RE/FishCaught"],
    
    -- Anti-Cheat
    UpdateAutoFishingState = Net and Net["RF/UpdateAutoFishingState"],
    MarkAutoFishingUsed = Net and Net["RF/MarkAutoFishingUsed"],
    
    -- Sell
    SellAllItems = Net and Net["RF/SellAllItems"],
    SellItem = Net and Net["RF/SellItem"],
    
    -- Favorite
    FavoriteItem = Net and Net["RE/FavoriteItem"],
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

-- ===== KONFIRMASI DIALOG =====
local function showConfirmDialog(title, message, callback)
    local dialogFrame = Instance.new("Frame")
    dialogFrame.Size = UDim2.new(0, 300, 0, 150)
    dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    dialogFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    dialogFrame.BackgroundTransparency = 0.1
    dialogFrame.BorderSizePixel = 0
    dialogFrame.Parent = gui
    dialogFrame.ZIndex = 1000
    
    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 8)
    dialogCorner.Parent = dialogFrame
    
    local dialogStroke = Instance.new("UIStroke")
    dialogStroke.Thickness = 1
    dialogStroke.Color = Color3.new(1, 1, 1)
    dialogStroke.Transparency = 0.5
    dialogStroke.Parent = dialogFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = dialogFrame
    titleLabel.ZIndex = 1001
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.Parent = dialogFrame
    msgLabel.ZIndex = 1001
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -5, 0, 35)
    yesBtn.Position = UDim2.new(0.1, 0, 0, 95)
    yesBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = dialogFrame
    yesBtn.ZIndex = 1001
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -5, 0, 35)
    noBtn.Position = UDim2.new(0.5, 5, 0, 95)
    noBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = dialogFrame
    noBtn.ZIndex = 1001
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(true)
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(false)
    end)
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
                rod.Instance.Parent = player.Character
                Config.CurrentRod = rod.Name
                notify("Equip", "Equipped: " .. rod.Name, 1)
                return true
            elseif rod.Location == "Character" then
                Config.CurrentRod = rod.Name
                return true
            end
        end
    end
    return false
end

-- ===== ANTI-CHEAT BYPASS =====
local function disableAntiCheat()
    if Remote.UpdateAutoFishingState then
        pcall(function() Remote.UpdateAutoFishingState:InvokeServer(false) end)
    end
    if Remote.MarkAutoFishingUsed then
        pcall(function() Remote.MarkAutoFishingUsed:InvokeServer(0) end)
    end
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

-- ===== AUTO FISHING FUNCTIONS (Berdasarkan FishingController) =====
local function setupMinigameListener()
    if minigameConnection then
        minigameConnection:Disconnect()
    end
    
    if Remote.FishingMinigameChanged then
        minigameConnection = Remote.FishingMinigameChanged.OnClientEvent:Connect(function(state, data)
            print("🎣 Minigame state:", state)
            
            if state == "Activated" or state == "Started" then
                isMinigameActive = true
                print("🎣 Minigame started")
            elseif state == "Completed" or state == "Stop" then
                isMinigameActive = false
                print("✅ Minigame completed")
                
                -- Langsung catch setelah minigame selesai
                if autoFishing and Remote.CatchFishCompleted then
                    task.spawn(function()
                        pcall(function()
                            Remote.CatchFishCompleted:InvokeServer()
                            print("✅ Fish caught!")
                        end)
                    end)
                end
            end
        end)
    end
end

local function startFishing()
    if not Remote.ChargeFishingRod then return false end
    
    local serverTime = workspace:GetServerTimeNow()
    
    -- 1. CHARGE ROD (nil, nil, serverTime, nil)
    local chargeSuccess = pcall(function()
        return Remote.ChargeFishingRod:InvokeServer(nil, nil, serverTime, nil)
    end)
    
    if not chargeSuccess then 
        print("❌ Charge failed")
        return false 
    end
    
    -- Tunggu charge animation
    task.wait(0.5)
    
    -- Dapatkan posisi air
    local waterY = getWaterHeight()
    if waterY == 0 then waterY = -50 end
    
    -- 2. REQUEST MINIGAME (posY, power, serverTime)
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

-- ===== AUTO SELL =====
local function sellAllItems()
    if Remote.SellAllItems then
        local success = pcall(function() Remote.SellAllItems:InvokeServer() end)
        notify("Sell", success and "All items sold!" or "Sell failed", 2)
    end
end

-- ===== AUTO FAVORITE =====
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
    
    -- Setup listener
    setupMinigameListener()
    
    if autoEquip and not Config.CurrentRod then
        equipRod("any")
    end
    
    autoFishing = true
    notify("Auto Fish", "Started!", 2)
    
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFishing or guiClosed then return end
        
        disableAntiCheat()
        cancelFishing()
        task.wait(0.2)
        
        -- Start fishing (charge + request minigame)
        startFishing()
        
        -- Tunggu sesuai delay sebelum next cycle
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

-- ===== EXIT FUNCTION (PASTI CLOSE) =====
local function exitGUI()
    if guiClosed then return end
    
    showConfirmDialog("Exit GUI", "Are you sure you want to close?", function(confirmed)
        if confirmed then
            guiClosed = true
            
            -- Stop semua loops
            stopAutoFishing()
            stopAutoSell()
            stopAutoFavorite()
            
            -- Close dropdowns
            if activeDropdown then
                activeDropdown.Visible = false
                activeDropdown = nil
            end
            
            -- Destroy GUI dengan paksa
            task.wait(0.1)
            pcall(function() gui:Destroy() end)
        end
    end)
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

-- ===== DROPDOWN FUNCTIONS =====
local activeDropdown = nil

local function closeAllDropdowns()
    if activeDropdown then
        activeDropdown.Visible = false
        activeDropdown = nil
    end
end

local function setupInputTracking()
    local userInputService = game:GetService("UserInputService")
    
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            task.wait(0.05)
            if not activeDropdown then return end
            
            local mousePos = userInputService:GetMouseLocation()
            local objects = gui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
            
            local clickedOnDropdown = false
            for _, obj in ipairs(objects) do
                local current = obj
                while current do
                    if current == activeDropdown or current == activeDropdown.Parent then
                        clickedOnDropdown = true
                        break
                    end
                    current = current.Parent
                end
                if clickedOnDropdown then break end
            end
            
            if not clickedOnDropdown then
                closeAllDropdowns()
            end
        end
    end)
end

setupInputTracking()

local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 20
    frame.Active = true
    frame.Selectable = true
    
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
    btn.ZIndex = 21
    btn.AutoButtonColor = false
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 21
    
    -- Dropdown frame
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = gui
    dropdownFrame.ZIndex = 1000
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local optionsScrolling = Instance.new("ScrollingFrame")
    optionsScrolling.Size = UDim2.new(1, 0, 1, 0)
    optionsScrolling.BackgroundTransparency = 1
    optionsScrolling.ScrollBarThickness = 4
    optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsScrolling.Parent = dropdownFrame
    optionsScrolling.ZIndex = 1001
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = optionsScrolling
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.ZIndex = 1002
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    local function updateDropdownPosition()
        if not frame or not frame:IsDescendantOf(gui) or not frame.Visible then
            dropdownFrame.Visible = false
            return
        end
        if not mainFrame.Visible then
            dropdownFrame.Visible = false
            return
        end
        
        local absPos = frame.AbsolutePosition
        local absSize = frame.AbsoluteSize
        
        dropdownFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y)
        dropdownFrame.Size = UDim2.new(0, absSize.X, 0, math.min(#options * 32, 200))
    end
    
    local function updateDropdown(newOptions)
        for _, child in pairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, opt in ipairs(newOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.TextSize = 13
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = optionsContainer
            optBtn.ZIndex = 1002
            optBtn.BorderSizePixel = 0
            
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn
            
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
            end)
            
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                btn.Text = opt
                dropdownFrame.Visible = false
                activeDropdown = nil
                callback(opt)
            end)
        end
        
        task.wait()
        local contentHeight = #newOptions * 32 + (#newOptions - 1) * 2
        optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end
    
    updateDropdown(options)
    
    btn.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown ~= dropdownFrame then
            activeDropdown.Visible = false
        end
        if not mainFrame.Visible then return end
        
        updateDropdownPosition()
        dropdownFrame.Visible = not dropdownFrame.Visible
        activeDropdown = dropdownFrame.Visible and dropdownFrame or nil
    end)
    
    frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if dropdownFrame.Visible then updateDropdownPosition() end
    end)
    
    frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if dropdownFrame.Visible then updateDropdownPosition() end
    end)
    
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if not mainFrame.Visible and dropdownFrame.Visible then
            dropdownFrame.Visible = false
            activeDropdown = nil
        end
    end)
    
    frame.Destroying:Connect(function() dropdownFrame:Destroy() end)
    
    return frame, updateDropdown
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
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        callback()
    end)
    
    return btn
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
    label.ZIndex = 20
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 20
    frame.Active = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.new(0, 0.6, 0) or Color3.new(0.3, 0.3, 0.3)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    toggleBtn.ZIndex = 21
    toggleBtn.AutoButtonColor = false
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.new(0, 0.6, 0) or Color3.new(0.3, 0.3, 0.3)
        callback(state)
    end)
    
    return toggleBtn
end

local function createInput(parent, labelText, default, callback, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 0, 25)
    input.Position = UDim2.new(0.5, 0, 0.5, -12.5)
    input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.Parent = frame
    input.ZIndex = 21
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text) or default
        if min and max then
            val = math.max(min, math.min(max, val))
        end
        input.Text = tostring(val)
        callback(val)
    end)
    
    return frame
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== REFERENCE UNTUK TOGGLE =====
local autoFishToggle = nil
local autoSellToggle = nil
local autoFavoriteToggle = nil
local autoEquipToggle = nil

-- ===== FISHING MENU =====
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "⚡ AUTO FISHING")
    
    autoFishToggle = createToggle(featuresContainer, "Auto Fish", false, function(state)
        if state then
            startAutoFishing()
        else
            stopAutoFishing()
        end
    end)
    
    autoEquipToggle = createToggle(featuresContainer, "Auto Equip Rod", autoEquip, function(state)
        autoEquip = state
        if state then
            equipRod("any")
        end
    end)
    
    createLabel(featuresContainer, "⏱️ DELAY SETTINGS (Default: 2.0s / 1.0s)")
    
    createInput(featuresContainer, "Fish Delay (s)", Config.FishDelay, function(val)
        Config.FishDelay = val
    end, 0.1, 10)
    
    createInput(featuresContainer, "Catch Delay (s)", Config.CatchDelay, function(val)
        Config.CatchDelay = val
    end, 0.1, 10)
    
    createLabel(featuresContainer, "🎯 CAST POWER (Default: 0.5)")
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
        if state then
            startAutoSell()
        else
            stopAutoSell()
        end
    end)
    
    createLabel(featuresContainer, "⏱️ SELL DELAY (Default: 60s)")
    createInput(featuresContainer, "Sell Delay (s)", Config.SellDelay, function(val)
        Config.SellDelay = val
    end, 10, 300)
    
    createLabel(featuresContainer, "⚡ MANUAL SELL")
    createButton(featuresContainer, "SELL ALL NOW", function()
        sellAllItems()
    end)
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 60)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 0, 40)
    statusText.Position = UDim2.new(0, 5, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n" ..
                      "SellItem: " .. (Remote.SellItem and "✅" or "❌")
    statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextWrapped = true
    statusText.Parent = statusFrame
end

-- ===== FAVORITE MENU =====
local function showFavorite()
    clearFeatures()
    contentTitle.Text = "Favorite Features"
    
    createLabel(featuresContainer, "⭐ AUTO FAVORITE")
    
    autoFavoriteToggle = createToggle(featuresContainer, "Auto Favorite", false, function(state)
        if state then
            startAutoFavorite()
        else
            stopAutoFavorite()
        end
    end)
    
    createLabel(featuresContainer, "Rarity Settings (Default: Mythic)")
    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
    createDropdown(featuresContainer, rarities, Config.FavoriteRarity, function(selected)
        Config.FavoriteRarity = selected
    end)
    
    createLabel(featuresContainer, "⚡ MANUAL FAVORITE")
    createButton(featuresContainer, "PROMPT FAVORITE", function()
        promptFavorite()
    end)
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 60)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 0, 40)
    statusText.Position = UDim2.new(0, 5, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = "FavoriteItem: " .. (Remote.FavoriteItem and "✅" or "❌") .. "\n" ..
                      "PromptFavorite: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
    statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextWrapped = true
    statusText.Parent = statusFrame
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
    
    createButton(featuresContainer, "TELEPORT", function()
        teleportTo(selectedLoc)
    end)
    
    createLabel(featuresContainer, "📋 TELEPORT TO PLAYER")
    
    local function getPlayerList()
        local players = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p.Name)
            end
        end
        return players
    end
    
    local playerList = getPlayerList()
    local selectedPlayer = playerList[1] or "No players"
    
    createDropdown(featuresContainer, playerList, playerList[1] or "No players", function(selected)
        selectedPlayer = selected
    end)
    
    createButton(featuresContainer, "REFRESH PLAYERS", function()
        local newPlayerList = getPlayerList()
        notify("Players", #newPlayerList .. " online", 1)
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
    
    local statusText = ""
    statusText = statusText .. "🎣 FISHING REMOTES:\n"
    statusText = statusText .. "ChargeFishingRod: " .. (Remote.ChargeFishingRod and "✅" or "❌") .. "\n"
    statusText = statusText .. "RequestFishingMinigame: " .. (Remote.RequestFishingMinigame and "✅" or "❌") .. "\n"
    statusText = statusText .. "CatchFishCompleted: " .. (Remote.CatchFishCompleted and "✅" or "❌") .. "\n"
    statusText = statusText .. "FishCaught: " .. (Remote.FishCaught and "✅" or "❌") .. "\n\n"
    
    statusText = statusText .. "🛡️ ANTI-CHEAT:\n"
    statusText = statusText .. "UpdateAutoFishing: " .. (Remote.UpdateAutoFishingState and "✅" or "❌") .. "\n"
    statusText = statusText .. "MarkAutoFishing: " .. (Remote.MarkAutoFishingUsed and "✅" or "❌") .. "\n\n"
    
    statusText = statusText .. "💰 SELL:\n"
    statusText = statusText .. "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n"
    statusText = statusText .. "SellItem: " .. (Remote.SellItem and "✅" or "❌") .. "\n\n"
    
    statusText = statusText .. "⭐ FAVORITE:\n"
    statusText = statusText .. "FavoriteItem: " .. (Remote.FavoriteItem and "✅" or "❌") .. "\n"
    statusText = statusText .. "PromptFavorite: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 220)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
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
    statusLabel.TextWrapped = true
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
        closeAllDropdowns()
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

print("✅ Moe V1.0 Final Fixed - Auto Fishing SHOULD WORK!")
notify("Moe V1.0", "Fixed: Auto Fishing & Close Button", 3)