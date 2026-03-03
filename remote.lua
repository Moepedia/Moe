-- MOE REMOTE SCANNER v2.0 - GUI VERSION (COPY ALL)
-- Scan semua remote dan tampilkan dalam GUI yang bisa di-copy

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeRemoteScanner"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(0, 1, 0) -- Hijau
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔍 MOE REMOTE SCANNER v2.0"
title.TextColor3 = Color3.new(0, 1, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== STATUS BAR =====
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -20, 0, 30)
statusFrame.Position = UDim2.new(0, 10, 0, 45)
statusFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "⏳ Scanning remotes... (0 found)"
statusText.TextColor3 = Color3.new(1, 1, 0)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusFrame

-- ===== PROGRESS BAR =====
local progressFrame = Instance.new("Frame")
progressFrame.Size = UDim2.new(1, -20, 0, 20)
progressFrame.Position = UDim2.new(0, 10, 0, 80)
progressFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
progressFrame.Parent = mainFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 4)
progressCorner.Parent = progressFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.new(0, 1, 0)
progressBar.Parent = progressFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 4)
progressBarCorner.Parent = progressBar

local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(1, 0, 1, 0)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.TextColor3 = Color3.new(1, 1, 1)
progressText.TextSize = 12
progressText.Font = Enum.Font.GothamBold
progressText.Parent = progressFrame

-- ===== TEXT BOX HASIL SCAN (BISA COPY) =====
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -170)
textBox.Position = UDim2.new(0, 10, 0, 105)
textBox.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
textBox.TextColor3 = Color3.new(0, 1, 0)
textBox.Font = Enum.Font.Code
textBox.TextSize = 12
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.Text = "Starting scan...\n"
textBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- ===== BUTTON FRAME =====
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 40)
buttonFrame.Position = UDim2.new(0, 10, 1, -45)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Copy button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 35)
copyBtn.Position = UDim2.new(0, 0, 0.5, -17.5)
copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
copyBtn.Text = "📋 COPY ALL"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 14
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

-- Rescan button
local rescanBtn = Instance.new("TextButton")
rescanBtn.Size = UDim2.new(0, 100, 0, 35)
rescanBtn.Position = UDim2.new(0, 130, 0.5, -17.5)
rescanBtn.BackgroundColor3 = Color3.new(1, 0.5, 0)
rescanBtn.Text = "🔄 RESCAN"
rescanBtn.TextColor3 = Color3.new(1, 1, 1)
rescanBtn.TextSize = 14
rescanBtn.Font = Enum.Font.GothamBold
rescanBtn.Parent = buttonFrame

local rescanCorner = Instance.new("UICorner")
rescanCorner.CornerRadius = UDim.new(0, 6)
rescanCorner.Parent = rescanBtn

-- Clear button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 100, 0, 35)
clearBtn.Position = UDim2.new(0, 240, 0.5, -17.5)
clearBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
clearBtn.Text = "🗑️ CLEAR"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Save button (jika support)
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 100, 0, 35)
saveBtn.Position = UDim2.new(1, -105, 0.5, -17.5)
saveBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
saveBtn.Text = "💾 SAVE"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextSize = 14
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = buttonFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- ===== VARIABLES =====
local scanResults = {}
local remoteCount = 0
local totalInstances = 0

-- ===== FUNGSI UPDATE PROGRESS =====
local function updateProgress(percent, text)
    progressBar.Size = UDim2.new(percent, 0, 1, 0)
    progressText.Text = text or math.floor(percent * 100) .. "%"
end

-- ===== FUNGSI FORMAT PATH =====
local function getFullPath(instance)
    local path = instance.Name
    local parent = instance.Parent
    while parent and parent ~= game do
        path = parent.Name .. "/" .. path
        parent = parent.Parent
    end
    return path
end

