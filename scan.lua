-- Moe V1.0 - ULTIMATE REMOTE SCANNER
-- Scan semua remote dan coba semua kemungkinan parameter

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateRemoteScanner"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔍 ULTIMATE REMOTE SCANNER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Progress bar
local progressFrame = Instance.new("Frame")
progressFrame.Size = UDim2.new(1, -20, 0, 20)
progressFrame.Position = UDim2.new(0, 10, 0, 50)
progressFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
progressFrame.Parent = mainFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 6)
progressCorner.Parent = progressFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
progressBar.Parent = progressFrame

local progressCorner2 = Instance.new("UICorner")
progressCorner2.CornerRadius = UDim.new(0, 6)
progressCorner2.Parent = progressBar

local progressLabel = Instance.new("TextLabel")
progressLabel.Size = UDim2.new(1, 0, 1, 0)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "0%"
progressLabel.TextColor3 = Color3.new(1, 1, 1)
progressLabel.Font = Enum.Font.GothamBold
progressLabel.TextSize = 12
progressLabel.Parent = progressFrame

-- Result area
local resultFrame = Instance.new("Frame")
resultFrame.Size = UDim2.new(1, -20, 1, -150)
resultFrame.Position = UDim2.new(0, 10, 0, 75)
resultFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
resultFrame.Parent = mainFrame

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 8)
resultCorner.Parent = resultFrame

local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(1, -10, 1, -10)
resultBox.Position = UDim2.new(0, 5, 0, 5)
resultBox.BackgroundTransparency = 1
resultBox.TextColor3 = Color3.new(0.3, 1, 0.3)
resultBox.Font = Enum.Font.Code
resultBox.TextSize = 12
resultBox.TextXAlignment = Enum.TextXAlignment.Left
resultBox.TextYAlignment = Enum.TextYAlignment.Top
resultBox.MultiLine = true
resultBox.ClearTextOnFocus = false
resultBox.TextEditable = false
resultBox.Text = "Klik START SCAN untuk memulai..."
resultBox.Parent = resultFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 5)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.23, -5, 1, 0)
scanBtn.Position = UDim2.new(0, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
scanBtn.Text = "▶ START SCAN"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 12
scanBtn.Parent = buttonFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

local pauseBtn = Instance.new("TextButton")
pauseBtn.Size = UDim2.new(0.23, -5, 1, 0)
pauseBtn.Position = UDim2.new(0.25, 0, 0, 0)
pauseBtn.BackgroundColor3 = Color3.new(0.8, 0.6, 0.2)
pauseBtn.Text = "⏸ PAUSE"
pauseBtn.TextColor3 = Color3.new(1, 1, 1)
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.TextSize = 12
pauseBtn.Parent = buttonFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 6)
pauseCorner.Parent = pauseBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.23, -5, 1, 0)
copyBtn.Position = UDim2.new(0.5, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.23, -5, 1, 0)
saveBtn.Position = UDim2.new(0.75, 0, 0, 0)
saveBtn.BackgroundColor3 = Color3.new(0.6, 0.2, 0.6)
saveBtn.Text = "💾 SAVE"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = buttonFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, buttonFrame.Position.Y.Offset + buttonFrame.Size.Y.Offset + 2)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusLabel

-- ===== FUNGSI GET REMOTE =====
local allRemotes = {}
local scanPaused = false
varTestResults = {}

local function getAllRemotes()
    local remotes = {}
    
    -- Scan semua folder di ReplicatedStorage
    local function scanFolder(folder, path)
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                local remoteType = obj:IsA("RemoteFunction") and "RF" or "RE"
                table.insert(remotes, {
                    type = remoteType,
                    path = path .. "." .. obj.Name,
                    name = obj.Name,
                    obj = obj
                })
            elseif obj:IsA("Folder") then
                scanFolder(obj, path .. "." .. obj.Name)
            end
        end
    end
    
    scanFolder(ReplicatedStorage, "ReplicatedStorage")
    return remotes
