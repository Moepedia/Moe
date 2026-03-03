-- FISH IT - REMOTE PARAMETER TESTER + COPY ALL
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteTesterGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
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
title.Text = "🔍 REMOTE PARAMETER TESTER"
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

-- Tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"All", "Fishing", "Bait", "Rod", "Weather", "Teleport", "Quest", "Sell"}

-- Result area
local resultFrame = Instance.new("Frame")
resultFrame.Size = UDim2.new(1, -20, 1, -150)
resultFrame.Position = UDim2.new(0, 10, 0, 80)
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
resultBox.Text = "Klik tombol SCAN untuk mulai testing..."
resultBox.Parent = resultFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 10)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.3, -5, 1, 0)
scanBtn.Position = UDim2.new(0, 0, 0, 0)
scanBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
scanBtn.Text = "🔍 SCAN ALL"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 14
scanBtn.Parent = buttonFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 6)
scanCorner.Parent = scanBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.3, -5, 1, 0)
copyBtn.Position = UDim2.new(0.35, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY ALL"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.3, -5, 1, 0)
clearBtn.Position = UDim2.new(0.7, 0, 0, 0)
clearBtn.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
clearBtn.Text = "🗑️ CLEAR"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 14
clearBtn.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, buttonFrame.Position.Y.Offset + buttonFrame.Size.Y.Offset + 5)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusLabel

-- ===== FUNGSI UTILITY =====
local function getRemote(name)
    local rf = ReplicatedStorage:FindFirstChild("RF")
    if rf then
        local r = rf:FindFirstChild(name)
        if r then return r, "RF" end
    end
    
    local re = ReplicatedStorage:FindFirstChild("RE")
    if re then
        local r = re:FindFirstChild(name)
        if r then return r, "RE" end
    end
    
    return nil, nil
end

local function log(text)
    resultBox.Text = text .. "\n" .. resultBox.Text
end

local function testRemote(remoteName, params, desc)
    local remote, type = getRemote(remoteName)
    if not remote then
        return "❌ " .. remoteName .. " - NOT FOUND"
    end
    
    local result = "🔍 " .. remoteName .. " (" .. type .. ")\n"
    result = result .. "   Parameter: " .. desc .. "\n"
    
    local success, res = pcall(function()
        if type == "RF" then
            return remote:InvokeServer(unpack(params))
        else
            remote:FireServer(unpack(params))
            return "Fired (no return)"
        end
    end)
    
    if success then
        result = result .. "   ✅ SUCCESS: " .. tostring(res) .. "\n"
    else
        result = result .. "   ❌ ERROR: " .. tostring(res) .. "\n"
    end
    
    return result
end

