-- Moe V1.0 GUI with Dynamic Hash Detection
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
    -- Akan diisi otomatis
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

-- Deteksi semua remote yang dibutuhkan
print("🔍 Mendeteksi hash remote...")

-- Cari Equip (RE/EquipToolFromHotbar) - biasanya masih pake nama asli
Remote.Equip = Net:FindFirstChild("RE/EquipToolFromHotbar") or 
               findRemoteByType("RE", "Equip") or
               findRemoteByType("RE", "Tool")

-- Cari Charge (RF/ChargeFishingRod) - hash panjang
Remote.Charge = Net:FindFirstChild("RF/ChargeFishingRod") or
                findRemoteByType("RF", "Charge") or
                findRemoteByType("RF", "Fishing") or
                Net:FindFirstChildOfClass("RemoteFunction") -- fallback ke remote function pertama

-- Cari Minigame (RF/RequestFishingMinigameStarted)
Remote.Minigame = Net:FindFirstChild("RF/RequestFishingMinigameStarted") or
                  findRemoteByType("RF", "Minigame") or
                  findRemoteByType("RF", "Request")

-- Cari Catch (RF/CatchFishCompleted)
Remote.Catch = Net:FindFirstChild("RF/CatchFishCompleted") or
               findRemoteByType("RF", "Catch")

-- Cari Cancel (RF/CancelFishingInputs)
Remote.Cancel = Net:FindFirstChild("RF/CancelFishingInputs") or
                findRemoteByType("RF", "Cancel")

-- Cari Minigame Event (RE/FishingMinigameChanged)
Remote.MinigameEvent = Net:FindFirstChild("RE/FishingMinigameChanged") or
                       findRemoteByType("RE", "Minigame") or
                       findRemoteByType("RE", "Changed")

-- Cari FishCaught Event (RE/FishCaught)
Remote.FishCaught = Net:FindFirstChild("RE/FishCaught") or
                    findRemoteByType("RE", "Fish") or
                    findRemoteByType("RE", "Caught")

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

-- ===== EQUIP ROD FUNCTION =====
local function equipRod()
    if Remote.Equip then
        local success = pcall(function()
            Remote.Equip:FireServer(1)  -- Slot 1
            print("✅ Equip remote called")
        end)
        return success
    else
        -- Fallback ke manual
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                tool.Parent = player.Character
                print("✅ Equipped manually: " .. tool.Name)
                return true
            end
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
