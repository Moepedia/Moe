-- ====================================================================
--     ROD EQUIPMENT FIXER - DELTA HP EDITION
-- ====================================================================
-- Fokus: Memaksa rod untuk bisa dipegang
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI sederhana
local CoreGui = game:GetService("CoreGui")

pcall(function() CoreGui:FindFirstChild("RodFixer"):Destroy() end)

local gui = Instance.new("ScreenGui")
gui.Name = "RodFixer"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
title.Text = "🎣 ROD EQUIPMENT FIXER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.MouseButton1Click:Connect(function() gui:Destroy() end)
close.Parent = title

-- ====================================================================
--                     SCAN ALL TOOLS
-- ====================================================================
local function scanAllTools()
    local tools = {}
    
    -- Scan Backpack
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(tools, {
                name = tool.Name,
                instance = tool,
                location = "Backpack"
            })
        end
    end
    
    -- Scan Character
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, {
                    name = tool.Name,
                    instance = tool,
                    location = "Character"
                })
            end
        end
    end
    
    return tools
end

-- ====================================================================
--                     FIND FISHING ROD
-- ====================================================================
local function findFishingRod()
    local allTools = scanAllTools()
    local rods = {}
    
    for _, tool in ipairs(allTools) do
        -- Cari yang namanya mengandung kata rod/fishing
        if tool.name:lower():match("rod") or 
           tool.name:lower():match("fishing") or 
           tool.name:lower():match("pancing") or
           tool.name:lower():match("pole") then
            table.insert(rods, tool)
        end
    end
    
    return rods
end

-- ====================================================================
--                     FORCE EQUIP ROD
-- ====================================================================
local function forceEquipRod(rod)
    if not rod then return false end
    
    print("🔧 Mencoba equip: " .. rod.name)
    
    -- Method 1: Pindahkan ke Character
    local success = pcall(function()
        if rod.location == "Backpack" then
            rod.instance.Parent = LocalPlayer.Character
            print("✅ Method 1: Dipindah ke Character")
            return true
        end
    end)
    
    if success and rod.instance.Parent == LocalPlayer.Character then
        return true
    end
    
    -- Method 2: Paksa pakai Humanoid
    success = pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(rod.instance)
            print("✅ Method 2: Equip via Humanoid")
            return true
        end
    end)
    
    if success then return true end
    
    -- Method 3: Panggil remote equip (kalau ada)
    success = pcall(function()
        -- Cari remote equip
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:match("Equip") or obj.Name:match("Tool")) then
                obj:FireServer(rod.instance)
                print("✅ Method 3: Via remote " .. obj.Name)
                return true
            end
        end
    end)
    
    return false
end

-- ====================================================================
--                     UI ELEMENTS
-- ====================================================================
local yPos = 40

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, yPos)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Mencari rod..."
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame
yPos = yPos + 30

-- List rod
local rodList = Instance.new("ScrollingFrame")
rodList.Size = UDim2.new(1, -20, 0, 80)
rodList.Position = UDim2.new(0, 10, 0, yPos)
rodList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
rodList.BorderSizePixel = 0
rodList.CanvasSize = UDim2.new(0, 0, 0, 0)
rodList.Parent = frame
yPos = yPos + 85

-- Tombol scan ulang
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.45, 0, 0, 30)
scanBtn.Position = UDim2.new(0.05, 0, 0, yPos)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
scanBtn.Text = "🔄 SCAN ULANG"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = frame

-- Tombol equip paksa
local forceBtn = Instance.new("TextButton")
forceBtn.Size = UDim2.new(0.45, 0, 0, 30)
forceBtn.Position = UDim2.new(0.5, 5, 0, yPos)
forceBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
forceBtn.Text = "⚡ EQUIP PAKSA"
forceBtn.TextColor3 = Color3.new(1, 1, 1)
forceBtn.Font = Enum.Font.GothamBold
forceBtn.Parent = frame
yPos = yPos + 35