-- ===== SCAN ALL REMOTES =====
scanBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Scanning... (mohon tunggu)"
    resultBox.Text = "Memulai scan semua remote...\n\n"
    
    local results = {}
    
    -- Daftar remote yang akan di test
    local testList = {
        -- Fishing
        {name = "RF/StartFishing", params = {}, desc = "no params"},
        {name = "RF/StartFishing", params = {1}, desc = "{1}"},
        {name = "RF/CatchFishCompleted", params = {}, desc = "no params"},
        {name = "RF/CatchFishCompleted", params = {true}, desc = "{true}"},
        {name = "RF/ChargeFishingRod", params = {}, desc = "no params"},
        {name = "RF/ChargeFishingRod", params = {1}, desc = "{1}"},
        {name = "RE/FishingMinigameChanged", params = {true}, desc = "{true}"},
        {name = "RE/FishingStopped", params = {}, desc = "no params"},
        
        -- Bait
        {name = "RF/PurchaseBait", params = {}, desc = "no params"},
        {name = "RF/PurchaseBait", params = {"Starter Bait"}, desc = '{"Starter Bait"}'},
        {name = "RF/PurchaseBait", params = {"Starter Bait", 1}, desc = '{"Starter Bait", 1}'},
        {name = "RF/PurchaseBait", params = {1, "Starter Bait"}, desc = '{1, "Starter Bait"}'},
        {name = "RF/PurchaseBait", params = {1}, desc = "{1}"},
        {name = "RE/EquipBait", params = {}, desc = "no params"},
        {name = "RE/EquipBait", params = {"Starter Bait"}, desc = '{"Starter Bait"}'},
        {name = "RE/EquipBait", params = {1}, desc = "{1}"},
        
        -- Rod
        {name = "RF/PurchaseFishingRod", params = {}, desc = "no params"},
        {name = "RF/PurchaseFishingRod", params = {"Starter Rod"}, desc = '{"Starter Rod"}'},
        {name = "RF/PurchaseFishingRod", params = {"Starter Rod", 1}, desc = '{"Starter Rod", 1}'},
        {name = "RF/PurchaseFishingRod", params = {1, "Starter Rod"}, desc = '{1, "Starter Rod"}'},
        {name = "RF/PurchaseFishingRod", params = {1}, desc = "{1}"},
        {name = "RE/EquipRodSkin", params = {}, desc = "no params"},
        {name = "RE/EquipRodSkin", params = {"Starter Rod"}, desc = '{"Starter Rod"}'},
        {name = "RE/EquipRodSkin", params = {1}, desc = "{1}"},
        
        -- Weather
        {name = "RE/WeatherCommand", params = {}, desc = "no params"},
        {name = "RE/WeatherCommand", params = {"Clear"}, desc = '{"Clear"}'},
        {name = "RE/WeatherCommand", params = {"Rain"}, desc = '{"Rain"}'},
        {name = "RE/WeatherCommand", params = {"Storm"}, desc = '{"Storm"}'},
        {name = "RE/WeatherCommand", params = {"Fog"}, desc = '{"Fog"}'},
        {name = "RF/PurchaseWeatherEvent", params = {}, desc = "no params"},
        {name = "RF/PurchaseWeatherEvent", params = {1}, desc = "{1}"},
        {name = "RF/PurchaseWeatherEvent", params = {1, "Clear"}, desc = '{1, "Clear"}'},
        {name = "RF/PurchaseWeatherEvent", params = {"Clear", 1}, desc = '{"Clear", 1}'},
        
        -- Teleport
        {name = "RE/SubmarineTP", params = {}, desc = "no params"},
        {name = "RE/SubmarineTP", params = {"Spawn"}, desc = '{"Spawn"}'},
        {name = "RF/SubmarineTP2", params = {}, desc = "no params"},
        {name = "RF/SubmarineTP2", params = {"Spawn"}, desc = '{"Spawn"}'},
        {name = "RE/BoatTeleport", params = {}, desc = "no params"},
        {name = "RE/BoatTeleport", params = {"Spawn"}, desc = '{"Spawn"}'},
        
        -- Quest
        {name = "RF/ClaimDailyLogin", params = {}, desc = "no params"},
        {name = "RF/ClaimDailyLogin", params = {1}, desc = "{1}"},
        {name = "RF/ClaimBounty", params = {}, desc = "no params"},
        {name = "RF/ClaimBounty", params = {1}, desc = "{1}"},
        {name = "RE/ClaimEventReward", params = {}, desc = "no params"},
        {name = "RE/ClaimEventReward", params = {1}, desc = "{1}"},
        {name = "RF/ClaimMegalodonQuest", params = {}, desc = "no params"},
        {name = "RF/ClaimMegalodonQuest", params = {1}, desc = "{1}"},
        {name = "RF/CreateTranscendedStone", params = {}, desc = "no params"},
        {name = "RF/CreateTranscendedStone", params = {1}, desc = "{1}"},
        
        -- Sell
        {name = "RF/SellAllItems", params = {}, desc = "no params"},
        {name = "RF/SellAllItems", params = {1}, desc = "{1}"},
        {name = "RF/SellItem", params = {}, desc = "no params"},
        {name = "RF/SellItem", params = {1}, desc = "{1}"},
        {name = "RF/SellItem", params = {"item"}, desc = '{"item"}'},
        
        -- Favorite
        {name = "RE/FavoriteItem", params = {}, desc = "no params"},
        {name = "RE/FavoriteItem", params = {1}, desc = "{1}"},
        {name = "RE/FavoriteItem", params = {"item"}, desc = '{"item"}'},
        {name = "RE/FavoriteStateChanged", params = {}, desc = "no params"},
        {name = "RE/FavoriteStateChanged", params = {1, true}, desc = '{1, true}'},
        
        -- Market
        {name = "RF/PurchaseMarketItem", params = {}, desc = "no params"},
        {name = "RF/PurchaseMarketItem", params = {"item"}, desc = '{"item"}'},
        {name = "RF/PurchaseMarketItem", params = {"item", 1}, desc = '{"item", 1}'},
    }
    
    for i, test in ipairs(testList) do
        local res = testRemote(test.name, test.params, test.desc)
        table.insert(results, res)
        task.wait(0.05) -- Jeda biar ga overload
    end
    
    -- Gabungkan hasil
    local finalText = "=" .. string.rep("=", 50) .. "\n"
    finalText = finalText .. "HASIL SCAN REMOTE PARAMETER\n"
    finalText = finalText .. string.rep("=", 50) .. "\n\n"
    finalText = finalText .. table.concat(results, "\n")
    
    resultBox.Text = finalText
    statusLabel.Text = "✅ Scan selesai! " .. #testList .. " remote di test"
