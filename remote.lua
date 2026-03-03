-- FISH IT - AUTO FIND ALL REMOTES
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFindRemoteGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔍 AUTO FIND ALL REMOTES"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
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

-- Result area
local resultFrame = Instance.new("Frame")
resultFrame.Size = UDim2.new(1, -20, 1, -100)
resultFrame.Position = UDim2.new(0, 10, 0, 50)
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
resultBox.Text = "Klik tombol FIND ALL REMOTES untuk mulai..."
resultBox.Parent = resultFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 5)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local findBtn = Instance.new("TextButton")
findBtn.Size = UDim2.new(0.48, -5, 1, 0)
findBtn.Position = UDim2.new(0, 0, 0, 0)
findBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
findBtn.Text = "🔍 FIND ALL REMOTES"
findBtn.TextColor3 = Color3.new(1, 1, 1)
findBtn.Font = Enum.Font.GothamBold
findBtn.TextSize = 14
findBtn.Parent = buttonFrame

local findCorner = Instance.new("UICorner")
findCorner.CornerRadius = UDim.new(0, 6)
findCorner.Parent = findBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.48, -5, 1, 0)
copyBtn.Position = UDim2.new(0.52, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY RESULTS"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
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
