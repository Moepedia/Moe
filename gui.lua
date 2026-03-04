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
    if autoFishToggle then
        autoFishToggle.Text = "ON"
        autoFishToggle.BackgroundColor3 = Color3.new(0, 0.6, 0)
    end
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
    if autoFishToggle then
        autoFishToggle.Text = "OFF"
        autoFishToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
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

-- ===== FLOATING LOGO (FIXED) =====
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

-- Rounded corners for floating logo
local floatFrameCorner = Instance.new("UICorner")
floatFrameCorner.CornerRadius = UDim.new(0, 25)
floatFrameCorner.Parent = floatingLogo

-- Border for floating logo
local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.5
floatStroke.Parent = floatingLogo

-- Logo image
local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, -10, 1, -10)
floatLogoImg.Position = UDim2.new(0, 5, 0, 5)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

-- Button to restore
local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo
floatButton.ZIndex = 1001

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
contentArea.Active = true
contentArea.Selectable = true

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
contentTitle.ZIndex = 5

-- Scrolling frame for features - FIXED: No AutomaticSize.Y
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
-- REMOVED: scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarImageColor3 = Color3.new(0.5, 0.5, 0.5)
scrollFrame.Parent = contentArea
scrollFrame.ZIndex = 5
scrollFrame.Active = true
scrollFrame.Selectable = true
scrollFrame.ClipsDescendants = true -- This is fine, but dropdowns will be positioned outside

-- Features container - NO AutomaticSize.Y, we'll manually size it
local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.ZIndex = 5
featuresContainer.Active = true
-- REMOVED: featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- Update canvas size when layout changes
local function updateCanvasSize()
    local contentHeight = featuresLayout.AbsoluteContentSize.Y
    featuresContainer.Size = UDim2.new(1, 0, 0, contentHeight)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 10)
end

featuresLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
-- Initial update
task.wait(0.1)
updateCanvasSize()

-- ===== GLOBAL VARIABLES FOR DROPDOWNS =====
local activeDropdown = nil
local dropdownConnections = {}

-- Function to close all dropdowns
local function closeAllDropdowns()
    if activeDropdown then
        activeDropdown.Visible = false
        activeDropdown = nil
    end
end

-- Function to setup input tracking for dropdowns - FIXED: Better click detection
local function setupInputTracking()
    -- Use UserInputService for better click detection
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Small delay to let the click event propagate
            task.wait(0.05)
            
            if not activeDropdown then return end
            
            -- Get mouse position
            local mousePos = UserInputService:GetMouseLocation()
            
            -- Check if click is inside any part of the dropdown system
            local clickedOnDropdown = false
            
            -- Find the parent dropdown frame (the container)
            local dropdownParent = activeDropdown.Parent
            if dropdownParent and dropdownParent:IsA("Frame") then
                -- Check main dropdown button
                local absPos, absSize = dropdownParent.AbsolutePosition, dropdownParent.AbsoluteSize
                local buttonRect = Rect.new(absPos, absPos + absSize)
                
                if buttonRect:Contains(mousePos) then
                    clickedOnDropdown = true
                end
                
                -- Check dropdown options
                if activeDropdown and activeDropdown.Visible then
                    absPos, absSize = activeDropdown.AbsolutePosition, activeDropdown.AbsoluteSize
                    local dropdownRect = Rect.new(absPos, absPos + absSize)
                    
                    if dropdownRect:Contains(mousePos) then
                        clickedOnDropdown = true
                    end
                end
            end
            
            -- If not clicked on dropdown, close it
            if not clickedOnDropdown then
                closeAllDropdowns()
            end
        end
    end)
end

-- Setup input tracking
setupInputTracking()