end)

-- COPY ALL
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(resultBox.Text)
        statusLabel.Text = "✅ Hasil scan dicopy ke clipboard!"
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

-- CLEAR
clearBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "Hasil scan dibersihkan.\nKlik SCAN ALL untuk memulai lagi."
    statusLabel.Text = "Ready"
end)

-- ===== TAB BUTTONS =====
local function createTab(name, xPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 60, 0, 25)
    tab.Position = UDim2.new(0, xPos, 0, 5)
    tab.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    tab.BackgroundTransparency = 0.3
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 12
    tab.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab
    
    if name == "All" then
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
    end
    
    tab.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, child in pairs(tabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
        
        -- Filter results based on tab
        local text = resultBox.Text
        if name ~= "All" then
            -- Simple filter (bisa dikembangkan)
            local lines = text:split("\n")
            local filtered = {}
            for _, line in ipairs(lines) do
                if line:find(name) or line:find("=") then
                    table.insert(filtered, line)
                end
            end
            resultBox.Text = table.concat(filtered, "\n")
        end
    end)
end

-- Create tabs
for i, tabName in ipairs(tabs) do
    createTab(tabName, 5 + (i-1) * 65)
end

-- Auto scan on start
task.wait(0.5)
scanBtn.MouseButton1Click:Fire()

print("Remote Tester GUI loaded - Scan all parameters and copy results")
for _, btn in pairs({RemoteTab, BaitTab, RodTab, WeatherTab}) do
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
end

-- ========== TEXT BOX BESAR ==========
local ResultBox = Instance.new("TextBox")
ResultBox.Size = UDim2.new(0.9, 0, 0, 380)
ResultBox.Position = UDim2.new(0.05, 0, 0, 90)
ResultBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ResultBox.TextColor3 = Color3.fromRGB(100, 255, 100)
ResultBox.Font = Enum.Font.Code
ResultBox.TextSize = 14
ResultBox.TextXAlignment = Enum.TextXAlignment.Left
ResultBox.TextYAlignment = Enum.TextYAlignment.Top
ResultBox.MultiLine = true
ResultBox.ClearTextOnFocus = false
ResultBox.TextEditable = false
ResultBox.BorderSizePixel = 0
ResultBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = ResultBox

-- ========== BUTTONS ==========
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(0.9, 0, 0, 45)
ButtonFrame.Position = UDim2.new(0.05, 0, 0, 480)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.48, 0, 0, 45)
ScanButton.Position = UDim2.new(0, 0, 0, 0)
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
ScanButton.Text = "🔍 SCAN"
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 14
ScanButton.BorderSizePixel = 0
ScanButton.Parent = ButtonFrame

-- Ganti tombol COPY dengan INSTRUKSI
local InfoButton = Instance.new("TextButton")
InfoButton.Size = UDim2.new(0.48, 0, 0, 45)
InfoButton.Position = UDim2.new(0.52, 0, 0, 0)
InfoButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
InfoButton.Text = "📋 CARA COPY"
InfoButton.TextColor3 = Color3.new(1, 1, 1)
InfoButton.Font = Enum.Font.GothamBold
InfoButton.TextSize = 14
InfoButton.BorderSizePixel = 0
InfoButton.Parent = ButtonFrame

