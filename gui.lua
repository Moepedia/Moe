-- Moe V1.0 GUI for FISH IT - SAFE VERSION
-- Versi aman, tidak agresif, anti-cheat friendly

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ===== ANTI-AFK (AMAN) =====
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ===== DATA LOKASI TELEPORT =====
local TeleportLocations = {
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
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693)
}

-- ===== SETTINGS =====
local Settings = {
    AutoFish = false,
    AutoSell = false,
    AutoFavorite = false,
    FishDelay = 2.5,  -- Lebih lambat biar aman
    SellDelay = 45,
    BlatantMode = false  -- Nonaktifkan blatant mode karena berbahaya
}

-- ===== FUNGSI UTILITY =====
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
        warn("[Error] " .. tostring(result))
    end
    return result
end

-- ===== REMOTE EVENTS (PENCARIAN AMAN) =====
local function findRemote(name)
    -- Cari di ReplicatedStorage
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then return remote end
    
    -- Cari di folder RE
    local reFolder = ReplicatedStorage:FindFirstChild("RE")
    if reFolder then
        remote = reFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    -- Cari di folder RF
    local rfFolder = ReplicatedStorage:FindFirstChild("RF")
    if rfFolder then
        remote = rfFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    return nil
end

local Remote = {
    StartFishing = findRemote("StartFishing") or findRemote("RF/StartFishing"),
    CatchFish = findRemote("CatchFishCompleted") or findRemote("RF/CatchFishCompleted"),
    FishingMinigame = findRemote("FishingMinigameChanged") or findRemote("RE/FishingMinigameChanged"),
    SellAll = findRemote("SellAllItems") or findRemote("RF/SellAllItems"),
    Favorite = findRemote("FavoriteItem") or findRemote("RE/FavoriteItem"),
    PurchaseBait = findRemote("PurchaseBait") or findRemote("RF/PurchaseBait"),
    PurchaseRod = findRemote("PurchaseFishingRod") or findRemote("RF/PurchaseFishingRod"),
    WeatherCommand = findRemote("WeatherCommand") or findRemote("RE/WeatherCommand"),
    PurchaseWeather = findRemote("PurchaseWeatherEvent") or findRemote("RF/PurchaseWeatherEvent")
}

-- ===== AUTO FISHING (VERSI LEMBUT, ANTI-DETEKSI) =====
local fishingActive = false
local lastAction = 0

local function safeCast()
    if Remote.StartFishing then
        Remote.StartFishing:FireServer()
        print("[Fishing] 🎣 Cast")
    end
end

local function safeCatch()
    if Remote.CatchFish then
        Remote.CatchFish:FireServer()
        print("[Fishing] ✅ Catch")
    end
end

-- Loop fishing dengan delay acak biar tidak seperti bot
spawn(function()
    while true do
        if Settings.AutoFish then
            local now = tick()
            if now - lastAction >= Settings.FishDelay then
                protectedCall(function()
                    -- Variasi acar kecil biar tidak terdeteksi
                    local variation = math.random(80, 120) / 100
                    
                    safeCast()
                    task.wait(0.1 * variation)
                    
                    if Remote.FishingMinigame then
                        Remote.FishingMinigame:FireServer(true)
                    end
                    
                    task.wait(0.2 * variation)
                    safeCatch()
                    
                    lastAction = now
                end)
            end
        end
        task.wait(0.5)
    end
end)

-- ===== AUTO SELL (VERSI LEMBUT) =====
local function safeSell()
    if Remote.SellAll then
        if Remote.SellAll:IsA("RemoteFunction") then
            Remote.SellAll:InvokeServer()
        else
            Remote.SellAll:FireServer()
        end
        print("[Sell] 💰 Sold items")
    end
end

spawn(function()
    while true do
        task.wait(Settings.SellDelay)
        if Settings.AutoSell then
            protectedCall(safeSell)
        end
    end
end)

-- ===== AUTO FAVORITE (VERSI LEMBUT) =====
spawn(function()
    while true do
        task.wait(15)
        if Settings.AutoFavorite and Remote.Favorite then
            protectedCall(function()
                Remote.Favorite:FireServer()
                print("[Favorite] ⭐ Auto favorite")
            end)
        end
    end
end)