-- ===== UI ELEMENTS FUNCTIONS =====
local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 10
    frame.Active = true
    frame.Selectable = true
    frame.ClipsDescendants = false -- FIXED: Important! Allow dropdown to overflow
    
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
    btn.ZIndex = 11
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = false
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 11
    
    -- FIXED: Dropdown frame - Positioned absolutely, not relative to parent with clipping
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 1, 0) -- Position right below the button
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame -- Parent to frame, not to scrolling frame
    dropdownFrame.ZIndex = 100 -- High z-index to appear above everything
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    dropdownFrame.ClipsDescendants = false -- FIXED: Don't clip the content
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    dropdownFrame.Active = true
    dropdownFrame.Selectable = true
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.FillDirection = Enum.FillDirection.Vertical
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.Parent = dropdownFrame
    
    -- Function to populate dropdown
    local function updateDropdown(newOptions)
        -- Clear existing options
        for _, child in pairs(dropdownFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Add new options
        for i, opt in ipairs(newOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            optBtn.BackgroundTransparency = 0
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.TextSize = 13
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = dropdownFrame
            optBtn.ZIndex = 101
            optBtn.BorderSizePixel = 0
            optBtn.Active = true
            optBtn.Selectable = true
            optBtn.AutoButtonColor = false
            
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
                if callback then
                    callback(opt)
                end
            end)
        end
    end
    
    -- Initial population
    updateDropdown(options)
    
    -- Toggle dropdown on button click
    btn.MouseButton1Click:Connect(function()
        if dropdownFrame.Visible then
            dropdownFrame.Visible = false
            activeDropdown = nil
        else
            -- Close any other open dropdown
            closeAllDropdowns()
            
            -- Show this dropdown
            dropdownFrame.Visible = true
            activeDropdown = dropdownFrame
            
            -- FIXED: Ensure dropdown stays within screen bounds
            task.wait(0.1) -- Wait for layout to update
            
            local absPos = dropdownFrame.AbsolutePosition
            local absSize = dropdownFrame.AbsoluteSize
            local viewportSize = workspace.CurrentCamera.ViewportSize
            
            -- Check if dropdown goes off screen at bottom
            if absPos.Y + absSize.Y > viewportSize.Y - 20 then
                -- Position above instead
                dropdownFrame.Position = UDim2.new(0, 0, 0, -absSize.Y)
            else
                dropdownFrame.Position = UDim2.new(0, 0, 1, 0)
            end
        end
    end)
    
    return frame
end

-- ===== CREATE FISHING FEATURES =====
-- Auto Fishing Toggle
local autoFishFrame = Instance.new("Frame")
autoFishFrame.Size = UDim2.new(1, 0, 0, 35)
autoFishFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
autoFishFrame.BackgroundTransparency = 0.2
autoFishFrame.Parent = featuresContainer
autoFishFrame.ZIndex = 5

local autoFishCorner = Instance.new("UICorner")
autoFishCorner.CornerRadius = UDim.new(0, 6)
autoFishCorner.Parent = autoFishFrame

local autoFishLabel = Instance.new("TextLabel")
autoFishLabel.Size = UDim2.new(0.7, -5, 1, 0)
autoFishLabel.Position = UDim2.new(0, 8, 0, 0)
autoFishLabel.BackgroundTransparency = 1
autoFishLabel.Text = "Auto Fishing"
autoFishLabel.TextColor3 = Color3.new(1, 1, 1)
autoFishLabel.TextSize = 13
autoFishLabel.Font = Enum.Font.Gotham
autoFishLabel.TextXAlignment = Enum.TextXAlignment.Left
autoFishLabel.Parent = autoFishFrame
autoFishLabel.ZIndex = 5

local autoFishToggle = Instance.new("TextButton")
autoFishToggle.Size = UDim2.new(0, 50, 0, 25)
autoFishToggle.Position = UDim2.new(1, -55, 0.5, -12.5)
autoFishToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
autoFishToggle.Text = "OFF"
autoFishToggle.TextColor3 = Color3.new(1, 1, 1)
autoFishToggle.TextSize = 12
autoFishToggle.Font = Enum.Font.GothamBold
autoFishToggle.Parent = autoFishFrame
autoFishToggle.ZIndex = 6

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = autoFishToggle

autoFishToggle.MouseButton1Click:Connect(function()
    if autoFishing then
        stopAutoFishing()
    else
        startAutoFishing()
    end
end)

-- Teleport Dropdown
local teleportDropdown = createDropdown(featuresContainer, TeleportLocations, "Select Location", function(selected)
    local cframe = LOCATIONS[selected]
    if cframe and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cframe
        notify("Teleport", "Teleported to " .. selected, 2)
    end
end)

-- Update canvas size after adding elements
updateCanvasSize()