for _, btn in pairs({ScanButton, InfoButton}) do
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
end

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 535)
StatusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatusLabel.Text = "🟡 Pilih tab dan klik SCAN"
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.BorderSizePixel = 0
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 4)
StatusCorner.Parent = StatusLabel

-- ========== FUNGSI SCAN ==========
local currentTab = "REMOTE"

local function setActiveTab(active)
    RemoteTab.BackgroundColor3 = (active == "REMOTE") and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
    BaitTab.BackgroundColor3 = (active == "BAIT") and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
    RodTab.BackgroundColor3 = (active == "ROD") and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
    WeatherTab.BackgroundColor3 = (active == "WEATHER") and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(50, 50, 50)
    currentTab = active
end

RemoteTab.MouseButton1Click:Connect(function() setActiveTab("REMOTE") end)
BaitTab.MouseButton1Click:Connect(function() setActiveTab("BAIT") end)
RodTab.MouseButton1Click:Connect(function() setActiveTab("ROD") end)
WeatherTab.MouseButton1Click:Connect(function() setActiveTab("WEATHER") end)

-- Fungsi scan remote
local function scanRemotes()
    StatusLabel.Text = "🟡 Scanning remote..."
    ResultBox.Text = "🔍 Mencari remote...\n"
    task.wait(0.1)
    
    local funcList = {}
    local eventList = {}
    
    -- Cari di semua folder
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            -- Abaikan yang random hash, cari yang ada hubungannya sama Bait/Rod/Weather
            if obj.Name:find("Bait") or obj.Name:find("Rod") or obj.Name:find("Weather") or obj.Name:find("Purchase") then
                table.insert(funcList, obj.Name)
            end
        elseif obj:IsA("RemoteEvent") then
            if obj.Name:find("Bait") or obj.Name:find("Rod") or obj.Name:find("Weather") or obj.Name:find("Purchase") then
                table.insert(eventList, obj.Name)
            end
        end
    end
    
    -- Urutin
    table.sort(funcList)
    table.sort(eventList)
    
    -- Buat teks
    local resultText = ""
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "🔹 REMOTE FUNCTIONS (" .. #funcList .. ")\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n"
    
    for i, name in ipairs(funcList) do
        resultText = resultText .. i .. ". " .. name .. "\n"
    end
    
    resultText = resultText .. "\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "🔸 REMOTE EVENTS (" .. #eventList .. ")\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n"
    
    for i, name in ipairs(eventList) do
        resultText = resultText .. i .. ". " .. name .. "\n"
    end
    
    ResultBox.Text = resultText
    StatusLabel.Text = "✅ Selesai! " .. #funcList .. " Function, " .. #eventList .. " Event"
end

-- Fungsi deteksi Bait
local function scanBait()
    StatusLabel.Text = "🟡 Mendeteksi Bait..."
    ResultBox.Text = "🔍 Mencari daftar Bait...\n"
    task.wait(0.1)
    
    local baitList = {}
    
    -- Cari dari PurchaseBait remote
    local purchaseBait = ReplicatedStorage:FindFirstChild("RF") and 
                        ReplicatedStorage.RF:FindFirstChild("PurchaseBait")
    
    if purchaseBait then
        -- Coba lihat di game, biasanya ada list di client
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ModuleScript") or obj:IsA("Folder") then
                if obj.Name:find("Bait") or obj.Name:find("BaitList") then
                    table.insert(baitList, "Ditemukan module: " .. obj.Name)
                end
            end
        end
    end
    
    -- Tambahkan contoh bait umum
    local commonBaits = {
        "Basic Bait",
        "Quality Bait",
        "Super Bait", 
        "Mystic Bait",
        "Golden Bait",
        "Diamond Bait",
        "Rainbow Bait"
    }
    
    local resultText = "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "🎣 DAFTAR BAIT YANG TERDETEKSI\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n\n"
    
    resultText = resultText .. "📌 REMOTE PURCHASE:\n"
    resultText = resultText .. "- RF/PurchaseBait\n\n"
    
    resultText = resultText .. "📌 BAIT UMUM (Contoh):\n"
    for i, bait in ipairs(commonBaits) do
        resultText = resultText .. i .. ". " .. bait .. "\n"
    end
    
    ResultBox.Text = resultText
    StatusLabel.Text = "✅ Deteksi Bait selesai. Gunakan INSTRUKSI untuk copy!"
