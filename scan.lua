-- Moe V1.0 - DETECTOR TOOL
-- Fungsi: Mendeteksi semua Bait, Rod, dan Weather di game Fish It
-- Hasil akan muncul di console (F9) dan bisa di-copas

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeDetector"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0 - Item Detector"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 60)
status.Position = UDim2.new(0, 10, 0, 45)
status.BackgroundTransparency = 1
status.Text = "Mendeteksi item...\nLihat console (F9)"
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.TextWrapped = true
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0.5, -75, 0, 200)
button.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
button.Text = "COPY TO CLIPBOARD"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Fungsi untuk mendeteksi item
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function detectItems()
    print("\n=== MOE V1.0 ITEM DETECTOR ===\n")
    
    local results = {
        Baits = {},
        Rods = {},
        Weathers = {}
    }
    
    -- 1. DETEKSI BAIT dari RF/PurchaseBait
    print("🔍 MENDETEKSI BAIT...")
    local purchaseBait = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("PurchaseBait")
    if purchaseBait then
        -- Coba lihat di client scripts atau value
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            if child.Name:lower():find("bait") and not child.Name:find("Purchase") then
                table.insert(results.Baits, child.Name)
            end
        end
        
        -- Cek di module scripts
        for _, module in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if module:IsA("ModuleScript") and module.Name:lower():find("bait") then
                local success, data = pcall(function()
                    return require(module)
                end)
                if success and type(data) == "table" then
                    for key, value in pairs(data) do
                        if type(key) == "string" and not table.find(results.Baits, key) then
                            table.insert(results.Baits, key)
                        end
                    end
                end
            end
        end
    end
    
    -- 2. DETEKSI ROD dari RF/PurchaseFishingRod
    print("🔍 MENDETEKSI FISHING ROD...")
    local purchaseRod = ReplicatedStorage:FindFirstChild("RF") and ReplicatedStorage.RF:FindFirstChild("PurchaseFishingRod")
    if purchaseRod then
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            if (child.Name:lower():find("rod") or child.Name:lower():find("pole")) and not child.Name:find("Purchase") then
                table.insert(results.Rods, child.Name)
            end
        end
        
        for _, module in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if module:IsA("ModuleScript") and (module.Name:lower():find("rod") or module.Name:lower():find("fishing")) then
                local success, data = pcall(function()
                    return require(module)
                end)
                if success and type(data) == "table" then
                    for key, value in pairs(data) do
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
