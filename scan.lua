-- ====================================================================
--     AUTO FISH v5.0 - DELTA HP EDITION (LANGSUNG PAKAI)
-- ====================================================================
-- Berdasarkan hash remote yang ditemukan di packet capture
-- ====================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- ====================================================================
--                     REMOTE HASH DARI CAPTURE
-- ====================================================================
-- Ini adalah hash remote yang dipanggil saat fishing manual
local REMOTE_HASHES = {
    -- Hash yang paling sering muncul di packet capture
    main = "c83da140199b695e0338dcfc521b0441f3a801823d9f178fb00791f708e9b837",
    secondary = "7b12f430cc70bc4e939d6032b967fa19647c80c2ae7396cf500f1e3113e07685",
    third = "2560f6f476bebf12c2e1410090e3e7ee9c45755de63c8b6acf8bd43af4a3612a"
}

-- Remote yang dikenal (dari hasil scan)
local KNOWN_REMOTES = {
    charge = "RF/ChargeFishingRod",
    minigame = "RF/RequestFishingMinigameStarted",
    cancel = "RF/CancelFishingInputs",
    fishCaught = "RE/FishCaught",
    autoFishing = "RF/UpdateAutoFishingState"
}

-- ====================================================================
--                     FIND REMOTE FUNCTION
-- ====================================================================
local function findRemote(pathOrHash)
    -- Coba cari berdasarkan path (contoh: "RF/ChargeFishingRod")
    if type(pathOrHash) == "string" and pathOrHash:find("/") then
        local parts = pathOrHash:split("/")
        local container = ReplicatedStorage
        
        for _, part in ipairs(parts) do
            container = container:FindFirstChild(part)
            if not container then break end
        end
        
        if container then
            return container
        end
    end
    
    -- Coba cari berdasarkan hash (nama remote)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
            if obj.Name == pathOrHash then
                return obj
            end
        end
    end
    
    return nil
end

-- ====================================================================
--                     GET ALL REMOTES
-- ====================================================================
local function getAllRemotes()
    local remotes = {
        -- Remote yang dikenal
        charge = findRemote(KNOWN_REMOTES.charge),
        minigame = findRemote(KNOWN_REMOTES.minigame),
        cancel = findRemote(KNOWN_REMOTES.cancel),
        fishCaught = findRemote(KNOWN_REMOTES.fishCaught),
        autoFishing = findRemote(KNOWN_REMOTES.autoFishing),
        
        -- Remote hash
        hashMain = findRemote(REMOTE_HASHES.main),
        hashSecondary = findRemote(REMOTE_HASHES.secondary),
        hashThird = findRemote(REMOTE_HASHES.third)
    }
    
    return remotes
end

-- ====================================================================
--                     ANTI-AFK
-- ====================================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ====================================================================
--                     FISHING FUNCTIONS
-- ====================================================================
local remotes = getAllRemotes()

-- Tampilkan remote yang ditemukan
print("\n🎣 AUTO FISH V5.0 - DELTA HP")
print("==================================")
for name, remote in pairs(remotes) do
    if remote then
        print("✅ " .. name .. ": " .. remote.Name)
    else
        print("❌ " .. name .. ": TIDAK DITEMUKAN")
    end
end
print("==================================\n")

-- Fungsi casting dengan berbagai method
local function castRod()
    local success = false
    
    -- METHOD 1: Pakai remote hash (paling sering muncul di capture)
    if remotes.hashMain and remotes.hashMain:IsA("RemoteFunction") then
        pcall(function()
            remotes.hashMain:InvokeServer()
            success = true
            print("🎣 Cast dengan hash main")
        end)
    end
    
    -- METHOD 2: Pakai ChargeFishingRod
    if not success and remotes.charge then
        pcall(function()
            if remotes.charge:IsA("RemoteFunction") then
                remotes.charge:InvokeServer(1755848498.4834)
            else
                remotes.charge:FireServer()
            end
            success = true
            print("🎣 Cast dengan ChargeFishingRod")
        end)
    end
    
    -- METHOD 3: Pakai minigame langsung
    if not success and remotes.minigame then
        pcall(function()
            if remotes.minigame:IsA("RemoteFunction") then
                remotes.minigame:InvokeServer(1.2854545116425, 1)
            else
                remotes.minigame:FireServer()
            end
            success = true
            print("🎣 Cast dengan RequestFishingMinigame")
        end)
    end
    
    return success
end