-- ===== UI DESIGN (TETAP SAMA) =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 850, 0, 550)
mainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

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
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

-- Logo
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 40, 0, 40)
logoFrame.Position = UDim2.new(0, 15, 0.5, -20)
logoFrame.BackgroundTransparency = 1
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

-- Title
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

-- Minimize
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -70, 0.5, -15)
minButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextScaled = true
minButton.Font = Enum.Font.GothamBold
minButton.AutoButtonColor = false
minButton.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minButton

-- Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
closeButton.BackgroundTransparency = 0.3
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
floatingLogo.Size = UDim2.new(0, 60, 0, 60)
floatingLogo.Position = UDim2.new(0.9, -30, 0.9, -30)
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
floatLogoCorner.CornerRadius = UDim.new(0, 30)
floatLogoCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1.5
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.2
floatStroke.Parent = floatingLogo

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

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 50)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- Content container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 55)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- LEFT MENU
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 140, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 150, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -160, 1, 0)
contentArea.Position = UDim2.new(0, 160, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentArea

-- Content title
local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -20, 0, 30)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Pilih menu"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextScaled = true
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.ScrollBarImageTransparency = 0.5
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

-- Features container
local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.Padding = UDim.new(0, 12)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENTS =====
local function createToggle(parent, title, getValue, setValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
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
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(0.8, 0, 0.5, -12.5)
    btn.BackgroundColor3 = getValue and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.3, 0.3, 0.3)
    btn.BackgroundTransparency = 0.2
    btn.Text = getValue and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local newState = not getValue
        setValue(newState)
        btn.BackgroundColor3 = newState and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.3, 0.3, 0.3)
        btn.Text = newState and "ON" or "OFF"
    end)
end

local function createInput(parent, title, getValue, setValue)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
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
    inputFrame.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputFrame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 1, 0)
    box.Position = UDim2.new(0, 5, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = tostring(getValue)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = inputFrame
    
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text) or getValue
        box.Text = tostring(val)
        setValue(val)
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
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
end

