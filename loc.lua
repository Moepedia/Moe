-- [[ DARK ZEPHYR REMOTE SCANNER v3.0 - FIXED ]]

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 750, 0, 550)
frame.Position = UDim2.new(0.5, -375, 0.5, -275)
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
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🔍 DARK ZEPHYR REMOTE SCANNER v3.0"
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
close.Position = UDim2.new(1, -35, 0, 5)
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
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 45)
status.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
status.Text = "🔍 Scanning remotes..."
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = status

-- TextBox untuk hasil scan (bisa di-copy)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -160)
textBox.Position = UDim2.new(0, 10, 0, 80)
textBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
textBox.TextColor3 = Color3.new(0, 1, 0)
textBox.Font = Enum.Font.Code
textBox.TextSize = 12
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.Text = "Starting scan..."
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = textBox

-- Progress bar
local progressFrame = Instance.new("Frame")
progressFrame.Size = UDim2.new(1, -20, 0, 20)
progressFrame.Position = UDim2.new(0, 10, 0, 350)
progressFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
progressFrame.Parent = frame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 4)
progressCorner.Parent = progressFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.new(0, 0.8, 0)
progressBar.Parent = progressFrame

local progressCorner2 = Instance.new("UICorner")
progressCorner2.CornerRadius = UDim.new(0, 4)
progressCorner2.Parent = progressBar

local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.new(1, 1, 1)
progressText.Font = Enum.Font.GothamBold
progressText.TextSize = 12
progressText.Parent = progressFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 40)
buttonFrame.Position = UDim2.new(0, 10, 1, -45)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = frame

-- Copy button (manual instruction)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 35)
copyBtn.Position = UDim2.new(0, 0, 0, 2.5)
copyBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.8)
copyBtn.Text = "📋 COPY INSTRUCTION"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 4)
copyCorner.Parent = copyBtn

-- Rescan button
local rescanBtn = Instance.new("TextButton")
rescanBtn.Size = UDim2.new(0, 100, 0, 35)
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

-- Clear button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 100, 0, 35)
clearBtn.Position = UDim2.new(0, 240, 0, 2.5)
clearBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
clearBtn.Text = "🗑️ CLEAR"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearBtn

-- Variable untuk menyimpan hasil
local scanResults = {}
local remoteList = {}
local totalInstances = 0
local scannedInstances = 0

-- Fungsi untuk update progress
local function updateProgress(percent, text)
    progressBar.Size = UDim2.new(percent, 0, 1, 0)
    progressText.Text = text or math.floor(percent * 100) .. "%"
end

-- Fungsi untuk format path
local function getFullPath(instance)
    local path = instance.Name
    local parent = instance.Parent
    while parent and parent ~= game do
        path = parent.Name .. "/" .. path
        parent = parent.Parent
    end
    return path
end

-- Fungsi untuk scan remotes
local function scanRemotes()
    status.Text = "🔍 Scanning remotes..."
    status.TextColor3 = Color3.new(1, 1, 0)
    textBox.Text = "SCANNING REMOTES...\n\n"
    scanResults = {}
    remoteList = {}
    
    local total = 0
    local allDescendants = game:GetDescendants()
    totalInstances = #allDescendants
    scannedInstances = 0
    
    updateProgress(0, "0%")
    
    for i, child in ipairs(allDescendants) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("UnreliableRemoteEvent") then
            total = total + 1
            local path = getFullPath(child)
            local remoteInfo = {
                name = child.Name,
                class = child.ClassName,
                path = path
            }
            table.insert(remoteList, remoteInfo)
            table.insert(scanResults, string.format("[%d] %s ➜ %s", total, child.ClassName, path))
        end
        
        -- Update progress setiap 500 instance
        if i % 500 == 0 then
            scannedInstances = i
            local percent = i / totalInstances
            updateProgress(percent, string.format("%d%% (%d/%d)", math.floor(percent*100), i, totalInstances))
            status.Text = string.format("🔍 Scanning... %d remotes found", total)
            task.wait()
        end
    end
    
    -- Format hasil akhir
    if total > 0 then
        local resultText = string.format("=== REMOTE SCAN RESULTS ===\nTotal ditemukan: %d\nWaktu: %s\n\n", total, os.date("%H:%M:%S"))
        resultText = resultText .. table.concat(scanResults, "\n")
        
        -- Tambahkan summary
        resultText = resultText .. "\n\n=== SUMMARY ===\n"
        local remoteEvents = 0
        local remoteFunctions = 0
        local unreliable = 0
        
        for _, remote in ipairs(remoteList) do
            if remote.class == "RemoteEvent" then
                remoteEvents = remoteEvents + 1
            elseif remote.class == "RemoteFunction" then
                remoteFunctions = remoteFunctions + 1
            elseif remote.class == "UnreliableRemoteEvent" then
                unreliable = unreliable + 1
            end
        end
        
        resultText = resultText .. string.format("RemoteEvents: %d\nRemoteFunctions: %d\nUnreliable: %d", remoteEvents, remoteFunctions, unreliable)
        
        textBox.Text = resultText
        status.Text = string.format("✅ Selesai! Ditemukan %d remote", total)
        status.TextColor3 = Color3.new(0, 1, 0)
        updateProgress(1, "100%")
    else
        textBox.Text = "❌ TIDAK ADA REMOTE DITEMUKAN!\n\n" ..
                       "Kemungkinan game menggunakan sistem:\n" ..
                       "1. BindableEvent (client-side only)\n" ..
                       "2. Remote tersembunyi di ModuleScript\n" ..
                       "3. Sistem networking kustom\n\n" ..
                       "Mencari ModuleScripts untuk referensi..."
        
        -- Cari ModuleScripts sebagai referensi
        local modules = {}
        for _, child in ipairs(allDescendants) do
            if child:IsA("ModuleScript") then
                table.insert(modules, getFullPath(child))
            end
        end
        
        if #modules > 0 then
            textBox.Text = textBox.Text .. "\n\n=== MODULES DITEMUKAN ===\n"
            for i = 1, math.min(20, #modules) do
                textBox.Text = textBox.Text .. string.format("📦 %s\n", modules[i])
            end
            if #modules > 20 then
                textBox.Text = textBox.Text .. string.format("... dan %d lainnya", #modules - 20)
            end
        end
        
        status.Text = "❌ Tidak ada remote ditemukan"
        status.TextColor3 = Color3.new(1, 0, 0)
        updateProgress(1, "GAGAL")
    end
end

-- Copy instruction
copyBtn.MouseButton1Click:Connect(function()
    textBox.Text = textBox.Text .. "\n\n[INSTRUKSI COPY]\n" ..
                   "1. Klik di dalam text box ini\n" ..
                   "2. Tekan Ctrl+A untuk select all\n" ..
                   "3. Tekan Ctrl+C untuk copy\n" ..
                   "4. Paste di chat atau file"
    
    status.Text = "✅ Gunakan Ctrl+A dan Ctrl+C untuk copy"
    status.TextColor3 = Color3.new(0, 1, 0)
    
    -- Focus ke textBox
    textBox:CaptureFocus()
    textBox.CursorPosition = #textBox.Text
end)

-- Rescan
rescanBtn.MouseButton1Click:Connect(function()
    scanRemotes()
end)

-- Clear
clearBtn.MouseButton1Click:Connect(function()
    textBox.Text = ""
    scanResults = {}
    remoteList = {}
    status.Text = "Cleared"
    status.TextColor3 = Color3.new(1, 1, 1)
    updateProgress(0, "0%")
end)

-- Start scan
scanRemotes()

-- Auto focus biar gampang copy
textBox:CaptureFocus()
