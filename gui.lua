-- Moe V1.0 - Dark Zepyhr Edition
-- Dengan Auto-Detect Remote Functions

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== AUTO-DETECT REMOTE FUNCTIONS =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DetectedRemotes = {
    Teleport = {},
    Fishing = {},
    Bait = {},
    Rod = {},
    Weather = {},
    Sell = {},
    Other = {}
}

-- Fungsi untuk scan semua kemungkinan remote
local function ScanRemotes()
    print("🔍 Scanning for remotes...")
    
    -- Scan di ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") then
            local name = obj.Name:lower()
            
            -- Kategorikan berdasarkan nama
            if name:find("tp") or name:find("teleport") or name:find("tele") or 
               name:find("submarine") or name:find("boat") or name:find("spawn") then
                table.insert(DetectedRemotes.Teleport, obj)
                
            elseif name:find("fish") or name:find("catch") or name:find("cast") or 
                   name:find("reel") or name:find("minigame") or name:find("charge") then
                table.insert(DetectedRemotes.Fishing, obj)
                
            elseif name:find("bait") then
                table.insert(DetectedRemotes.Bait, obj)
                
            elseif name:find("rod") or name:find("pole") then
                table.insert(DetectedRemotes.Rod, obj)
                
            elseif name:find("weather") or name:find("wind") or name:find("storm") then
                table.insert(DetectedRemotes.Weather, obj)
                
            elseif name:find("sell") then
                table.insert(DetectedRemotes.Sell, obj)
                
            else
                table.insert(DetectedRemotes.Other, obj)
            end
        end
    end
    
    -- Print hasil scan
    print("\n=== DETECTED REMOTES ===")
    for category, remotes in pairs(DetectedRemotes) do
        if #remotes > 0 then
            print(category .. ": " .. #remotes .. " found")
            for _, remote in ipairs(remotes) do
                print("  🔹 " .. remote.Name)
            end
        end
    end
end

ScanRemotes()

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

-- ===== DATA ITEMS (untuk GUI) =====
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

local WeatherNames = {
    "Wind",
    "Cloudy",
    "Snow",
    "Storm",
    "Radiant",
    "Shark Hunt"
}

-- ===== VARIABLES =====
local AutoFishing = false
local AutoEquipRod = false
local InstantFishing = false
local InstantFishingDelay = 0.5
local SelectedBait = BaitNames[1]
local SelectedRod = RodNames[1]
local SelectedWeather = WeatherNames[1]
local SelectedLocation = "Spawn"
local FishingLoop = nil

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== SMART REMOTE INVOKER =====
local function TryInvoke(category, ...)
    local remotes = DetectedRemotes[category]
    if not remotes or #remotes == 0 then
        notify("Error", "No " .. category .. " remote found!")
        return false
    end
    
    -- Coba semua remote yang relevan
    local success = false
    for _, remote in ipairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
            success = true
        end)
    end
    
    return success
end

-- ===== INSTANT FISHING FUNCTION =====
local function DoInstantFishing()
    if not InstantFishing then return end
    
    -- Bypass semua state, langsung coba semua kemungkinan fishing remote
    local success = TryInvoke("Fishing")
    
    if success then
        -- Coba juga remote spesifik catch jika ada
        for _, remote in ipairs(DetectedRemotes.Fishing) do
            if remote.Name:lower():find("catch") or remote.Name:lower():find("complete") then
                pcall(function()
                    remote:FireServer()
                end)
            end
        end
    end
end

-- ===== AUTO FISHING LOOP =====
local function StartAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    
    FishingLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutoFishing and InstantFishing then
            DoInstantFishing()
            task.wait(InstantFishingDelay)
        end
    end)
end

local function StopAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    AutoFishing = false
end

-- ===== TELEPORT FUNCTION =====
local function TeleportTo(location)
    local cf = LOCATIONS[location]
    if not cf then
        notify("Teleport", "Location not found!")
        return
    end
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = cf
        notify("Teleport", "Teleported to " .. location)
    end
end

-- ===== GUI CONSTRUCTION =====
-- [SISIPKAN KODE GUI DARI SEBELUMNYA DI SINI]
-- (Saya akan gunakan kode GUI yang sudah kita buat sebelumnya, 
--  tapi dengan fungsi-fungsi yang sudah dimodifikasi)

-- ===== MODIFIED MENU FUNCTIONS =====

