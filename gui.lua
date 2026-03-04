-- Moe V1.0 GUI for FISH IT

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== DATA LOKASI TELEPORT (COMPLETE LIST) =====
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

-- Daftar lokasi untuk dropdown
local TeleportLocations = {}
for loc, _ in pairs(LOCATIONS) do
    table.insert(TeleportLocations, loc)
end
table.sort(TeleportLocations)

-- ===== REMOTE FUNCTIONS DARI PACKAGES (DEX RESULTS) =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

-- ===== SELL & FAVORITE REMOTES (YANG KAMU MINTA) =====
local SellRemotes = {
    SellAllItems = Net and Net["RF/SellAllitems"],
    SellItem = Net and Net["RF/Sellitem"],
    UpdateAutoSellThreshold = Net and Net["RF/UpdateAutoSell Threshold"],
    PromptFavoriteGame = Net and Net["RF/PromptFavoriteGame"],
    FavoriteItem = Net and Net["RE/Favoriteltm"],
    FavoriteStateChanged = Net and Net["RE/Favorite StateChanged"]
}

-- ===== FISHING REMOTES (DARI DEX SEBELUMNYA) =====
local FishingRemotes = {
    CancelFishingInputs = Net and Net["RF/CancelFishingInputs"],
    CatchFishCompleted = Net and Net["RF/CatchFishCompleted"],
    ChargeFishingRod = Net and Net["RF/ChargeFishingRod"],
    MarkAutoFishingUsed = Net and Net["RF/MarkAutoFishingUsed"],
    RequestFishingMinigame = Net and Net["RF/RequestFishingMinigameStarted"],
    UpdateAutoFishingState = Net and Net["RF/UpdateAutoFishingState"],
    FishCaught = Net and Net["RE/FishCaught"],
    FishingStopped = Net and Net["RE/FishingStopped"],
    CaughtFishVisual = Net and Net["RE/Caught FishVisual"],
    FishingMinigameChanged = Net and Net["RE/FishingMinigameChanged"]
}

-- ===== VARIABEL UNTUK AUTO FISH =====
local isFishing = false
local fishingConnection = nil
local sellConnection = nil
local favoriteConnection = nil

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== CEK REMOTE FUNCTION =====
local function checkRemote(remote, name)
    if remote then
        return "✅ " .. name
    else
        return "❌ " .. name .. " (tidak ditemukan)"
    end
end

-- ===== AUTO FISHING FUNCTIONS =====
local function disableAntiCheat()
    if FishingRemotes.UpdateAutoFishingState then
        pcall(function()
            FishingRemotes.UpdateAutoFishingState:InvokeServer(false)
        end)
    end
    
    if FishingRemotes.MarkAutoFishingUsed then
        pcall(function()
            FishingRemotes.MarkAutoFishingUsed:InvokeServer(0)
        end)
    end
end

local function castRod()
    if not FishingRemotes.ChargeFishingRod or not FishingRemotes.RequestFishingMinigame then
        return false
    end
    
    return pcall(function()
        FishingRemotes.ChargeFishingRod:InvokeServer(1755848498.4834)
        task.wait(0.1)
        FishingRemotes.RequestFishingMinigame:InvokeServer(1.2854545116425, 1)
    end)
end

local function reelIn()
    if FishingRemotes.CatchFishCompleted then
        pcall(function() FishingRemotes.CatchFishCompleted:InvokeServer() end)
    end
    
    if FishingRemotes.FishCaught then
        pcall(function() FishingRemotes.FishCaught:FireServer() end)
    end
end

local function cancelFishing()
    if FishingRemotes.CancelFishingInputs then
        pcall(function() FishingRemotes.CancelFishingInputs:InvokeServer() end)
    end
end

-- ===== AUTO SELL FUNCTIONS =====
local function sellAllItems()
    if SellRemotes.SellAllItems then
        local success = pcall(function()
            SellRemotes.SellAllItems:InvokeServer()
        end)
        notify("Auto Sell", success and "✅ Semua item terjual!" or "❌ Gagal menjual", 2)
    else
        notify("Error", "Remote SellAllItems tidak ditemukan", 2)
    end
end

