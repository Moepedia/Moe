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

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local fishingConnection = nil
local currentFishingSpot = nil
local bobber = nil

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
    -- Teleport
    SubmarineTP = getRemoteFromPackages("RE", "SubmarineTP"),
    SubmarineTP2 = getRemoteFromPackages("RF", "SubmarineTP2"),
    
    -- Fishing
    Cast = getRemoteFromPackages("RF", "Cast"),
    Reel = getRemoteFromPackages("RF", "Reel"),
    FinishFishing = getRemoteFromPackages("RF", "FinishFishing"),
}

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== KOORDINAT LOKASI =====
local function updateLocationDisplay()
    if locationText then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            locationText.Text = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
        else
            locationText.Text = "X: 0, Y: 0, Z: 0"
        end
    end
end

-- ===== AUTO FISHING FUNCTIONS =====
local function findBobber()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Bobber" and v:IsA("Part") and v:FindFirstChild("Owner") then
            local owner = v:FindFirstChild("Owner")
            if owner and owner.Value == player then
                return v
            end
        end
    end
    return nil
end

local function castLine()
    if Remote.Cast then
        -- Cari spot memancing terdekat
        local fishingSpots = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "FishingSpot" and v:IsA("Part") then
                table.insert(fishingSpots, v)
            end
        end
        
        if #fishingSpots > 0 then
            -- Pilih spot terdekat
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local closest = fishingSpots[1]
                local closestDist = (closest.Position - char.HumanoidRootPart.Position).Magnitude
                
                for _, spot in ipairs(fishingSpots) do
                    local dist = (spot.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist then
                        closest = spot
                        closestDist = dist
                    end
                end
                
                currentFishingSpot = closest
                Remote.Cast:InvokeServer(closest)
                notify("Auto Fishing", "Casting line...", 1)
            end
        end
    end
end

local function reelIn()
    if Remote.Reel then
        Remote.Reel:InvokeServer()
        task.wait(0.5)
        if Remote.FinishFishing then
            Remote.FinishFishing:InvokeServer()
        end
    end
end

local function startAutoFishing()
    if autoFishing then return end
    
    autoFishing = true
    autoFishBtn.Text = "Stop Auto Fishing"
    autoFishBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    notify("Auto Fishing", "Auto fishing started!", 2)
    
    -- Loop auto fishing
    fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not autoFishing then return end
        
        bobber = findBobber()
        
        if bobber then
            -- Cek apakah ada ikan yang menggigit
            local biteProgress = bobber:FindFirstChild("BiteProgress")
            if biteProgress and biteProgress.Value >= 0.95 then
                reelIn()
                task.wait(1)
                castLine()
            end
        else
            -- Tidak ada bobber, cast line
            castLine()
        end
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    if autoFishBtn then
        autoFishBtn.Text = "Start Auto Fishing"
        autoFishBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    end
    notify("Auto Fishing", "Auto fishing stopped!", 2)
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

-- Logo (menggunakan asset ID yang benar)
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

-- Location Display
local locationFrame = Instance.new("Frame")
locationFrame.Size = UDim2.new(0, 200, 0, 25)
locationFrame.Position = UDim2.new(0.5, -100, 0.5, -12.5)
locationFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
locationFrame.BackgroundTransparency = 0.3
locationFrame.Parent = headerFrame

local locationCorner = Instance.new("UICorner")
locationCorner.CornerRadius = UDim.new(0, 6)
locationCorner.Parent = locationFrame

local locationText = Instance.new("TextLabel")
locationText.Size = UDim2.new(1, -10, 1, 0)
locationText.Position = UDim2.new(0, 5, 0, 0)
locationText.BackgroundTransparency = 1
locationText.Text = "X: 0, Y: 0, Z: 0"
locationText.TextColor3 = Color3.new(0, 1, 0)
locationText.TextSize = 12
locationText.Font = Enum.Font.GothamBold
locationText.TextXAlignment = Enum.TextXAlignment.Left
locationText.Parent = locationFrame

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
    stopAutoFishing()
    gui:Destroy()
end)

-- Update location periodically
game:GetService("RunService").RenderStepped:Connect(updateLocationDisplay)

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

-- ===== UI ELEMENTS FUNCTIONS =====
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
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
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
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(0.5, 0.5, 0.5)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(0.5, 0.5, 0.5)
        callback(state)
    end)
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== AUTO FISHING BUTTON REFERENCE =====
local autoFishBtn = nil

