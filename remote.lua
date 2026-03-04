-- ====================================================================
--     AUTO FISH V5.0 - BERDASARKAN HASIL SCAN
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- ====================================================================
--                     PATH LENGKAP DARI SCAN
-- ====================================================================
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local Remote = {
    -- FISHING REMOTES
    ChargeFishingRod = Net:FindFirstChild("RF/ChargeFishingRod"),
    RequestMinigame = Net:FindFirstChild("RF/RequestFishingMinigameStarted"),
    CatchFishCompleted = Net:FindFirstChild("RF/CatchFishCompleted"),
    CancelFishing = Net:FindFirstChild("RF/CancelFishingInputs"),
    FishCaught = Net:FindFirstChild("RE/FishCaught"),
    FishingStopped = Net:FindFirstChild("RE/FishingStopped"),
    
    -- ANTI-CHEAT BYPASS
    UpdateAutoFishing = Net:FindFirstChild("RF/UpdateAutoFishingState"),
    MarkAutoFishing = Net:FindFirstChild("RF/MarkAutoFishingUsed"),
    
    -- SELL REMOTES
    SellAll = Net:FindFirstChild("RF/SellAllItems"),
    SellItem = Net:FindFirstChild("RF/SellItem"),
    UpdateSellThreshold = Net:FindFirstChild("RF/UpdateAutoSellThreshold"),
    
    -- FAVORITE REMOTES
    Favorite = Net:FindFirstChild("RE/FavoriteItem"),
    FavoritePrompt = Net:FindFirstChild("RF/PromptFavoriteGame"),
    FavoriteState = Net:FindFirstChild("RE/FavoriteStateChanged")
}

-- ====================================================================
--                     CEK KETERSEDIAAN REMOTE
-- ====================================================================
print("\n🔍 REMOTE STATUS:")
for name, remote in pairs(Remote) do
    if remote then
        print("✅ " .. name .. " - " .. remote.ClassName)
    else
        print("❌ " .. name .. " - TIDAK DITEMUKAN")
    end
end
print("")

-- ====================================================================
--                     ANTI-CHEAT BYPASS
-- ====================================================================
local function disableAntiCheat()
    -- Matikan state auto fishing
    if Remote.UpdateAutoFishing then
        pcall(function()
            Remote.UpdateAutoFishing:InvokeServer(false)
        end)
    end
    
    -- Reset mark auto fishing
    if Remote.MarkAutoFishing then
        pcall(function()
            Remote.MarkAutoFishing:InvokeServer(0)
        end)
    end
end

-- ====================================================================
--                     FISHING FUNCTIONS
-- ====================================================================
local isFishing = false
local bobber = nil

-- Cari bobber
local function findBobber()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Bobber" and v:IsA("Part") and v:FindFirstChild("Owner") then
            local owner = v:FindFirstChild("Owner")
            if owner and owner.Value == LocalPlayer then
                return v
            end
        end
    end
    return nil
end

-- Cast rod
local function castRod()
    if not Remote.ChargeFishingRod or not Remote.RequestMinigame then
        return false
    end
    
    -- Coba dengan parameter (dari script lama)
    local success = pcall(function()
        Remote.ChargeFishingRod:InvokeServer(1755848498.4834)
        task.wait(0.1)
        Remote.RequestMinigame:InvokeServer(1.2854545116425, 1)
    end)
    
    -- Kalau gagal, coba tanpa parameter
    if not success then
        pcall(function()
            Remote.ChargeFishingRod:InvokeServer()
            task.wait(0.1)
            Remote.RequestMinigame:InvokeServer()
        end)
    end
    
    return true
end

-- Reel in
local function reelIn()
    -- Method 1: CatchFishCompleted (remote function)
    if Remote.CatchFishCompleted then
        pcall(function()
            Remote.CatchFishCompleted:InvokeServer()
        end)
    end
    
    -- Method 2: FishCaught (remote event)
    if Remote.FishCaught then
        pcall(function()
            Remote.FishCaught:FireServer()
        end)
    end
    
    -- Method 3: FishingStopped
    if Remote.FishingStopped then
        pcall(function()
            Remote.FishingStopped:FireServer()
        end)
    end