-- ===== FUNGSI SCAN REMOTES =====
local function scanRemotes()
    statusText.Text = "⏳ Scanning remotes... (0 found)"
    statusText.TextColor3 = Color3.new(1, 1, 0)
    textBox.Text = "🔍 MOE REMOTE SCANNER v2.0\n"
    textBox.Text = textBox.Text .. "=" .. string.rep("=", 50) .. "\n\n"
    textBox.Text = textBox.Text .. "STARTING SCAN...\n\n"
    
    scanResults = {}
    remoteCount = 0
    
    -- Kumpulkan semua instance
    local allDescendants = game:GetDescendants()
    totalInstances = #allDescendants
    
    updateProgress(0, "0%")
    
    -- Scan setiap instance
    for i, child in ipairs(allDescendants) do
        -- Cek apakah ini remote
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("UnreliableRemoteEvent") then
            remoteCount = remoteCount + 1
            local path = getFullPath(child)
            local icon = child:IsA("RemoteEvent") and "📡" or (child:IsA("RemoteFunction") and "⚡" or "📶")
            local line = string.format("%s [%d] %s: %s", icon, remoteCount, child.ClassName, path)
            table.insert(scanResults, line)
            
            -- Update text box setiap 10 remote ditemukan
            if remoteCount % 10 == 0 then
                local displayText = "🔍 MOE REMOTE SCANNER v2.0\n"
                displayText = displayText .. "=" .. string.rep("=", 50) .. "\n\n"
                displayText = displayText .. string.format("FOUND %d REMOTES (scanning...)\n\n", remoteCount)
                displayText = displayText .. table.concat(scanResults, "\n")
                textBox.Text = displayText
            end
        end
        
        -- Update progress setiap 1000 instance
        if i % 1000 == 0 then
            local percent = i / totalInstances
            updateProgress(percent, string.format("%d%% (%d/%d)", math.floor(percent*100), i, totalInstances))
            statusText.Text = string.format("⏳ Scanning... %d remotes found", remoteCount)
            task.wait() -- Biar gak freeze
        end
    end
    
    -- Format hasil akhir
    local resultText = "🔍 MOE REMOTE SCANNER v2.0\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n\n"
    resultText = resultText .. string.format("✅ SCAN COMPLETE! Found %d remotes\n", remoteCount)
    resultText = resultText .. string.format("📊 Total instances scanned: %d\n", totalInstances)
    resultText = resultText .. string.format("⏰ Time: %s\n\n", os.date("%H:%M:%S"))
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n\n"
    
    -- Hitung statistik
    local remoteEvents = 0
    local remoteFunctions = 0
    local unreliable = 0
    
    for _, line in ipairs(scanResults) do
        if string.find(line, "RemoteEvent") then
            remoteEvents = remoteEvents + 1
        elseif string.find(line, "RemoteFunction") then
            remoteFunctions = remoteFunctions + 1
        elseif string.find(line, "UnreliableRemoteEvent") then
            unreliable = unreliable + 1
        end
    end
    
    resultText = resultText .. "📊 STATISTICS:\n"
    resultText = resultText .. string.format("   RemoteEvents: %d\n", remoteEvents)
    resultText = resultText .. string.format("   RemoteFunctions: %d\n", remoteFunctions)
    resultText = resultText .. string.format("   Unreliable: %d\n", unreliable)
    resultText = resultText .. "\n" .. "=" .. string.rep("=", 50) .. "\n\n"
    resultText = resultText .. "📋 REMOTE LIST:\n\n"
    resultText = resultText .. table.concat(scanResults, "\n")
    
    -- Tambahan: cek folder Packages secara spesifik
    resultText = resultText .. "\n\n" .. "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "🔍 PACKAGES FOLDER CHECK:\n\n"
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    
    if packages then
        resultText = resultText .. "✅ Packages folder found!\n"
        
        local index = packages:FindFirstChild("_Index")
        if index then
            resultText = resultText .. "📁 _Index folder found\n"
            
            for _, folder in pairs(index:GetChildren()) do
                if string.find(folder.Name, "sleitnick_net") then
                    resultText = resultText .. string.format("\n📁 Found net folder: %s\n", folder.Name)
                    local net = folder:FindFirstChild("net")
                    if net then
                        resultText = resultText .. "   Contents of net:\n"
                        for _, child in pairs(net:GetChildren()) do
                            resultText = resultText .. string.format("   - %s (%s)\n", child.Name, child.ClassName)
                            
                            if child:IsA("Folder") then
                                for _, remote in pairs(child:GetChildren()) do
                                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                                        resultText = resultText .. string.format("      🔹 %s\n", remote.Name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        resultText = resultText .. "❌ Packages folder not found!\n"
    end
    
    textBox.Text = resultText
    statusText.Text = string.format("✅ Scan complete! Found %d remotes", remoteCount)
    statusText.TextColor3 = Color3.new(0, 1, 0)
    updateProgress(1, "100%")
end

-- ===== FUNGSI COPY =====
local function copyToClipboard()
    -- Method 1: Coba pake setclipboard (untuk executor yang support)
    local success, err = pcall(function()
        setclipboard(textBox.Text)
    end)
    
    if success then
        statusText.Text = "✅ Copied to clipboard! (Ctrl+V to paste)"
        statusText.TextColor3 = Color3.new(0, 1, 0)
        copyBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        task.wait(1)
        copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
    else
        -- Method 2: Kasih instruksi manual
        statusText.Text = "⚠️ Manual copy: Select all (Ctrl+A) then Ctrl+C"
        statusText.TextColor3 = Color3.new(1, 1, 0)
        
        -- Focus ke text box
        textBox:CaptureFocus()
        textBox.CursorPosition = #textBox.Text
    end
end

-- ===== BUTTON FUNCTIONS =====
copyBtn.MouseButton1Click:Connect(copyToClipboard)

rescanBtn.MouseButton1Click:Connect(function()
    scanRemotes()
end)

clearBtn.MouseButton1Click:Connect(function()
    textBox.Text = ""
    scanResults = {}
    remoteCount = 0
    statusText.Text = "🔄 Cleared"
    statusText.TextColor3 = Color3.new(1, 1, 1)
    updateProgress(0, "0%")
end)

saveBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        writefile("MoeRemoteScan_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", textBox.Text)
    end)
    
    if success then
        statusText.Text = "✅ Saved to file!"
        statusText.TextColor3 = Color3.new(0, 1, 0)
        saveBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        task.wait(1)
        saveBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    else
        statusText.Text = "❌ Save failed (manual copy only)"
        statusText.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- ===== INSTRUKSI =====
local instrFrame = Instance.new("Frame")
instrFrame.Size = UDim2.new(1, -20, 0, 25)
instrFrame.Position = UDim2.new(0, 10, 1, -25)
instrFrame.BackgroundTransparency = 1
instrFrame.Parent = mainFrame

local instrText = Instance.new("TextLabel")
instrText.Size = UDim2.new(1, 0, 1, 0)
instrText.BackgroundTransparency = 1
instrText.Text = "💡 Click COPY ALL or use Ctrl+A then Ctrl+C to copy results"
instrText.TextColor3 = Color3.new(0.5, 0.5, 0.5)
instrText.TextSize = 11
instrText.Font = Enum.Font.Gotham
instrText.Parent = instrFrame

-- ===== START SCAN =====
scanRemotes()

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ Moe Remote Scanner GUI Loaded - Click COPY ALL to copy results")