-- ===== FISHING MENU =====
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel(featuresContainer, "Auto Fishing Control")
    
    autoFishBtn = createButton(featuresContainer, "Start Auto Fishing", function()
        if autoFishing then
            stopAutoFishing()
        else
            startAutoFishing()
        end
    end)
    
    createLabel(featuresContainer, "Manual Fishing")
    
    createButton(featuresContainer, "Cast Line", function()
        castLine()
    end)
    
    createButton(featuresContainer, "Reel In", function()
        reelIn()
    end)
    
    createLabel(featuresContainer, "Fishing Stats")
    
    -- Stats display
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, 0, 0, 60)
    statsFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statsFrame.BackgroundTransparency = 0.2
    statsFrame.Parent = featuresContainer
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 6)
    statsCorner.Parent = statsFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 20)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statsFrame
    
    local bobberLabel = Instance.new("TextLabel")
    bobberLabel.Size = UDim2.new(1, -10, 0, 20)
    bobberLabel.Position = UDim2.new(0, 5, 0, 25)
    bobberLabel.BackgroundTransparency = 1
    bobberLabel.Text = "Bobber: Not found"
    bobberLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    bobberLabel.TextSize = 11
    bobberLabel.Font = Enum.Font.Gotham
    bobberLabel.TextXAlignment = Enum.TextXAlignment.Left
    bobberLabel.Parent = statsFrame
    
    -- Update stats
    game:GetService("RunService").Heartbeat:Connect(function()
        if not featuresContainer.Parent then return end
        
        if autoFishing then
            statusLabel.Text = "Status: Auto Fishing Active"
            statusLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            statusLabel.Text = "Status: Manual Mode"
            statusLabel.TextColor3 = Color3.new(1, 1, 0)
        end
        
        bobber = findBobber()
        if bobber then
            bobberLabel.Text = "Bobber: Found"
            bobberLabel.TextColor3 = Color3.new(0, 1, 0)
        else
            bobberLabel.Text = "Bobber: Not found"
            bobberLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
end

-- ===== TELEPORT MENU =====
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "Teleport to Location")
    
    local selectedLoc = TeleportLocations[1]
    
    createDropdown(featuresContainer, TeleportLocations, TeleportLocations[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT NOW", function()
        local cframe = LOCATIONS[selectedLoc]
        if cframe then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cframe
                notify("Teleport", "Teleported to " .. selectedLoc)
            end
        end
    end)
    
    createButton(featuresContainer, "TELEPORT (SUBMARINE)", function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer(selectedLoc)
            notify("Teleport", "Teleported to " .. selectedLoc .. " via submarine")
        elseif Remote.SubmarineTP2 then
            Remote.SubmarineTP2:InvokeServer(selectedLoc)
            notify("Teleport", "Teleported to " .. selectedLoc .. " via submarine")
        else
            -- Fallback to normal teleport
            local cframe = LOCATIONS[selectedLoc]
            if cframe then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = cframe
                    notify("Teleport", "Teleported to " .. selectedLoc)
                end
            end
        end
    end)
    
    createLabel(featuresContainer, "Location Coordinates")
    
    for loc, cframe in pairs(LOCATIONS) do
        local locFrame = Instance.new("Frame")
        locFrame.Size = UDim2.new(1, 0, 0, 45)
        locFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        locFrame.BackgroundTransparency = 0.2
        locFrame.Parent = featuresContainer
        
        local locCorner = Instance.new("UICorner")
        locCorner.CornerRadius = UDim.new(0, 6)
        locCorner.Parent = locFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -10, 0, 20)
        nameLabel.Position = UDim2.new(0, 5, 0, 3)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = loc
        nameLabel.TextColor3 = Color3.new(1, 1, 0)
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = locFrame
        
        local coordLabel = Instance.new("TextLabel")
        coordLabel.Size = UDim2.new(1, -10, 0, 18)
        coordLabel.Position = UDim2.new(0, 5, 0, 23)
        coordLabel.BackgroundTransparency = 1
        coordLabel.Text = string.format("X: %.1f, Y: %.1f, Z: %.1f", cframe.Position.X, cframe.Position.Y, cframe.Position.Z)
        coordLabel.TextColor3 = Color3.new(0, 1, 0)
        coordLabel.TextSize = 10
        coordLabel.Font = Enum.Font.Gotham
        coordLabel.TextXAlignment = Enum.TextXAlignment.Left
        coordLabel.Parent = locFrame
    end
    
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

-- ===== CREATE LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Teleport", func = showTeleport}
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

-- Cleanup on gui destroy
gui.Destroying:Connect(function()
    stopAutoFishing()
end)

print("Moe V1.0 GUI Loaded with Auto Fishing and Location Coordinates")
notify("Moe V1.0", "GUI Loaded Successfully!", 3)