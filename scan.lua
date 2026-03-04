-- ====================================================================
--     FISHING INVESTIGATOR v3.0 - DELTA HP EDITION
-- ====================================================================
-- Versi sangat sederhana untuk Delta Executor di HP
-- ====================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama kalau ada
pcall(function()
    CoreGui:FindFirstChild("FishingInvestigator"):Destroy()
end)

-- Buat GUI sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingInvestigator"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Fungsi membuat button
local function makeButton(parent, text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 120, 200)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Fungsi membuat label
local function makeLabel(parent, text, posY, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 25)
    lbl.Position = UDim2.new(0.05, 0, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

-- Fungsi membuat text box
local function makeTextBox(parent, placeholder, posY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.Position = UDim2.new(0.05, 0, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Parent = parent
    return box
end

-- Fungsi membuat scrolling frame untuk hasil
local function makeResults(parent, posY, height)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(0.9, 0, 0, height)
    frame.Position = UDim2.new(0.05, 0, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 5
    frame.Parent = parent
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.Parent = frame
    
    return frame
end

-- ====================================================================
--                     MAIN WINDOW
-- ====================================================================

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(0, 350, 0, 500)
bg.Position = UDim2.new(0.5, -175, 0.5, -250)
bg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
bg.BorderSizePixel = 0
bg.Active = true
bg.Draggable = true
bg.Parent = ScreenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = bg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 Fishing Investigator (Delta)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ====================================================================
--                     CONTENT
-- ====================================================================
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -40)
content.Position = UDim2.new(0, 10, 0, 35)
content.BackgroundTransparency = 1
content.Parent = bg

local yPos = 0

-- Status label
local statusLabel = makeLabel(content, "Status: Siap", yPos, Color3.fromRGB(0, 255, 0))
yPos = yPos + 30

-- Hasil investigasi
local resultsFrame = makeResults(content, yPos, 250)
yPos = yPos + 255

-- Tombol-tombol
local btn1 = makeButton(content, "1️⃣ SCAN REMOTES", yPos, Color3.fromRGB(0, 120, 200))
yPos = yPos + 50

local btn2 = makeButton(content, "2️⃣ CAPTURE PACKETS", yPos, Color3.fromRGB(200, 120, 0))
yPos = yPos + 50

local btn3 = makeButton(content, "3️⃣ CHECK ROD", yPos, Color3.fromRGB(0, 150, 100))
yPos = yPos + 50

local btn4 = makeButton(content, "4️⃣ COMPARE OLD", yPos, Color3.fromRGB(150, 0, 150))
yPos = yPos + 50

local btn5 = makeButton(content, "5️⃣ COPY RESULTS", yPos, Color3.fromRGB(200, 0, 0))
yPos = yPos + 50

-- ====================================================================
--                     FUNGSI INVESTIGASI
-- ====================================================================

-- Variabel penyimpanan
local InvestigationResults = {
    Remotes = {},
    Captured = {},
    RodInfo = {}
}

-- Fungsi untuk update hasil di GUI
local function updateResults(lines)
    -- Clear frame
    for _, child in ipairs(resultsFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Tambah lines
    for _, line in ipairs(lines) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 0, 18)
        lbl.BackgroundTransparency = 1
        lbl.Text = line
        lbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = resultsFrame
    end
    
    -- Update canvas size
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #lines * 21)
end

-- 1. SCAN REMOTES
btn1.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Scanning remotes..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local results = {}
    table.insert(results, "📡 FISHING REMOTES:")
    
    local remotes = {}
    local allDescendants = game:GetDescendants()
    
    for _, obj in ipairs(allDescendants) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            local name = obj.Name:lower()
            if name:match("fish") or name:match("rod") or name:match("cast") or 
               name:match("reel") or name:match("sell") or name:match("charge") then
                table.insert(remotes, {
                    Name = obj.Name,
                    Class = obj.ClassName,
                    Path = obj:GetFullName()
                })
                table.insert(results, string.format("%s - %s", obj.Name, obj.ClassName))
            end
        end
    end
    
    InvestigationResults.Remotes = remotes
    table.insert(results, string.format("\nTotal: %d remotes", #remotes))
    
    updateResults(results)
    statusLabel.Text = "Status: Scan selesai!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- 2. CAPTURE PACKETS
btn2.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Capture 10 detik - Fishing manual!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local results = {}
    table.insert(results, "📦 CAPTURING PACKETS...")
    table.insert(results, "Fishing manual selama 10 detik")
    updateResults(results)
    
    local captured = {}
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        local self = args[1]
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self)
            table.insert(captured, string.format("%s - %s", remoteName, method))
        end
        
        return oldNamecall(...)
    end)
    
    -- Tunggu 10 detik
    task.wait(10)
    
    setreadonly(mt, true)
    
    InvestigationResults.Captured = captured
    
    -- Tampilkan hasil
    local results2 = {}
    table.insert(results2, "📊 CAPTURE RESULTS:")
    table.insert(results2, string.format("Total calls: %d", #captured))
    
    if #captured > 0 then
        table.insert(results2, "\nSEQUENCE:")
        for i, call in ipairs(captured) do
            table.insert(results2, string.format("%d. %s", i, call))
            if i >= 20 then
                table.insert(results2, "... dan seterusnya")
                break
            end
        end
    end
    
    updateResults(results2)
    statusLabel.Text = "Status: Capture selesai!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- 3. CHECK ROD
btn3.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Checking rod..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local results = {}
    table.insert(results, "🎣 ROD CHECK:")
    
    local rodInfo = {found = false}
    
    -- Cek di Backpack
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            rodInfo.found = true
            rodInfo.name = tool.Name
            rodInfo.location = "Backpack"
            table.insert(results, "✅ Rod di Backpack: " .. tool.Name)
        end
    end
    
    -- Cek di Character
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                rodInfo.found = true
                rodInfo.name = tool.Name
                rodInfo.location = "Character"
                table.insert(results, "✅ Rod dipegang: " .. tool.Name)
            end
        end
    end
    
    if not rodInfo.found then
        table.insert(results, "❌ TIDAK ADA ROD!")
    end
    
    InvestigationResults.RodInfo = rodInfo
    updateResults(results)
    statusLabel.Text = "Status: Rod check selesai!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- 4. COMPARE OLD
btn4.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Comparing..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local results = {}
    table.insert(results, "🔄 OLD VS NEW:")
    
    local oldRemotes = {
        "FishingCompleted",
        "SellAllItems",
        "ChargeFishingRod",
        "RequestFishingMinigameStarted",
        "CancelFishingInputs",
        "EquipToolFromHotbar",
        "UnequipToolFromHotbar",
        "FavoriteItem"
    }
    
    for _, oldName in ipairs(oldRemotes) do
        local found = false
        for _, remote in ipairs(InvestigationResults.Remotes) do
            if remote.Name == oldName then
                found = true
                table.insert(results, "✅ " .. oldName)
                break
            end
        end
        if not found then
            table.insert(results, "❌ " .. oldName .. " (HILANG)")
            
            -- Cari yang mirip
            for _, remote in ipairs(InvestigationResults.Remotes) do
                if remote.Name:lower():match(oldName:lower():gsub("fishing",""):gsub("rod","")) then
                    table.insert(results, "   🔍 Mungkin: " .. remote.Name)
                    break
                end
            end
        end
    end
    
    updateResults(results)
    statusLabel.Text = "Status: Compare selesai!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- 5. COPY RESULTS
btn5.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Copying results..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local textLines = {}
    table.insert(textLines, "🔍 FISHING INVESTIGATION RESULTS - DELTA HP")
    table.insert(textLines, "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(textLines, string.rep("=", 50))
    
    table.insert(textLines, "\n📡 REMOTES FOUND:")
    for i, r in ipairs(InvestigationResults.Remotes) do
        table.insert(textLines, string.format("%d. %s", i, r.Name))
        if i >= 20 then
            table.insert(textLines, "... dan " .. (#InvestigationResults.Remotes - 20) .. " lainnya")
            break
        end
    end
    
    table.insert(textLines, "\n📦 CAPTURED PACKETS:")
    for i, c in ipairs(InvestigationResults.Captured) do
        table.insert(textLines, string.format("%d. %s", i, c))
        if i >= 15 then
            table.insert(textLines, "... dan " .. (#InvestigationResults.Captured - 15) .. " lainnya")
            break
        end
    end
    
    table.insert(textLines, "\n🎣 ROD INFO:")
    if InvestigationResults.RodInfo.found then
        table.insert(textLines, "Rod: " .. InvestigationResults.RodInfo.name)
        table.insert(textLines, "Location: " .. InvestigationResults.RodInfo.location)
    else
        table.insert(textLines, "No rod found!")
    end
    
    local fullText = table.concat(textLines, "\n")
    
    -- Coba copy dengan berbagai method
    local copied = false
    
    -- Method 1: setclipboard
    pcall(function()
        setclipboard(fullText)
        copied = true
    end)
    
    -- Method 2: toclipboard
    if not copied then
        pcall(function()
            toclipboard(fullText)
            copied = true
        end)
    end
    
    if copied then
        statusLabel.Text = "Status: ✅ Copied to clipboard!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Tampilkan preview
        local preview = {}
        for i = 1, math.min(10, #textLines) do
            table.insert(preview, textLines[i])
        end
        table.insert(preview, "\n...(copied to clipboard)")
        updateResults(preview)
    else
        statusLabel.Text = "Status: ❌ Copy failed - Screenshot manual"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Tampilkan hasil di GUI
        updateResults(textLines)
    end
end)

-- Info awal
local welcome = {}
table.insert(welcome, "🎣 FISHING INVESTIGATOR")
table.insert(welcome, "Untuk Delta Executor HP")
table.insert(welcome, "")
table.insert(welcome, "CARA PAKAI:")
table.insert(welcome, "1. Klik SCAN REMOTES")
table.insert(welcome, "2. Klik CAPTURE PACKETS")
table.insert(welcome, "   lalu fishing manual 10 detik")
table.insert(welcome, "3. Klik CHECK ROD")
table.insert(welcome, "4. Klik COMPARE OLD")
table.insert(welcome, "5. Klik COPY RESULTS")
table.insert(welcome, "")
table.insert(welcome, "Paste hasilnya di sini!")

updateResults(welcome)

print("✅ Fishing Investigator untuk Delta HP siap!")