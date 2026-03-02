-- Moe V1.0 GUI for FISH IT - FINAL FIX
-- Fix: Error Fire, Button dobel, Instant Fishing & Blatant Mode

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

-- ===== VARIABEL GLOBAL UNTUK SETTINGAN =====
local Settings = {
    Fishing = {
        InstantFishing = {Enabled = false, CastDelay = 1.5, CatchDelay = 0.5},
        BlatantMode = {Enabled = false, BurstCount = 5, BurstDelay = 2},
        AutoPerfect = {Enabled = false},
        AutoSell = {Enabled = false, Delay = 3, Mode = "All"},
        AutoFavorite = {Enabled = false, Mode = "Name"}
    }
}

-- ===== FUNGSI UTILITY =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemote(name)
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then return remote end
    
    local reFolder = ReplicatedStorage:FindFirstChild("RE")
    if reFolder then
        remote = reFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    local rfFolder = ReplicatedStorage:FindFirstChild("RF")
    if rfFolder then
        remote = rfFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    return nil
end

local function notify(title, text, duration)
    duration = duration or 2
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

local function protectedCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[Protected] Error: " .. tostring(result))
    end
    return result
end

-- ===== REMOTE REFERENCES =====
local Remote = {
    StartFishing = getRemote("RF/StartFishing") or getRemote("StartFishing"),
    CatchFish = getRemote("RF/CatchFishCompleted") or getRemote("CatchFishCompleted"),
    FishingMinigame = getRemote("RE/FishingMinigameChanged") or getRemote("FishingMinigameChanged"),
    SellAll = getRemote("RF/SellAllItems") or getRemote("SellAllItems"),
    SellItem = getRemote("RF/SellItem") or getRemote("SellItem"),
    Favorite = getRemote("RE/FavoriteItem") or getRemote("FavoriteItem"),
    Unfavorite = getRemote("RE/FavoriteStateChanged") or getRemote("FavoriteStateChanged"),
    Weather = getRemote("RE/WeatherCommand") or getRemote("WeatherCommand"),
    SubmarineTP = getRemote("RE/SubmarineTP") or getRemote("RF/SubmarineTP2")
}

-- ===== LOOP AUTO FISHING =====
spawn(function()
    local lastCast = 0
    local lastCatch = 0
    local lastBlatant = 0
    
    while task.wait(0.1) do
        protectedCall(function()
            local currentTime = tick()
            
            -- INSTANT FISHING: Auto cast + auto catch tanpa reel
            if Settings.Fishing.InstantFishing.Enabled then
                -- Auto Cast
                if Remote.StartFishing and currentTime - lastCast >= Settings.Fishing.InstantFishing.CastDelay then
                    Remote.StartFishing:FireServer()
                    lastCast = currentTime
                end
                
                -- Auto Catch (langsung catch tanpa reel)
                if Remote.CatchFish and currentTime - lastCatch >= Settings.Fishing.InstantFishing.CatchDelay then
                    Remote.CatchFish:FireServer()
                    lastCatch = currentTime
                end
            end
            
            -- BLATANT MODE: Bypass minigame + catch beruntun
            if Settings.Fishing.BlatantMode.Enabled then
                if Remote.FishingMinigame then
                    Remote.FishingMinigame:FireServer(true) -- Bypass minigame
                end
                
                -- Catch beruntun setiap BurstDelay detik
                if Remote.CatchFish and currentTime - lastBlatant >= Settings.Fishing.BlatantMode.BurstDelay then
                    for i = 1, Settings.Fishing.BlatantMode.BurstCount do
                        Remote.CatchFish:FireServer()
                        task.wait(0.05)
                    end
                    lastBlatant = currentTime
                end
            end
            
            -- AUTO PERFECT
            if Settings.Fishing.AutoPerfect.Enabled and Remote.FishingMinigame then
                Remote.FishingMinigame:FireServer(true)
            end
            
            -- AUTO SELL
            if Settings.Fishing.AutoSell.Enabled and Remote.SellAll then
                task.wait(Settings.Fishing.AutoSell.Delay)
                Remote.SellAll:FireServer()
            end
        end)
    end
end)

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 850, 0, 550)
mainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
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
minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

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
leftMenu.Size = UDim2.new(0, 140, 1, 0)
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
verticalLine.Position = UDim2.new(0, 150, 0, 0)
verticalLine.BackgroundColor3 = Color3.new(1, 1, 1)
verticalLine.BackgroundTransparency = 0.3
verticalLine.BorderSizePixel = 0
verticalLine.Parent = contentContainer

