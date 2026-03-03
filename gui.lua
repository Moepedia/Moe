-- Moe V1.0 GUI for FISH IT - EXPLOIT EDITION
-- Dengan fitur exploit berdasarkan analisis kelemahan

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

local TeleportNames = {}
for name, _ in pairs(TeleportLocations) do
    table.insert(TeleportNames, name)
end
table.sort(TeleportNames)

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

-- ===== REMOTE FUNCTIONS DARI PACKAGES (DENGAN HASH) =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromPackages(folder, hashName)
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

-- Remote references dengan hash yang benar dari hasil scan
local Remote = {
    -- KRITIS - CELAH BESAR
    CatchFish = getRemoteFromPackages("RF", "76b3e3c8c811abe6c6ef36d0f6ec91de75fffd97bff713a4cb421303410ccb84"), -- RF/CatchFishCompleted
    SellAll = getRemoteFromPackages("RF", "478362a898e12ac6421d7a6b918dab8385b48c04cfaba211fdb6dd48111107e6"), -- RF/SellAllItems
    SellItem = getRemoteFromPackages("RF", "61ac0f04b309d722f1df60502b90edcd4bca7cd395c192e06bc5497d5ce0b598"), -- RF/SellItem
    ClaimDaily = getRemoteFromPackages("RF", "91f555bbe3531dd9d8461f63f1b5ed9fdfe8275e29df3d6b4bf50d016c58cf6e"), -- RF/ClaimDailyLogin
    ClaimBounty = getRemoteFromPackages("RF", "970dc117e86b893579c095f746bfd11bb5ad743effa48a4b11f9b3acaab40e1b"), -- RF/ClaimBounty
    ClaimPercentile = getRemoteFromPackages("RF", "28ac64e07a0a2cfe835a4d6c979e13cfbc1b2c3a0612424751f9ff1125dc2919"), -- RF/ClaimPercentileReward
    
    -- Fishing
    ChargeRod = getRemoteFromPackages("RF", "aae67692fc443eb0cd6545ac1a4069ced9a4285e239b3e6b7d323b7d17070b5a"),
    FishingMinigame = getRemoteFromPackages("RE", "609e281eb1fbf03c9f0721e7dde16b73b4d06ff1fec785fe4db2dfe51e9a0caa"),
    FishingStopped = getRemoteFromPackages("RE", "c383f9c214e1c1e0762958ea102068a6e4afd3982ea6e9a51680b761cca74ad6"),
    RequestMinigame = getRemoteFromPackages("RF", "5bb84866ad161084fd12642cc898f39385bdc087cfb4d6946aab18e64acc7399"),
    CancelFishing = getRemoteFromPackages("RF", "c6367d6617944584bb0ef40e9b32f8ff72f63384bced4991544f9b805f11f93f"),
    
    -- Bait
    PurchaseBait = getRemoteFromPackages("RF", "749e74fbc5fc3d196df3235c7e0e96639484e875de7bfe82629d1b86a0c6f01d"),
    EquipBait = getRemoteFromPackages("RE", "55a2c14da700896b9e9aed3b7e18c550a7ae5b43f1a5715012d08695da66744e"),
    
    -- Rod
    PurchaseRod = getRemoteFromPackages("RF", "631361fdb4712a1bbd2df65a1c5fd948e6f85e5f30ef746c022a4ba1bf5c3399"),
    EquipRodSkin = getRemoteFromPackages("RE", "bbeb56f30d491f113e3b3ed28b781b1d62cf54a8acc66ab53a287d4b928fc60e"),
    
    -- Weather
    PurchaseWeather = getRemoteFromPackages("RF", "f7df2819493cf037d3870073bcb17495569565c5a08c7bd2b3632f440a361335"),
    WeatherCommand = getRemoteFromPackages("RE", "33e2a9e4854072028b2dc6cb66fe1365ad2d0bebf72421f844ccb80e780e2f4f"),
    
    -- Teleport
    SubmarineTP = getRemoteFromPackages("RE", "08ad2bcf5a0af3edb493588043f0a994dd33514a272a67578891ad2a6be01671"),
    SubmarineTP2 = getRemoteFromPackages("RF", "6203ae7bb361769999702f03e4dbaef00297b1664c8ec7733886476daabb88c1"),
    BoatTeleport = getRemoteFromPackages("RE", "067b63bd57d92bdb13769386e6591dc769c45b37b3bb7144b5c3368f1cc7dec2"),
    
    -- Other
    ClaimEvent = getRemoteFromPackages("RE", "3205d5ea83639e08c73e6c8a2605acf32e604bd7785761e488cbf47971cd9021"),
    UseGift = getRemoteFromPackages("RF", "93e7bd4ee545856c489046f58d520b38f9960a9f438d20ac7d3c9bf9fdac5da3"),
    ConsumePotion = getRemoteFromPackages("RF", "9d6f9a67eecd6285efabf46e099b4514e0b92f1c2ab04529ab5c446cc3e5f449"),
}

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== EXPLOIT FUNCTIONS =====

