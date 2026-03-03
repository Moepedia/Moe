-- DARK ZEPHYR FISHING GUI v1.0 - NET FRAMEWORK
-- Untuk game FISH IT

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DarkZephyrGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== REMOTE PATHS YANG BENAR =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local Remote = {
    -- Teleport (HANYA INI YANG AKAN TETAP)
    SubmarineTP = Net.RE.SubmarineTP,
    SubmarineTP2 = Net.RF.SubmarineTP2,
    BoatTeleport = Net.RE.BoatTeleport,
    TriggerSubmarine = Net.RE.TriggerSubmarine,
    
    -- Fishing (UNTUK BYPASS)
    ChargeRod = Net.RF.ChargeFishingRod,
    CatchFish = Net.RF.CatchFishCompleted,
    FishingMinigame = Net.RE.FishingMinigameChanged,
    RequestMinigame = Net.RF.RequestFishingMinigameStarted,
    FishCaught = Net.RE.FishCaught,
    CaughtFishVisual = Net.RE.CaughtFishVisual,
    FishingStopped = Net.RE.FishingStopped,
    UpdateChargeState = Net.RE.UpdateChargeState,
    
    -- Rod & Bait
    EquipRodSkin = Net.RE.EquipRodSkin,
    EquipBait = Net.RE.EquipBait,
    PurchaseRod = Net.RF.PurchaseFishingRod,
    PurchaseBait = Net.RF.PurchaseBait,
    
    -- Sell
    SellItem = Net.RF.SellItem,
    SellAllItems = Net.RF.SellAllItems,
    
    -- Weather
    WeatherCommand = Net.RE.WeatherCommand,
    PurchaseWeather = Net.RF.PurchaseWeatherEvent,
    
    -- Lainnya
    ClaimDailyLogin = Net.RF.ClaimDailyLogin,
    SetSpawn = Net.RE.SetSpawn,
}

-- ===== DATA LOKASI TELEPORT =====
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693),
}

-- ===== DATA ITEMS =====
local BaitNames = {
    "Starter Bait", "Topwater Bait", "Luck Bait", "Midnight Bait",
    "Nature Bait", "Chroma Bait", "Royal Bait", "Dark Matter Bait",
    "Corrupt Bait", "Aether Bait", "Floral Bait", "Singularity Bait"
}

local RodNames = {
    "Starter Rod", "Luck Rod", "Carbon Rod", "Toy Rod", "Grass Rod",
    "Damascus Rod", "Ice Rod", "Lava Rod", "Lucky Rod", "Midnight Rod",
    "Steampunk Rod", "Chrome Rod", "Fluorescent Rod", "Astral Rod",
    "Hazmat Rod", "Ares Rod", "Angler Rod", "Ghostfinn Rod",
    "Bamboo Rod", "Element Rod", "Diamond Rod"
}

-- ===== VARIABLES =====
local AutoFishing = false
local AutoEquipRod = false
local InstantFishing = false
local InstantFishingDelay = 0.3
local SelectedBait = BaitNames[1]
local SelectedRod = RodNames[1]
local SelectedLocation = "Spawn"
local FishingLoop = nil

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== INSTANT FISHING BYPASS =====
local function BypassFishing()
    if not InstantFishing then return end
    
    -- Bypass semua state, langsung invoke catch
    pcall(function()
        if Remote.CatchFish then
            -- Langsung catch tanpa minigame
            Remote.CatchFish:FireServer()
            
            -- Trigger visual biar keliatan real
            if Remote.CaughtFishVisual then
                Remote.CaughtFishVisual:FireServer()
            end
            
            -- Notify di console
            print("🎣 BYPASS: Fish caught without minigame!")
        end
    end)
end

-- ===== AUTO FISHING LOOP =====
local function StartAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    
    notify("Auto Fishing", "Started with delay " .. InstantFishingDelay .. "s")
    
    FishingLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutoFishing and InstantFishing then
            BypassFishing()
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
    notify("Auto Fishing", "Stopped")
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
        
        -- Coba pake submarine remote juga
        pcall(function()
            if Remote.SubmarineTP then
                Remote.SubmarineTP:FireServer(cf)
            end
        end)
    end
end

-- ===== GUI SETUP =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.new(0.3, 0.3, 0.3)
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DARK ZEPHYR FISHING GUI"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    StopAutoFishing()
    gui:Destroy()
end)

-- Tab Buttons
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -20, 0, 35)
TabFrame.Position = UDim2.new(0, 10, 0, 40)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local Tabs = {}
local CurrentTab = "Fishing"

local function CreateTab(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, position, 0, 2.5)
    btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    btn.Text = name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = TabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -90)
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 6)
ContentCorner.Parent = ContentFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = ContentFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 0, 0)
Container.BackgroundTransparency = 1
Container.Parent = ScrollingFrame
Container.AutomaticSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- ===== UI HELPER FUNCTIONS =====
local function CreateLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Container
end

