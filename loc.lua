-- [[ DARK ZEPHYR REMOTE SCANNER v2.0 - NO CLIPBOARD ]]
-- Scan semua remote dan tampilkan dalam GUI dengan fitur select all

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 700, 0, 500)
frame.Position = UDim2.new(0.5, -350, 0.5, -250)
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
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🔍 DARK ZEPHYR REMOTE SCANNER"
title.TextColor3 = Color3.new(1, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 2.5)
close.BackgroundColor3 = Color3.new(1, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = title

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Status bar
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 40)
status.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
status.BackgroundTransparency = 0.5
status.Text = "🔍 Scanning remotes..."
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = status

-- TextBox untuk hasil scan (bisa di-select semua)
local textBox = Instance.new("ScrollingFrame")
textBox.Size = UDim2.new(1, -20, 1, -120)
textBox.Position = UDim2.new(0, 10, 0, 70)
textBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
textBox.BorderSizePixel = 0
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = textBox

-- TextLabel untuk menampilkan hasil (bisa select text)
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -10, 0, 0)
textLabel.Position = UDim2.new(0, 5, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Starting scan..."
textLabel.TextColor3 = Color3.new(0, 1, 0)
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.Font = Enum.Font.Code
textLabel.TextSize = 12
textLabel.RichText = true
textLabel.Parent = textBox
textLabel.AutomaticSize = Enum.AutomaticSize.Y
textLabel.TextSelectable = true -- Bisa di-select

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 35)
buttonFrame.Position = UDim2.new(0, 10, 1, -40)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = frame

-- Select All button
local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(0, 120, 0, 30)
selectBtn.Position = UDim2.new(0, 0, 0, 2.5)
selectBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
selectBtn.Text = "📋 SELECT ALL"
selectBtn.TextColor3 = Color3.new(1, 1, 1)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 12
selectBtn.Parent = buttonFrame

local selectCorner = Instance.new("UICorner")
selectCorner.CornerRadius = UDim.new(0, 4)
selectCorner.Parent = selectBtn

-- Rescan button
local rescanBtn = Instance.new("TextButton")
rescanBtn.Size = UDim2.new(0, 100, 0, 30)
rescanBtn.Position = UDim2.new(0, 130, 0, 2.5)
rescanBtn.BackgroundColor3 = Color3.new(1, 0.5, 0)
rescanBtn.Text = "🔄 RESCAN"
rescanBtn.TextColor3 = Color3.new(1, 1, 1)
rescanBtn.Font = Enum.Font.GothamBold
rescanBtn.TextSize = 12
rescanBtn.Parent = buttonFrame

local rescanCorner = Instance.new("UICorner")
rescanCorner.CornerRadius = UDim.new(0, 4)
rescanCorner.Parent = rescanBtn

-- Save/Load buttons
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 80, 0, 30)
saveBtn.Position = UDim2.new(1, -170, 0, 2.5)
saveBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
saveBtn.Text = "💾 SAVE"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = buttonFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveBtn

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0, 80, 0, 30)
loadBtn.Position = UDim2.new(1, -85, 0, 2.5)
loadBtn.BackgroundColor3 = Color3.new(0.7, 0, 0.7)
loadBtn.Text = "📂 LOAD"
loadBtn.TextColor3 = Color3.new(1, 1, 1)
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 12
loadBtn.Parent = buttonFrame

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 4)
loadCorner.Parent = loadBtn

-- Variable untuk menyimpan hasil
local scanResults = {}
local remoteList = {}

-- Fungsi untuk format path
local function getFullPath(instance)
    local path = instance.Name
    local parent = instance.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return path
end

