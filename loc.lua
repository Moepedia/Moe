-- [[ DARK ZEPHYR REMOTE SCANNER v1.0 ]]
-- Scan semua remote di game dan tampilkan dalam GUI yang bisa di-copy

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🔍 REMOTE SCANNER - COPY ALL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.new(1, 0, 0)
close.BackgroundTransparency = 0.3
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 35)
status.BackgroundTransparency = 1
status.Text = "Scanning remotes..."
status.TextColor3 = Color3.new(1, 1, 0)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

-- TextBox untuk hasil scan (bisa copy all)
local textBox = Instance.new("ScrollingFrame")
textBox.Size = UDim2.new(1, -20, 1, -100)
textBox.Position = UDim2.new(0, 10, 0, 65)
textBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
textBox.BorderSizePixel = 0
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = textBox

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Scanning..."
textLabel.TextColor3 = Color3.new(0, 1, 0)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.Font = Enum.Font.Code
textLabel.TextSize = 12
textLabel.RichText = true
textLabel.Parent = textBox
textLabel.AutomaticSize = Enum.AutomaticSize.Y

-- Copy button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 100, 0, 30)
copyBtn.Position = UDim2.new(1, -110, 1, -35)
copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
copyBtn.Text = "📋 COPY ALL"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = frame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 4)
copyCorner.Parent = copyBtn

-- Rescan button
local rescanBtn = Instance.new("TextButton")
rescanBtn.Size = UDim2.new(0, 100, 0, 30)
rescanBtn.Position = UDim2.new(1, -220, 1, -35)
rescanBtn.BackgroundColor3 = Color3.new(1, 0.5, 0)
rescanBtn.Text = "🔄 RESCAN"
rescanBtn.TextColor3 = Color3.new(1, 1, 1)
rescanBtn.Font = Enum.Font.GothamBold
rescanBtn.TextSize = 12
rescanBtn.Parent = frame

local rescanCorner = Instance.new("UICorner")
rescanCorner.CornerRadius = UDim.new(0, 4)
rescanCorner.Parent = rescanBtn

-- Fungsi untuk scan remotes
local function scanRemotes()
    status.Text = "🔍 Scanning... (0 found)"
    textLabel.Text = "Scanning...\n"
    
    local results = {}
    local total = 0
    
    -- Cari di semua kemungkinan lokasi
    local locationsToScan = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        player:WaitForChild("PlayerGui"),
        player:WaitForChild("PlayerScripts"),
        workspace,
    }
    
    -- Tambahkan folder spesifik yang disebut
    local specificFolders = {
        "_Index",
        "FastCastRedux",
        "Icon",
        "LightningBolt",
        "Loader",
        "MarketplaceService",
        "MersenneTwister",
        "Net",
        "NumberSpinner",
        "Observers",
        "Promise",
        "Replion",
        "Signal",
        "Spring",
        "Thread",
        "Timer",
        "Trove",
        "ZonePlus",
        "spr"
    }
    
    -- Fungsi recursive scan
    local function scanFolder(folder, depth)
        if depth > 5 then return end -- Batasi kedalaman
        
        for _, child in pairs(folder:GetChildren()) do
            -- Cek apakah ini remote
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("UnreliableRemoteEvent") then
                total = total + 1
                local path = child:GetFullName()
                table.insert(results, string.format("[%d] %s -> %s", total, child.ClassName, path))
  