local function CreateToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -70, 0.5, -12.5)
    btn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function CreateSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1, 1, 0)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 1, -12)
    sliderBg.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sliderBg.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.new(0, 0.7, 1)
    sliderFill.Parent = sliderBg
    
    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(0, 12, 0, 12)
    dragBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    dragBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    dragBtn.Text = ""
    dragBtn.Parent = sliderBg
    
    local dragging = false
    
    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local width = sliderBg.AbsoluteSize.X
            local percentage = math.clamp(pos / width, 0, 1)
            local value = min + (max - min) * percentage
            value = math.floor(value * 10) / 10
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            dragBtn.Position = UDim2.new(percentage, -6, 0.5, -6)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function CreateDropdown(options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.Parent = Container
    frame.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = frame
    btn.ZIndex = 11
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 11
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdown.Position = UDim2.new(0, 0, 1, 2)
    dropdown.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdown.Visible = false
    dropdown.Parent = frame
    dropdown.ZIndex = 20
    dropdown.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 13
        optBtn.Parent = dropdown
        optBtn.ZIndex = 21
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdown.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
end

local function ClearContainer()
    for _, child in pairs(Container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== TAB FUNCTIONS =====
local function ShowFishingTab()
    ClearContainer()
    
    CreateLabel("⚡ INSTANT FISHING BYPASS")
    
    CreateToggle("Instant Fishing", InstantFishing, function(state)
        InstantFishing = state
        if not state then StopAutoFishing() end
        notify("Instant Fishing", state and "Enabled" or "Disabled")
    end)
    
    CreateSlider("Delay (seconds)", 0.1, 2, InstantFishingDelay, function(value)
        InstantFishingDelay = value
        if AutoFishing then
            notify("Delay", "Updated to " .. value .. "s")
        end
    end)
    
    CreateToggle("Auto Equip Rod", AutoEquipRod, function(state)
        AutoEquipRod = state
        notify("Auto Equip", state and "Enabled" or "Disabled")
    end)
    
    CreateLabel("🎣 AUTO FISHING")
    
    CreateButton("START AUTO FISHING", function()
        if InstantFishing then
            AutoFishing = true
            StartAutoFishing()
        else
            notify("Error", "Enable Instant Fishing first!", 3)
        end
    end)
    
    CreateButton("STOP AUTO FISHING", StopAutoFishing)
    
    CreateLabel("🔥 MANUAL BYPASS")
    
    CreateButton("INSTANT CATCH (BYPASS ALL)", function()
        if Remote.CatchFish then
            Remote.CatchFish:FireServer()
            if Remote.CaughtFishVisual then
                Remote.CaughtFishVisual:FireServer()
            end
            notify("Bypass", "Fish caught instantly!")
        end
    end)
    
    CreateButton("CHARGE ROD", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
            notify("Rod", "Charged")
        end
    end)
    
    CreateButton("SELL ALL ITEMS", function()
        if Remote.SellAllItems then
            Remote.SellAllItems:FireServer()
            notify("Sell", "All items sold")
        end
    end)
end

local function ShowTeleportTab()
    ClearContainer()
    
    CreateLabel("📍 TELEPORT MENU")
    
    CreateDropdown(LOCATIONS, SelectedLocation, function(selected)
        SelectedLocation = selected
    end)
    
    CreateButton("🚀 TELEPORT NOW", function()
        TeleportTo(SelectedLocation)
    end)
    
    CreateLabel("⚡ QUICK TELEPORT")
    
    local quickLocs = {"Spawn", "Treasure Room", "Ancient Jungle", "Sacred Temple", "Coral Reefs", "Kohana"}
    for _, loc in ipairs(quickLocs) do
        CreateButton("→ " .. loc, function()
            TeleportTo(loc)
        end)
    end
end

local function ShowBaitTab()
    ClearContainer()
    
    CreateLabel("🎣 BAIT SELECTOR")
    
    CreateDropdown(BaitNames, SelectedBait, function(selected)
        SelectedBait = selected
    end)
    
    CreateButton("EQUIP SELECTED BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer(SelectedBait)
            notify("Bait", "Equipped " .. SelectedBait)
        end
    end)
    
    CreateButton("BUY SELECTED BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer(SelectedBait, 1)
            notify("Bait", "Purchased " .. SelectedBait)
        end
    end)
end

local function ShowRodTab()
    ClearContainer()
    
    CreateLabel("🪝 ROD SELECTOR")
    
    CreateDropdown(RodNames, SelectedRod, function(selected)
        SelectedRod = selected
    end)
    
    CreateButton("EQUIP ROD SKIN", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer(SelectedRod)
            notify("Rod", "Equipped " .. SelectedRod)
        end
    end)
    
    CreateButton("BUY ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer(SelectedRod, 1)
            notify("Rod", "Purchased " .. SelectedRod)
        end
    end)
    
    if AutoEquipRod then
        CreateLabel("⚙️ Auto Equip is ON")
    end
end

local function ShowWeatherTab()
    ClearContainer()
    
    local WeatherNames = {"Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"}
    
    CreateLabel("🌦️ WEATHER CONTROL")
    
    CreateDropdown(WeatherNames, WeatherNames[1], function(selected)
        SelectedWeather = selected
    end)
    
    CreateButton("ACTIVATE WEATHER", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer(SelectedWeather)
            notify("Weather", SelectedWeather .. " activated")
        elseif Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(SelectedWeather)
            notify("Weather", SelectedWeather .. " purchased")
        end
    end)
end

-- Create tabs
local tabPositions = {0, 105, 210, 315, 420}
local tabNames = {"Fishing", "Teleport", "Bait", "Rod", "Weather"}
local tabFunctions = {ShowFishingTab, ShowTeleportTab, ShowBaitTab, ShowRodTab, ShowWeatherTab}

for i, name in ipairs(tabNames) do
    local btn = CreateTab(name, tabPositions[i])
    btn.MouseButton1Click:Connect(function()
        CurrentTab = name
        tabFunctions[i]()
        
        -- Update tab colors
        for _, child in pairs(TabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
                child.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            end
        end
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
end

-- Show default tab
ShowFishingTab()

notify("Dark Zephyr", "GUI Loaded Successfully!", 3)