-- Fungsi untuk scan remotes
local function scanRemotes()
    status.Text = "🔍 Scanning... (0 found)"
    status.TextColor3 = Color3.new(1, 1, 0)
    textLabel.Text = "SCANNING REMOTES...\n\n"
    scanResults = {}
    remoteList = {}
    
    local total = 0
    local scanned = 0
    
    -- Cari semua remote di game
    local allDescendants = game:GetDescendants()
    status.Text = string.format("🔍 Scanning %d instances...", #allDescendants)
    
    for i, child in ipairs(allDescendants) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("UnreliableRemoteEvent") then
            total = total + 1
            local path = getFullPath(child)
            local remoteInfo = {
                name = child.Name,
                class = child.ClassName,
                path = path,
                fullPath = child:GetFullName()
            }
            table.insert(remoteList, remoteInfo)
            table.insert(scanResults, string.format("[%d] 🔹 %s: %s", total, child.ClassName, path))
        end
        
        -- Update progress setiap 1000 instance
        if i % 1000 == 0 then
            status.Text = string.format("🔍 Scanning... %d/%d (%d found)", i, #allDescendants, total)
            task.wait() -- Biar gak freeze
        end
    end
    
    -- Format hasil akhir
    if total > 0 then
        local resultText = string.format("=== REMOTE SCAN RESULTS ===\nTotal ditemukan: %d\n\n", total)
        resultText = resultText .. table.concat(scanResults, "\n")
        
        -- Tambahkan summary per folder
        local folders = {}
        for _, remote in ipairs(remoteList) do
            local parts = string.split(remote.path, ".")
            if #parts > 1 then
                local folder = parts[#parts - 1]
                folders[folder] = (folders[folder] or 0) + 1
            end
        end
        
        resultText = resultText .. "\n\n=== SUMMARY PER FOLDER ===\n"
        for folder, count in pairs(folders) do
            resultText = resultText .. string.format("📁 %s: %d remotes\n", folder, count)
        end
        
        textLabel.Text = resultText
        status.Text = string.format("✅ Scan selesai! Ditemukan %d remote", total)
        status.TextColor3 = Color3.new(0, 1, 0)
    else
        textLabel.Text = "❌ TIDAK ADA REMOTE DITEMUKAN!\n\n" ..
                        "Kemungkinan penyebab:\n" ..
                        "1. Game menggunakan BindableEvent (client-side only)\n" ..
                        "2. Remote tersembunyi di dalam ModuleScript\n" ..
                        "3. Game menggunakan sistem networking kustom\n\n" ..
                        "Mencoba metode deep scan..."
        status.Text = "⚠️ Melakukan deep scan..."
        status.TextColor3 = Color3.new(1, 0.5, 0)
        
        -- Deep scan: cari di semua module scripts
        task.wait(1)
        textLabel.Text = textLabel.Text .. "\n\nDEEP SCAN RESULTS:\n"
        
        local moduleCount = 0
        for _, child in ipairs(allDescendants) do
            if child:IsA("ModuleScript") then
                moduleCount = moduleCount + 1
                if moduleCount <= 50 then -- Batasi biar gak terlalu banyak
                    textLabel.Text = textLabel.Text .. string.format("📦 Module: %s\n", getFullPath(child))
                end
            end
        end
        
        textLabel.Text = textLabel.Text .. string.format("\nTotal ModuleScripts: %d", moduleCount)
        status.Text = "❌ Deep scan selesai - Tidak ada remote, hanya modules"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end

-- Select All function (manual)
selectBtn.MouseButton1Click:Connect(function()
    -- Method manual: user bisa select text dengan mouse
    status.Text = "✅ Gunakan mouse untuk select text (Ctrl+A)"
    status.TextColor3 = Color3.new(0, 1, 0)
    
    -- Focus ke textLabel
    textLabel:CaptureFocus()
end)

-- Rescan
rescanBtn.MouseButton1Click:Connect(scanRemotes)

-- Save results
saveBtn.MouseButton1Click:Connect(function()
    if #scanResults == 0 then
        status.Text = "❌ Tidak ada data untuk disave"
        status.TextColor3 = Color3.new(1, 0, 0)
        return
    end
    
    local success, err = pcall(function()
        writefile("DarkZephyr_RemoteScan.txt", textLabel.Text)
    end)
    
    if success then
        status.Text = "✅ Saved to DarkZephyr_RemoteScan.txt"
        status.TextColor3 = Color3.new(0, 1, 0)
        saveBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        task.wait(1)
        saveBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
    else
        status.Text = "❌ Gagal save (gunakan copy manual)"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Load results
loadBtn.MouseButton1Click:Connect(function()
    local success, data = pcall(function()
        return readfile("DarkZephyr_RemoteScan.txt")
    end)
    
    if success and data then
        textLabel.Text = data
        status.Text = "✅ Loaded from file"
        status.TextColor3 = Color3.new(0, 1, 0)
    else
        status.Text = "❌ No saved file found"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Start scan
scanRemotes()

-- Instructions
local instr = Instance.new("TextLabel")
instr.Size = UDim2.new(1, -20, 0, 20)
instr.Position = UDim2.new(0, 10, 1, -20)
instr.BackgroundTransparency = 1
instr.Text = "💡 Klik SELECT ALL, lalu tekan Ctrl+A dan Ctrl+C untuk copy"
instr.TextColor3 = Color3.new(0.5, 0.5, 0.5)
instr.TextSize = 10
instr.Font = Enum.Font.Gotham
instr.Parent = frame