-- Fungsi reeling
local function reelIn()
    local success = false
    
    -- METHOD 1: Pakai hash secondary
    if remotes.hashSecondary then
        pcall(function()
            if remotes.hashSecondary:IsA("RemoteFunction") then
                remotes.hashSecondary:InvokeServer()
            else
                remotes.hashSecondary:FireServer()
            end
            success = true
            print("✅ Reel dengan hash secondary")
        end)
    end
    
    -- METHOD 2: Pakai FishCaught
    if not success and remotes.fishCaught then
        pcall(function()
            remotes.fishCaught:FireServer()
            success = true
            print("✅ Reel dengan FishCaught")
        end)
    end
    
    -- METHOD 3: Pakai hash main (kadang dipakai juga untuk reel)
    if not success and remotes.hashMain then
        pcall(function()
            if remotes.hashMain:IsA("RemoteFunction") then
                remotes.hashMain:InvokeServer()
            else
                remotes.hashMain:FireServer()
            end
            success = true
            print("✅ Reel dengan hash main")
        end)
    end
    
    return success
end

-- Fungsi untuk reset state
local function resetFishingState()
    if remotes.cancel then
        pcall(function()
            if remotes.cancel:IsA("RemoteFunction") then
                remotes.cancel:InvokeServer()
            else
                remotes.cancel:FireServer()
            end
        end)
    end
    
    -- Matikan auto fishing state kalau ada
    if remotes.autoFishing then
        pcall(function()
            if remotes.autoFishing:IsA("RemoteFunction") then
                remotes.autoFishing:InvokeServer(false)
            else
                remotes.autoFishing:FireServer(false)
            end
        end)
    end
end

-- ====================================================================
--                     UI SEDERHANA UNTUK DELTA HP
-- ====================================================================
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama kalau ada
pcall(function()
    CoreGui:FindFirstChild("AutoFishing"):Destroy()
end)

-- Buat GUI baru
local gui = Instance.new("ScreenGui")
gui.Name = "AutoFishing"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 10, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
title.Text = "🎣 AUTO FISH V5.0 (DELTA)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.Parent = title

close.MouseButton1Click:Connect(function()
    fishing = false
    gui:Destroy()
end)

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: STOPPED"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Remote info
local remoteLabel = Instance.new("TextLabel")
remoteLabel.Size = UDim2.new(1, -20, 0, 40)
remoteLabel.Position = UDim2.new(0, 10, 0, 60)
remoteLabel.BackgroundTransparency = 1
remoteLabel.Text = "Remote: Menyiapkan..."
remoteLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
remoteLabel.Font = Enum.Font.Gotham
remoteLabel.TextSize = 10
remoteLabel.TextWrapped = true
remoteLabel.TextXAlignment = Enum.TextXAlignment.Left
remoteLabel.Parent = frame

-- Hitung remote yang ditemukan
local foundCount = 0
for _, v in pairs(remotes) do
    if v then foundCount = foundCount + 1 end
end
remoteLabel.Text = string.format("Remote ditemukan: %d/8\nHash: %s", foundCount, remotes.hashMain and "✅" or "❌")

-- Tombol Start/Stop
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 110)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
toggleBtn.Text = "START FISHING"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = frame

-- Counter
local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -20, 0, 20)
counterLabel.Position = UDim2.new(0, 10, 0, 150)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Cycle: 0 | Catch: 0"
counterLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
counterLabel.Font = Enum.Font.Gotham
counterLabel.TextSize = 10
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = frame

-- ====================================================================
--                     FISHING LOOP
-- ====================================================================
local fishing = false
local cycleCount = 0
local catchCount = 0

local function fishingLoop()
    while fishing do
        cycleCount = cycleCount + 1
        counterLabel.Text = string.format("Cycle: %d | Catch: %d", cycleCount, catchCount)
        
        -- Reset state dulu
        resetFishingState()
        task.wait(0.1)
        
        -- Cast
        statusLabel.Text = "Status: CASTING..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        local castSuccess = castRod()
        
        if castSuccess then
            task.wait(2) -- Tunggu ikan (sesuaikan)
            
            -- Reel
            statusLabel.Text = "Status: REELING..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            local reelSuccess = reelIn()
            
            if reelSuccess then
                catchCount = catchCount + 1
            end
            
            task.wait(1) -- Cooldown
        else
            statusLabel.Text = "Status: CAST FAILED"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
        end
    end
end

-- Tombol toggle
toggleBtn.MouseButton1Click:Connect(function()
    fishing = not fishing
    
    if fishing then
        toggleBtn.Text = "STOP FISHING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Status: FISHING..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Reset counters
        cycleCount = 0
        catchCount = 0
        
        -- Start loop
        task.spawn(fishingLoop)
    else
        toggleBtn.Text = "START FISHING"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        statusLabel.Text = "Status: STOPPED"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

print("✅ AUTO FISH V5.0 READY - Tekan START FISHING untuk mulai")