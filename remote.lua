-- SIMPLE EQUIP ROD GUI - FIXED VERSION
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "EquipRodGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- ===== AUTO FIND EQUIP REMOTE =====
local EquipRemote = nil

-- Cari semua RemoteEvent yang mungkin untuk equip
print("🔍 Mencari remote equip...")
for _, obj in ipairs(Net:GetChildren()) do
    if obj:IsA("RemoteEvent") then
        local name = obj.Name
        print("  RE: " .. name)
        
        -- Cek apakah ini remote equip (berdasarkan pola nama)
        if name:match("Equip") or name:match("equip") then
            if not EquipRemote then
                EquipRemote = obj
                print("✅ Equip remote terpilih: " .. name)
            end
        end
    end
end

-- Kalau tidak ketemu, coba remote function
if not EquipRemote then
    for _, obj in ipairs(Net:GetChildren()) do
        if obj:IsA("RemoteFunction") and (obj.Name:match("Equip") or obj.Name:match("equip")) then
            EquipRemote = obj
            print("✅ Equip remote (RF) terpilih: " .. obj.Name)
            break
        end
    end
end

-- ===== FUNGSI EQUIP ROD =====
local function equipRod(rodTool)
    if not EquipRemote then
        return false, "Tidak ada remote equip ditemukan"
    end
    
    local isFunction = EquipRemote:IsA("RemoteFunction")
    print("Menggunakan remote: " .. EquipRemote.Name .. " (" .. (isFunction and "RF" or "RE") .. ")")
    
    -- Coba berbagai cara equip
    local methods = {
        {rodTool},                          -- Kirim rod object
        {rodTool.Name},                      -- Kirim nama rod
        {1},                                 -- Slot 1 aja
        {rodTool, 1},                         -- Rod + slot 1
        {1, rodTool},                         -- Slot 1 + rod
    }
    
    for i, args in ipairs(methods) do
        local success
        if isFunction then
            success = pcall(function()
                EquipRemote:InvokeServer(unpack(args))
            end)
        else
            success = pcall(function()
                EquipRemote:FireServer(unpack(args))
            end)
        end
        
        print("Method " .. i .. ": " .. (success and "✅" or "❌"))
        
        if success then
            task.wait(0.3)
            -- Cek apakah rod pindah ke tangan
            if player.Character then
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == rodTool.Name then
                        return true, "Method " .. i .. " berhasil"
                    end
                end
            end
        end
    end
    
    -- Fallback: manual equip
    rodTool.Parent = player.Character
    task.wait(0.2)
    
    if rodTool.Parent == player.Character then
        return true, "Manual equip berhasil"
    end
    
    return false, "Semua metode gagal"
end

-- ===== GUI SEDERHANA =====
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.5
stroke.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎣 EQUIP ROD"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -40)
content.Position = UDim2.new(0, 10, 0, 35)
content.BackgroundTransparency = 1
content.Parent = frame

-- Remote info
local remoteLabel = Instance.new("TextLabel")
remoteLabel.Size = UDim2.new(1, 0, 0, 30)
remoteLabel.Position = UDim2.new(0, 0, 0, 0)
remoteLabel.BackgroundTransparency = 1
remoteLabel.Text = "Remote: " .. (EquipRemote and EquipRemote.Name or "Tidak ditemukan")
remoteLabel.TextColor3 = EquipRemote and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
remoteLabel.Font = Enum.Font.Gotham
remoteLabel.TextSize = 11
remoteLabel.TextWrapped = true
remoteLabel.Parent = content

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.new(0, 1, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = content

-- Rod list
local listBox = Instance.new("TextLabel")
listBox.Size = UDim2.new(1, 0, 0, 80)
listBox.Position = UDim2.new(0, 0, 0, 70)
listBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
listBox.Text = "Scanning for rods..."
listBox.TextColor3 = Color3.new(1, 1, 1)
listBox.Font = Enum.Font.Gotham
listBox.TextSize = 11
listBox.TextWrapped = true
listBox.TextXAlignment = Enum.TextXAlignment.Left
listBox.TextYAlignment = Enum.TextYAlignment.Top
listBox.Parent = content

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 4)
listCorner.Parent = listBox

-- Buttons
local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0.45, 0, 0, 35)
equipBtn.Position = UDim2.new(0, 0, 0, 160)
equipBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
equipBtn.Text = "EQUIP"
equipBtn.TextColor3 = Color3.new(1, 1, 1)
equipBtn.Font = Enum.Font.GothamBold
equipBtn.TextSize = 12
equipBtn.Parent = content

local equipCorner = Instance.new("UICorner")
equipCorner.CornerRadius = UDim.new(0, 4)
equipCorner.Parent = equipBtn

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.45, 0, 0, 35)
refreshBtn.Position = UDim2.new(0.55, 0, 0, 160)
refreshBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
refreshBtn.Text = "REFRESH"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 12
refreshBtn.Parent = content

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 4)
refreshCorner.Parent = refreshBtn

-- ===== FUNGSI SCAN ROD =====
local rods = {}
local selectedRod = nil

local function scanRods()
    rods = {}
    local rodNames = {}
    
    -- Scan backpack
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():match("rod") then
            table.insert(rods, tool)
            table.insert(rodNames, "📦 " .. tool.Name)
        end
    end
    
    -- Scan character
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                table.insert(rods, tool)
                table.insert(rodNames, "🎣 " .. tool.Name .. " (Equipped)")
            end
        end
    end
    
    if #rods == 0 then
        listBox.Text = "❌ No fishing rods found!"
        equipBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        equipBtn.Text = "NO ROD"
        selectedRod = nil
    else
        local text = "🎣 Rods found:\n"
        for i, name in ipairs(rodNames) do
            text = text .. i .. ". " .. name .. "\n"
        end
        listBox.Text = text
        selectedRod = rods[1]
        equipBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
        equipBtn.Text = "EQUIP #1"
    end
end

-- Panggil scan pertama
scanRods()

-- Refresh button
refreshBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Scanning..."
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    scanRods()
    statusLabel.Text = "Scan complete"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
end)

-- Equip button
equipBtn.MouseButton1Click:Connect(function()
    if not selectedRod then
        statusLabel.Text = "❌ No rod selected"
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
        return
    end
    
    statusLabel.Text = "Equipping " .. selectedRod.Name .. "..."
    statusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local success, msg = equipRod(selectedRod)
    
    if success then
        statusLabel.Text = "✅ " .. msg
        statusLabel.TextColor3 = Color3.new(0, 1, 0)
        scanRods()  -- Refresh list
    else
        statusLabel.Text = "❌ " .. msg
        statusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Drag functionality
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Simple Equip GUI Loaded")