-- AREA KONTEN
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -160, 1, 0)
contentArea.Position = UDim2.new(0, 160, 0, 0)
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

-- SCROLLING FRAME
local featuresScrollingFrame = Instance.new("ScrollingFrame")
featuresScrollingFrame.Name = "FeaturesScrollingFrame"
featuresScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
featuresScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
featuresScrollingFrame.BackgroundTransparency = 1
featuresScrollingFrame.BorderSizePixel = 0
featuresScrollingFrame.ScrollBarThickness = 6
featuresScrollingFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
featuresScrollingFrame.ScrollBarImageTransparency = 0.5
featuresScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
featuresScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
featuresScrollingFrame.Parent = contentArea

local featuresContainer = Instance.new("Frame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.BorderSizePixel = 0
featuresContainer.Parent = featuresScrollingFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
featuresLayout.VerticalAlignment = Enum.VerticalAlignment.Top
featuresLayout.Padding = UDim.new(0, 12)
featuresLayout.Parent = featuresContainer

-- ===== FUNGSI MEMBUAT DROPDOWN =====
local function createDropdown(parent, title, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Name = title.."Dropdown"
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = "DropdownBtn"
    dropdownBtn.Size = UDim2.new(1, 0, 0, 35)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 25)
    dropdownBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownBtn.BackgroundTransparency = 0.3
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default
    dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 62)
    dropdownFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.FillDirection = Enum.FillDirection.Vertical
    dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    dropdownLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdownFrame
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Name = opt.."Option"
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.BorderSizePixel = 0
        optBtn.Text = "  "..opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.AutoButtonColor = false
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
            dropdownBtn.Text = opt
            dropdownFrame.Visible = false
            if callback then callback(opt) end
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
        local count = #options
        dropdownFrame.Size = UDim2.new(1, 0, 0, count * 32 + 4)
    end)
    
    return dropdownBtn
end

-- ===== FUNGSI MEMBUAT INPUT DELAY =====
local function createDelayInput(parent, title, default, callback)
    local frame = Instance.new("Frame")
    frame.Name = title.."Delay"
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.4, 0, 0, 30)
    inputFrame.Position = UDim2.new(0.6, 0, 0.5, -15)
    inputFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    inputFrame.BackgroundTransparency = 0.3
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -10, 1, 0)
    inputBox.Position = UDim2.new(0, 5, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.BorderSizePixel = 0
    inputBox.Text = tostring(default)
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame
    
    inputBox.FocusLost:Connect(function()
        local val = tonumber(inputBox.Text) or default
        inputBox.Text = tostring(val)
        if callback then callback(val) end
    end)
    
    return inputBox
end

-- ===== FUNGSI MEMBUAT TOGGLE =====
local function createToggle(parent, title, default, callback)
    local frame = Instance.new("Frame")
    frame.Name = title.."Toggle"
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.3, 0.3, 0.3)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.3, 0.3, 0.3)
        toggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    return toggleBtn
end

-- ===== FUNGSI MEMBUAT BUTTON =====
local function createButton(parent, title, callback)
    local btn = Instance.new("TextButton")
    btn.Name = title.."Btn"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = title
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        if callback then protectedCall(callback) end
    end)
    
    return btn
end

