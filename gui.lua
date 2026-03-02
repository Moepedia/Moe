-- Moe V1.0 GUI for FISH IT Game
-- Semua fitur dengan remote events yang tepat

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 450)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
mainFrame.Visible = true

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 20)
corners.Parent = mainFrame

-- Border putih
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

-- Logo
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 40, 0, 40)
logoFrame.Position = UDim2.new(0, 15, 0.5, -20)
logoFrame.BackgroundTransparency = 1
logoFrame.BorderSizePixel = 0
logoFrame.Parent = headerFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 20)
logoCorner.Parent = logoFrame

-- Teks "Moe V1.0"
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 65, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moe V1.0"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- ===== TOMBOL MINIMIZE =====
local minButton = Instance.new("TextButton")
minButton.Name = "MinimizeButton"
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -70, 0.5, -15)
minButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minButton.BackgroundTransparency = 0.3
minButton.BorderSizePixel = 0
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextScaled = true
minButton.Font = Enum.Font.GothamBold
minButton.AutoButtonColor = false
minButton.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minButton

-- ===== TOMBOL CLOSE =====
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
closeButton.BackgroundTransparency = 0.3
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Name = "FloatingLogo"
floatingLogo.Size = UDim2.new(0, 60, 0, 60)
floatingLogo.Position = UDim2.new(0.9, -30, 0.9, -30)
floatingLogo.BackgroundTransparency = 1
floatingLogo.BorderSizePixel = 0
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
floatLogoCorner.CornerRadius = UDim.new(0, 30)
floatLogoCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1.5
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.2
floatStroke.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.BorderSizePixel = 0
floatButton.Text = ""
floatButton.Parent = floatingLogo

-- ===== FUNGSI MINIMIZE/RESTORE =====
local function minimize()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end

local function restore()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end

minButton.MouseButton1Click:Connect(minimize)
floatButton.MouseButton1Click:Connect(restore)
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- GARIS HORIZONTAL
local horizontalLine = Instance.new("Frame")
horizontalLine.Name = "HorizontalLine"
horizontalLine.Size = UDim2.new(1, -20, 0, 1)
horizontalLine.Position = UDim2.new(0, 10, 0, 50)
horizontalLine.BackgroundColor3 = Color3.new(1, 1, 1)
horizontalLine.BackgroundTransparency = 0.3
horizontalLine.BorderSizePixel = 0
horizontalLine.Parent = mainFrame

-- CONTAINER UTAMA
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 55)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame

-- MENU KIRI
local leftMenu = Instance.new("Frame")
leftMenu.Name = "LeftMenu"
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.Position = UDim2.new(0, 0, 0, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.BorderSizePixel = 0
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = leftMenu

-- GARIS VERTIKAL
local verticalLine = Instance.new("Frame")
verticalLine.Name = "VerticalLine"
verticalLine.Size = UDim2.new(0, 1, 1, 0)
verticalLine.Position = UDim2.new(0, 130, 0, 0)
verticalLine.BackgroundColor3 = Color3.new(1, 1, 1)
verticalLine.BackgroundTransparency = 0.3
verticalLine.BorderSizePixel = 0
verticalLine.Parent = contentContainer

-- AREA KONTEN
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentArea

-- JUDUL KONTEN
local contentTitle = Instance.new("TextLabel")
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(1, -20, 0, 30)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Pilih menu di samping"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextScaled = true
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- CONTAINER FITUR
local featuresContainer = Instance.new("Frame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, -20, 1, -50)
featuresContainer.Position = UDim2.new(0, 10, 0, 45)
featuresContainer.BackgroundTransparency = 1
featuresContainer.BorderSizePixel = 0
featuresContainer.Parent = contentArea

-- LAYOUT VERTIKAL untuk fitur
local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
featuresLayout.VerticalAlignment = Enum.VerticalAlignment.Top
featuresLayout.Padding = UDim.new(0, 10)
featuresLayout.Parent = featuresContainer

-- ===== FUNGSI GET REMOTE UNTUK FISH IT =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemote(name)
    -- Cari di ReplicatedStorage langsung
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then return remote end
    
    -- Cari di folder RE (Remote Events)
    local reFolder = ReplicatedStorage:FindFirstChild("RE")
    if reFolder then
        remote = reFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    -- Cari di folder RF (Remote Functions)
    local rfFolder = ReplicatedStorage:FindFirstChild("RF")
    if rfFolder then
        remote = rfFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    -- Cari di semua folder
    for _, folder in pairs(ReplicatedStorage:GetChildren()) do
        if folder:IsA("Folder") then
            remote = folder:FindFirstChild(name)
            if remote then return remote end
        end
    end
    
    return nil
end

-- ===== FITUR FISHING UNTUK FISH IT =====
local function instantFishing()
    print("[Fishing] Instant Fishing activated")
    
    -- Untuk Fish It, biasanya pake remote ini
    local castRod = getRemote("StartFishing") or getRemote("RF/StartFishing")
    local catchFish = getRemote("CatchFishCompleted") or getRemote("RF/CatchFishCompleted")
    
    if castRod then
        spawn(function()
            while wait(0.5) do
                castRod:FireServer()
                if catchFish then
                    wait(0.1)
                    catchFish:FireServer()
                end
            end
        end)
        notify("Fishing", "Instant Fishing ON")
    else
        warn("Remote StartFishing tidak ditemukan")
    end
end

local function blatantMode()
    print("[Fishing] Blatant Mode activated")
    
    -- Skip minigame fishing
    local skipMinigame = getRemote("FishingMinigameChanged") or getRemote("RE/FishingMinigameChanged")
    local catchFish = getRemote("CatchFishCompleted") or getRemote("RF/CatchFishCompleted")
    
    if skipMinigame and catchFish then
        spawn(function()
            while wait(0.1) do
                skipMinigame:FireServer(true)
                catchFish:FireServer()
            end
        end)
        notify("Fishing", "Blatant Mode ON")
    end
end

local function autoSell()
    print("[Fishing] Auto Sell activated")
    
    local sellAll = getRemote("SellAllItems") or getRemote("RF/SellAllItems")
    local sellItem = getRemote("SellItem") or getRemote("RF/SellItem")
    
    if sellAll then
        spawn(function()
            while wait(3) do
                sellAll:FireServer()
            end
        end)
        notify("Fishing", "Auto Sell ON")
    elseif sellItem then
        spawn(function()
            while wait(3) do
                sellItem:FireServer()
            end
        end)
        notify("Fishing", "Auto Sell ON")
    end
end

local function autoCast()
    print("[Fishing] Auto Cast activated")
    
    local castRod = getRemote("StartFishing") or getRemote("RF/StartFishing")
    
    if castRod then
        spawn(function()
            while wait(1.5) do
                castRod:FireServer()
            end
        end)
        notify("Fishing", "Auto Cast ON")
    end
end

local function autoReel()
    print("[Fishing] Auto Reel activated")
    
    local reelIn = getRemote("StopFishing") or getRemote("RE/FishingStopped") or getRemote("CatchFishCompleted")
    
    if reelIn then
        spawn(function()
            while wait(0.5) do
                reelIn:FireServer()
            end
        end)
        notify("Fishing", "Auto Reel ON")
    end
end

local function fishFinder()
    print("[Fishing] Fish Finder activated")
    
    local findFish = getRemote("FishingCircleParticipantsChanged") or getRemote("RE/FishingCircleParticipantsChanged")
    
    if findFish then
        findFish:FireServer()
        notify("Fishing", "Fish Finder activated")
    end
end

-- ===== FITUR FAVORITE UNTUK FISH IT =====
local function addToFavorite()
    print("[Favorite] Add to Favorite")
    
    local favorite = getRemote("FavoriteItem") or getRemote("RE/FavoriteItem")
    
    if favorite then
        -- Favorite item yang sedang dipegang atau item terakhir
        favorite:FireServer()
        notify("Favorite", "Added to favorites")
    end
end

local function removeFromFavorite()
    print("[Favorite] Remove from Favorite")
    
    local unfavorite = getRemote("FavoriteStateChanged") or getRemote("RE/FavoriteStateChanged")
    
    if unfavorite then
        unfavorite:FireServer(false)
        notify("Favorite", "Removed from favorites")
    end
end

local function favoriteList()
    print("[Favorite] Show Favorite List")
    
    local getFav = getRemote("FunctionGet") or getRemote("GetFavorites")
    
    if getFav and getFav:IsA("RemoteFunction") then
        local favorites = getFav:InvokeServer("GetFavorites")
        print("Favorites:", favorites)
        notify("Favorite", "Check console (F9)")
    end
end

-- ===== FITUR SHOP UNTUK FISH IT =====
local function autoBuy()
    print("[Shop] Auto Buy activated")
    
    local purchase = getRemote("PurchaseMarketItem") or getRemote("RF/PurchaseMarketItem") or getRemote("PurchaseBait")
    
    if purchase then
        spawn(function()
            while wait(5) do
                -- Beli bait
                purchase:FireServer("Bait", 5)
            end
        end)
        notify("Shop", "Auto Buy ON")
    end
end

local function quickSell()
    print("[Shop] Quick Sell activated")
    
    local sell = getRemote("SellItem") or getRemote("RF/SellItem")
    
    if sell then
        sell:FireServer()
        notify("Shop", "Item sold")
    end
end

local function priceChecker()
    print("[Shop] Price Checker activated")
    
    local getPrice = getRemote("GetProductPrice") or getRemote("FunctionGetProductPrice")
    
    if getPrice and getPrice:IsA("RemoteFunction") then
        local price = getPrice:InvokeServer("Bait")
        print("Price for Bait:", price)
        notify("Shop", "Check console (F9)")
    end
end

local function bulkPurchase()
    print("[Shop] Bulk Purchase activated")
    
    local purchase = getRemote("PurchaseMarketItem") or getRemote("RF/PurchaseMarketItem")
    
    if purchase then
        purchase:FireServer("Bait", 50)
        notify("Shop", "Bulk purchased 50 Bait")
    end
end

-- ===== FITUR TELEPORT UNTUK FISH IT =====
local function teleportToNPC()
    print("[Teleport] Teleport to NPC")
    
    -- Cari NPC di workspace
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and (npc.Name:find("NPC") or npc.Name:find("Merchant")) then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local npcPos = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                if npcPos then
                    char.HumanoidRootPart.CFrame = npcPos.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to "..npc.Name)
                    return
                end
            end
        end
    end
end

local function teleportToIsland()
    print("[Teleport] Teleport to Island")
    
    -- Fish It punya remote teleport
    local teleport = getRemote("SubmarineTP") or getRemote("RE/SubmarineTP") or getRemote("RF/SubmarineTP2")
    
    if teleport then
        teleport:FireServer("MainIsland")
        notify("Teleport", "Teleported to Island")
    end
end

local function teleportToPlayer()
    print("[Teleport] Teleport to Player")
    
    -- Cari player lain
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to "..plr.Name)
                    return
                end
            end
        end
    end
end

local function saveLocation()
    print("[Teleport] Location saved")
    
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        _G.SavedLocation = char.HumanoidRootPart.CFrame
        notify("Teleport", "Location saved")
    end
end

local function loadLocation()
    print("[Teleport] Loading saved location")
    
    if _G.SavedLocation then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = _G.SavedLocation
            notify("Teleport", "Location loaded")
        end
    else
        notify("Teleport", "No location saved")
    end
end

-- ===== FITUR WEATHER UNTUK FISH IT =====
local function setClear()
    print("[Weather] Set Clear")
    
    local weather = getRemote("WeatherCommand") or getRemote("RE/WeatherCommand")
    
    if weather then
        weather:FireServer("Clear")
        notify("Weather", "Set to Clear")
    else
        -- Fallback ke Lighting
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").Brightness = 1
        notify("Weather", "Set to Clear (local)")
    end
end

local function setRain()
    print("[Weather] Set Rain")
    
    local weather = getRemote("WeatherCommand") or getRemote("RE/WeatherCommand")
    
    if weather then
        weather:FireServer("Rain")
        notify("Weather", "Set to Rain")
    end
end

local function setStorm()
    print("[Weather] Set Storm")
    
    local weather = getRemote("WeatherCommand") or getRemote("RE/WeatherCommand")
    
    if weather then
        weather:FireServer("Storm")
        notify("Weather", "Set to Storm")
    end
end

local function setFog()
    print("[Weather] Set Fog")
    
    local weather = getRemote("WeatherCommand") or getRemote("RE/WeatherCommand")
    
    if weather then
        weather:FireServer("Fog")
        notify("Weather", "Set to Fog")
    else
        game:GetService("Lighting").FogEnd = 50
        notify("Weather", "Set to Fog (local)")
    end
end

local function setNight()
    print("[Weather] Set Night")
    
    game:GetService("Lighting").ClockTime = 0
    game:GetService("Lighting").Brightness = 0.3
    notify("Weather", "Set to Night")
end

local function setDay()
    print("[Weather] Set Day")
    
    game:GetService("Lighting").ClockTime = 12
    game:GetService("Lighting").Brightness = 1
    notify("Weather", "Set to Day")
end

-- ===== FUNGSI NOTIFIKASI =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== FUNGSI MEMBUAT TOMBOL FITUR =====
local function createFeatureButton(name, callback)
    local featureFrame = Instance.new("Frame")
    featureFrame.Name = name.."Frame"
    featureFrame.Size = UDim2.new(1, 0, 0, 50)
    featureFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
    featureFrame.BackgroundTransparency = 0.2
    featureFrame.BorderSizePixel = 0
    featureFrame.Parent = featuresContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = featureFrame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 1
    frameStroke.Color = Color3.new(1, 1, 1)
    frameStroke.Transparency = 0.7
    frameStroke.Parent = featureFrame
    
    local btn = Instance.new("TextButton")
    btn.Name = name.."FeatureBtn"
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = "  "..name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = featureFrame
    
    btn.MouseEnter:Connect(function()
        featureFrame.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        featureFrame.BackgroundTransparency = 0.1
        frameStroke.Transparency = 0.4
    end)
    
    btn.MouseLeave:Connect(function()
        featureFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        featureFrame.BackgroundTransparency = 0.2
        frameStroke.Transparency = 0.7
    end)
    
    btn.MouseButton1Click:Connect(function()
        featureFrame.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35)
        task.wait(0.1)
        featureFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
        
        if callback then
            callback()
        else
            warn("No callback for "..name)
        end
    end)
    
    return featureFrame
end

-- ===== FUNGSI MEMBUAT TOMBOL MENU =====
local menuButtons = {}
local currentMenu = nil

local function createMenuButton(name)
    local btn = Instance.new("TextButton")
    btn.Name = name.."MenuBtn"
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = leftMenu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= name then
            btn.BackgroundTransparency = 0.1
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= name then
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(menuButtons) do
            b.BackgroundTransparency = 0.3
            b.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        end
        
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        currentMenu = name
        contentTitle.Text = name.." Features"
        
        -- Hapus fitur lama
        for _, child in pairs(featuresContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Tambah fitur baru sesuai menu
        if name == "Fishing" then
            createFeatureButton("Instant Fishing", instantFishing)
            createFeatureButton("Blatant Mode", blatantMode)
            createFeatureButton("Auto Sell", autoSell)
            createFeatureButton("Auto Cast", autoCast)
            createFeatureButton("Auto Reel", autoReel)
            createFeatureButton("Fish Finder", fishFinder)
        elseif name == "Favorite" then
            createFeatureButton("Add to Favorite", addToFavorite)
            createFeatureButton("Remove from Favorite", removeFromFavorite)
            createFeatureButton("Favorite List", favoriteList)
        elseif name == "Shop" then
            createFeatureButton("Auto Buy", autoBuy)
            createFeatureButton("Quick Sell", quickSell)
            createFeatureButton("Price Checker", priceChecker)
            createFeatureButton("Bulk Purchase", bulkPurchase)
        elseif name == "Teleport" then
            createFeatureButton("Teleport to NPC", teleportToNPC)
            createFeatureButton("Teleport to Island", teleportToIsland)
            createFeatureButton("Teleport to Player", teleportToPlayer)
            createFeatureButton("Save Location", saveLocation)
            createFeatureButton("Load Location", loadLocation)
        elseif name == "Weather" then
            createFeatureButton("Set Clear", setClear)
            createFeatureButton("Set Rain", setRain)
            createFeatureButton("Set Storm", setStorm)
            createFeatureButton("Set Fog", setFog)
            createFeatureButton("Set Night", setNight)
            createFeatureButton("Set Day", setDay)
        end
    end)
    
    table.insert(menuButtons, btn)
    return btn
end

-- BUAT TOMBOL MENU
createMenuButton("Fishing")
createMenuButton("Favorite")
createMenuButton("Shop")
createMenuButton("Teleport")
createMenuButton("Weather")

-- DRAG GUI
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Auto-click Fishing
task.wait(0.5)
for _, btn in pairs(leftMenu:GetChildren()) do
    if btn:IsA("TextButton") and btn.Name == "FishingMenuBtn" then
        btn.MouseButton1Click:Fire()
        break
    end
end

print("Moe V1.0 GUI for FISH IT - Loaded!")