local function sellSingleItem(itemId)
    if SellRemotes.SellItem and itemId then
        pcall(function()
            SellRemotes.SellItem:InvokeServer(itemId)
        end)
    end
end

local function updateSellThreshold(threshold)
    if SellRemotes.UpdateAutoSellThreshold then
        pcall(function()
            SellRemotes.UpdateAutoSellThreshold:InvokeServer(threshold)
        end)
        notify("Auto Sell", "Threshold diupdate ke " .. threshold, 1)
    end
end

-- ===== AUTO FAVORITE FUNCTIONS =====
local function favoriteItem(itemId)
    if SellRemotes.FavoriteItem and itemId then
        pcall(function()
            SellRemotes.FavoriteItem:FireServer(itemId)
        end)
        return true
    end
    return false
end

local function promptFavoriteGame()
    if SellRemotes.PromptFavoriteGame then
        pcall(function()
            SellRemotes.PromptFavoriteGame:InvokeServer()
        end)
    end
end

-- ===== TELEPORT FUNCTION =====
local function teleportTo(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then
        notify("Teleport", "Lokasi tidak ditemukan!", 2)
        return
    end
    
    local character = player.Character
    if not character then
        notify("Teleport", "Karakter tidak ditemukan!", 2)
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        notify("Teleport", "RootPart tidak ditemukan!", 2)
        return
    end
    
    rootPart.CFrame = cframe
    notify("Teleport", "Teleport ke " .. locationName, 1.5)
end

-- ===== MAIN FRAME (650x400) =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 450)  -- Diperbesar untuk fitur baru
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

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

-- ===== HEADER (sama seperti sebelumnya) =====
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

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

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
contentContainer.Active = true

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

-- Menu buttons
local menuButtons = {}
local menuItems = {"Fishing", "Sell", "Favorite", "Teleport", "Status"}
local menuColors = {
    Color3.fromRGB(0, 150, 200),  -- Fishing (biru)
    Color3.fromRGB(200, 150, 0),   -- Sell (orange)
    Color3.fromRGB(200, 50, 150),  -- Favorite (pink)
    Color3.fromRGB(100, 200, 100), -- Teleport (hijau)
    Color3.fromRGB(150, 150, 150)  -- Status (abu)
}

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