end

-- Cancel fishing
local function cancelFishing()
    if Remote.CancelFishing then
        pcall(function()
            Remote.CancelFishing:InvokeServer()
        end)
    end
end

-- ====================================================================
--                     AUTO FISHING LOOP
-- ====================================================================
local function startFishing()
    if isFishing then return end
    isFishing = true
    
    -- Anti-AFK
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    -- Main loop
    task.spawn(function()
        while isFishing do
            -- Bypass anti-cheat
            disableAntiCheat()
            
            -- Cancel previous fishing
            cancelFishing()
            task.wait(0.2)
            
            -- Cast
            castRod()
            
            -- Tunggu bobber muncul
            local timeout = 0
            bobber = nil
            while not bobber and timeout < 5 do
                bobber = findBobber()
                task.wait(0.1)
                timeout = timeout + 0.1
            end
            
            -- Tunggu ikan
            if bobber then
                local biteStart = tick()
                while isFishing do
                    local biteProgress = bobber:FindFirstChild("BiteProgress")
                    if biteProgress and biteProgress.Value >= 0.95 then
                        reelIn()
                        break
                    end
                    
                    -- Timeout setelah 15 detik
                    if tick() - biteStart > 15 then
                        cancelFishing()
                        break
                    end
                    
                    task.wait(0.1)
                end
            end
            
            task.wait(1) -- Cooldown
        end
    end)
end

local function stopFishing()
    isFishing = false
    cancelFishing()
end

-- ====================================================================
--                     AUTO SELL
-- ====================================================================
local function sellAllItems()
    if Remote.SellAll then
        local success = pcall(function()
            Remote.SellAll:InvokeServer()
        end)
        return success
    end
    return false
end

local function updateSellThreshold(value)
    if Remote.UpdateSellThreshold then
        pcall(function()
            Remote.UpdateSellThreshold:InvokeServer(value)
        end)
    end
end

-- ====================================================================
--                     AUTO FAVORITE
-- ====================================================================
local function favoriteItem(itemId)
    if Remote.Favorite then
        pcall(function()
            Remote.Favorite:FireServer(itemId)
        end)
    end
end

local function promptFavoriteGame()
    if Remote.FavoritePrompt then
        pcall(function()
            Remote.FavoritePrompt:InvokeServer()
        end)
    end
end

-- ====================================================================
--                     SIMPLE GUI
-- ====================================================================
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama
pcall(function() CoreGui:FindFirstChild("AutoFishV5"):Destroy() end)

-- Buat GUI baru
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishV5"
gui.Parent = CoreGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
title.Text = "🎣 AUTO FISH V5.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.Parent = title

close.MouseButton1Click:Connect(function()
    stopFishing()
    gui:Destroy()
end)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 45)
status.BackgroundTransparency = 1
status.Text = "⏹️ Stopped"
status.TextColor3 = Color3.fromRGB(255, 100, 100)
status.Font = Enum.Font.GothamBold
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

-- Remote status
local remoteStatus = Instance.new("TextLabel")
remoteStatus.Size = UDim2.new(1, -20, 0, 40)
remoteStatus.Position = UDim2.new(0, 10, 0, 70)
remoteStatus.BackgroundTransparency = 1
remoteStatus.Text = "Charge: ✅\nMinigame: ✅\nCatch: ✅"
remoteStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
remoteStatus.Font = Enum.Font.Gotham
remoteStatus.TextSize = 11
remoteStatus.TextXAlignment = Enum.TextXAlignment.Left
remoteStatus.TextWrapped = true
remoteStatus.Parent = frame

-- Start/Stop button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 120)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
toggleBtn.Text = "🚀 START FISHING"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Sell button
local sellBtn = Instance.new("TextButton")
sellBtn.Size = UDim2.new(0.9, 0, 0, 35)
sellBtn.Position = UDim2.new(0.05, 0, 0, 170)
sellBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
sellBtn.Text = "💰 SELL ALL ITEMS"
sellBtn.TextColor3 = Color3.new(1, 1, 1)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.Parent = frame

local sellCorner = Instance.new("UICorner")
sellCorner.CornerRadius = UDim.new(0, 6)
sellCorner.Parent = sellBtn