end

-- ===== GENERATE PARAMETER VARIATIONS =====
local function generateParams()
    return {
        -- No params
        {},
        
        -- Basic types
        {1},
        {0},
        {true},
        {false},
        {"test"},
        {"Spawn"},
        {"MainIsland"},
        {"Starter Bait"},
        {"Starter Rod"},
        {"Clear"},
        {"Rain"},
        
        -- Numbers
        {1, 2},
        {1, "test"},
        {0, "test"},
        
        -- Strings + numbers
        {"Starter Bait", 1},
        {"Starter Rod", 1},
        {"Clear", 1},
        {1, "Starter Bait"},
        {1, "Starter Rod"},
        
        -- Arrays
        {{}},
        {{1, 2, 3}},
        {{"test", 1}},
        
        -- Common combinations
        {1, true},
        {true, 1},
        {"Spawn", 1},
        {1, "Spawn"},
        {player.Name},
        {player.UserId},
        {player},
        
        -- Game-specific guesses
        {"Treasure Room"},
        {"Ancient Jungle"},
        {"Coral Reefs"},
        {"Shark Hunt"},
        {"Wind"},
        {"Cloudy"},
        {"Storm"},
        {"Fog"}
    }
end

-- ===== TEST REMOTE =====
local function testRemote(remote, params)
    if not remote.obj then return "❌ INVALID" end
    
    local success, result = pcall(function()
        if remote.type == "RF" then
            return remote.obj:InvokeServer(unpack(params))
        else
            remote.obj:FireServer(unpack(params))
            return "Fired (no return)"
        end
    end)
    
    if success then
        return "✅", tostring(result)
    else
        return "❌", tostring(result)
    end
end

