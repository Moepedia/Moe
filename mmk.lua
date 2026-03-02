-- ====================================================================
--                 MOE FISHER - SIMPLE EDITION (PASTI MUNCUL)
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                     GUI SETUP (SIMPLE, PASTI WORK)
-- ====================================================================
if CoreGui:FindFirstChild("MoeFisher") then
    CoreGui.MoeFisher:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "MoeFisher"
GUI.Parent = CoreGui
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999

-- ====================================================================
--                     FLOATING CIRCLE (PAKE LOGO)
-- ====================================================================
local FloatingCircle = Instance.new("ImageButton")
FloatingCircle.Size = UDim2.new(0, 60, 0, 60)
FloatingCircle.Position = UDim2.new(0, 100, 0, 100)
FloatingCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FloatingCircle.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
FloatingCircle.ScaleType = Enum.ScaleType.Fit
FloatingCircle.BorderSizePixel = 0
FloatingCircle.Visible = false
FloatingCircle.Parent = GUI

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = FloatingCircle

-- Drag untuk circle
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

-- ====================================================================
--                     MAIN WINDOW (SIMPLE)
-- ====================================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0, 50, 0, 50)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
Header.BorderSizePixel = 0
Header.Parent = Main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = Header

-- Logo di header
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 30, 0, 30)
HeaderLogo.Position = UDim2.new(0, 10, 0.5, -15)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "https://raw.githubusercontent.com/Moepedia/Moe/refs/heads/master/logo.png"
HeaderLogo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Moe"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(250, 166, 26)
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Minimize function
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingCircle.Visible = true
end)

FloatingCircle.MouseButton1Click:Connect(function()
    Main.Visible = true
    FloatingCircle.Visible = false
end)

-- ====================================================================
--                     CONTENT (PASTI MUNCUL)
-- ====================================================================
local yPos = 10
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Fungsi toggle sederhana (PASTI WORK)
local function addToggle(text, y, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = Content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(1, -50, 0.5, -12.5)
    btn.BackgroundColor3 = default and Color3.fromRGB(67, 181, 129) or Color3.fromRGB(240, 71, 71)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(67, 181, 129) or Color3.fromRGB(240, 71, 71)
        btn.Text = state and "ON" or "OFF"
        print("[Toggle]", text, state and "ON" or "OFF")
    end)
end

-- Fungsi button sederhana
local function addButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        print("[Button]", text)
    end)
end

-- SECTION 1: FISHING
local fishingTitle = Instance.new("TextLabel")
fishingTitle.Size = UDim2.new(1, 0, 0, 25)
fishingTitle.Position = UDim2.new(0, 0, 0, yPos)
fishingTitle.BackgroundTransparency = 1
fishingTitle.Text = "⚡ FISHING"
fishingTitle.TextColor3 = Color3.fromRGB(88, 101, 242)
fishingTitle.Font = Enum.Font.GothamBold
fishingTitle.TextSize = 16
fishingTitle.TextXAlignment = Enum.TextXAlignment.Left
fishingTitle.Parent = Content

yPos = yPos + 30
addToggle("Instant Fishing", yPos, false)
yPos = yPos + 40
addToggle("Blatant Mode", yPos, false)
yPos = yPos + 40
addToggle("Auto Equip Rod", yPos, true)
yPos = yPos + 50

-- SECTION 2: AUTO SELL
local sellTitle = Instance.new("TextLabel")
sellTitle.Size = UDim2.new(1, 0, 0, 25)
sellTitle.Position = UDim2.new(0, 0, 0, yPos)
sellTitle.BackgroundTransparency = 1
sellTitle.Text = "💰 AUTO SELL"
sellTitle.TextColor3 = Color3.fromRGB(67, 181, 129)
sellTitle.Font = Enum.Font.GothamBold
sellTitle.TextSize = 16
sellTitle.TextXAlignment = Enum.TextXAlignment.Left
sellTitle.Parent = Content

yPos = yPos + 30
addToggle("Auto Sell", yPos, false)
yPos = yPos + 40

-- SECTION 3: AUTO FAVORITE
local favTitle = Instance.new("TextLabel")
favTitle.Size = UDim2.new(1, 0, 0, 25)
favTitle.Position = UDim2.new(0, 0, 0, yPos)
favTitle.BackgroundTransparency = 1
favTitle.Text = "⭐ AUTO FAVORITE"
favTitle.TextColor3 = Color3.fromRGB(250, 166, 26)
favTitle.Font = Enum.Font.GothamBold
favTitle.TextSize = 16
favTitle.TextXAlignment = Enum.TextXAlignment.Left
favTitle.Parent = Content

yPos = yPos + 30
addToggle("Auto Favorite", yPos, false)
yPos = yPos + 40

-- SECTION 4: TELEPORT
local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, 0, 0, 25)
tpTitle.Position = UDim2.new(0, 0, 0, yPos)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "🌍 TELEPORT"
tpTitle.TextColor3 = Color3.fromRGB(88, 101, 242)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 16
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.Parent = Content

yPos = yPos + 30
addButton("👤 Teleport to Player", yPos, Color3.fromRGB(88, 101, 242))
yPos = yPos + 40
addButton("📍 TP to Location", yPos, Color3.fromRGB(67, 181, 129))
yPos = yPos + 40
addButton("💾 Save Position", yPos, Color3.fromRGB(250, 166, 26))

print("✅ Moe Fisher Simple - PASTI MUNCUL!")