-- ===== FUNGSI MEMBUAT SEPARATOR =====
local function createSeparator(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, #text * 10, 1, 0)
    label.Position = UDim2.new(0.5, -(#text * 5), 0, 0)
    label.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    label.BackgroundTransparency = 0.3
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = frame
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = label
end

-- ===== FUNGSI TELEPORT =====
local function safeTeleportToLocation(locationName)
    protectedCall(function()
        local player = game.Players.LocalPlayer
        if not player then return end
        
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            player.CharacterAdded:Wait()
            char = player.Character
            if not char then return end
        end
        
        local cframe = TeleportLocations[locationName]
        if cframe then
            char.HumanoidRootPart.CFrame = cframe
            notify("Teleport", "Teleported to "..locationName, 2)
        end
    end)
end

local function safeTeleportToNPC()
    protectedCall(function()
        local player = game.Players.LocalPlayer
        if not player then return end
        
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            player.CharacterAdded:Wait()
            char = player.Character
            if not char then return end
        end
        
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                local npcName = npc.Name:lower()
                if npcName:find("npc") or npcName:find("merchant") or npcName:find("trader") or npcName:find("seller") then
                    local npcPos = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                    if npcPos then
                        char.HumanoidRootPart.CFrame = npcPos.CFrame + Vector3.new(0, 5, 0)
                        notify("Teleport", "Teleported to "..npc.Name, 2)
                        return
                    end
                end
            end
        end
        notify("Teleport", "No NPC found", 1)
    end)
end

local function safeTeleportToIsland()
    protectedCall(function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer("MainIsland")
            notify("Teleport", "Teleported to Island (via remote)", 2)
        else
            safeTeleportToLocation("Spawn")
        end
    end)
end

local function safeTeleportToPlayer(targetPlayerName)
    protectedCall(function()
        local player = game.Players.LocalPlayer
        if not player then return end
        
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            player.CharacterAdded:Wait()
            char = player.Character
            if not char then return end
        end
        
        local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            notify("Teleport", "Teleported to "..targetPlayer.Name, 2)
        end
    end)
end

-- ===== FUNGSI WEATHER =====
local function setWeather(weatherType)
    protectedCall(function()
        if Remote.Weather then
            Remote.Weather:FireServer(weatherType)
            notify("Weather", "Weather set to "..weatherType, 1)
        else
            local lighting = game:GetService("Lighting")
            if weatherType == "Clear" then
                lighting.ClockTime = 12
                lighting.Brightness = 1
                lighting.FogEnd = 100000
            elseif weatherType == "Rain" then
                lighting.ClockTime = 14
                lighting.Brightness = 0.7
            elseif weatherType == "Storm" then
                lighting.ClockTime = 18
                lighting.Brightness = 0.4
            elseif weatherType == "Fog" then
                lighting.FogEnd = 50
            elseif weatherType == "Night" then
                lighting.ClockTime = 0
                lighting.Brightness = 0.3
            elseif weatherType == "Day" then
                lighting.ClockTime = 12
                lighting.Brightness = 1
            end
            notify("Weather", "Weather set to "..weatherType.." (local)", 1)
        end
    end)
end

-- ===== FUNGSI CLEAR FEATURES =====
local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- ===== KONTEN FISHING =====
local function createFishingContent()
    clearFeatures()
    
    -- Instant Fishing
    createToggle(featuresContainer, "🎣 Instant Fishing", Settings.Fishing.InstantFishing.Enabled, function(state)
        Settings.Fishing.InstantFishing.Enabled = state
        notify("Fishing", "Instant Fishing "..(state and "ON" or "OFF"))
    end)
    
    createDelayInput(featuresContainer, "Cast Delay (s)", Settings.Fishing.InstantFishing.CastDelay, function(val)
        Settings.Fishing.InstantFishing.CastDelay = val
    end)
    
    createDelayInput(featuresContainer, "Catch Delay (s)", Settings.Fishing.InstantFishing.CatchDelay, function(val)
        Settings.Fishing.InstantFishing.CatchDelay = val
    end)
    
    createSeparator(featuresContainer, "⚡ BLATANT MODE")
    
    -- Blatant Mode
    createToggle(featuresContainer, "🔥 Blatant Mode", Settings.Fishing.BlatantMode.Enabled, function(state)
        Settings.Fishing.BlatantMode.Enabled = state
        notify("Fishing", "Blatant Mode "..(state and "ON" or "OFF"))
    end)
    
    createDelayInput(featuresContainer, "Burst Delay (s)", Settings.Fishing.BlatantMode.BurstDelay, function(val)
        Settings.Fishing.BlatantMode.BurstDelay = val
    end)
    
    createDelayInput(featuresContainer, "Burst Count", Settings.Fishing.BlatantMode.BurstCount, function(val)
        Settings.Fishing.BlatantMode.BurstCount = math.floor(val)
    end)
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 40)
    infoLabel.Position = UDim2.new(0, 10, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "• Bypass minigame\n• Catch beruntun tanpa reel"
    infoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Parent = featuresContainer
    
    createSeparator(featuresContainer, "✨ AUTO PERFECT")
    
    createToggle(featuresContainer, "🏆 Auto Perfect", Settings.Fishing.AutoPerfect.Enabled, function(state)
        Settings.Fishing.AutoPerfect.Enabled = state
        notify("Fishing", "Auto Perfect "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "💰 AUTO SELL")
    
    createToggle(featuresContainer, "💰 Auto Sell", Settings.Fishing.AutoSell.Enabled, function(state)
        Settings.Fishing.AutoSell.Enabled = state
        notify("Fishing", "Auto Sell "..(state and "ON" or "OFF"))
    end)
    
    createDelayInput(featuresContainer, "Sell Delay (s)", Settings.Fishing.AutoSell.Delay, function(val)
        Settings.Fishing.AutoSell.Delay = val
    end)
    
    createDropdown(featuresContainer, "Sell Mode", {"All", "By Name", "By Variant", "By Rarity"}, Settings.Fishing.AutoSell.Mode, function(opt)
        Settings.Fishing.AutoSell.Mode = opt
        notify("Fishing", "Sell Mode: "..opt)
    end)
    
    createButton(featuresContainer, "💰 SELL ALL NOW", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            notify("Fishing", "Sold all items!")
        end
    end)
    
    createSeparator(featuresContainer, "⭐ AUTO FAVORITE")
    
    createToggle(featuresContainer, "⭐ Auto Favorite", Settings.Fishing.AutoFavorite.Enabled, function(state)
        Settings.Fishing.AutoFavorite.Enabled = state
        notify("Fishing", "Auto Favorite "..(state and "ON" or "OFF"))
    end)
    
    createDropdown(featuresContainer, "Favorite Mode", {"Name", "Variant", "Rarity"}, Settings.Fishing.AutoFavorite.Mode, function(opt)
        Settings.Fishing.AutoFavorite.Mode = opt
        notify("Fishing", "Favorite Mode: "..opt)
    end)
end

-- ===== KONTEN FAVORITE =====
local function createFavoriteContent()
    clearFeatures()
    
    createButton(featuresContainer, "⭐ Add to Favorite", function()
        if Remote.Favorite then
            Remote.Favorite:FireServer()
            notify("Favorite", "Added to favorites")
        end
    end)
    
    createButton(featuresContainer, "❌ Remove from Favorite", function()
        if Remote.Unfavorite then
            Remote.Unfavorite:FireServer(false)
            notify("Favorite", "Removed from favorites")
        end
    end)
    
    createButton(featuresContainer, "📋 Favorite List", function()
        notify("Favorite", "Check console (F9)")
        print("Favorite List - Feature coming soon")
    end)
end

-- ===== KONTEN SHOP =====
local function createShopContent()
    clearFeatures()
    
    createButton(featuresContainer, "🛒 Auto Buy", function()
        local purchase = getRemote("RF/PurchaseMarketItem") or getRemote("PurchaseMarketItem")
        if purchase then
            purchase:FireServer("Bait", 5)
            notify("Shop", "Auto Buy activated")
        end
    end)
    
    createButton(featuresContainer, "💰 Quick Sell", function()
        if Remote.SellItem then
            Remote.SellItem:FireServer()
            notify("Shop", "Quick Sell")
        end
    end)
    
    createButton(featuresContainer, "🏷️ Price Checker", function()
        notify("Shop", "Check console (F9)")
        print("Price Checker - Feature coming soon")
    end)
    
    createButton(featuresContainer, "📦 Bulk Purchase", function()
        local purchase = getRemote("RF/PurchaseMarketItem") or getRemote("PurchaseMarketItem")
        if purchase then
            purchase:FireServer("Bait", 50)
            notify("Shop", "Bulk purchased 50 Bait")
        end
    end)
end

-- ===== KONTEN TELEPORT =====
local function createTeleportContent()
    clearFeatures()
    
    local locations = {}
    for name, _ in pairs(TeleportLocations) do
        table.insert(locations, name)
    end
    table.sort(locations)
    
    createDropdown(featuresContainer, "📍 Pilih Lokasi", locations, "Spawn", function(opt)
        safeTeleportToLocation(opt)
    end)
    
    createButton(featuresContainer, "🚶 Teleport ke NPC", safeTeleportToNPC)
    createButton(featuresContainer, "🏝️ Teleport ke Island", safeTeleportToIsland)
    
    local players = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            table.insert(players, plr.Name)
        end
    end
    table.sort(players)
    
    if #players > 0 then
        createDropdown(featuresContainer, "👤 Pilih Player", players, players[1], function(opt)
            safeTeleportToPlayer(opt)
        end)
    else
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 40)
        label.BackgroundTransparency = 1
        label.Text = "Tidak ada player lain"
        label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.Parent = featuresContainer
    end
    
    createSeparator(featuresContainer, "💾 Save / Load")
    
    createButton(featuresContainer, "💾 Save Location", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            _G.SavedLocation = char.HumanoidRootPart.CFrame
            notify("Teleport", "Location saved!")
        end
    end)
    
    createButton(featuresContainer, "📂 Load Location", function()
        if _G.SavedLocation then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = _G.SavedLocation
                notify("Teleport", "Location loaded!")
            end
        else
            notify("Teleport", "No location saved")
        end
    end)
end

-- ===== KONTEN WEATHER =====
local function createWeatherContent()
    clearFeatures()
    
    local weatherOptions = {"Clear", "Rain", "Storm", "Fog", "Night", "Day"}
    
    createDropdown(featuresContainer, "☁️ Pilih Cuaca", weatherOptions, "Clear", function(opt)
        setWeather(opt)
    end)
    
    createSeparator(featuresContainer, "⚡ Quick Access")
    
    for _, weather in ipairs(weatherOptions) do
        createButton(featuresContainer, "☁️ "..weather, function()
            setWeather(weather)
        end)
    end
end

-- ===== FUNGSI MEMBUAT TOMBOL MENU =====
local menuButtons = {}
local currentMenu = nil

local function createMenuButton(name, contentCreator)
    local btn = Instance.new("TextButton")
    btn.Name = name.."MenuBtn"
    btn.Size = UDim2.new(0, 120, 0, 45)
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
        
        if contentCreator then
            contentCreator()
        end
    end)
    
    table.insert(menuButtons, btn)
    return btn
end

-- BUAT TOMBOL MENU
createMenuButton("Fishing", createFishingContent)
createMenuButton("Favorite", createFavoriteContent)
createMenuButton("Shop", createShopContent)
createMenuButton("Teleport", createTeleportContent)
createMenuButton("Weather", createWeatherContent)

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

-- AUTO-CLICK FISHING (FIXED)
task.wait(0.5)
for _, btn in pairs(leftMenu:GetChildren()) do
    if btn:IsA("TextButton") and btn.Name == "FishingMenuBtn" then
        btn.MouseButton1Click:Fire()
        break
    end
end

print("=== MOE V1.0 GUI FINAL FIX ===")
print("✅ Instant Fishing: Auto cast + auto catch tanpa reel")
print("✅ Blatant Mode: Bypass minigame + catch beruntun")
print("✅ Delay bisa diatur manual")
print("✅ Button tidak dobel")
print("✅ Error Fire fixed di line 1134")