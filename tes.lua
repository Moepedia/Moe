-- ====================================================================
--                 MOE FISHER - FIXED FOR DELTA
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")  -- ✅ FORMAT YANG BENER
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                     REMOTE FISHING
-- ====================================================================
local Events = {}

local success, Net = pcall(function()
    return require(ReplicatedStorage.Packages.Net)
end)

if success and Net then
    pcall(function() Events.fishing = Net:RemoteFunction("RF/CatchFishCompleted") end)
    pcall(function() Events.charge = Net:RemoteFunction("RF/ChargeFishingRod") end)
    pcall(function() Events.minigame = Net:RemoteFunction("RF/RequestFishingMinigameStarted") end)
    pcall(function() Events.equip = Net:RemoteEvent("RE/EquipToolFromHotbar") end)
    pcall(function() Events.unequip = Net:RemoteEvent("RE/UnequipToolFromHotbar") end)
    pcall(function() Events.favorite = Net:RemoteEvent("RE/FavoriteItem") end)
    pcall(function() Events.sell = Net:RemoteFunction("RF/SellAllItems") end)
    
    print("✅ Remote fishing: RF/CatchFishCompleted, RF/ChargeFishingRod")
else
    warn("⚠️ Net module not found")
    Events = {
        fishing = {InvokeServer = function() end},
        charge = {InvokeServer = function() end},
        minigame = {InvokeServer = function() end},
        equip = {FireServer = function() end},
        sell = {InvokeServer = function() end},
    }
end

-- ====================================================================
--                     GUI SETUP (COPY PASTE DARI REMOTE FINDER)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui  -- PAKE CoreGui yang udah di-define di atas
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (copy styling dari Remote Finder)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 500)
Main.Position = UDim2.new(0.5, -190, 0.5, -250)  -- Tengah
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  -- Dark theme
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "🎣 MOE FISHER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- Tombol Minimize (ke floating circle)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Main

-- Floating Circle (logo)
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 55, 0, 55)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

-- Bikin lingkaran
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

-- Minimize function
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- Drag untuk floating circle
local circleDragging = false
local circleDragStart
local circleStartPos

FloatingCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = true
        circleDragStart = input.Position
        circleStartPos = FloatingCircle.Position
    end
end)

FloatingCircle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        circleDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if circleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - circleDragStart
        FloatingCircle.Position = UDim2.new(circleStartPos.X.Scale, circleStartPos.X.Offset + delta.X, circleStartPos.Y.Scale, circleStartPos.Y.Offset + delta.Y)
    end
end)

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ====================================================================
--                     FITUR-FITUR (SEDERHANA DULU)
-- ====================================================================
local yPos = 5

-- Fungsi toggle
local function createToggle(parent, text, yPos, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -50, 0.5, -12.5)
    btn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    return {frame = frame, btn = btn, state = default}
end

-- SECTION 1: FISHING
local fishTitle = Instance.new("TextLabel")
fishTitle.Size = UDim2.new(1, 0, 0, 25)
fishTitle.Position = UDim2.new(0, 0, 0, yPos)
fishTitle.BackgroundTransparency = 1
fishTitle.Text = "⚡ FISHING"
fishTitle.TextColor3 = Color3.new(0.3, 0.8, 1)
fishTitle.Font = Enum.Font.GothamBold
fishTitle.TextSize = 16
fishTitle.TextXAlignment = Enum.TextXAlignment.Left
fishTitle.Parent = Content

yPos = yPos + 30

local instantToggle = createToggle(Content, "Instant Fishing", yPos, false)
yPos = yPos + 40

local blatantToggle = createToggle(Content, "Blatant Mode", yPos, false)
yPos = yPos + 40

local equipToggle = createToggle(Content, "Auto Equip Rod", yPos, true)
yPos = yPos + 45

-- SECTION 2: AUTO SELL
local sellTitle = Instance.new("TextLabel")
sellTitle.Size = UDim2.new(1, 0, 0, 25)
sellTitle.Position = UDim2.new(0, 0, 0, yPos)
sellTitle.BackgroundTransparency = 1
sellTitle.Text = "💰 AUTO SELL"
sellTitle.TextColor3 = Color3.new(0.3, 1, 0.3)
sellTitle.Font = Enum.Font.GothamBold
sellTitle.TextSize = 16
sellTitle.TextXAlignment = Enum.TextXAlignment.Left
sellTitle.Parent = Content