-- 🔴 KRITIS 1: Instant Fish (Tanpa Mancing)
local function instantFish()
    if not Remote.CatchFish then
        notify("Error", "Remote CatchFish tidak ditemukan")
        return
    end
    
    -- Coba berbagai parameter untuk test celah
    local testParams = {
        {"Legendary Fish", 100, "Mythical"},
        {"Secret Fish", 999, "Secret"},
        {"Megalodon", 1000, "Boss"},
        {true, "Legendary"},
        {1, "Epic", 50}
    }
    
    for _, params in ipairs(testParams) do
        spawn(function()
            Remote.CatchFish:FireServer(unpack(params))
            task.wait(0.1)
        end)
    end
    
    notify("Exploit", "Instant Fish - Cek console untuk hasil")
end

-- 🔴 KRITIS 2: Unlimited Money (Sell Spoof)
local function unlimitedMoney()
    if not Remote.SellAll then
        notify("Error", "Remote SellAll tidak ditemukan")
        return
    end
    
    -- Test race condition (spam)
    for i = 1, 20 do
        spawn(function()
            Remote.SellAll:FireServer()
        end)
    end
    
    -- Test parameter ekstrem
    if Remote.SellItem then
        Remote.SellItem:FireServer(999999) -- Jual item dengan ID tidak ada
        Remote.SellItem:FireServer(-1) -- Negative ID
        Remote.SellItem:FireServer("any") -- String sebagai ID
    end
    
    notify("Exploit", "Unlimited Money - Cek saldo")
end

-- 🔴 KRITIS 3: Unlimited Daily Rewards
local function unlimitedDaily()
    if not Remote.ClaimDaily then
        notify("Error", "Remote ClaimDaily tidak ditemukan")
        return
    end
    
    -- Spam claim (test cooldown)
    for i = 1, 50 do
        spawn(function()
            Remote.ClaimDaily:FireServer()
        end)
    end
    
    if Remote.ClaimBounty then
        for i = 1, 20 do
            Remote.ClaimBounty:FireServer()
        end
    end
    
    if Remote.ClaimPercentile then
        Remote.ClaimPercentile:FireServer(1)
        Remote.ClaimPercentile:FireServer(999)
    end
    
    notify("Exploit", "Unlimited Daily - Cek reward")
end

-- 🔴 KRITIS 4: Free Items (Purchase Bypass)
local function freeItems()
    if not Remote.PurchaseBait then
        notify("Error", "Remote PurchaseBait tidak ditemukan")
        return
    end
    
    -- Test parameter harga 0
    Remote.PurchaseBait:FireServer("Corrupt Bait", 0)
    Remote.PurchaseBait:FireServer("Royal Bait", 0)
    
    -- Test parameter negative
    Remote.PurchaseBait:FireServer("Aether Bait", -1000)
    
    -- Test nil parameter
    Remote.PurchaseBait:FireServer(nil, nil)
    
    if Remote.PurchaseRod then
        Remote.PurchaseRod:FireServer("Ares Rod", 0)
        Remote.PurchaseRod:FireServer("Element Rod", -1)
    end
    
    notify("Exploit", "Free Items - Cek inventory")
end

-- 🔴 KRITIS 5: Bypass Minigame
local function bypassMinigame()
    if not Remote.FishingMinigame or not Remote.CatchFish then
        notify("Error", "Remote tidak ditemukan")
        return
    end
    
    -- Langsung menang tanpa minigame
    Remote.FishingMinigame:FireServer(true)
    
    -- Langsung dapat ikan
    Remote.CatchFish:FireServer("Mythical Fish", 100, "Legendary")
    
    notify("Exploit", "Minigame Bypassed - Langsung dapat ikan")
end

-- 🔴 KRITIS 6: Race Condition Test
local function raceCondition()
    local remotes = {
        Remote.SellAll,
        Remote.ClaimDaily,
        Remote.CatchFish
    }
    
    for _, remote in ipairs(remotes) do
        if remote then
            for i = 1, 100 do
                spawn(function()
                    remote:FireServer()
                end)
            end
        end
    end
    
    notify("Exploit", "Race Condition Test - Cek response server")
end

-- 🔴 KRITIS 7: Parameter Fuzzing
local function parameterFuzzing()
    local testValues = {
        nil,
        true,
        false,
        0,
        999999,
        -1,
        math.huge,
        -math.huge,
        "any",
        {"nested"},
        {1,2,3},
        function() end
    }
    
    if Remote.PurchaseBait then
        for _, val in ipairs(testValues) do
            spawn(function()
                pcall(function()
                    Remote.PurchaseBait:FireServer(val, val)
                end)
            end)
        end
    end
    
    notify("Exploit", "Parameter Fuzzing - Cek server crash")
end

-- ===== UI ELEMENTS (SAMA SEPERTI SEBELUMNYA) =====
-- [Saya pertahankan semua fungsi UI dari script sebelumnya]
-- ...

-- ===== MENU FUNCTIONS DENGAN TAMBAHAN EXPLOIT =====

