-- Moe V1.0 GUI with Auto Hash Detection
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- ===== AUTO DETECT HASH REMOTES =====
local Remote = {
    Equip = nil,
    Charge = nil,
    Minigame = nil,
    Catch = nil,
    Cancel = nil,
    MinigameEvent = nil,
    FishCaught = nil
}

-- Fungsi untuk mencari remote berdasarkan pola
local function findRemoteByType(typePattern, namePattern)
    for _, obj in ipairs(Net:GetChildren()) do
        local isCorrectType = (typePattern == "RF" and obj:IsA("RemoteFunction")) or 
                              (typePattern == "RE" and obj:IsA("RemoteEvent"))
        
        if isCorrectType then
            if namePattern == "any" or obj.Name:match(namePattern) then
                return obj
            end
        end
    end
    return nil
end

-- Fungsi untuk mencari semua remote dengan tipe tertentu
local function findAllRemotesByType(typePattern)
    local results = {}
    for _, obj in ipairs(Net:GetChildren()) do
        local isCorrectType = (typePattern == "RF" and obj:IsA("RemoteFunction")) or 
                              (typePattern == "RE" and obj:IsA("RemoteEvent"))
        if isCorrectType then
            table.insert(results, obj)
        end
    end
    return results
end

-- Cari semua RE (RemoteEvent) untuk equip
local allRE = findAllRemotesByType("RE")
print("🔍 Ditemukan " .. #allRE .. " RemoteEvent")

-- Urutkan berdasarkan kemiripan dengan pola equip
table.sort(allRE, function(a, b)
    local scoreA = 0
    local scoreB = 0
    if a.Name:match("Equip") then scoreA = scoreA + 10 end
    if a.Name:match("Tool") then scoreA = scoreA + 5 end
    if a.Name:match("Hotbar") then scoreA = scoreA + 5 end
    if #a.Name > 30 then scoreA = scoreA + 3 end -- hash biasanya panjang
    
    if b.Name:match("Equip") then scoreB = scoreB + 10 end
    if b.Name:match("Tool") then scoreB = scoreB + 5 end
    if b.Name:match("Hotbar") then scoreB = scoreB + 5 end
    if #b.Name > 30 then scoreB = scoreB + 3 end
    
    return scoreA > scoreB
end)

-- Ambil yang paling mungkin untuk equip
if #allRE > 0 then
    Remote.Equip = allRE[1]
    print("✅ Equip remote terpilih: " .. Remote.Equip.Name)
end

-- Deteksi remote lainnya (seperti sebelumnya)
Remote.Charge = Net:FindFirstChild("RF/ChargeFishingRod") or findRemoteByType("RF", "Charge")
Remote.Minigame = Net:FindFirstChild("RF/RequestFishingMinigameStarted") or findRemoteByType("RF", "Minigame")
Remote.Catch = Net:FindFirstChild("RF/CatchFishCompleted") or findRemoteByType("RF", "Catch")
Remote.Cancel = Net:FindFirstChild("RF/CancelFishingInputs") or findRemoteByType("RF", "Cancel")
Remote.MinigameEvent = Net:FindFirstChild("RE/FishingMinigameChanged") or findRemoteByType("RE", "Minigame")
Remote.FishCaught = Net:FindFirstChild("RE/FishCaught") or findRemoteByType("RE", "Fish")

-- Tampilkan hasil deteksi
print("\n📡 HASIL DETEKSI REMOTE:")
for name, remote in pairs(Remote) do
    if remote then
        local type = remote:IsA("RemoteFunction") and "RF" or "RE"
        print(string.format("✅ %s: %s/%s", name, type, remote.Name))
    else
        print(string.format("❌ %s: TIDAK DITEMUKAN", name))
    end
end

-- ===== EQUIP ROD FUNCTION (DENGAN BANYAK PERCOBAAN) =====
local function equipRod()
    if not Remote.Equip then 
        print("❌ No equip remote found")
        return false 
    end
    
    -- Coba berbagai parameter
    local testParams = {
        {1},
        {1, player.Character},
        {tonumber("1")},
        {"1"},
        {player.Backpack:FindFirstChildWhichIsA("Tool")},
        {}
    }
    
    for i, params in ipairs(testParams) do
        local success = pcall(function()
            Remote.Equip:FireServer(unpack(params))
        end)
        print(string.format("   Param set %d: %s", i, success and "✅" or "❌"))
        if success then
            task.wait(0.5)
            -- Cek apakah rod sudah di tangan
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                    print("✅ Rod terdeteksi di tangan: " .. tool.Name)
                    return true
                end
            end
        end
    end
    
    -- Fallback: manual equip
    print("⚡ Mencoba manual equip...")
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            tool.Parent = player.Character
            print("✅ Equipped manually: " .. tool.Name)
            return true
        end
    end
    
    return false
end

-- ===== TEST EQUIP =====
local function testEquip()
    print("\n🧪 TESTING EQUIP ROD...")
    if equipRod() then
        print("✅ Equip berhasil!")
    else
        print("❌ Equip gagal!")
    end
end

-- Simple GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🎣 AUTO FISH - EQUIP FIX"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Info remote
local remoteInfo = Instance.new("TextLabel")
remoteInfo.Size = UDim2.new(1, -10, 0, 60)
remoteInfo.Position = UDim2.new(0, 5, 0, 45)
remoteInfo.BackgroundTransparency = 1
remoteInfo.Text = "Equip Remote: " .. (Remote.Equip and Remote.Equip.Name:sub(1, 20).."..." or "Tidak ditemukan")
remoteInfo.TextColor3 = Color3.new(0.8, 0.8, 0.8)
remoteInfo.Font = Enum.Font.Gotham
remoteInfo.TextSize = 11
remoteInfo.TextWrapped = true
remoteInfo.Parent = frame

local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
equipBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
equipBtn.BackgroundColor3 = Color3.new(0, 0.6, 0.8)
equipBtn.Text = "TEST EQUIP ROD"
equipBtn.TextColor3 = Color3.new(1, 1, 1)
equipBtn.Font = Enum.Font.GothamBold
equipBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0.2, 0)
status.Position = UDim2.new(0, 0, 0.85, 0)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.Parent = frame

equipBtn.MouseButton1Click:Connect(function()
    status.Text = "Equipping..."
    status.TextColor3 = Color3.new(1, 1, 0)
    
    local success = equipRod()
    
    if success then
        status.Text = "✅ Equip Success!"
        status.TextColor3 = Color3.new(0, 1, 0)
    else
        status.Text = "❌ Equip Failed!"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("\n✅ Script siap! Klik TEST EQUIP ROD")    else
        print("❌ Equip gagal!")
    end
end

-- Simple GUI untuk test
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🎣 AUTO FISH - HASH DETECTOR"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
equipBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
equipBtn.BackgroundColor3 = Color3.new(0, 0.6, 0.8)
equipBtn.Text = "TEST EQUIP ROD"
equipBtn.TextColor3 = Color3.new(1, 1, 1)
equipBtn.Font = Enum.Font.GothamBold
equipBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0.3, 0)
status.Position = UDim2.new(0, 0, 0.7, 0)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 0)
status.Font = Enum.Font.Gotham
status.Parent = frame

equipBtn.MouseButton1Click:Connect(function()
    status.Text = "Equipping..."
    status.TextColor3 = Color3.new(1, 1, 0)
    
    local success = equipRod()
    
    if success then
        status.Text = "✅ Equip Success!"
        status.TextColor3 = Color3.new(0, 1, 0)
    else
        status.Text = "❌ Equip Failed!"
        status.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("\n✅ Script siap! Klik TEST EQUIP ROD")