-- ===== SCAN ALL =====
local function startScan()
    scanPaused = false
    allRemotes = getAllRemotes()
    statusLabel.Text = "Scanning " .. #allRemotes .. " remotes..."
    resultBox.Text = ""
    
    local results = {}
    local paramList = generateParams()
    local totalTests = #allRemotes * #paramList
    local completedTests = 0
    
    for i, remote in ipairs(allRemotes) do
        if scanPaused then break end
        
        -- Update progress
        local progress = (i-1) / #allRemotes * 100
        progressBar.Size = UDim2.new(progress/100, 0, 1, 0)
        progressLabel.Text = string.format("%.1f%%", progress)
        
        -- Header untuk remote ini
        local remoteHeader = string.format("\n%s[%d/%d] %s %s%s", 
            string.rep("=", 50) .. "\n",
            i, #allRemotes,
            remote.type,
            remote.path,
            "\n" .. string.rep("=", 50))
        
        table.insert(results, remoteHeader)
        resultBox.Text = table.concat(results, "\n")
        task.wait(0.01)
        
        -- Test semua parameter
        for j, params in ipairs(paramList) do
            if scanPaused then break end
            
            completedTests = completedTests + 1
            local progress2 = completedTests / totalTests * 100
            progressBar.Size = UDim2.new(progress2/100, 0, 1, 0)
            progressLabel.Text = string.format("%.1f%%", progress2)
            
            -- Format parameter untuk display
            local paramStr = "{"
            for k, v in ipairs(params) do
                if k > 1 then paramStr = paramStr .. ", " end
                if type(v) == "string" then
                    paramStr = paramStr .. '"' .. v .. '"'
                else
                    paramStr = paramStr .. tostring(v)
                end
            end
            paramStr = paramStr .. "}"
            
            -- Test
            local status, msg = testRemote(remote, params)
            
            -- Simpan hasil
            local resultLine = string.format("%s %-30s → %s", status, paramStr, msg)
            table.insert(results, resultLine)
            
            -- Update display setiap 5 tes
            if completedTests % 5 == 0 then
                resultBox.Text = table.concat(results, "\n")
                task.wait(0.01)
            end
        end
        
        -- Save results to global for later
        varTestResults[remote.path] = results
        
        -- Jeda antar remote
        task.wait(0.1)
    end
    
    -- Final progress
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressLabel.Text = "100%"
    
    -- Ringkasan
    local summary = "\n" .. string.rep("=", 60) .. "\n"
    summary = summary .. "SCAN COMPLETE!\n"
    summary = summary .. string.rep("=", 60) .. "\n"
    summary = summary .. "Total Remotes: " .. #allRemotes .. "\n"
    summary = summary .. "Total Tests: " .. totalTests .. "\n"
    summary = summary .. "Successful: [lihat hasil di atas]\n"
    
    table.insert(results, summary)
    resultBox.Text = table.concat(results, "\n")
    
    statusLabel.Text = string.format("✅ Scan complete! Tested %d remotes with %d parameters", #allRemotes, #paramList)
end

-- ===== SAVE RESULTS =====
local function saveResults()
    local fileName = "RemoteScan_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
    local content = resultBox.Text
    
    -- Coba save ke file (kalo executor support)
    local success = pcall(function()
        writefile(fileName, content)
    end)
    
    if success then
        statusLabel.Text = "✅ Results saved to " .. fileName
    else
        -- Fallback ke copy
        if setclipboard then
            setclipboard(content)
            statusLabel.Text = "✅ Results copied to clipboard (save not supported)"
        else
            statusLabel.Text = "❌ Cannot save - use COPY button"
        end
    end
end

-- Button functions
scanBtn.MouseButton1Click:Connect(startScan)

pauseBtn.MouseButton1Click:Connect(function()
    scanPaused = not scanPaused
    pauseBtn.Text = scanPaused and "▶ RESUME" or "⏸ PAUSE"
    statusLabel.Text = scanPaused and "⏸ Paused" or "▶ Resuming..."
end)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(resultBox.Text)
        statusLabel.Text = "✅ Results copied to clipboard!"
    else
        -- Manual copy instructions
        resultBox.Text = [[
╔════════════════════════════════════╗
║  CARA COPY MANUAL                  ║
╠════════════════════════════════════╣
║ 1. Tekan lama di kotak teks ini    ║
║ 2. Pilih "SELECT ALL"              ║
║ 3. Pilih "COPY"                    ║
║ 4. Paste di chat                   ║
╚════════════════════════════════════╝

]] .. resultBox.Text
        statusLabel.Text = "ℹ️ Ikuti instruksi di atas untuk copy"
    end
end)

saveBtn.MouseButton1Click:Connect(saveResults)

-- Info awal
resultBox.Text = [[
╔════════════════════════════════════════════════════════════╗
║              ULTIMATE REMOTE SCANNER v1.0                  ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  Fitur:                                                    ║
║  • Scan SEMUA remote di game                               ║
║  • Test 40+ kombinasi parameter per remote                 ║
║  • Progress bar real-time                                  ║
║  • Pause/Resume scan                                       ║
║  • Copy hasil ke clipboard                                 ║
║  • Save ke file (jika support)                             ║
║                                                            ║
║  Cara Penggunaan:                                          ║
║  1. Klik START SCAN                                        ║
║  2. Tunggu proses (bisa sampai 5-10 menit)                 ║
║  3. Lihat hasil ✅ yang SUCCESS                             ║
║  4. Klik COPY untuk menyalin                               ║
║  5. Paste di chat dan kirim ke Moe                         ║
║                                                            ║
║  Parameter yang di-test:                                   ║
║  • {}, {1}, {0}, {true}, {false}                           ║
║  • {"test"}, {"Spawn"}, {"Starter Bait"}                   ║
║  • {1,2}, {1,"test"}, {"Starter Bait",1}                   ║
║  • Dan masih banyak lagi...                                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

Klik START SCAN untuk memulai!
]]

print("✅ Ultimate Remote Scanner loaded - Klik START SCAN")