-- Info tambahan
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 40)
infoLabel.Position = UDim2.new(0, 10, 0, yPos)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Pilih rod di atas, lalu klik EQUIP PAKSA"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.TextWrapped = true
infoLabel.Parent = frame

-- ====================================================================
--                     FUNGSI UPDATE LIST
-- ====================================================================
local selectedRod = nil
local rodButtons = {}

local function updateRodList()
    -- Clear list
    for _, btn in ipairs(rodButtons) do
        btn:Destroy()
    end
    rodButtons = {}
    
    local rods = findFishingRod()
    
    if #rods == 0 then
        statusLabel.Text = "Status: ❌ TIDAK ADA ROD DITEMUKAN!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Tampilkan semua tools yang ada
        local allTools = scanAllTools()
        local toolNames = {}
        for _, tool in ipairs(allTools) do
            table.insert(toolNames, tool.name)
        end
        
        if #toolNames > 0 then
            infoLabel.Text = "Tools ditemukan: " .. table.concat(toolNames, ", ")
        else
            infoLabel.Text = "Tidak ada tools sama sekali di inventory!"
        end
        return
    end
    
    statusLabel.Text = string.format("Status: ✅ %d rod ditemukan", #rods)
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- Buat tombol untuk setiap rod
    for i, rod in ipairs(rods) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.Position = UDim2.new(0, 5, 0, (i-1) * 27)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.Text = string.format("%s (%s)", rod.name, rod.location)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = rodList
        
        btn.MouseButton1Click:Connect(function()
            -- Reset semua button
            for _, b in ipairs(rodButtons) do
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end
            -- Highlight yang dipilih
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            selectedRod = rod
            infoLabel.Text = "Dipilih: " .. rod.name .. " - Klik EQUIP PAKSA"
        end)
        
        table.insert(rodButtons, btn)
    end
    
    rodList.CanvasSize = UDim2.new(0, 0, 0, #rods * 27)
end

-- ====================================================================
--                     TOMBOL FUNCTIONS
-- ====================================================================
scanBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Scanning..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    updateRodList()
end)

forceBtn.MouseButton1Click:Connect(function()
    if not selectedRod then
        infoLabel.Text = "❌ Pilih rod dulu dari list di atas!"
        return
    end
    
    statusLabel.Text = "Status: ⚡ Memaksa equip " .. selectedRod.name
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local success = forceEquipRod(selectedRod)
    
    if success then
        statusLabel.Text = "Status: ✅ ROD TER-EQUIP!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        infoLabel.Text = "✅ Sukses! Rod sekarang di tangan"
        
        -- Cek apakah benar-benar kepegang
        task.wait(1)
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == selectedRod.name then
                    infoLabel.Text = "✅ TERKONFIRMASI: " .. tool.Name .. " ada di tangan"
                    break
                end
            end
        end
    else
        statusLabel.Text = "Status: ❌ GAGAL equip"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        infoLabel.Text = "❌ Semua metode equip gagal. " ..
                        "Coba klik SCAN ULANG dan pilih rod lain"
    end
end)

-- ====================================================================
--                     AUTO EQUIP PERTAMA KALI
-- ====================================================================
-- Coba equip otomatis rod pertama yang ditemukan
task.spawn(function()
    task.wait(1)
    updateRodList()
    
    task.wait(0.5)
    local rods = findFishingRod()
    if #rods > 0 then
        selectedRod = rods[1]
        infoLabel.Text = "Mencoba equip otomatis: " .. rods[1].name
        forceEquipRod(rods[1])
    end
end)

print([[
╔════════════════════════════════════════╗
║         ROD EQUIPMENT FIXER            ║
║           Untuk Delta HP               ║
╚════════════════════════════════════════╝

LANGKAH:
1. Lihat daftar rod di window
2. Klik nama rod yang ingin dipegang
3. Klik EQUIP PAKSA
4. Kalau berhasil, rod pindah ke tangan
]])
