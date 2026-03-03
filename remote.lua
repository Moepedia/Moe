-- Moe V1.0 - SCAN SEMUA FOLDER DI REPLICATEDSTORAGE
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FullReplicatedStorageScanner"
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
title.Text = "🔍 FULL REPLICATEDSTORAGE SCANNER"
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

-- Progress
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
resultBox.Text = "Klik SCAN untuk memulai..."
resultBox.Parent = resultFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 5)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.49, -5, 1, 0)
scanBtn.Position = UDim2.new(0, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
scanBtn.Text = "🔍 SCAN ALL FOLDERS"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 12
scanBtn.Parent = buttonFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.49, -5, 1, 0)
copyBtn.Position = UDim2.new(0.51, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

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

-- ===== FUNGSI SCAN =====
local targetRemotes = {
    "PurchaseBait",
    "PurchaseFishingRod",
    "PurchaseWeatherEvent",
    "EquipBait",
    "EquipRodSkin",
    "WeatherCommand",
    "SubmarineTP",
    "SubmarineTP2",
    "BoatTeleport",
    "ClaimDailyLogin",
    "ClaimBounty",
    "ClaimEventReward",
    "SellAllItems",
    "SellItem",
    "ChargeFishingRod",
    "CatchFishCompleted",
    "FishingMinigameChanged"
}

local function scanAllFolders()
    resultBox.Text = "🔍 SCANNING ALL FOLDERS IN REPLICATEDSTORAGE...\n\n"
    statusLabel.Text = "Scanning..."
    
    -- Cari semua folder
    local folders = {}
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("Folder") then
            table.insert(folders, obj)
        end
    end
    
    resultBox.Text = resultBox.Text .. "📁 Folders ditemukan (" .. #folders .. "):\n"
    for _, folder in ipairs(folders) do
        resultBox.Text = resultBox.Text .. "   - " .. folder.Name .. "\n"
    end
    resultBox.Text = resultBox.Text .. "\n"
    
    -- Scan setiap folder untuk mencari remote
    local allRemotes = {}
    local totalItems = 0
    
    for _, folder in ipairs(folders) do
        resultBox.Text = resultBox.Text .. "\n" .. string.rep("=", 50) .. "\n"
        resultBox.Text = resultBox.Text .. "📂 Scanning folder: " .. folder.Name .. "\n"
        resultBox.Text = resultBox.Text .. string.rep("=", 50) .. "\n"
        
        local remoteCount = 0
        
        -- Cari RemoteFunction dan RemoteEvent di folder ini
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                remoteCount = remoteCount + 1
                totalItems = totalItems + 1
                
                local objType = obj:IsA("RemoteFunction") and "RF" or "RE"
                local fullPath = folder.Name .. "." .. obj.Name
                
                table.insert(allRemotes, {
                    type = objType,
                    path = fullPath,
                    name = obj.Name,
                    obj = obj
                })
                
                resultBox.Text = resultBox.Text .. "   " .. objType .. "/" .. fullPath .. "\n"
            end
        end
        
        if remoteCount == 0 then
            resultBox.Text = resultBox.Text .. "   (tidak ada remote di folder ini)\n"
        end
    end
    
    -- Ringkasan
    resultBox.Text = resultBox.Text .. "\n" .. string.rep("=", 60) .. "\n"
    resultBox.Text = resultBox.Text .. "📊 RINGKASAN SCAN\n"
    resultBox.Text = resultBox.Text .. string.rep("=", 60) .. "\n"
    resultBox.Text = resultBox.Text .. "Total Folders: " .. #folders .. "\n"
    resultBox.Text = resultBox.Text .. "Total Remote: " .. totalItems .. "\n\n"
    
    -- Cari target remotes
    resultBox.Text = resultBox.Text .. "🎯 TARGET REMOTES YANG DICARI:\n"
    resultBox.Text = resultBox.Text .. string.rep("-", 40) .. "\n"
    
    for _, target in ipairs(targetRemotes) do
        local found = false
        for _, remote in ipairs(allRemotes) do
            if remote.name == target then
                resultBox.Text = resultBox.Text .. "✅ " .. remote.type .. "/" .. remote.path .. "\n"
                found = true
                break
            end
        end
        if not found then
            resultBox.Text = resultBox.Text .. "❌ " .. target .. " - TIDAK DITEMUKAN\n"
        end
    end
    
    -- Update progress
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressLabel.Text = "100%"
    statusLabel.Text = "✅ Scan selesai! Total " .. totalItems .. " remote ditemukan"
end

-- Button functions
scanBtn.MouseButton1Click:Connect(scanAllFolders)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(resultBox.Text)
        statusLabel.Text = "✅ Hasil dicopy ke clipboard!"
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

-- Auto scan on start
task.wait(0.5)
scanAllFolders()

print("✅ Full ReplicatedStorage Scanner loaded")
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, buttonFrame.Position.Y.Offset + buttonFrame.Size.Y.Offset + 2)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusLabel

