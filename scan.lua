-- ====================================================================
-- REMOTE FINDER + ITEM DETECTOR UNTUK FISH IT
-- ====================================================================

repeat task.wait() until game:IsLoaded()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

if CoreGui:FindFirstChild("RemoteFinderGUI") then
    CoreGui.RemoteFinderGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteFinderGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "🎣 FISH IT - REMOTE & ITEM FINDER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Tombol tutup
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
end)

-- ========== TAB BUTTONS ==========
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 45)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local RemoteTab = Instance.new("TextButton")
RemoteTab.Size = UDim2.new(0.33, -2, 0, 35)
RemoteTab.Position = UDim2.new(0, 5, 0, 2)
RemoteTab.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
RemoteTab.Text = "🔍 REMOTES"
RemoteTab.TextColor3 = Color3.new(1, 1, 1)
RemoteTab.Font = Enum.Font.GothamBold
RemoteTab.TextSize = 12
RemoteTab.BorderSizePixel = 0
RemoteTab.Parent = TabFrame

local BaitTab = Instance.new("TextButton")
BaitTab.Size = UDim2.new(0.33, -2, 0, 35)
BaitTab.Position = UDim2.new(0.33, 2, 0, 2)
BaitTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BaitTab.Text = "🎣 BAIT"
BaitTab.TextColor3 = Color3.new(1, 1, 1)
BaitTab.Font = Enum.Font.GothamBold
BaitTab.TextSize = 12
BaitTab.BorderSizePixel = 0
BaitTab.Parent = TabFrame

local RodTab = Instance.new("TextButton")
RodTab.Size = UDim2.new(0.33, -2, 0, 35)
RodTab.Position = UDim2.new(0.66, 4, 0, 2)
RodTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RodTab.Text = "🎣 ROD"
RodTab.TextColor3 = Color3.new(1, 1, 1)
RodTab.Font = Enum.Font.GothamBold
RodTab.TextSize = 12
RodTab.BorderSizePixel = 0
RodTab.Parent = TabFrame

local WeatherTab = Instance.new("TextButton")
WeatherTab.Size = UDim2.new(0.33, -2, 0, 35)
WeatherTab.Position = UDim2.new(0.99, -0.33, 0, 2)
WeatherTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WeatherTab.Text = "☁️ WEATHER"
WeatherTab.TextColor3 = Color3.new(1, 1, 1)
WeatherTab.Font = Enum.Font.GothamBold
WeatherTab.TextSize = 12
WeatherTab.BorderSizePixel = 0
WeatherTab.Parent = TabFrame

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

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.48, 0, 0, 45)
CopyButton.Position = UDim2.new(0.52, 0, 0, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
CopyButton.Text = "📋 COPY"
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 14
CopyButton.BorderSizePixel = 0
CopyButton.Parent = ButtonFrame

for _, btn in pairs({ScanButton, CopyButton}) do
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
    StatusLabel.Text = "✅ Deteksi Bait selesai. Copy dan kirim ke Moe!"
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
    StatusLabel.Text = "✅ Deteksi Rod selesai. Copy dan kirim ke Moe!"
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
    StatusLabel.Text = "✅ Deteksi Weather selesai. Copy dan kirim ke Moe!"
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

-- Tombol Copy
CopyButton.MouseButton1Click:Connect(function()
    if ResultBox.Text ~= "" then
        setclipboard and setclipboard(ResultBox.Text)
        StatusLabel.Text = "✅ Teks telah dicopy ke clipboard!"
        task.wait(1)
        StatusLabel.Text = "🟡 Pilih tab dan klik SCAN"
    else
        StatusLabel.Text = "❌ Tidak ada teks untuk dicopy"
    end
end)

-- Auto scan remotes pas pertama buka
task.spawn(function()
    task.wait(0.5)
    scanRemotes()
end)                    for key, value in pairs(data) do
                        if type(key) == "string" and not table.find(results.Rods, key) then
                            results.Rods[key] = value
                        end
                    end
                end
            end
        end
    end
    
    -- 3. DETEKSI WEATHER dari RE/WeatherCommand
    print("🔍 MENDETEKSI WEATHER...")
    local weatherCmd = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("WeatherCommand")
    if weatherCmd then
        -- Weather umum
        local commonWeather = {"Clear", "Rain", "Storm", "Fog", "Night", "Day", "Windy", "Snow", "Thunder", "Hurricane", "Tornado", "Heatwave", "Blizzard", "Sandstorm"}
        for _, w in ipairs(commonWeather) do
            table.insert(results.Weathers, w)
        end
        
        -- Cek di module
        for _, module in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("weather") then
                local success, data = pcall(function()
                    return require(module)
                end)
                if success and type(data) == "table" then
                    for key, value in pairs(data) do
                        if type(key) == "string" and not table.find(results.Weathers, key) then
                            table.insert(results.Weathers, key)
                        end
                    end
                end
            end
        end
    end
    
    -- TAMPILKAN HASIL
    print("\n" .. string.rep("=", 50))
    print("📋 DAFTAR ITEM YANG TERDETEKSI")
    print(string.rep("=", 50))
    
    print("\n🎣 BAIT (" .. #results.Baits .. " item):")
    if #results.Baits > 0 then
        table.sort(results.Baits)
        for i, bait in ipairs(results.Baits) do
            print(string.format("%2d. %s", i, bait))
        end
    else
        print("   [Tidak ada bait terdeteksi - mungkin perlu method lain]")
    end
    
    print("\n🎣 FISHING ROD (" .. #results.Rods .. " item):")
    if #results.Rods > 0 then
        table.sort(results.Rods)
        for i, rod in ipairs(results.Rods) do
            print(string.format("%2d. %s", i, rod))
        end
    else
        print("   [Tidak ada rod terdeteksi - mungkin perlu method lain]")
    end
    
    print("\n☁️ WEATHER (" .. #results.Weathers .. " item):")
    if #results.Weathers > 0 then
        table.sort(results.Weathers)
        for i, weather in ipairs(results.Weathers) do
            print(string.format("%2d. %s", i, weather))
        end
    else
        print("   [Tidak ada weather terdeteksi - mungkin perlu method lain]")
    end
    
    print("\n" .. string.rep("=", 50))
    print("✅ DETEKSI SELESAI")
    print("📝 Copy list di atas dan kirim ke saya!")
    print(string.rep("=", 50) .. "\n")
    
    -- Format untuk di-copy
    local copyText = "-- DAFTAR BAIT:\n"
    for _, bait in ipairs(results.Baits) do
        copyText = copyText .. '    "' .. bait .. '",\n'
    end
    
    copyText = copyText .. "\n-- DAFTAR ROD:\n"
    for _, rod in ipairs(results.Rods) do
        copyText = copyText .. '    "' .. rod .. '",\n'
    end
    
    copyText = copyText .. "\n-- DAFTAR WEATHER:\n"
    for _, weather in ipairs(results.Weathers) do
        copyText = copyText .. '    "' .. weather .. '",\n'
    end
    
    return copyText
end

-- Tombol copy
button.MouseButton1Click:Connect(function()
    local text = detectItems()
    setclipboard and setclipboard(text) or notify("Clipboard tidak tersedia")
    status.Text = "✅ List sudah di-copy!\nLihat console (F9) untuk detail"
end)

-- Auto detect saat buka
task.wait(1)
detectItems()

print("\n🔄 MOE DETECTOR READY")
print("Klik tombol 'COPY TO CLIPBOARD' untuk menyalin list")
