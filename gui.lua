-- DARK ZEPHYR FISHING GUI v1.1 - FIXED NET STRUCTURE

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DarkZephyrGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== REMOTE PATHS YANG BENAR (FIXED) =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- Cek struktur
local RE = Net:FindFirstChild("RE") -- RemoteEvent folder
local RF = Net:FindFirstChild("RF") -- RemoteFunction folder
local URE = Net:FindFirstChild("URE") -- UnreliableRemoteEvent folder

print("=== REMOTE CHECK ===")
print("RE folder:", RE ~= nil)
print("RF folder:", RF ~= nil)
print("URE folder:", URE ~= nil)

-- Function aman untuk get remote
local function GetRemote(type, name)
    local folder = type == "RE" and RE or (type == "RF" and RF or URE)
    if folder then
        local remote = folder:FindFirstChild(name)
        if remote then
            print("✅ Found:", type, name)
            return remote
        else
            -- Coba cari yang hash (kalo ada)
            for _, child in pairs(folder:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    -- Match berdasarkan pola nama
                    if string.find(child.Name:lower(), name:lower()) then
                        print("✅ Found (hash):", type, child.Name)
                        return child
                    end
                end
            end
            print("❌ Not found:", type, name)
        end
    end
    return nil
end

-- Remote yang kita butuhkan (berdasarkan hasil scan)
local Remote = {
    -- Teleport
    SubmarineTP = GetRemote("RE", "SubmarineTP"),
    BoatTeleport = GetRemote("RE", "BoatTeleport"),
    TriggerSubmarine = GetRemote("RE", "TriggerSubmarine"),
    
    -- Fishing
    CatchFish = GetRemote("RF", "CatchFishCompleted"),
    ChargeRod = GetRemote("RF", "ChargeFishingRod"),
    FishingMinigame = GetRemote("RE", "FishingMinigameChanged"),
    CaughtFishVisual = GetRemote("RE", "CaughtFishVisual"),
    FishingStopped = GetRemote("RE", "FishingStopped"),
    
    -- Rod & Bait
    EquipRodSkin = GetRemote("RE", "EquipRodSkin"),
    EquipBait = GetRemote("RE", "EquipBait"),
    PurchaseRod = GetRemote("RF", "PurchaseFishingRod"),
    PurchaseBait = GetRemote("RF", "PurchaseBait"),
    
    -- Sell
    SellAllItems = GetRemote("RF", "SellAllItems"),
    
    -- Weather
    WeatherCommand = GetRemote("RE", "WeatherCommand"),
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

-- ===== VARIABLES =====
local AutoFishing = false
local InstantFishing = false
local InstantFishingDelay = 0.3
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
    
    if Remote.CatchFish then
        pcall(function()
            Remote.CatchFish:FireServer()
            if Remote.CaughtFishVisual then
                Remote.CaughtFishVisual:FireServer()
            end
        end)
    end
end

-- ===== AUTO FISHING LOOP =====
local function StartAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    
    if not Remote.CatchFish then
        notify("Error", "CatchFish remote not found!", 3)
        return
    end
    
    notify("Auto Fishing", "Started")
    
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
        
        -- Coba pake submarine remote
        pcall(function()
            if Remote.SubmarineTP then
                Remote.SubmarineTP:FireServer(cf)
            end
            if Remote.TriggerSubmarine then
                Remote.TriggerSubmarine:FireServer()
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
Title.Text = "DARK ZEPHYR GUI"
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
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- ===== UI FUNCTIONS =====
local function ClearContainer()
    for _, child in pairs(Container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

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
    
    local value = default
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local width = sliderBg.AbsoluteSize.X
            local percentage = math.clamp(pos / width, 0, 1)
            value = min + (max - min) * percentage
            value = math.floor(value * 10) / 10
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
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
    frame.ZIndex = 5
    
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
    btn.ZIndex = 6
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 6
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdown.Position = UDim2.new(0, 0, 1, 2)
    dropdown.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdown.Visible = false
    dropdown.Parent = frame
    dropdown.ZIndex = 10
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
            dropdown.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
end

-- ===== TAB FUNCTIONS =====
local function ShowTeleportTab()
    ClearContainer()
    
    CreateLabel("📍 TELEPORT MENU")
    
    local locList = {}
    for loc, _ in pairs(LOCATIONS) do
        table.insert(locList, loc)
    end
    table.sort(locList)
    
    CreateDropdown(locList, SelectedLocation, function(selected)
        SelectedLocation = selected
    end)
    
    CreateButton("🚀 TELEPORT NOW", function()
        TeleportTo(SelectedLocation)
    end)
    
    CreateLabel("⚡ QUICK LOCATIONS")
    local quickLocs = {"Spawn", "Treasure Room", "Ancient Jungle", "Coral Reefs", "Kohana"}
    for _, loc in ipairs(quickLocs) do
        if LOCATIONS[loc] then
            CreateButton("→ " .. loc, function()
                TeleportTo(loc)
            end)
        end
    end
end

local function ShowFishingTab()
    ClearContainer()
    
    CreateLabel("⚡ INSTANT FISHING")
    
    if not Remote.CatchFish then
        CreateLabel("❌ CATCH FISH REMOTE TIDAK DITEMUKAN")
        return
    end
    
    CreateToggle("Instant Fishing", InstantFishing, function(state)
        InstantFishing = state
        if not state then StopAutoFishing() end
    end)
    
    CreateSlider("Delay (seconds)", 0.1, 2, InstantFishingDelay, function(value)
        InstantFishingDelay = value
    end)
    
    CreateLabel("🎣 AUTO FISHING")
    
    CreateButton("START AUTO FISHING", function()
        if InstantFishing then
            AutoFishing = true
            StartAutoFishing()
        else
            notify("Error", "Enable Instant Fishing first!")
        end
    end)
    
    CreateButton("STOP AUTO FISHING", StopAutoFishing)
    
    CreateLabel("🔥 MANUAL")
    
    CreateButton("INSTANT CATCH", function()
        BypassFishing()
    end)
    
    if Remote.SellAllItems then
        CreateButton("SELL ALL ITEMS", function()
            Remote.SellAllItems:FireServer()
            notify("Sell", "All items sold")
        end)
    end
end

-- Create tabs
local FishingTab = Instance.new("TextButton")
FishingTab.Size = UDim2.new(0, 100, 0, 30)
FishingTab.Position = UDim2.new(0, 0, 0, 2.5)
FishingTab.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
FishingTab.Text = "Fishing"
FishingTab.TextColor3 = Color3.new(1, 1, 1)
FishingTab.Font = Enum.Font.GothamBold
FishingTab.TextSize = 13
FishingTab.Parent = TabFrame

local FishingCorner = Instance.new("UICorner")
FishingCorner.CornerRadius = UDim.new(0, 6)
FishingCorner.Parent = FishingTab

local TeleportTab = Instance.new("TextButton")
TeleportTab.Size = UDim2.new(0, 100, 0, 30)
TeleportTab.Position = UDim2.new(0, 105, 0, 2.5)
TeleportTab.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
TeleportTab.Text = "Teleport"
TeleportTab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
TeleportTab.Font = Enum.Font.GothamBold
TeleportTab.TextSize = 13
TeleportTab.Parent = TabFrame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 6)
TeleportCorner.Parent = TeleportTab

-- Tab click events
FishingTab.MouseButton1Click:Connect(function()
    FishingTab.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
    FishingTab.TextColor3 = Color3.new(1, 1, 1)
    TeleportTab.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    TeleportTab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ShowFishingTab()
end)

TeleportTab.MouseButton1Click:Connect(function()
    TeleportTab.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
    TeleportTab.TextColor3 = Color3.new(1, 1, 1)
    FishingTab.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    FishingTab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    ShowTeleportTab()
end)

-- Show teleport tab first (karena ini yang pasti work)
ShowTeleportTab()

notify("Dark Zephyr", "GUI Loaded - Teleport Ready!", 3)