-- Fishing Menu dengan auto-detect
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    -- Status remote yang terdeteksi
    if #DetectedRemotes.Fishing > 0 then
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "✅ " .. #DetectedRemotes.Fishing .. " fishing remotes detected"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
    end
    
    createLabel(featuresContainer, "⚡ Instant Fishing Settings")
    
    createToggle(featuresContainer, "Instant Fishing", InstantFishing, function(state)
        InstantFishing = state
        if state then
            notify("Instant Fishing", "Enabled")
        else
            StopAutoFishing()
            notify("Instant Fishing", "Disabled")
        end
    end)
    
    createSlider(featuresContainer, "Delay (seconds)", 0.1, 2, InstantFishingDelay, function(value)
        InstantFishingDelay = value
    end)
    
    createToggle(featuresContainer, "Auto Equip Rod", AutoEquipRod, function(state)
        AutoEquipRod = state
        notify("Auto Equip Rod", state and "Enabled" or "Disabled")
    end)
    
    createLabel(featuresContainer, "🎣 Auto Fishing Control")
    
    createButton(featuresContainer, "START AUTO FISHING", function()
        if InstantFishing then
            AutoFishing = true
            StartAutoFishing()
            notify("Auto Fishing", "Started")
        else
            notify("Auto Fishing", "Enable Instant Fishing first!")
        end
    end)
    
    createButton(featuresContainer, "STOP AUTO FISHING", function()
        StopAutoFishing()
        notify("Auto Fishing", "Stopped")
    end)
    
    createLabel(featuresContainer, "🔥 Manual Controls")
    
    createButton(featuresContainer, "TRY CATCH FISH", function()
        DoInstantFishing()
    end)
    
    if #DetectedRemotes.Sell > 0 then
        createButton(featuresContainer, "SELL ALL ITEMS", function()
            TryInvoke("Sell")
            notify("Sell", "Attempted to sell items")
        end)
    end
end

-- Teleport Menu (tetap sama)
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport Menu"
    
    createLabel(featuresContainer, "Select Location")
    
    createDropdown(featuresContainer, LOCATIONS, SelectedLocation, function(selected)
        SelectedLocation = selected
    end)
    
    createButton(featuresContainer, "🚀 TELEPORT NOW", function()
        TeleportTo(SelectedLocation)
    end)
    
    createLabel(featuresContainer, "📍 Quick Locations")
    local quickLocations = {"Spawn", "Treasure Room", "Ancient Jungle", "Sacred Temple"}
    for _, loc in ipairs(quickLocations) do
        createButton(featuresContainer, "→ " .. loc, function()
            TeleportTo(loc)
        end)
    end
end

-- Bait Menu dengan auto-detect
local function showBait()
    clearFeatures()
    contentTitle.Text = "Bait Selector"
    
    if #DetectedRemotes.Bait > 0 then
        createLabel(featuresContainer, "✅ Bait remotes available")
    else
        createLabel(featuresContainer, "⚠️ No bait remotes detected")
    end
    
    createLabel(featuresContainer, "Select Bait")
    createDropdown(featuresContainer, BaitNames, SelectedBait, function(selected)
        SelectedBait = selected
    end)
    
    createButton(featuresContainer, "TRY EQUIP BAIT", function()
        if TryInvoke("Bait", SelectedBait) then
            notify("Bait", "Attempted to equip " .. SelectedBait)
        end
    end)
end

-- Rod Menu dengan auto-detect
local function showRod()
    clearFeatures()
    contentTitle.Text = "Rod Selector"
    
    if #DetectedRemotes.Rod > 0 then
        createLabel(featuresContainer, "✅ Rod remotes available")
    else
        createLabel(featuresContainer, "⚠️ No rod remotes detected")
    end
    
    createLabel(featuresContainer, "Select Rod")
    createDropdown(featuresContainer, RodNames, SelectedRod, function(selected)
        SelectedRod = selected
    end)
    
    createButton(featuresContainer, "TRY EQUIP ROD", function()
        if TryInvoke("Rod", SelectedRod) then
            notify("Rod", "Attempted to equip " .. SelectedRod)
        end
    end)
    
    if AutoEquipRod then
        createLabel(featuresContainer, "⚙️ Auto Equip is ON")
    end
end

-- Weather Menu dengan auto-detect
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    if #DetectedRemotes.Weather > 0 then
        createLabel(featuresContainer, "✅ Weather remotes available")
    else
        createLabel(featuresContainer, "⚠️ No weather remotes detected")
    end
    
    createLabel(featuresContainer, "Select Weather")
    createDropdown(featuresContainer, WeatherNames, SelectedWeather, function(selected)
        SelectedWeather = selected
    end)
    
    createButton(featuresContainer, "TRY ACTIVATE WEATHER", function()
        if TryInvoke("Weather", SelectedWeather) then
            notify("Weather", "Attempted to activate " .. SelectedWeather)
        end
    end)
end

-- [SISIPKAN SEMUA FUNGSI GUI LAINNYA DARI SEBELUMNYA]
-- (createToggle, createSlider, createDropdown, createButton, createLabel, clearFeatures)

-- ===== LEFT MENU BUTTONS =====
createMenuButton("⚡ Fishing", showFishing)
createMenuButton("📍 Teleport", showTeleport)
createMenuButton("🎣 Bait", showBait)
createMenuButton("🪝 Rod", showRod)
createMenuButton("🌦️ Weather", showWeather)

-- Show fishing menu by default
showFishing()

notify("Moe V1.0 - Dark Zepyhr", "Loaded! " .. #DetectedRemotes.Fishing + #DetectedRemotes.Bait + #DetectedRemotes.Rod + #DetectedRemotes.Weather + #DetectedRemotes.Sell .. " remotes detected")