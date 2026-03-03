-- Moe V1.0 GUI for FISH IT - Dengan Fungsi dari Auto Fish V4.0
-- Desain menu kiri seperti sebelumnya, fungsi fishing dari script yang bekerja

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
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ===== ANTI-AFK =====
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
    BlatantMode = false,
    AutoCatch = false,
    AutoSell = false,
    AutoFavorite = false,
    FishDelay = 0.9,
    CatchDelay = 0.2,
    SellDelay = 30
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

-- ===== NETWORK EVENTS (DARI AUTO FISH V4.0) =====
local net = ReplicatedStorage:FindFirstChild("Packages") 
    and ReplicatedStorage.Packages:FindFirstChild("_Index")
    and ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
    and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local Events = {}

if net then
    Events = {
        fishing = net:FindFirstChild("RE/FishingCompleted"),
        sell = net:FindFirstChild("RF/SellAllItems"),
        charge = net:FindFirstChild("RF/ChargeFishingRod"),
        minigame = net:FindFirstChild("RF/RequestFishingMinigameStarted"),
        cancel = net:FindFirstChild("RF/CancelFishingInputs"),
        equip = net:FindFirstChild("RE/EquipToolFromHotbar"),
        unequip = net:FindFirstChild("RE/UnequipToolFromHotbar"),
        favorite = net:FindFirstChild("RE/FavoriteItem")
    }
else
    -- Fallback ke pencarian manual
    Events = {
        fishing = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("FishingCompleted"),
        sell = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("SellAllItems"),
        charge = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("ChargeFishingRod"),
        minigame = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("RequestFishingMinigameStarted"),
        equip = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("EquipToolFromHotbar"),
        unequip = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("UnequipToolFromHotbar"),
        favorite = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("FavoriteItem")
    }
end

-- ===== STATUS FISHING =====
local isFishing = false
local fishingActive = false

-- ===== FUNGSI FISHING DARI AUTO FISH V4.0 =====
local function castRod()
    protectedCall(function()
        if Events.equip then
            Events.equip:FireServer(1)
        end
        task.wait(0.05)
        if Events.charge then
            Events.charge:InvokeServer(1755848498.4834)
        end
        task.wait(0.02)
        if Events.minigame then
            Events.minigame:InvokeServer(1.2854545116425, 1)
        end
        print("[Fishing] 🎣 Cast")
    end)
end

local function reelIn()
    protectedCall(function()
        if Events.fishing then
            Events.fishing:FireServer()
            print("[Fishing] ✅ Reel")
        end
    end)
end

-- BLATANT MODE (dari Auto Fish V4.0)
local function blatantFishingLoop()
    while fishingActive and Settings.BlatantMode do
        if not isFishing then
            isFishing = true
            
            -- Step 1: Rapid fire casts
            protectedCall(function()
                if Events.equip then
                    Events.equip:FireServer(1)
                end
                task.wait(0.01)
                
                -- Cast 1
                task.spawn(function()
                    if Events.charge then
                        Events.charge:InvokeServer(1755848498.4834)
                    end
                    task.wait(0.01)
                    if Events.minigame then
                        Events.minigame:InvokeServer(1.2854545116425, 1)
                    end
                end)
                
                task.wait(0.05)
                
                -- Cast 2 (overlapping)
                task.spawn(function()
                    if Events.charge then
                        Events.charge:InvokeServer(1755848498.4834)
                    end
                    task.wait(0.01)
                    if Events.minigame then
                        Events.minigame:InvokeServer(1.2854545116425, 1)
                    end
                end)
            end)
            
            -- Step 2: Wait for fish
            task.wait(Settings.FishDelay)
            
            -- Step 3: Spam reel 5x
            for i = 1, 5 do
                protectedCall(function() 
                    if Events.fishing then
                        Events.fishing:FireServer()
                    end
                end)
                task.wait(0.01)
            end
            
            -- Step 4: Short cooldown
            task.wait(Settings.CatchDelay * 0.5)
            
            isFishing = false
            print("[Blatant] ⚡ Fast cycle")
        else
            task.wait(0.01)
        end
    end
end

-- NORMAL MODE
local function normalFishingLoop()
    while fishingActive and not Settings.BlatantMode do
        if not isFishing then
            isFishing = true
            
            castRod()
            task.wait(Settings.FishDelay)
            reelIn()
            task.wait(Settings.CatchDelay)
            
            isFishing = false
        else
            task.wait(0.1)
        end
    end
end

-- Main fishing controller
local function fishingLoop()
    while fishingActive do
        if Settings.BlatantMode then
            blatantFishingLoop()
        else
            normalFishingLoop()
        end
        task.wait(0.1)
    end
end

-- Auto Catch spam
task.spawn(function()
    while true do
        if Settings.AutoCatch and not isFishing and Events.fishing then
            protectedCall(function() 
                Events.fishing:FireServer()
            end)
        end
        task.wait(Settings.CatchDelay)
    end
end)

-- ===== AUTO SELL =====
local function sellAllItems()
    print("╔═══════════════════════════════════╗")
    print("[Auto Sell] 💰 Selling all items...")
    
    protectedCall(function()
        if Events.sell then
            if Events.sell:IsA("RemoteFunction") then
                Events.sell:InvokeServer()
            else
                Events.sell:FireServer()
            end
            print("[Auto Sell] ✅ SOLD!")
        end
    end)
    
    print("╚═══════════════════════════════════╝")
end

