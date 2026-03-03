-- MOE DEX EXPLORER SEDERHANA - Cari remote fishing manual
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeExplorer"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
header.Text = "🔍 MOE EXPLORER - Cari Remote Fishing"
header.TextColor3 = Color3.new(0, 1, 0)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Parent = frame

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.new(1, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.Parent = header

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Text box untuk hasil
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -80)
textBox.Position = UDim2.new(0, 10, 0, 35)
textBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
textBox.TextColor3 = Color3.new(0, 1, 0)
textBox.Font = Enum.Font.Code
textBox.TextSize = 12
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.Text = "Klik tombol SCAN untuk mencari remote fishing...\n"
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = textBox

-- Button frame
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, -20, 0, 40)
btnFrame.Position = UDim2.new(0, 10, 1, -45)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = frame

-- Scan button
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0, 120, 0, 35)
scanBtn.Position = UDim2.new(0, 0, 0.5, -17.5)
scanBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
scanBtn.Text = "🔍 SCAN"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.TextSize = 14
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = btnFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

-- Copy button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 100, 0, 35)
copyBtn.Position = UDim2.new(0, 130, 0.5, -17.5)
copyBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
copyBtn.Text = "📋 COPY"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 14
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = btnFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

-- Fungsi scan
local function scanRemotes()
    textBox.Text = "🔍 SCANNING...\n\n"
    local results = {}
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Kata kunci fishing
    local keywords = {"Fish", "Fishing", "Catch", "Rod", "Bait", "Cast", "Reel", "Minigame", "Charge"}
    
    -- Fungsi recursive scan
    local function scanFolder(folder, depth)
        if depth > 4 then return end
        
        for _, child in pairs(folder:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                for _, kw in ipairs(keywords) do
                    if string.find(child.Name, kw) or string.find(child.Name:lower(), kw:lower()) then
                        table.insert(results, string.format("[%s] %s (%s)", 
                            child.ClassName, child:GetFullName(), child.Name))
                        break
                    end
                end
            end
            scanFolder(child, depth + 1)
        end
    end
    
    -- Scan lokasi penting
    scanFolder(ReplicatedStorage, 0)
    
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        scanFolder(packages, 0)
    end
    
    -- Tampilkan hasil
    if #results > 0 then
        textBox.Text = "🔍 REMOTE FISHING DITEMUKAN:\n"
        textBox.Text = textBox.Text .. "================================\n\n"
        for i, res in ipairs(results) do
            textBox.Text = textBox.Text .. res .. "\n\n"
        end
    else
        textBox.Text = "❌ TIDAK ADA REMOTE FISHING DITEMUKAN!\n"
        textBox.Text = textBox.Text .. "Coba cek manual dengan Dex Explorer"
    end
end

-- Button functions
scanBtn.MouseButton1Click:Connect(scanRemotes)

copyBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        setclipboard(textBox.Text)
    end)
    
    if success then
        scanBtn.Text = "✅ COPIED!"
        task.wait(1)
        scanBtn.Text = "📋 COPY"
    else
        textBox:CaptureFocus()
    end
end)

-- Auto scan
task.wait(0.5)
scanRemotes()buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 5)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.32, -5, 1, 0)
scanBtn.Position = UDim2.new(0, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
scanBtn.Text = "🔍 SCAN PACKAGES"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 12
scanBtn.Parent = buttonFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.32, -5, 1, 0)
copyBtn.Position = UDim2.new(0.34, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.32, -5, 1, 0)
clearBtn.Position = UDim2.new(0.68, 0, 0, 0)
clearBtn.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
clearBtn.Text = "🗑️ CLEAR"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

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

