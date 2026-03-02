-- Moe V1.0 GUI for FISH IT - Teleport Features Complete
-- Dengan semua lokasi dari list Anda

-- ===== DATA LOKASI TELEPORT =====
local TeleportLocations = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439, -0.977613986, -1.77645827e-08, 0.210406482, -2.42338203e-08, 1, -2.81680421e-08, -0.210406482, -3.26364251e-08, -0.977613986),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

-- ===== FUNGSI TELEPORT =====
local function teleportToLocation(locationName)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        notify("Teleport", "Character not found", 1)
        return
    end
    
    local cframe = TeleportLocations[locationName]
    if cframe then
        char.HumanoidRootPart.CFrame = cframe
        notify("Teleport", "Teleported to "..locationName, 2)
    else
        notify("Teleport", "Location not found", 1)
    end
end

local function teleportToNPC()
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and (npc.Name:find("NPC") or npc.Name:find("Merchant") or npc.Name:find("Trader")) then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local npcPos = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                if npcPos then
                    char.HumanoidRootPart.CFrame = npcPos.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to "..npc.Name, 2)
                    return
                end
            end
        end
    end
    notify("Teleport", "No NPC found", 1)
end

local function teleportToIsland()
    -- Coba pake remote game dulu
    local teleportRemote = getRemote("SubmarineTP") or getRemote("RE/SubmarineTP") or getRemote("RF/SubmarineTP2")
    if teleportRemote then
        teleportRemote:FireServer("MainIsland")
        notify("Teleport", "Teleported to Island (via remote)", 2)
    else
        -- Fallback ke lokasi yang sudah ditentukan
        teleportToLocation("Spawn")
    end
end

local function teleportToPlayer(targetPlayerName)
    local targetPlayer = nil
    if targetPlayerName then
        targetPlayer = game.Players:FindFirstChild(targetPlayerName)
    else
        -- Cari player pertama selain diri sendiri
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                targetPlayer = plr
                break
            end
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            notify("Teleport", "Teleported to "..targetPlayer.Name, 2)
            return true
        end
    end
    notify("Teleport", "Player not found", 1)
    return false
end

-- ===== DROPDOWN UNTUK PILIH LOKASI =====
local function createLocationDropdown(parent)
    local frame = Instance.new("Frame")
    frame.Name = "LocationDropdownFrame"
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "Pilih Lokasi Teleport"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = "LocationDropdownBtn"
    dropdownBtn.Size = UDim2.new(1, 0, 0, 35)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 25)
    dropdownBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownBtn.BackgroundTransparency = 0.3
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = "Pilih Lokasi"
    dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "LocationDropdownList"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 62)
    dropdownFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.FillDirection = Enum.FillDirection.Vertical
    dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    dropdownLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdownFrame
    
    -- Buat opsi dari TeleportLocations
    local locations = {}
    for name, _ in pairs(TeleportLocations) do
        table.insert(locations, name)
    end
    table.sort(locations)
    
    for _, locName in ipairs(locations) do
        local optBtn = Instance.new("TextButton")
        optBtn.Name = locName.."Option"
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.BorderSizePixel = 0
        optBtn.Text = "  "..locName
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.AutoButtonColor = false
        optBtn.Parent = dropdownFrame
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = locName
            dropdownFrame.Visible = false
            teleportToLocation(locName)
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
        local count = #locations
        dropdownFrame.Size = UDim2.new(1, 0, 0, count * 32 + 4)
    end)
    
    return dropdownBtn
end

-- ===== DROPDOWN UNTUK PILIH PLAYER =====
local function createPlayerDropdown(parent)
    local frame = Instance.new("Frame")
    frame.Name = "PlayerDropdownFrame"
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "Pilih Player Tujuan"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Name = "PlayerDropdownBtn"
    dropdownBtn.Size = UDim2.new(1, 0, 0, 35)
    dropdownBtn.Position = UDim2.new(0, 0, 0, 25)
    dropdownBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownBtn.BackgroundTransparency = 0.3
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = "Pilih Player"
    dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "PlayerDropdownList"
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 62)
    dropdownFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.FillDirection = Enum.FillDirection.Vertical
    dropdownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    dropdownLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdownFrame
    
    -- Fungsi untuk update daftar player
    local function updatePlayerList()
        -- Hapus semua opsi lama
        for _, child in pairs(dropdownFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Tambah player baru
        local players = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(players, plr.Name)
            end
        end
        table.sort(players)
        
        for _, plrName in ipairs(players) do
            local optBtn = Instance.new("TextButton")
            optBtn.Name = plrName.."Option"
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundTransparency = 1
            optBtn.BorderSizePixel = 0
            optBtn.Text = "  "..plrName
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 14
            optBtn.AutoButtonColor = false
            optBtn.Parent = dropdownFrame
            optBtn.ZIndex = 11
            
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                optBtn.BackgroundTransparency = 0.3
            end)
            
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundTransparency = 1
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = plrName
                dropdownFrame.Visible = false
                teleportToPlayer(plrName)
            end)
        end
        
        -- Update ukuran dropdown
        local count = #players
        dropdownFrame.Size = UDim2.new(1, 0, 0, count * 32 + 4)
    end
    
    -- Update setiap ada player yang join/leave
    game.Players.PlayerAdded:Connect(updatePlayerList)
    game.Players.PlayerRemoving:Connect(updatePlayerList)
    
    dropdownBtn.MouseButton1Click:Connect(function()
        updatePlayerList() -- Update sebelum muncul
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)
    
    return dropdownBtn