-- Delay input
local delayFrame = Instance.new("Frame")
delayFrame.Size = UDim2.new(0.9, 0, 0, 30)
delayFrame.Position = UDim2.new(0.05, 0, 0, 215)
delayFrame.BackgroundTransparency = 1
delayFrame.Parent = frame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.3, 0, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay:"
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayFrame

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.6, 0, 1, 0)
delayInput.Position = UDim2.new(0.4, 0, 0, 0)
delayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
delayInput.Text = "2"
delayInput.TextColor3 = Color3.new(1, 1, 1)
delayInput.Font = Enum.Font.Gotham
delayInput.Parent = delayFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = delayInput

-- ====================================================================
--                     BUTTON FUNCTIONS
-- ====================================================================
toggleBtn.MouseButton1Click:Connect(function()
    if isFishing then
        stopFishing()
        toggleBtn.Text = "🚀 START FISHING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        status.Text = "⏹️ Stopped"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        startFishing()
        toggleBtn.Text = "⏹️ STOP FISHING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        status.Text = "🎣 Fishing..."
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

sellBtn.MouseButton1Click:Connect(function()
    local success = sellAllItems()
    if success then
        status.Text = "💰 Sold!"
        task.wait(1)
        status.Text = isFishing and "🎣 Fishing..." or "⏹️ Stopped"
    end
end)

-- ====================================================================
--                     STARTUP
-- ====================================================================
print([[
╔════════════════════════════════════════╗
║     AUTO FISH V5.0 - READY             ║
║     Berdasarkan hasil scan!            ║
╚════════════════════════════════════════╝

✅ Remote fishing:
   - ChargeFishingRod
   - RequestFishingMinigameStarted
   - CatchFishCompleted
   - FishCaught

✅ Anti-cheat bypass:
   - UpdateAutoFishingState = false
   - MarkAutoFishingUsed = 0

✅ Sell: SellAllItems
✅ Favorite: FavoriteItem
]])

-- Update remote status
local chargeStatus = Remote.ChargeFishingRod and "✅" or "❌"
local minigameStatus = Remote.RequestMinigame and "✅" or "❌"
local catchStatus = Remote.CatchFishCompleted and "✅" or "❌"
remoteStatus.Text = string.format("Charge: %s\nMinigame: %s\nCatch: %s", 
    chargeStatus, minigameStatus, catchStatus)        end
    end)
    
    if success and rod.instance.Parent == LocalPlayer.Character then
        return true
    end
    
    -- Method 2: Paksa pakai Humanoid
    success = pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(rod.instance)
            print("✅ Method 2: Equip via Humanoid")
            return true
        end
    end)
    
    if success then return true end
    
    -- Method 3: Panggil remote equip (kalau ada)
    success = pcall(function()
        -- Cari remote equip
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:match("Equip") or obj.Name:match("Tool")) then
                obj:FireServer(rod.instance)
                print("✅ Method 3: Via remote " .. obj.Name)
                return true
            end
        end
    end)
    
    return false
end

-- ====================================================================
--                     UI ELEMENTS
-- ====================================================================
local yPos = 40

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, yPos)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Mencari rod..."
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame
yPos = yPos + 30

-- List rod
local rodList = Instance.new("ScrollingFrame")
rodList.Size = UDim2.new(1, -20, 0, 80)
rodList.Position = UDim2.new(0, 10, 0, yPos)
rodList.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
rodList.BorderSizePixel = 0
rodList.CanvasSize = UDim2.new(0, 0, 0, 0)
rodList.Parent = frame
yPos = yPos + 85

-- Tombol scan ulang
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.45, 0, 0, 30)
scanBtn.Position = UDim2.new(0.05, 0, 0, yPos)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
scanBtn.Text = "🔄 SCAN ULANG"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = frame

-- Tombol equip paksa
local forceBtn = Instance.new("TextButton")
forceBtn.Size = UDim2.new(0.45, 0, 0, 30)
forceBtn.Position = UDim2.new(0.5, 5, 0, yPos)
forceBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
forceBtn.Text = "⚡ EQUIP PAKSA"
forceBtn.TextColor3 = Color3.new(1, 1, 1)
forceBtn.Font = Enum.Font.GothamBold
forceBtn.Parent = frame
yPos = yPos + 35