yPos = yPos + 30

local sellToggle = createToggle(Content, "Auto Sell", yPos, false)
yPos = yPos + 40

-- SECTION 3: AUTO FAVORITE
local favTitle = Instance.new("TextLabel")
favTitle.Size = UDim2.new(1, 0, 0, 25)
favTitle.Position = UDim2.new(0, 0, 0, yPos)
favTitle.BackgroundTransparency = 1
favTitle.Text = "⭐ AUTO FAVORITE"
favTitle.TextColor3 = Color3.new(1, 0.8, 0.3)
favTitle.Font = Enum.Font.GothamBold
favTitle.TextSize = 16
favTitle.TextXAlignment = Enum.TextXAlignment.Left
favTitle.Parent = Content

yPos = yPos + 30

local favToggle = createToggle(Content, "Auto Favorite", yPos, false)
yPos = yPos + 40

-- SECTION 4: TELEPORT
local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0, 25)
tpTitle.Position = UDim2.new(0, 0, 0, yPos)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "🌍 TELEPORT"
tpTitle.TextColor3 = Color3.new(0.3, 0.8, 1)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 16
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.Parent = Content

yPos = yPos + 30

-- ====================================================================
--                     FISHING LOGIC
-- ====================================================================
local isFishing = false
local fishCount = 0

local function castRod()
    pcall(function()
        if equipToggle.state and Events.equip then
            Events.equip:FireServer(1)
        end
        if Events.charge then
            Events.charge:InvokeServer()
        end
        task.wait(0.2)
        if Events.minigame then
            Events.minigame:InvokeServer(1, 1)
        end
    end)
end

local function reelIn()
    pcall(function()
        if Events.fishing then
            Events.fishing:InvokeServer()
            fishCount = fishCount + 1
            print("🐟 Fish caught! Total: " .. fishCount)
        end
    end)
end

-- Fishing loop
task.spawn(function()
    while true do
        if instantToggle.state and not isFishing then
            isFishing = true
            
            if blatantToggle.state then
                for i = 1, 2 do
                    castRod()
                    task.wait(0.3)
                end
                task.wait(0.5)
                for i = 1, 3 do
                    reelIn()
                    task.wait(0.1)
                end
            else
                castRod()
                task.wait(2)
                reelIn()
            end
            
            task.wait(0.5)
            isFishing = false
        end
        task.wait(0.1)
    end
end)

-- Auto sell
task.spawn(function()
    while true do
        if sellToggle.state and Events.sell then
            pcall(function()
                Events.sell:InvokeServer()
                print("💰 Auto sold items")
            end)
        end
        task.wait(30)
    end
end)

-- Event handlers untuk toggle
instantToggle.btn.MouseButton1Click:Connect(function()
    instantToggle.state = not instantToggle.state
    instantToggle.btn.BackgroundColor3 = instantToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    instantToggle.btn.Text = instantToggle.state and "ON" or "OFF"
end)

blatantToggle.btn.MouseButton1Click:Connect(function()
    blatantToggle.state = not blatantToggle.state
    blatantToggle.btn.BackgroundColor3 = blatantToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    blatantToggle.btn.Text = blatantToggle.state and "ON" or "OFF"
end)

equipToggle.btn.MouseButton1Click:Connect(function()
    equipToggle.state = not equipToggle.state
    equipToggle.btn.BackgroundColor3 = equipToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    equipToggle.btn.Text = equipToggle.state and "ON" or "OFF"
end)

sellToggle.btn.MouseButton1Click:Connect(function()
    sellToggle.state = not sellToggle.state
    sellToggle.btn.BackgroundColor3 = sellToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    sellToggle.btn.Text = sellToggle.state and "ON" or "OFF"
end)

favToggle.btn.MouseButton1Click:Connect(function()
    favToggle.state = not favToggle.state
    favToggle.btn.BackgroundColor3 = favToggle.state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    favToggle.btn.Text = favToggle.state and "ON" or "OFF"
end)

print("✅ Moe Fisher loaded!")
print("📍 GUI di tengah layar - Klik X buat tutup, 🗕 buat minimize")