for i, itemName in ipairs(menuItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = menuColors[i]
    btn.BackgroundTransparency = 0.3
    btn.Text = itemName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    btn.Name = itemName.."Btn"
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    table.insert(menuButtons, btn)
end

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
contentArea.Active = true
contentArea.Selectable = true
contentArea.ClipsDescendants = true

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

-- Container untuk features
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

-- ===== FUNCTION TO SWITCH PAGES =====
local function switchPage(pageName)
    -- Clear container
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    contentTitle.Text = pageName .. " Features"
    
    if pageName == "Fishing" then
        -- Fishing Page
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = "🎣 AUTO FISHING CONTROLS"
        title.TextColor3 = Color3.fromRGB(0, 200, 255)
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = featuresContainer
        
        -- Auto Fish Toggle
        local fishToggle = Instance.new("TextButton")
        fishToggle.Size = UDim2.new(1, 0, 0, 40)
        fishToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        fishToggle.Text = "START AUTO FISH"
        fishToggle.TextColor3 = Color3.new(1, 1, 1)
        fishToggle.Font = Enum.Font.GothamBold
        fishToggle.Parent = featuresContainer
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = fishToggle
        
        fishToggle.MouseButton1Click:Connect(function()
            isFishing = not isFishing
            if isFishing then
                fishToggle.Text = "STOP AUTO FISH"
                fishToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                
                -- Start fishing loop
                task.spawn(function()
                    while isFishing do
                        disableAntiCheat()
                        cancelFishing()
                        task.wait(0.2)
                        castRod()
                        task.wait(2)
                        reelIn()
                        task.wait(1)
                    end
                end)
                notify("Auto Fish", "Started", 1)
            else
                fishToggle.Text = "START AUTO FISH"
                fishToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
                cancelFishing()
                notify("Auto Fish", "Stopped", 1)
            end
        end)
        
        -- Cancel Fishing Button
        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.new(1, 0, 0, 35)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        cancelBtn.Text = "CANCEL FISHING"
        cancelBtn.TextColor3 = Color3.new(1, 1, 1)
        cancelBtn.Font = Enum.Font.Gotham
        cancelBtn.Parent = featuresContainer
        
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 6)
        cancelCorner.Parent = cancelBtn
        
        cancelBtn.MouseButton1Click:Connect(function()
            cancelFishing()
            notify("Fishing", "Cancelled", 1)
        end)
        
        -- Remote Status
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 60)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Remote Status:\n" ..
            checkRemote(FishingRemotes.ChargeFishingRod, "ChargeFishingRod") .. "\n" ..
            checkRemote(FishingRemotes.RequestFishingMinigame, "RequestFishingMinigame") .. "\n" ..
            checkRemote(FishingRemotes.CatchFishCompleted, "CatchFishCompleted")
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 11
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
        
    elseif pageName == "Sell" then
        -- Sell Page
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = "💰 AUTO SELL FEATURES"
        title.TextColor3 = Color3.fromRGB(255, 200, 0)
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = featuresContainer
        
        -- Sell All Button
        local sellAllBtn = Instance.new("TextButton")
        sellAllBtn.Size = UDim2.new(1, 0, 0, 45)
        sellAllBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        sellAllBtn.Text = "SELL ALL ITEMS"
        sellAllBtn.TextColor3 = Color3.new(1, 1, 1)
        sellAllBtn.Font = Enum.Font.GothamBold
        sellAllBtn.Parent = featuresContainer
        
        local sellCorner = Instance.new("UICorner")
        sellCorner.CornerRadius = UDim.new(0, 6)
        sellCorner.Parent = sellAllBtn
        
        sellAllBtn.MouseButton1Click:Connect(sellAllItems)
        
        -- Threshold Input
        local thresholdFrame = Instance.new("Frame")
        thresholdFrame.Size = UDim2.new(1, 0, 0, 35)
        thresholdFrame.BackgroundTransparency = 1
        thresholdFrame.Parent = featuresContainer
        
        local thresholdLabel = Instance.new("TextLabel")
        thresholdLabel.Size = UDim2.new(0.3, 0, 1, 0)
        thresholdLabel.BackgroundTransparency = 1
        thresholdLabel.Text = "Threshold:"
        thresholdLabel.TextColor3 = Color3.new(1, 1, 1)
        thresholdLabel.Font = Enum.Font.Gotham
        thresholdLabel.TextXAlignment = Enum.TextXAlignment.Left
        thresholdLabel.Parent = thresholdFrame
        
        local thresholdInput = Instance.new("TextBox")
        thresholdInput.Size = UDim2.new(0.6, 0, 1, 0)
        thresholdInput.Position = UDim2.new(0.4, 0, 0, 0)
        thresholdInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        thresholdInput.PlaceholderText = "1000"
        thresholdInput.Text = ""
        thresholdInput.TextColor3 = Color3.new(1, 1, 1)
        thresholdInput.Font = Enum.Font.Gotham
        thresholdInput.Parent = thresholdFrame
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 4)
        inputCorner.Parent = thresholdInput
        
        local updateBtn = Instance.new("TextButton")
        updateBtn.Size = UDim2.new(1, 0, 0, 35)
        updateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        updateBtn.Text = "UPDATE THRESHOLD"
        updateBtn.TextColor3 = Color3.new(1, 1, 1)
        updateBtn.Font = Enum.Font.Gotham
        updateBtn.Parent = featuresContainer
        
        local updateCorner = Instance.new("UICorner")
        updateCorner.CornerRadius = UDim.new(0, 6)
        updateCorner.Parent = updateBtn
        
        updateBtn.MouseButton1Click:Connect(function()
            local val = tonumber(thresholdInput.Text) or 1000
            updateSellThreshold(val)
        end)
        
        -- Remote Status
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 80)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Remote Status:\n" ..
            checkRemote(SellRemotes.SellAllItems, "SellAllItems") .. "\n" ..
            checkRemote(SellRemotes.SellItem, "SellItem") .. "\n" ..
            checkRemote(SellRemotes.UpdateAutoSellThreshold, "UpdateAutoSellThreshold")
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 11
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
        
    elseif pageName == "Favorite" then
        -- Favorite Page
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = "⭐ AUTO FAVORITE FEATURES"
        title.TextColor3 = Color3.fromRGB(255, 100, 255)
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = featuresContainer
        
        -- Favorite Item Button
        local favBtn = Instance.new("TextButton")
        favBtn.Size = UDim2.new(1, 0, 0, 40)
        favBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 150)
        favBtn.Text = "FAVORITE ITEM (TEST)"
        favBtn.TextColor3 = Color3.new(1, 1, 1)
        favBtn.Font = Enum.Font.GothamBold
        favBtn.Parent = featuresContainer
        
        local favCorner = Instance.new("UICorner")
        favCorner.CornerRadius = UDim.new(0, 6)
        favCorner.Parent = favBtn
        
        favBtn.MouseButton1Click:Connect(function()
            favoriteItem("test_id")
        end)
        
        -- Prompt Favorite Game
        local promptBtn = Instance.new("TextButton")
        promptBtn.Size = UDim2.new(1, 0, 0, 35)
        promptBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 100)
        promptBtn.Text = "PROMPT FAVORITE GAME"
        promptBtn.TextColor3 = Color3.new(1, 1, 1)
        promptBtn.Font = Enum.Font.Gotham
        promptBtn.Parent = featuresContainer
        
        local promptCorner = Instance.new("UICorner")
        promptCorner.CornerRadius = UDim.new(0, 6)
        promptCorner.Parent = promptBtn
        
        promptBtn.MouseButton1Click:Connect(promptFavoriteGame)
        
        -- Remote Status
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 60)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Remote Status:\n" ..
            checkRemote(SellRemotes.FavoriteItem, "FavoriteItem") .. "\n" ..
            checkRemote(SellRemotes.PromptFavoriteGame, "PromptFavoriteGame") .. "\n" ..
            checkRemote(SellRemotes.FavoriteStateChanged, "FavoriteStateChanged")
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 11
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
        
    elseif pageName == "Teleport" then
        -- Teleport Page
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = "🌍 TELEPORT LOCATIONS"
        title.TextColor3 = Color3.fromRGB(100, 255, 100)
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = featuresContainer
        
        -- Create teleport buttons in a grid
        local gridFrame = Instance.new("Frame")
        gridFrame.Size = UDim2.new(1, 0, 0, 0)
        gridFrame.BackgroundTransparency = 1
        gridFrame.Parent = featuresContainer
        gridFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local gridLayout = Instance.new("UIListLayout")
        gridLayout.FillDirection = Enum.FillDirection.Vertical
        gridLayout.Padding = UDim.new(0, 5)
        gridLayout.Parent = gridFrame
        
        for i, locName in ipairs(TeleportLocations) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
            btn.Text = locName
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = gridFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                teleportTo(locName)
            end)
        end
        
    elseif pageName == "Status" then
        -- Status Page
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = "📊 ALL REMOTES STATUS"
        title.TextColor3 = Color3.fromRGB(150, 150, 150)
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = featuresContainer
        
        local statusText = ""
        
        -- Fishing Remotes
        statusText = statusText .. "\n🎣 FISHING REMOTES:\n"
        for name, remote in pairs(FishingRemotes) do
            statusText = statusText .. checkRemote(remote, name) .. "\n"
        end
        
        -- Sell Remotes
        statusText = statusText .. "\n💰 SELL REMOTES:\n"
        for name, remote in pairs(SellRemotes) do
            statusText = statusText .. checkRemote(remote, name) .. "\n"
        end
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 200)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = statusText
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 11
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.TextWrapped = true
        statusLabel.Parent = featuresContainer
    end
end

-- Connect menu buttons
for i, btn in ipairs(menuButtons) do
    btn.MouseButton1Click:Connect(function()
        switchPage(menuItems[i])
    end)
end

-- Default page
switchPage("Fishing")

-- Initial notification
notify("Moe V1.0", "Loaded successfully!\n" ..
       (#SellRemotes.SellAllItems and "✅ Sell" or "❌ No Sell") .. " | " ..
       (#SellRemotes.FavoriteItem and "✅ Favorite" or "❌ No Favorite"), 3)