end

-- ===== KONTEN TELEPORT =====
local function createTeleportContent()
    -- Hapus konten lama
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Separator
    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(1, 0, 0, 20)
    sep1.BackgroundTransparency = 1
    sep1.BorderSizePixel = 0
    sep1.Parent = featuresContainer
    
    -- Dropdown Lokasi (dari list yang diberikan)
    createLocationDropdown(featuresContainer)
    
    -- Button Teleport ke NPC
    createButton(featuresContainer, "🚶 Teleport ke NPC", teleportToNPC)
    
    -- Button Teleport ke Island (via remote)
    createButton(featuresContainer, "🏝️ Teleport ke Island", teleportToIsland)
    
    -- Dropdown Player
    createPlayerDropdown(featuresContainer)
    
    -- Button Refresh Player List
    createButton(featuresContainer, "🔄 Refresh Player List", function()
        -- Trigger update dropdown dengan cara buka tutup
        local dropdown = featuresContainer:FindFirstChild("PlayerDropdownFrame")
        if dropdown then
            local btn = dropdown:FindFirstChild("PlayerDropdownBtn")
            if btn then
                btn.MouseButton1Click:Fire()
                task.wait(0.1)
                btn.MouseButton1Click:Fire()
            end
        end
        notify("Teleport", "Player list refreshed", 1)
    end)
    
    -- Separator untuk Save/Load
    local sep2 = Instance.new("Frame")
    sep2.Size = UDim2.new(1, 0, 0, 20)
    sep2.BackgroundTransparency = 1
    sep2.BorderSizePixel = 0
    sep2.Parent = featuresContainer
    
    local saveLabel = Instance.new("TextLabel")
    saveLabel.Size = UDim2.new(1, 0, 0, 30)
    saveLabel.BackgroundTransparency = 1
    saveLabel.Text = "📍 Save / Load Location"
    saveLabel.TextColor3 = Color3.new(1, 1, 1)
    saveLabel.Font = Enum.Font.GothamBold
    saveLabel.TextSize = 16
    saveLabel.Parent = featuresContainer
    
    -- Button Save Location
    createButton(featuresContainer, "💾 Save Current Location", function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            _G.SavedLocation = char.HumanoidRootPart.CFrame
            notify("Teleport", "Location saved!", 1)
        end
    end)
    
    -- Button Load Location
    createButton(featuresContainer, "📂 Load Saved Location", function()
        if _G.SavedLocation then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = _G.SavedLocation
                notify("Teleport", "Location loaded!", 1)
            end
        else
            notify("Teleport", "No location saved", 1)
        end
    end)
    
    -- Daftar Semua Lokasi (untuk referensi)
    local sep3 = Instance.new("Frame")
    sep3.Size = UDim2.new(1, 0, 0, 20)
    sep3.BackgroundTransparency = 1
    sep3.BorderSizePixel = 0
    sep3.Parent = featuresContainer
    
    local listLabel = Instance.new("TextLabel")
    listLabel.Size = UDim2.new(1, 0, 0, 30)
    listLabel.BackgroundTransparency = 1
    listLabel.Text = "📋 Daftar Semua Lokasi:"
    listLabel.TextColor3 = Color3.new(1, 1, 1)
    listLabel.Font = Enum.Font.GothamBold
    listLabel.TextSize = 14
    listLabel.TextXAlignment = Enum.TextXAlignment.Left
    listLabel.Parent = featuresContainer
    
    -- Tampilkan daftar lokasi dalam grid
    local locations = {}
    for name, _ in pairs(TeleportLocations) do
        table.insert(locations, name)
    end
    table.sort(locations)
    
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, #locations * 25)
    listFrame.BackgroundTransparency = 1
    listFrame.BorderSizePixel = 0
    listFrame.Parent = featuresContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame
    
    for _, locName in ipairs(locations) do
        local locLabel = Instance.new("TextLabel")
        locLabel.Size = UDim2.new(1, 0, 0, 20)
        locLabel.BackgroundTransparency = 1
        locLabel.Text = "  • "..locName
        locLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        locLabel.Font = Enum.Font.Gotham
        locLabel.TextSize = 12
        locLabel.TextXAlignment = Enum.TextXAlignment.Left
        locLabel.Parent = listFrame
    end
end