-- ===== FUNGSI FIND ALL REMOTES =====
findBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Mencari semua remote..."
    resultBox.Text = "🔍 SCANNING ALL FOLDERS...\n\n"
    
    local allRemotes = {}
    local folders = {}
    
    -- Cari semua folder di ReplicatedStorage
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("Folder") then
            table.insert(folders, obj.Name)
        end
    end
    
    resultBox.Text = resultBox.Text .. "📁 Folders ditemukan:\n"
    for _, folder in ipairs(folders) do
        resultBox.Text = resultBox.Text .. "   - " .. folder .. "\n"
    end
    resultBox.Text = resultBox.Text .. "\n"
    
    -- Scan semua folder
    for _, folderName in ipairs(folders) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        if folder then
            resultBox.Text = resultBox.Text .. "📂 Scanning: " .. folderName .. "\n"
            
            for _, remote in ipairs(folder:GetDescendants()) do
                if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
                    local remoteType = remote:IsA("RemoteFunction") and "RF" or "RE"
                    local fullPath = folderName .. "." .. remote.Name
                    table.insert(allRemotes, {type = remoteType, path = fullPath, name = remote.Name})
                    resultBox.Text = resultBox.Text .. "   ✅ " .. remoteType .. "/" .. fullPath .. "\n"
                    task.wait(0.01)
                end
            end
            resultBox.Text = resultBox.Text .. "\n"
        end
    end
    
    -- Cari juga di root ReplicatedStorage
    resultBox.Text = resultBox.Text .. "📂 Scanning: Root\n"
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) and remote.Parent == ReplicatedStorage then
            local remoteType = remote:IsA("RemoteFunction") and "RF" or "RE"
            table.insert(allRemotes, {type = remoteType, path = remote.Name, name = remote.Name})
            resultBox.Text = resultBox.Text .. "   ✅ " .. remoteType .. "/" .. remote.Name .. "\n"
            task.wait(0.01)
        end
    end
    
    -- Buat ringkasan
    local summary = "\n" .. string.rep("=", 50) .. "\n"
    summary = summary .. "📊 RINGKASAN REMOTE DITEMUKAN\n"
    summary = summary .. string.rep("=", 50) .. "\n"
    summary = summary .. "Total Remote: " .. #allRemotes .. "\n\n"
    
    -- Kelompokkan berdasarkan kata kunci
    local keywords = {"Bait", "Rod", "Fish", "Catch", "Weather", "Sell", "Buy", "Purchase", "Claim", "TP", "Teleport", "Boat", "Event", "Quest", "Daily", "Bounty", "Favorite"}
    
    for _, keyword in ipairs(keywords) do
        local matches = {}
        for _, r in ipairs(allRemotes) do
            if r.name:find(keyword) then
                table.insert(matches, r)
            end
        end
        if #matches > 0 then
            summary = summary .. "🔹 " .. keyword .. " (" .. #matches .. ")\n"
            for _, r in ipairs(matches) do
                summary = summary .. "   - " .. r.type .. "/" .. r.path .. "\n"
            end
            summary = summary .. "\n"
        end
    end
    
    resultBox.Text = resultBox.Text .. summary
    statusLabel.Text = "✅ Selesai! Ditemukan " .. #allRemotes .. " remote"
end)

-- COPY
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(resultBox.Text)
        statusLabel.Text = "✅ Hasil dicopy ke clipboard!"
    else
        statusLabel.Text = "❌ Executor tidak support setclipboard"
    end
end)

print("✅ Auto Find Remote GUI loaded - Klik FIND ALL REMOTES")