-- ===== FUNGSI SCAN PACKAGES =====
local function scanPackages()
    resultBox.Text = "🔍 Mencari folder Packages...\n"
    statusLabel.Text = "Scanning..."
    
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then
        resultBox.Text = "❌ Folder Packages tidak ditemukan di ReplicatedStorage!"
        statusLabel.Text = "Error: Packages not found"
        return
    end
    
    resultBox.Text = resultBox.Text .. "✅ Folder Packages ditemukan!\n\n"
    resultBox.Text = resultBox.Text .. "Isi folder Packages:\n"
    
    local rfFolder = packages:FindFirstChild("RF")
    local reFolder = packages:FindFirstChild("RE")
    
    if rfFolder then
        resultBox.Text = resultBox.Text .. "\n📁 RF Folder:\n"
        for _, remote in ipairs(rfFolder:GetChildren()) do
            if remote:IsA("RemoteFunction") then
                resultBox.Text = resultBox.Text .. "   🔹 RF/" .. remote.Name .. "\n"
            end
        end
    end
    
    if reFolder then
        resultBox.Text = resultBox.Text .. "\n📁 RE Folder:\n"
        for _, remote in ipairs(reFolder:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                resultBox.Text = resultBox.Text .. "   🔸 RE/" .. remote.Name .. "\n"
            end
        end
    end
    
    -- Cari remote yang kita butuhkan
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
    
    resultBox.Text = resultBox.Text .. "\n" .. string.rep("=", 50) .. "\n"
    resultBox.Text = resultBox.Text .. "🔍 REMOTE YANG DICARI:\n"
    resultBox.Text = resultBox.Text .. string.rep("=", 50) .. "\n"
    
    for _, target in ipairs(targetRemotes) do
        local found = false
        if rfFolder and rfFolder:FindFirstChild(target) then
            resultBox.Text = resultBox.Text .. "✅ RF/" .. target .. " - DITEMUKAN di RF!\n"
            found = true
        end
        if reFolder and reFolder:FindFirstChild(target) then
            resultBox.Text = resultBox.Text .. "✅ RE/" .. target .. " - DITEMUKAN di RE!\n"
            found = true
        end
        if not found then
            resultBox.Text = resultBox.Text .. "❌ " .. target .. " - TIDAK DITEMUKAN\n"
        end
    end
    
    statusLabel.Text = "✅ Scan selesai! Lihat hasil di atas"
end

-- ===== FUNGSI TEST PARAMETER =====
local function testRemoteParameters()
    resultBox.Text = "🔍 Testing parameter untuk remote di Packages...\n\n"
    statusLabel.Text = "Testing parameters..."
    
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then
        resultBox.Text = "❌ Folder Packages tidak ditemukan!"
        return
    end
    
    local rfFolder = packages:FindFirstChild("RF")
    local reFolder = packages:FindFirstChild("RE")
    
    -- Test cases
    local testCases = {
        -- Bait
        {name = "PurchaseBait", folder = rfFolder, params = {{}, {"Starter Bait"}, {1}, {"Starter Bait", 1}, {1, "Starter Bait"}}},
        {name = "EquipBait", folder = reFolder, params = {{}, {"Starter Bait"}, {1}}},
        
        -- Rod
        {name = "PurchaseFishingRod", folder = rfFolder, params = {{}, {"Starter Rod"}, {1}, {"Starter Rod", 1}, {1, "Starter Rod"}}},
        {name = "EquipRodSkin", folder = reFolder, params = {{}, {"Starter Rod"}, {1}}},
        
        -- Weather
        {name = "WeatherCommand", folder = reFolder, params = {{}, {"Clear"}, {"Rain"}, {"Storm"}, {"Fog"}, {"Wind"}}},
        {name = "PurchaseWeatherEvent", folder = rfFolder, params = {{}, {1}, {1, "Clear"}, {"Clear", 1}}},
        
        -- Teleport
        {name = "SubmarineTP", folder = reFolder, params = {{}, {"Spawn"}, {"Treasure Room"}, {"Ancient Jungle"}}},
        {name = "SubmarineTP2", folder = rfFolder, params = {{}, {"Spawn"}, {1}}},
        {name = "BoatTeleport", folder = reFolder, params = {{}, {"Spawn"}, {1}}},
        
        -- Quest
        {name = "ClaimDailyLogin", folder = rfFolder, params = {{}, {1}}},
        {name = "ClaimBounty", folder = rfFolder, params = {{}, {1}}},
        {name = "ClaimEventReward", folder = reFolder, params = {{}, {1}}},
        
        -- Sell
        {name = "SellAllItems", folder = rfFolder, params = {{}, {1}}},
        {name = "SellItem", folder = rfFolder, params = {{}, {1}, {"item"}}},
        
        -- Fishing
        {name = "ChargeFishingRod", folder = rfFolder, params = {{}, {1}}},
        {name = "CatchFishCompleted", folder = rfFolder, params = {{}, {true}}},
        {name = "FishingMinigameChanged", folder = reFolder, params = {{}, {true}}},
    }
    
    for _, test in ipairs(testCases) do
        if test.folder then
            local remote = test.folder:FindFirstChild(test.name)
            if remote then
                local remoteType = (test.folder == rfFolder) and "RF" or "RE"
                resultBox.Text = resultBox.Text .. "\n" .. string.rep("=", 50) .. "\n"
                resultBox.Text = resultBox.Text .. "🔍 Testing: " .. remoteType .. "/" .. test.name .. "\n"
                resultBox.Text = resultBox.Text .. string.rep("=", 50) .. "\n"
                
                for _, params in ipairs(test.params) do
                    local paramStr = "{"
                    for i, v in ipairs(params) do
                        if i > 1 then paramStr = paramStr .. ", " end
                        if type(v) == "string" then
                            paramStr = paramStr .. '"' .. v .. '"'
                        else
                            paramStr = paramStr .. tostring(v)
                        end
                    end
                    paramStr = paramStr .. "}"
                    
                    local success, result = pcall(function()
                        if remoteType == "RF" then
                            return remote:InvokeServer(unpack(params))
                        else
                            remote:FireServer(unpack(params))
                            return "Fired (no return)"
                        end
                    end)
                    
                    if success then
                        resultBox.Text = resultBox.Text .. "✅ " .. paramStr .. " → " .. tostring(result) .. "\n"
                    else
                        resultBox.Text = resultBox.Text .. "❌ " .. paramStr .. " → " .. tostring(result) .. "\n"
                    end
                    
                    task.wait(0.05)
                end
            end
        end
    end
    
    statusLabel.Text = "✅ Testing selesai! Lihat hasil parameter"
end

-- Button functions
scanBtn.MouseButton1Click:Connect(function()
    scanPackages()
end)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(resultBox.Text)
        statusLabel.Text = "✅ Hasil dicopy ke clipboard!"
    else
        statusLabel.Text = "❌ Executor tidak support setclipboard"
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "Hasil dibersihkan. Klik SCAN PACKAGES untuk memulai."
    statusLabel.Text = "Ready"
end)

-- Auto scan on start
task.wait(0.5)
scanPackages()

print("✅ Packages Remote Scanner loaded")
