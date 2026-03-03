-- Moe V1.0 - REMOTE PARAMETER TESTER + COPY ALL
-- Jalankan ini di game, test semua parameter, copy hasilnya

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteParameterTester"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 550)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
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

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"All", "Bait", "Rod", "Weather", "Teleport", "Quest", "Sell"}
local currentTab = "All"

-- Result area
local resultFrame = Instance.new("Frame")
resultFrame.Size = UDim2.new(1, -20, 1, -140)
resultFrame.Position = UDim2.new(0, 10, 0, 85)
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
resultBox.Text = "Klik tombol TEST ALL REMOTES untuk memulai..."
resultBox.Parent = resultFrame

-- Button frame
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -20, 0, 45)
buttonFrame.Position = UDim2.new(0, 10, 0, resultFrame.Position.Y.Offset + resultFrame.Size.Y.Offset + 5)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0.32, -5, 1, 0)
testBtn.Position = UDim2.new(0, 0, 0, 0)
testBtn.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
testBtn.Text = "🔍 TEST ALL REMOTES"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 12
testBtn.Parent = buttonFrame

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 6)
testCorner.Parent = testBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.32, -5, 1, 0)
copyBtn.Position = UDim2.new(0.34, 0, 0, 0)
copyBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.8)
copyBtn.Text = "📋 COPY RESULTS"
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

-- ===== FUNGSI GET REMOTE =====
local function getRemoteFromPackages(folder, name)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then return rf:FindFirstChild(name) end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then return re:FindFirstChild(name) end
    end
    return nil
end

-- ===== TEST REMOTE =====
local function testRemote(remote, params, desc)
    if not remote then
        return "❌ REMOTE NOT FOUND - " .. desc
    end
    
    local success, result = pcall(function()
        return remote:FireServer(unpack(params))
    end)
    
    if success then
        return "✅ SUCCESS - " .. desc .. " | Result: " .. tostring(result)
    else
        return "❌ ERROR - " .. desc .. " | Error: " .. tostring(result)
    end
end

-- ===== TEST FUNCTIONS =====
local function testAllRemotes()
    statusLabel.Text = "Testing all remotes..."
    resultBox.Text = ""

    local results = {}
    
    -- AMBIL SEMUA REMOTE DARI PACKAGES
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then
        resultBox.Text = "❌ Packages folder not found!"
        return
    end
    
    local rfFolder = packages:FindFirstChild("RF")
    local reFolder = packages:FindFirstChild("RE")
    
    -- Test semua kemungkinan parameter untuk setiap remote
    local testCases = {
        -- BAIT
        {folder = "RF", name = "PurchaseBait", params = {{}, {"Starter Bait"}, {1}, {"Starter Bait", 1}, {1, "Starter Bait"}}},
        {folder = "RE", name = "EquipBait", params = {{}, {"Starter Bait"}, {1}}},
        
        -- ROD
        {folder = "RF", name = "PurchaseFishingRod", params = {{}, {"Starter Rod"}, {1}, {"Starter Rod", 1}, {1, "Starter Rod"}}},
        {folder = "RE", name = "EquipRodSkin", params = {{}, {"Starter Rod"}, {1}}},
        
        -- WEATHER
        {folder = "RE", name = "WeatherCommand", params = {{}, {"Clear"}, {"Rain"}, {"Storm"}, {"Fog"}, {"Wind"}}},
        {folder = "RF", name = "PurchaseWeatherEvent", params = {{}, {1}, {1, "Clear"}, {"Clear", 1}}},
        
        -- TELEPORT
        {folder = "RE", name = "SubmarineTP", params = {{}, {"Spawn"}, {"Coral Reefs"}, {"Ancient Jungle"}}},
        {folder = "RF", name = "SubmarineTP2", params = {{}, {"Spawn"}, {1}}},
        {folder = "RE", name = "BoatTeleport", params = {{}, {"Spawn"}, {1}}},
        
        -- QUEST
        {folder = "RF", name = "ClaimDailyLogin", params = {{}, {1}}},
        {folder = "RF", name = "ClaimBounty", params = {{}, {1}}},
        {folder = "RE", name = "ClaimEventReward", params = {{}, {1}}},
        
        -- SELL
        {folder = "RF", name = "SellAllItems", params = {{}, {1}}},
        {folder = "RF", name = "SellItem", params = {{}, {1}, {"item"}}},
        
        -- FISHING
        {folder = "RF", name = "ChargeFishingRod", params = {{}, {1}}},
        {folder = "RF", name = "CatchFishCompleted", params = {{}, {true}}},
        {folder = "RE", name = "FishingMinigameChanged", params = {{}, {true}}},
    }
    
    for _, test in ipairs(testCases) do
        local remote = getRemoteFromPackages(test.folder, test.name)
        local remoteName = test.folder .. "/" .. test.name
        
        table.insert(results, "\n=== " .. remoteName .. " ===")
        
        for _, params in ipairs(test.params) do
            local paramStr = "{" .. table.concat(params, ", ") .. "}"
            if #params == 0 then paramStr = "{}" end
            
            local result = testRemote(remote, params, remoteName .. " " .. paramStr)
            table.insert(results, result)
            
            -- Jeda biar ga overload
            task.wait(0.05)
        end
    end
    
    -- Cari juga remote lain yang mungkin berguna
    if rfFolder then
        table.insert(results, "\n=== OTHER RF REMOTES ===")
        for _, remote in ipairs(rfFolder:GetChildren()) do
            if remote:IsA("RemoteFunction") then
                local result = testRemote(remote, {}, "RF/" .. remote.Name .. " {}")
                table.insert(results, result)
                task.wait(0.05)
            end
        end
    end
    
    if reFolder then
        table.insert(results, "\n=== OTHER RE REMOTES ===")
        for _, remote in ipairs(reFolder:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                local result = testRemote(remote, {}, "RE/" .. remote.Name .. " {}")
                table.insert(results, result)
                task.wait(0.05)
            end
        end
    end
    
    -- Gabungkan hasil
    local finalText = "=" .. string.rep("=", 60) .. "\n"
    finalText = finalText .. "REMOTE PARAMETER TEST RESULTS\n"
    finalText = finalText .. string.rep("=", 60) .. "\n"
    finalText = finalText .. "Tested at: " .. os.date() .. "\n"
    finalText = finalText .. string.rep("=", 60) .. "\n\n"
    finalText = finalText .. table.concat(results, "\n")
    
    resultBox.Text = finalText
    statusLabel.Text = "✅ Test complete! Total " .. #results .. " tests"
end

-- ===== CREATE TABS =====
local function createTab(name, xPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 70, 0, 30)
    tab.Position = UDim2.new(0, xPos, 0, 2)
    tab.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
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
        currentTab = name
        
        -- Filter results
        if name ~= "All" then
            local lines = resultBox.Text:split("\n")
            local filtered = {}
            for _, line in ipairs(lines) do
                if line:find(name) or line:find("===") or line:find("=") then
                    table.insert(filtered, line)
                end
            end
            resultBox.Text = table.concat(filtered, "\n")
        end
    end)
end

-- Create tabs
for i, name in ipairs(tabs) do
    createTab(name, 5 + (i-1) * 75)
end

-- Button functions
testBtn.MouseButton1Click:Connect(testAllRemotes)

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

clearBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "Hasil dibersihkan. Klik TEST ALL REMOTES untuk memulai lagi."
    statusLabel.Text = "Ready"
end)

-- Auto test on start
task.wait(0.5)
testAllRemotes()

print("✅ Remote Parameter Tester loaded - Klik TEST ALL REMOTES")