-- Info tambahan
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 40)
infoLabel.Position = UDim2.new(0, 10, 0, yPos)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Pilih rod di atas, lalu klik EQUIP PAKSA"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.TextWrapped = true
infoLabel.Parent = frame

-- ====================================================================
--                     FUNGSI UPDATE LIST
-- ====================================================================
local selectedRod = nil
local rodButtons = {}

local function updateRodList()
    -- Clear list
    for _, btn in ipairs(rodButtons) do
        btn:Destroy()
    end
    rodButtons = {}
    
    local rods = findFishingRod()
    
    if #rods == 0 then
        statusLabel.Text = "Status: ❌ TIDAK ADA ROD DITEMUKAN!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Tampilkan semua tools yang ada
        local allTools = scanAllTools()
        local toolNames = {}
        for _, tool in ipairs(allTools) do
            table.insert(toolNames, tool.name)
        end
        
        if #toolNames > 0 then
            infoLabel.Text = "Tools ditemukan: " .. table.concat(toolNames, ", ")
        else
            infoLabel.Text = "Tidak ada tools sama sekali di inventory!"
        end
        return
    end
    
    statusLabel.Text = string.format("Status: ✅ %d rod ditemukan", #rods)
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- Buat tombol untuk setiap rod
    for i, rod in ipairs(rods) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.Position = UDim2.new(0, 5, 0, (i-1) * 27)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        btn.Text = string.format("%s (%s)", rod.name, rod.location)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = rodList
        
        btn.MouseButton1Click:Connect(function()
            -- Reset semua button
            for _, b in ipairs(rodButtons) do
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end
            -- Highlight yang dipilih
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            selectedRod = rod
            infoLabel.Text = "Dipilih: " .. rod.name .. " - Klik EQUIP PAKSA"
        end)
        
        table.insert(rodButtons, btn)
    end
    
    rodList.CanvasSize = UDim2.new(0, 0, 0, #rods * 27)
end

-- ====================================================================
--                     TOMBOL FUNCTIONS
-- ====================================================================
scanBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "Status: Scanning..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    updateRodList()
end)

forceBtn.MouseButton1Click:Connect(function()
    if not selectedRod then
        infoLabel.Text = "❌ Pilih rod dulu dari list di atas!"
        return
    end
    
    statusLabel.Text = "Status: ⚡ Memaksa equip " .. selectedRod.name
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local success = forceEquipRod(selectedRod)
    
    if success then
        statusLabel.Text = "Status: ✅ ROD TER-EQUIP!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        infoLabel.Text = "✅ Sukses! Rod sekarang di tangan"
        
        -- Cek apakah benar-benar kepegang
        task.wait(1)
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == selectedRod.name then
                    infoLabel.Text = "✅ TERKONFIRMASI: " .. tool.Name .. " ada di tangan"
                    break
                end
            end
        end
    else
        statusLabel.Text = "Status: ❌ GAGAL equip"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        infoLabel.Text = "❌ Semua metode equip gagal. " ..
                        "Coba klik SCAN ULANG dan pilih rod lain"
    end
end)

-- ====================================================================
--                     AUTO EQUIP PERTAMA KALI
-- ====================================================================
-- Coba equip otomatis rod pertama yang ditemukan
task.spawn(function()
    task.wait(1)
    updateRodList()
    
    task.wait(0.5)
    local rods = findFishingRod()
    if #rods > 0 then
        selectedRod = rods[1]
        infoLabel.Text = "Mencoba equip otomatis: " .. rods[1].name
        forceEquipRod(rods[1])
    end
end)

print([[
╔════════════════════════════════════════╗
║         ROD EQUIPMENT FIXER            ║
║           Untuk Delta HP               ║
╚════════════════════════════════════════╝

LANGKAH:
1. Lihat daftar rod di window
2. Klik nama rod yang ingin dipegang
3. Klik EQUIP PAKSA
4. Kalau berhasil, rod pindah ke tangan
]])
