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
                   name:find("reel") or name:find("minigame") or name:find("charge") or
                   name:find("complete") then
                table.insert(DetectedRemotes.Fishing, obj)
                
            elseif name:find("bait") then
                table.insert(DetectedRemotes.Bait, obj)
                
            elseif name:find("rod") or name:find("pole") then
                table.insert(DetectedRemotes.Rod, obj)
                
            elseif name:find("weather") or name:find("wind") or name:find("storm") or
                   name:find("radiant") then
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
        return false
    end
    
    -- Coba semua remote yang relevan
    local success = false
    for _, remote in ipairs(remotes) do
        local s, e = pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(...)
            end
        end)
        if s then success = true end
    end
    
    return success
end

-- ===== INSTANT FISHING FUNCTION =====
local function DoInstantFishing()
    if not InstantFishing then return end
    
    -- Bypass semua state, langsung coba semua kemungkinan fishing remote
    TryInvoke("Fishing")
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

-- ===== MAIN FRAME (650x400) =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.ZIndex = 1

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
    StopAutoFishing()
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
contentContainer.ZIndex = 2

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer
leftMenu.ZIndex = 2

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
contentArea.ZIndex = 2
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
contentTitle.ZIndex = 2

-- Scrolling frame untuk features
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea
scrollFrame.ZIndex = 2
scrollFrame.ScrollingEnabled = true

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y
featuresContainer.ZIndex = 2

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENTS FUNCTIONS =====
local function createToggle(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 2
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 2
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 24)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    toggleBtn.ZIndex = 3
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local state = defaultValue
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 2
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 2
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1, 1, 0)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    valueLabel.ZIndex = 2
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 1, -10)
    sliderBg.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sliderBg.Parent = frame
    sliderBg.ZIndex = 2
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 2)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.new(0, 0.7, 1)
    sliderFill.Parent = sliderBg
    sliderFill.ZIndex = 2
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = sliderFill
    
    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(0, 12, 0, 12)
    dragBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    dragBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    dragBtn.Text = ""
    dragBtn.Parent = sliderBg
    dragBtn.ZIndex = 3
    
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 6)
    dragCorner.Parent = dragBtn
    
    local dragging = false
    
    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    mouse.Move:Connect(function()
        if dragging then
            local pos = mouse.X - sliderBg.AbsolutePosition.X
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
    
    mouse.Button1Up:Connect(function()
        dragging = false
    end)
    
    return frame
end

local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 5
    frame.ClipsDescendants = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or (type(options) == "table" and options[1] or "Select")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
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
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 1, 2)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 1000
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.FillDirection = Enum.FillDirection.Vertical
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.Parent = dropdownFrame
    
    -- Handle both table types (array or dictionary)
    local optionsList = {}
    if type(options) == "table" then
        -- Check if it's an array or dictionary
        local isArray = false
        for i, v in pairs(options) do
            if type(i) == "number" then
                isArray = true
            end
            table.insert(optionsList, v)
        end
        if not isArray then
            optionsList = {}
            for key, _ in pairs(options) do
                table.insert(optionsList, key)
            end
        end
    end
    
    for i, opt in ipairs(optionsList) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = tostring(opt)
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdownFrame
        optBtn.ZIndex = 1001
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = tostring(opt)
            dropdownFrame.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)
    
    -- Close dropdown when clicking outside
    mouse.Button1Down:Connect(function()
        if dropdownFrame.Visible then
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local dropdownAbsPos = dropdownFrame.AbsolutePosition
            local dropdownAbsSize = dropdownFrame.AbsoluteSize
            local frameAbsPos = frame.AbsolutePosition
            local frameAbsSize = frame.AbsoluteSize
            
            if mousePos.X < dropdownAbsPos.X or mousePos.X > dropdownAbsPos.X + dropdownAbsSize.X or
               mousePos.Y < dropdownAbsPos.Y or mousePos.Y > dropdownAbsPos.Y + dropdownAbsSize.Y then
                if mousePos.X < frameAbsPos.X or mousePos.X > frameAbsPos.X + frameAbsSize.X or
                   mousePos.Y < frameAbsPos.Y or mousePos.Y > frameAbsPos.Y + frameAbsSize.Y then
                    dropdownFrame.Visible = false
                end
            end
        end
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
    btn.ZIndex = 2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
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
    label.ZIndex = 2
    
    return label
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

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
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "✅ " .. #DetectedRemotes.Bait .. " bait remotes detected"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
    else
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "⚠️ No bait remotes detected"
        statusLabel.TextColor3 = Color3.new(1, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
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
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "✅ " .. #DetectedRemotes.Rod .. " rod remotes detected"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
    else
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "⚠️ No rod remotes detected"
        statusLabel.TextColor3 = Color3.new(1, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
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
        local autoLabel = Instance.new("TextLabel")
        autoLabel.Size = UDim2.new(1, 0, 0, 20)
        autoLabel.BackgroundTransparency = 1
        autoLabel.Text = "⚙️ Auto Equip is ON"
        autoLabel.TextColor3 = Color3.new(0, 1, 1)
        autoLabel.TextSize = 11
        autoLabel.Font = Enum.Font.Gotham
        autoLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoLabel.Parent = featuresContainer
    end
end

-- Weather Menu dengan auto-detect
local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    if #DetectedRemotes.Weather > 0 then
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "✅ " .. #DetectedRemotes.Weather .. " weather remotes detected"
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
    else
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "⚠️ No weather remotes detected"
        statusLabel.TextColor3 = Color3.new(1, 1, 0)
        statusLabel.TextSize = 11
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = featuresContainer
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

-- ===== LEFT MENU BUTTONS =====
local function createMenuButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    btn.ZIndex = 2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    end)
    
    return btn
end

-- Create menu buttons
createMenuButton("⚡ Fishing", showFishing)
createMenuButton("📍 Teleport", showTeleport)
createMenuButton("🎣 Bait", showBait)
createMenuButton("🪝 Rod", showRod)
createMenuButton("🌦️ Weather", showWeather)

-- Show fishing menu by default
showFishing()

local totalRemotes = #DetectedRemotes.Fishing + #DetectedRemotes.Bait + #DetectedRemotes.Rod + #DetectedRemotes.Weather + #DetectedRemotes.Sell
notify("Moe V1.0 - Dark Zepyhr", "Loaded! " .. totalRemotes .. " remotes detected")