local function createSeparator(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BackgroundTransparency = 0.5
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

local function createDropdown(parent, title, options, current, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundTransparency = 1
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
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, 25)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = current
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, #options * 32 + 4)
    dropdown.Position = UDim2.new(0, 0, 0, 62)
    dropdown.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    dropdown.BackgroundTransparency = 0.1
    dropdown.Visible = false
    dropdown.Parent = frame
    dropdown.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdown
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  "..opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.AutoButtonColor = false
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
            if callback then callback(opt) end
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
end

-- ===== CLEAR CONTAINER =====
local function clearContainer()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearContainer()
    contentTitle.Text = "⚓ FISHING FEATURES"
    
    createToggle(featuresContainer, "🎣 Auto Fish", Settings.AutoFish, function(state)
        Settings.AutoFish = state
        notify("Fishing", "Auto Fish "..(state and "ON" or "OFF"))
    end)
    
    createInput(featuresContainer, "Fish Delay (s)", Settings.FishDelay, function(val)
        Settings.FishDelay = val
    end)
    
    createSeparator(featuresContainer, "AUTO SELL")
    
    createToggle(featuresContainer, "💰 Auto Sell", Settings.AutoSell, function(state)
        Settings.AutoSell = state
        notify("Fishing", "Auto Sell "..(state and "ON" or "OFF"))
    end)
    
    createInput(featuresContainer, "Sell Delay (s)", Settings.SellDelay, function(val)
        Settings.SellDelay = val
    end)
    
    createButton(featuresContainer, "💰 SELL NOW", function()
        safeSell()
        notify("Fishing", "Sold all items!")
    end)
end

-- Favorite Menu
local function showFavorite()
    clearContainer()
    contentTitle.Text = "⭐ FAVORITE FEATURES"
    
    createToggle(featuresContainer, "⭐ Auto Favorite", Settings.AutoFavorite, function(state)
        Settings.AutoFavorite = state
        notify("Favorite", "Auto Favorite "..(state and "ON" or "OFF"))
    end)
    
    createButton(featuresContainer, "⭐ Favorite Now", function()
        if Remote.Favorite then
            Remote.Favorite:FireServer()
            notify("Favorite", "Favorited item")
        end
    end)
end

-- Shop Menu
local function showShop()
    clearContainer()
    contentTitle.Text = "🛒 SHOP FEATURES"
    
    createButton(featuresContainer, "🎣 Buy Bait (10x)", function()
        if Remote.PurchaseBait then
            if Remote.PurchaseBait:IsA("RemoteFunction") then
                Remote.PurchaseBait:InvokeServer(10)
            else
                Remote.PurchaseBait:FireServer(10)
            end
            notify("Shop", "Bought 10 Bait")
        end
    end)
    
    createButton(featuresContainer, "🎣 Buy Fishing Rod", function()
        if Remote.PurchaseRod then
            if Remote.PurchaseRod:IsA("RemoteFunction") then
                Remote.PurchaseRod:InvokeServer()
            else
                Remote.PurchaseRod:FireServer()
            end
            notify("Shop", "Bought Fishing Rod")
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearContainer()
    contentTitle.Text = "🌍 TELEPORT FEATURES"
    
    local locations = {}
    for name, _ in pairs(TeleportLocations) do
        table.insert(locations, name)
    end
    table.sort(locations)
    
    createDropdown(featuresContainer, "📍 Teleport to", locations, "Spawn", function(selected)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = TeleportLocations[selected]
            notify("Teleport", "Teleported to "..selected)
        end
    end)
    
    local players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(players, p.Name)
        end
    end
    table.sort(players)
    
    if #players > 0 then
        createDropdown(featuresContainer, "👤 Teleport to Player", players, players[1], function(selected)
            local target = Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to "..selected)
                end
            end
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
end

-- Weather Menu
local function showWeather()
    clearContainer()
    contentTitle.Text = "☁️ WEATHER FEATURES"
    
    local weathers = {"Clear", "Rain", "Storm", "Fog"}
    
    createDropdown(featuresContainer, "☀️ Change Weather", weathers, "Clear", function(selected)
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer(selected)
            notify("Weather", "Weather changed to "..selected)
        end
    end)
    
    if Remote.PurchaseWeather then
        createSeparator(featuresContainer, "WEATHER SLOTS")
        
        createDropdown(featuresContainer, "Slot 1", weathers, "Clear", function(selected)
            Remote.PurchaseWeather:FireServer(1, selected)
            notify("Weather", "Slot 1 set to "..selected)
        end)
        
        createDropdown(featuresContainer, "Slot 2", weathers, "Rain", function(selected)
            Remote.PurchaseWeather:FireServer(2, selected)
            notify("Weather", "Slot 2 set to "..selected)
        end)
        
        createDropdown(featuresContainer, "Slot 3", weathers, "Storm", function(selected)
            Remote.PurchaseWeather:FireServer(3, selected)
            notify("Weather", "Slot 3 set to "..selected)
        end)
    end
end

-- ===== MENU BUTTONS =====
local menuButtons = {}
local currentMenu = ""

local function createMenuButton(name, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 45)
    btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    btn.BackgroundTransparency = 0.3
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
        if currentMenu ~= name then btn.BackgroundTransparency = 0.1 end
    end)
    btn.MouseLeave:Connect(function()
        if currentMenu ~= name then btn.BackgroundTransparency = 0.3 end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(menuButtons) do
            b.BackgroundTransparency = 0.3
            b.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        end
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        currentMenu = name
        func()
    end)
    
    table.insert(menuButtons, btn)
end

-- Create menu buttons
createMenuButton("⚓ Fishing", showFishing)
createMenuButton("⭐ Favorite", showFavorite)
createMenuButton("🛒 Shop", showShop)
createMenuButton("🌍 Teleport", showTeleport)
createMenuButton("☁️ Weather", showWeather)

-- Auto-show Fishing menu
task.wait(0.5)
for _,btn in pairs(leftMenu:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "⚓ Fishing" then
        btn.MouseButton1Click:Fire()
        break
    end
end

-- Drag functionality
local dragging, dragInput, dragStart, startPos = false

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

print("=== MOE V1.0 SAFE VERSION LOADED ===")
print("✅ Versi aman, anti-cheat friendly")
print("⚠️ Jangan gunakan blatant mode atau speed terlalu tinggi")