end

-- Fungsi deteksi Rod
local function scanRod()
    StatusLabel.Text = "🟡 Mendeteksi Fishing Rod..."
    ResultBox.Text = "🔍 Mencari daftar Fishing Rod...\n"
    task.wait(0.1)
    
    local commonRods = {
        "Wooden Rod",
        "Carbon Rod",
        "Reinforced Rod",
        "Mythical Rod",
        "Legendary Rod",
        "Divine Rod",
        "Ancient Rod"
    }
    
    local resultText = "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "🎣 DAFTAR FISHING ROD YANG TERDETEKSI\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n\n"
    
    resultText = resultText .. "📌 REMOTE PURCHASE:\n"
    resultText = resultText .. "- RF/PurchaseFishingRod\n\n"
    
    resultText = resultText .. "📌 ROD UMUM (Contoh):\n"
    for i, rod in ipairs(commonRods) do
        resultText = resultText .. i .. ". " .. rod .. "\n"
    end
    
    ResultBox.Text = resultText
    StatusLabel.Text = "✅ Deteksi Rod selesai. Gunakan INSTRUKSI untuk copy!"
end

-- Fungsi deteksi Weather
local function scanWeather()
    StatusLabel.Text = "🟡 Mendeteksi Weather..."
    ResultBox.Text = "🔍 Mencari daftar Weather...\n"
    task.wait(0.1)
    
    -- Cari dari WeatherCommand
    local weatherCmd = ReplicatedStorage:FindFirstChild("RE") and 
                      ReplicatedStorage.RE:FindFirstChild("WeatherCommand")
    
    local commonWeather = {
        "Clear",
        "Rain",
        "Storm",
        "Fog",
        "Night",
        "Day",
        "Windy",
        "Snow",
        "Heatwave",
        "Thunder"
    }
    
    local resultText = "=" .. string.rep("=", 50) .. "\n"
    resultText = resultText .. "☁️ DAFTAR WEATHER YANG TERDETEKSI\n"
    resultText = resultText .. "=" .. string.rep("=", 50) .. "\n\n"
    
    resultText = resultText .. "📌 REMOTE COMMAND:\n"
    resultText = resultText .. "- RE/WeatherCommand\n"
    resultText = resultText .. "- RF/PurchaseWeatherEvent\n\n"
    
    resultText = resultText .. "📌 WEATHER UMUM (Contoh):\n"
    for i, w in ipairs(commonWeather) do
        resultText = resultText .. i .. ". " .. w .. "\n"
    end
    
    ResultBox.Text = resultText
    StatusLabel.Text = "✅ Deteksi Weather selesai. Gunakan INSTRUKSI untuk copy!"
end

-- Tombol Scan
ScanButton.MouseButton1Click:Connect(function()
    if currentTab == "REMOTE" then
        scanRemotes()
    elseif currentTab == "BAIT" then
        scanBait()
    elseif currentTab == "ROD" then
        scanRod()
    elseif currentTab == "WEATHER" then
        scanWeather()
    end
end)

-- Tombol INSTRUKSI (ganti COPY)
InfoButton.MouseButton1Click:Connect(function()
    ResultBox.Text = [[
📋 CARA COPY HASIL SCAN:

Karena executor tidak mendukung copy otomatis,
ikuti langkah berikut:

1. Tekan dan tahan di dalam kotak teks ini
2. Pilih "SELECT ALL" (Pilih Semua)
3. Pilih "COPY" (Salin)
4. Buka chat/notes
5. Paste (Tempel) hasilnya

🎯 Tips: Hasil scan akan muncul di sini
setelah kamu klik tombol SCAN.

📌 UNTUK DAFTAR LENGKAP:
Coba cek juga di folder:
- ReplicatedStorage.RF
- ReplicatedStorage.RE
- game:GetService("MarketplaceService")

Kadang daftar item ada di ModuleScript!
]]
    
    StatusLabel.Text = "ℹ️ Ikuti langkah di atas untuk copy manual"
end)

-- Auto scan remotes pas pertama buka
task.spawn(function()
    task.wait(0.5)
    scanRemotes()
end)