task.spawn(function()
    while true do
        task.wait(Settings.SellDelay)
        if Settings.AutoSell then
            sellAllItems()
        end
    end
end)

-- ===== AUTO FAVORITE =====
local favoritedItems = {}

local function autoFavorite()
    if not Settings.AutoFavorite or not Events.favorite then return end
    
    protectedCall(function()
        -- Cari inventory player
        local playerData = ReplicatedStorage:FindFirstChild("PlayerData")
        if playerData and playerData:FindFirstChild(LocalPlayer.Name) then
            local inventory = playerData[LocalPlayer.Name]:FindFirstChild("Inventory")
            if inventory then
                for _, item in pairs(inventory:GetChildren()) do
                    if item:IsA("Folder") and not favoritedItems[item.Name] then
                        Events.favorite:FireServer(item.Name)
                        favoritedItems[item.Name] = true
                        print("[Auto Favorite] ⭐ Favorited item")
                        task.wait(0.3)
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        autoFavorite()
    end
end)

-- ===== MAIN FRAME (DESAIN SEPERTI SEBELUMNYA) =====
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

-- LEFT MENU (desain seperti sebelumnya)
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

-- ===== FUNGSI CLEAR CONTAINER =====
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
    
    createToggle(featuresContainer, "🤖 Auto Fish", Settings.AutoFish, function(state)
        Settings.AutoFish = state
        fishingActive = state
        if state then
            notify("Fishing", "Auto Fish Started")
            task.spawn(fishingLoop)
        else
            notify("Fishing", "Auto Fish Stopped")
            if Events.unequip then
                Events.unequip:FireServer()
            end
        end
    end)
    
    createToggle(featuresContainer, "⚡ Blatant Mode", Settings.BlatantMode, function(state)
        Settings.BlatantMode = state
        notify("Fishing", "Blatant Mode "..(state and "ON - 3x Faster!" or "OFF"))
    end)
    
    createToggle(featuresContainer, "🎯 Auto Catch", Settings.AutoCatch, function(state)
        Settings.AutoCatch = state
        notify("Fishing", "Auto Catch "..(state and "ON" or "OFF"))
    end)
    
    createInput(featuresContainer, "Fish Delay (s)", Settings.FishDelay, function(val)
        Settings.FishDelay = val
    end)
    
    createInput(featuresContainer, "Catch Delay (s)", Settings.CatchDelay, function(val)
        Settings.CatchDelay = val
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
        sellAllItems()
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
        autoFavorite()
        notify("Favorite", "Favoriting items...")
    end)
end

-- Shop Menu
local function showShop()
    clearContainer()
    contentTitle.Text = "🛒 SHOP FEATURES"
    
    createButton(featuresContainer, "🎣 Buy Bait (10x)", function()
        local purchaseBait = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("PurchaseBait")
        if purchaseBait then
            if purchaseBait:IsA("RemoteFunction") then
                purchaseBait:InvokeServer(10)
            else
                purchaseBait:FireServer(10)
            end
            notify("Shop", "Bought 10 Bait")
        else
            notify("Shop", "Purchase remote not found")
        end
    end)
    
    createButton(featuresContainer, "🎣 Buy Fishing Rod", function()
        local purchaseRod = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("PurchaseFishingRod")
        if purchaseRod then
            if purchaseRod:IsA("RemoteFunction") then
                purchaseRod:InvokeServer()
            else
                purchaseRod:FireServer()
            end
            notify("Shop", "Bought Fishing Rod")
        else
            notify("Shop", "Purchase remote not found")
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
        local weatherCmd = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("WeatherCommand")
        if weatherCmd then
            weatherCmd:FireServer(selected)
            notify("Weather", "Weather changed to "..selected)
        else
            local lighting = game:GetService("Lighting")
            if selected == "Clear" then
                lighting.ClockTime = 12
                lighting.Brightness = 1
            elseif selected == "Rain" then
                lighting.ClockTime = 14
                lighting.Brightness = 0.7
            elseif selected == "Storm" then
                lighting.ClockTime = 18
                lighting.Brightness = 0.4
            elseif selected == "Fog" then
                lighting.FogEnd = 50
            end
            notify("Weather", "Weather changed to "..selected.." (local)")
        end
    end)
    
    createSeparator(featuresContainer, "WEATHER SLOTS")
    
    local purchaseWeather = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("PurchaseWeatherEvent")
    
    if purchaseWeather then
        createDropdown(featuresContainer, "Slot 1", weathers, "Clear", function(selected)
            purchaseWeather:FireServer(1, selected)
            notify("Weather", "Slot 1 set to "..selected)
        end)
        
        createDropdown(featuresContainer, "Slot 2", weathers, "Rain", function(selected)
            purchaseWeather:FireServer(2, selected)
            notify("Weather", "Slot 2 set to "..selected)
        end)
        
        createDropdown(featuresContainer, "Slot 3", weathers, "Storm", function(selected)
            purchaseWeather:FireServer(3, selected)
            notify("Weather", "Slot 3 set to "..selected)
        end)
    else
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 40)
        label.BackgroundTransparency = 1
        label.Text = "Weather slots tidak tersedia"
        label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.Parent = featuresContainer
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

print("=== MOE V1.0 LOADED ===")
print("✅ Fishing: Auto Fish, Blatant Mode, Auto Catch")
print("✅ Favorite: Auto Favorite")
print("✅ Shop: Buy Bait, Buy Rod")
print("✅ Teleport: 14 Locations + Players")
print("✅ Weather: Change + 3 Slots")