-- Fishing Menu (dengan tambahan exploit)
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "⚡ NORMAL FEATURES")
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
    
    createLabel(featuresContainer, "🔥 EXPLOIT FEATURES")
    createButton(featuresContainer, "⚡ INSTANT FISH (NO MINIGAME)", instantFish)
    createButton(featuresContainer, "🎯 BYPASS MINIGAME", bypassMinigame)
    createButton(featuresContainer, "⚡ RACE CONDITION TEST", raceCondition)
end

-- Bait Menu (dengan tambahan exploit)
local function showBait()
    clearFeatures()
    contentTitle.Text = "Bait Shop"
    
    createLabel(featuresContainer, "🛒 NORMAL SHOP")
    
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
    
    createLabel(featuresContainer, "🔥 EXPLOIT FEATURES")
    createButton(featuresContainer, "💰 FREE ITEMS (PRICE 0)", freeItems)
    createButton(featuresContainer, "🎲 PARAMETER FUZZING", parameterFuzzing)
end

-- Rod Menu (dengan tambahan exploit)
local function showRod()
    clearFeatures()
    contentTitle.Text = "Rod Shop"
    
    createLabel(featuresContainer, "🛒 NORMAL SHOP")
    
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
    
    createLabel(featuresContainer, "🔥 EXPLOIT FEATURES")
    createButton(featuresContainer, "💰 FREE RODS", freeItems)
end

-- Weather Menu
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    createLabel(featuresContainer, "☁️ WEATHER")
    
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
end

-- Teleport Menu
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "📍 LOCATIONS")
    
    local selectedLoc = TeleportNames[1]
    
    createDropdown(featuresContainer, TeleportNames, TeleportNames[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT NOW", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local cframe = TeleportLocations[selectedLoc]
            if cframe then
                char.HumanoidRootPart.CFrame = cframe
                notify("Teleport", "Teleported to " .. selectedLoc)
            end
        end
    end)
end

-- Quest Menu (dengan tambahan exploit)
local function showQuest()
    clearFeatures()
    contentTitle.Text = "Quests"
    
    createLabel(featuresContainer, "📋 NORMAL QUESTS")
    
    createButton(featuresContainer, "CLAIM DAILY LOGIN", function()
        if Remote.ClaimDaily then
            Remote.ClaimDaily:FireServer()
            notify("Quest", "Daily login claimed")
        end
    end)
    
    createButton(featuresContainer, "CLAIM BOUNTY", function()
        if Remote.ClaimBounty then
            Remote.ClaimBounty:FireServer()
            notify("Quest", "Bounty claimed")
        end
    end)
    
    createLabel(featuresContainer, "🔥 EXPLOIT FEATURES")
    createButton(featuresContainer, "💰 UNLIMITED DAILY", unlimitedDaily)
    createButton(featuresContainer, "💰 UNLIMITED MONEY", unlimitedMoney)
end

-- Exploit Menu (BARU)
local function showExploit()
    clearFeatures()
    contentTitle.Text = "Exploit Hub"
    
    createLabel(featuresContainer, "🔴 KRITICAL EXPLOITS")
    createButton(featuresContainer, "🎣 INSTANT FISH (NO MINIGAME)", instantFish)
    createButton(featuresContainer, "💰 UNLIMITED MONEY", unlimitedMoney)
    createButton(featuresContainer, "📅 UNLIMITED DAILY", unlimitedDaily)
    createButton(featuresContainer, "🛒 FREE ITEMS", freeItems)
    createButton(featuresContainer, "🎯 BYPASS MINIGAME", bypassMinigame)
    
    createLabel(featuresContainer, "⚡ ADVANCED EXPLOITS")
    createButton(featuresContainer, "🔄 RACE CONDITION TEST", raceCondition)
    createButton(featuresContainer, "🎲 PARAMETER FUZZING", parameterFuzzing)
    
    createLabel(featuresContainer, "📊 STATUS REMOTE")
    local status = "CatchFish: " .. (Remote.CatchFish and "✅" or "❌") .. "\n"
    status = status .. "SellAll: " .. (Remote.SellAll and "✅" or "❌") .. "\n"
    status = status .. "ClaimDaily: " .. (Remote.ClaimDaily and "✅" or "❌") .. "\n"
    status = status .. "PurchaseBait: " .. (Remote.PurchaseBait and "✅" or "❌") .. "\n"
    
    local infoBox = Instance.new("TextLabel")
    infoBox.Size = UDim2.new(1, 0, 0, 80)
    infoBox.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    infoBox.BackgroundTransparency = 0.2
    infoBox.Text = status
    infoBox.TextColor3 = Color3.new(0.3, 1, 0.3)
    infoBox.Font = Enum.Font.Code
    infoBox.TextSize = 12
    infoBox.TextXAlignment = Enum.TextXAlignment.Left
    infoBox.Parent = featuresContainer
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoBox
end

-- ===== CREATE LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Bait", func = showBait},
    {name = "Rod", func = showRod},
    {name = "Weather", func = showWeather},
    {name = "Teleport", func = showTeleport},
    {name = "Quest", func = showQuest},
    {name = "Exploit", func = showExploit} -- Menu baru
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

print("Moe V1.0 GUI Loaded - EXPLOIT EDITION")
print("🔥 7 Exploit features siap digunakan")
print("⚠️ Gunakan dengan risiko sendiri!")