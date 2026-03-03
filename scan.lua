-- FISH IT - REMOTE PARAMETER TESTER + COPY ALL (FIXED)
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteTesterGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 650)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
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

-- Tabs (baris pertama)
local tabFrame1 = Instance.new("Frame")
tabFrame1.Size = UDim2.new(1, -20, 0, 35)
tabFrame1.Position = UDim2.new(0, 10, 0, 50)
tabFrame1.BackgroundTransparency = 1
tabFrame1.Parent = mainFrame

-- Tabs (baris kedua)
local tabFrame2 = Instance.new("Frame")
tabFrame2.Size = UDim2.new(1, -20, 0, 35)
tabFrame2.Position = UDim2.new(0, 10, 0, 90)
tabFrame2.BackgroundTransparency = 1
tabFrame2.Parent = mainFrame

local tabs1 = {"All", "Fishing", "Bait", "Rod"}
local tabs2 = {"Weather", "Teleport", "Quest", "Sell"}

-- Result area (disesuaikan posisinya)
local resultFrame = Instance.new("Frame")
resultFrame.Size = UDim2.new(1, -20, 1, -240)
resultFrame.Position = UDim2.new(0, 10, 0, 130)
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
resultBox.Text = "Klik tombol SCAN ALL untuk mulai testing..."
resultBox.Parent = resultFrame

-- Button frame (3 tombol sejajar)
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 10)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.32, -5, 1, 0)
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
copyBtn.Size = UDim2.new(0.32, -5, 1, 0)
copyBtn.Position = UDim2.new(0.34, 0, 0, 0)
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
clearBtn.Size = UDim2.new(0.32, -5, 1, 0)
clearBtn.Position = UDim2.new(0.68, 0, 0, 0)
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
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, buttonFrame.Position.Y.Offset + buttonFrame.Size.Y.Offset + 5)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.Text = "Ready - Klik SCAN ALL untuk memulai"
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
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
        {name = "RF/RF_ClaimMegalodonQuest", params = {}, desc = "no params"},
        {name = "RF/RF_ClaimMegalodonQuest", params = {1}, desc = "{1}"},
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
local function createTab(parent, name, xPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 70, 0, 30)
    tab.Position = UDim2.new(0, xPos, 0, 2)
    tab.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    tab.BackgroundTransparency = 0.3
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 13
    tab.Parent = parent
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab
    
    if name == "All" then
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
    end
    
    tab.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, child in pairs(tabFrame1:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        for _, child in pairs(tabFrame2:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
        
        -- Filter results based on tab
        if name ~= "All" then
            local lines = resultBox.Text:split("\n")
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
for i, tabName in ipairs(tabs1) do
    createTab(tabFrame1, tabName, 5 + (i-1) * 75)
end

for i, tabName in ipairs(tabs2) do
    createTab(tabFrame2, tabName, 5 + (i-1) * 75)
end

print("✅ Remote Tester GUI loaded - Tombol SCAN ALL ada di bawah!")
