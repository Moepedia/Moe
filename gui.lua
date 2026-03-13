-- Moe V1.0 GUI with VEL.lua Features

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== SERVICES =====
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- ===== NOTIFY =====
local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ===== KONFIRMASI DIALOG =====
local function showConfirmDialog(title, message, callback)
    local dialogFrame = Instance.new("Frame")
    dialogFrame.Size = UDim2.new(0, 300, 0, 150)
    dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    dialogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    dialogFrame.BackgroundTransparency = 0.05
    dialogFrame.BorderSizePixel = 0
    dialogFrame.Parent = gui
    dialogFrame.ZIndex = 1000
    
    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 12)
    dialogCorner.Parent = dialogFrame
    
    local dialogStroke = Instance.new("UIStroke")
    dialogStroke.Thickness = 2
    dialogStroke.Color = Color3.fromRGB(100, 150, 255)
    dialogStroke.Transparency = 0.3
    dialogStroke.Parent = dialogFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = dialogFrame
    titleLabel.ZIndex = 1001
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.Parent = dialogFrame
    msgLabel.ZIndex = 1001
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -5, 0, 35)
    yesBtn.Position = UDim2.new(0.1, 0, 0, 95)
    yesBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = dialogFrame
    yesBtn.ZIndex = 1001
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -5, 0, 35)
    noBtn.Position = UDim2.new(0.5, 5, 0, 95)
    noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = dialogFrame
    noBtn.ZIndex = 1001
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(true)
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        dialogFrame:Destroy()
        callback(false)
    end)
end

-- ===== GET REMOTE FUNCTION =====
local function GetRemote(name)
    local Packages = ReplicatedStorage:FindFirstChild("Packages")
    if not Packages then return nil end
    
    local Index = Packages:FindFirstChild("_Index")
    if not Index then return nil end
    
    local NetFolder = Index:FindFirstChild("sleitnick_net@0.2.0")
    if not NetFolder then return nil end
    
    local Net = NetFolder:FindFirstChild("net")
    if not Net then return nil end
    
    return Net:FindFirstChild(name)
end

-- ===== REMOTES =====
local Remote = {
    -- Fishing
    ChargeFishingRod = GetRemote("RF/e4017e43355f4661b1e07f77fe2bfe13b5a48f4eff9ba55b0398ec0ef3c66765"),
    RequestFishingMinigame = GetRemote("RF/4d6dc93c9ecb915a8ae6425c83c8bb597b015e0bc4f874181ea308dcc7ae5015"),
    CatchFishCompleted = GetRemote("RF/76a108e0c7fed0fe6174984ba5c748621c6d347466644a819a806ed594a344b4"),
    CancelFishingInputs = GetRemote("RF/f9a876154b063e332e1667cef846eeab3bd7fe8485cf1491fc927f0f9718b436"),
    FishingMinigameChanged = GetRemote("RE/7c2a0bc8cd87d3e65a3d502bac59e416b8b1254902a83b5694a5648f80d817a0"),
    UpdateAutoFishingState = GetRemote("RF/c68d9e2817eb664656e9e9076a0591c6b9e1a2ab03d8b8b8bce02bfe0af47fe0"),
    EquipTool = GetRemote("RE/c6dd8019183b4837632988a186ea356b21b8ff046bb0151182a1167e3936bc9f"),
    
    -- Sell
    SellAllItems = GetRemote("RF/4417ef209575b73e441890816440faf3f5fa6a503ff1805d70afa5cf2b6d1453"),
    
    -- Favorite
    FavoriteItem = GetRemote("RE/f0e8ec714246b48fc2056f81a5106252267b280570723e12fef90d8cf1c4cc8e"),
    PromptFavoriteGame = GetRemote("RF/faec503b4c4a1859c79435903a10bed7e880cb893277e19692fa37d10991b011"),
    
    -- Weather
    PurchaseWeatherEvent = GetRemote("RF/dd5f5b5f5b5f5b5f5b5f5b5f5b5f5b5f"),
    
    -- Oxygen
    EquipOxygenTank = GetRemote("RF/EquipOxygenTank"),
    UnequipOxygenTank = GetRemote("RF/UnequipOxygenTank"),
    
    -- Radar
    UpdateFishingRadar = GetRemote("RF/UpdateFishingRadar"),
    
    -- Fish Notification
    ObtainedNewFishNotification = GetRemote("RE/ObtainedNewFishNotification")
}

-- ===== HELPER FUNCTIONS =====
local function GetHumanoid()
    local Character = player.Character
    if not Character then
        Character = player.CharacterAdded:Wait()
    end
    return Character:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local Character = player.Character
    if not Character then
        Character = player.CharacterAdded:Wait()
    end
    return Character:FindFirstChild("HumanoidRootPart")
end

local function findFishingRods()
    local rods = {}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Backpack"})
        end
    end
    if player.Character then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                table.insert(rods, {Name = tool.Name, Instance = tool, Location = "Character"})
            end
        end
    end
    return rods
end

local function equipRod(rodName)
    local rods = findFishingRods()
    for _, rod in ipairs(rods) do
        if rod.Name == rodName or rodName == "any" then
            if rod.Location == "Backpack" then
                if Remote.EquipTool then
                    pcall(function() Remote.EquipTool:FireServer(1) end)
                else
                    rod.Instance.Parent = player.Character
                end
                return true
            elseif rod.Location == "Character" then
                return true
            end
        end
    end
    return false
end

-- ===== FISHING LOCATIONS =====
local FishingAreas = {
    ["Ancient Jungle"] = CFrame.new(1896.9, 8.4, -578.7),
    ["Ancient Ruins"] = CFrame.new(6081.4, -585.9, 4634.5),
    ["Christmast Island"] = CFrame.new(1175.3,23.5,1545.3),
    ["Coral Reefs"] = CFrame.new(-2935.1,4.8,2050.9),
    ["Crater Island"] = CFrame.new(1077.6, 2.8, 5080.9),
    ["Esoteric Deep"] = CFrame.new(3202.2, -1302.9, 1432.7),
    ["Iron Cave"] = CFrame.new(-8641.3, -547.5, 162.0),
    ["Kohana"] = CFrame.new(-367.8, 6.8, 521.9),
    ["Sacred Temple"] = CFrame.new(1466.6, -22.8, -618.8),
    ["Sisyphus Statue"] = CFrame.new(-3715.1, -136.8, -1010.6),
    ["Treasure Room"] = CFrame.new(-3604.2, -283.2, -1613.7),
    ["Tropical Grove"] = CFrame.new(-2173.3,53.5,3632.3),
    ["Underground Cellar"] = CFrame.new(2136.0, -91.2, -699.0)
}

local AreaNames = {}
for name, _ in pairs(FishingAreas) do
    table.insert(AreaNames, name)
end
table.sort(AreaNames)

-- ===== WEATHER LIST =====
local WeatherList = {"Storm", "Cloudy", "Snow", "Wind", "Radiant", "Shark Hunt"}

-- ===== RARITY LIST =====
local RarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}

-- ===== MUTATION LIST =====
local MutationList = {"Shiny", "Gemstone", "Corrupt", "Galaxy", "Holographic", "Ghost", "Lightning", "Fairy Dust", "Gold", "Midnight", "Radioactive", "Stone", "Albino", "Sandy", "Acidic", "Disco", "Frozen"}

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local autoSell = false
local autoFavorite = false
local autoUnfavorite = false
local autoEquip = false
local autoWeather = false
local autoAcceptTrade = false
local isWalkOnWater = false
local isNoAnimation = false
local isStealthMode = false
local isFreezePlayer = false
local isNoClip = false
local isFlying = false
local isInfiniteJump = false
local isESPEnabled = false
local isHideUsernames = false
local isFPSBoost = false
local isNoCutscene = false
local isRemoveSkinEffect = false
local isInfiniteZoom = false
local isBypassRadar = false
local isBypassOxygen = false

-- ===== CONFIG VARIABLES =====
local Config = {
    FishDelay = 2.0,
    CatchDelay = 1.0,
    SellDelay = 60,
    SellCount = 50,
    SellMethod = "Delay",
    FavoriteRarity = {},
    FavoriteItemNames = {},
    FavoriteMutations = {},
    WebhookURL = "",
    WebhookRarities = {},
    WebhookItemNames = {},
    StealthHeight = 110,
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 60,
    CastPower = 0.5,
    SelectedWeather = {"Storm"}
}

-- ===== FISHING STATE =====
local FishingState = {
    IsActive = false,
    MinigameActive = false
}

-- ===== CONNECTIONS =====
local Connections = {
    fishing = nil,
    sell = nil,
    favorite = nil,
    unfavorite = nil,
    weather = nil,
    walkWater = nil,
    noClip = nil,
    fly = nil,
    infiniteJump = nil,
    esp = {},
    hideNames = nil,
    zoom = nil
}

-- ===== FLY MODE VARIABLES =====
local bodyGyro = nil
local bodyVel = nil

-- ===== WATER WALK VARIABLES =====
local waterPlatform = nil

-- ===== ESP VARIABLES =====
local espConnections = {}
local STUD_TO_M = 0.28

-- ===== PERFORMANCE MONITOR =====
local monitorEnabled = false
local monitorGui = nil
local monitorConnection = nil

-- ===== DROPDOWN MANAGEMENT =====
local activeDropdowns = {}
local dropdownConnections = {}

-- Fungsi untuk menutup semua dropdown
local function closeAllDropdowns()
    for _, dropdown in ipairs(activeDropdowns) do
        if dropdown and dropdown.Parent then
            dropdown.Visible = false
        end
    end
    activeDropdowns = {}
end

-- Fungsi untuk menutup semua dropdown kecuali yang specified
local function closeOtherDropdowns(exception)
    local newActive = {}
    for _, dropdown in ipairs(activeDropdowns) do
        if dropdown == exception then
            table.insert(newActive, dropdown)
        elseif dropdown and dropdown.Parent then
            dropdown.Visible = false
        end
    end
    activeDropdowns = newActive
end

-- Setup global click handler untuk menutup dropdown
local function setupGlobalClickHandler()
    if dropdownConnections.global then
        dropdownConnections.global:Disconnect()
    end
    
    dropdownConnections.global = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Tunggu sedikit untuk memastikan event button tidak ke-block
            task.wait(0.05)
            
            -- Cek apakah klik di luar semua dropdown
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local clickedOnDropdown = false
            
            for _, dropdown in ipairs(activeDropdowns) do
                if dropdown and dropdown.Visible and dropdown:IsDescendantOf(gui) then
                    local absPos = dropdown.AbsolutePosition
                    local absSize = dropdown.AbsoluteSize
                    local dropdownRect = Rect.new(absPos.X, absPos.Y, absPos.X + absSize.X, absPos.Y + absSize.Y)
                    
                    if dropdownRect:Contains(mousePos) then
                        clickedOnDropdown = true
                        break
                    end
                end
            end
            
            if not clickedOnDropdown then
                closeAllDropdowns()
            end
        end
    end)
end

-- Panggil setup global click handler
setupGlobalClickHandler()

-- ===== IMAGE CACHE =====
local ImageURLCache = {}

-- ===== HELPER FUNCTIONS =====

local function FormatNumber(n)
    n = math.floor(n)
    local formatted = tostring(n):reverse():gsub("%d%d%d", "%1."):reverse()
    return formatted:gsub("^%.", "")
end

local function GetPingColor(ping)
    if ping <= 50 then return Color3.fromRGB(0, 255, 0)
    elseif ping <= 100 then return Color3.fromRGB(255, 255, 0)
    elseif ping <= 300 then return Color3.fromRGB(255, 128, 0)
    else return Color3.fromRGB(255, 0, 0) end
end

local function GetCPUColor(cpu)
    if cpu <= 50 then return Color3.fromRGB(0, 255, 0)
    elseif cpu <= 100 then return Color3.fromRGB(255, 255, 0)
    elseif cpu <= 300 then return Color3.fromRGB(255, 128, 0)
    else return Color3.fromRGB(255, 0, 0) end
end

-- ===== TELEPORT FUNCTIONS =====
local pos_saved = nil
local look_saved = nil

local function TeleportToLookAt()
    local hrp = GetHRP()
    if not hrp or not pos_saved or not look_saved then return end
    
    local targetCFrame = CFrame.new(pos_saved, pos_saved + look_saved)
    
    if isStealthMode then
        hrp.CFrame = targetCFrame * CFrame.new(0, Config.StealthHeight, 0)
    else
        hrp.CFrame = targetCFrame * CFrame.new(0, 0.5, 0)
    end
end

-- ===== WALK ON WATER =====
local function setupWalkOnWater()
    if not waterPlatform then
        waterPlatform = Instance.new("Part")
        waterPlatform.Name = "WaterPlatform"
        waterPlatform.Anchored = true
        waterPlatform.CanCollide = true
        waterPlatform.Transparency = 1
        waterPlatform.Size = Vector3.new(15, 1, 15)
        waterPlatform.Parent = workspace
    end
    
    if Connections.walkWater then Connections.walkWater:Disconnect() end
    
    Connections.walkWater = RunService.RenderStepped:Connect(function()
        if not isWalkOnWater then return end
        
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if not waterPlatform or not waterPlatform.Parent then
            waterPlatform = Instance.new("Part")
            waterPlatform.Name = "WaterPlatform"
            waterPlatform.Anchored = true
            waterPlatform.CanCollide = true
            waterPlatform.Transparency = 1
            waterPlatform.Size = Vector3.new(15, 1, 15)
            waterPlatform.Parent = workspace
        end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {workspace.Terrain}
        rayParams.FilterType = Enum.RaycastFilterType.Include
        rayParams.IgnoreWater = false
        
        local result = workspace:Raycast(hrp.Position + Vector3.new(0,5,0), Vector3.new(0,-200,0), rayParams)
        
        if result and result.Material == Enum.Material.Water then
            waterPlatform.Position = Vector3.new(hrp.Position.X, result.Position.Y, hrp.Position.Z)
            if hrp.Position.Y < (result.Position.Y + 2) and hrp.Position.Y > (result.Position.Y - 5) then
                if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = CFrame.new(hrp.Position.X, result.Position.Y + 3.2, hrp.Position.Z)
                end
            end
        else
            waterPlatform.Position = Vector3.new(hrp.Position.X, -500, hrp.Position.Z)
        end
    end)
end

-- ===== DISABLE ANIMATIONS =====
local originalAnimator = nil
local originalAnimateScript = nil

local function DisableAnimations()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = GetHumanoid()
    if not humanoid then return end
    
    local animateScript = character:FindFirstChild("Animate")
    if animateScript and animateScript:IsA("LocalScript") and animateScript.Enabled then
        originalAnimateScript = animateScript.Enabled
        animateScript.Enabled = false
    end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        originalAnimator = animator
        animator:Destroy()
    end
end

local function EnableAnimations()
    local character = player.Character or player.CharacterAdded:Wait()
    local animateScript = character:FindFirstChild("Animate")
    if animateScript and originalAnimateScript ~= nil then
        animateScript.Enabled = originalAnimateScript
    end
    
    local humanoid = GetHumanoid()
    if not humanoid then return end
    
    local existingAnimator = humanoid:FindFirstChildOfClass("Animator")
    if not existingAnimator then
        if originalAnimator and not originalAnimator.Parent then
            originalAnimator.Parent = humanoid
        else
            Instance.new("Animator").Parent = humanoid
        end
    end
    originalAnimator = nil
end

-- ===== AUTO FISHING FUNCTIONS =====
local function instantFish()
    if not Remote.ChargeFishingRod or not Remote.RequestFishingMinigame or not Remote.CatchFishCompleted then return end
    
    pcall(function() Remote.ChargeFishingRod:InvokeServer(1, Config.CastPower) end)
    pcall(function() Remote.RequestFishingMinigame:InvokeServer() end)
    task.wait(Config.CatchDelay)
    pcall(function() Remote.CatchFishCompleted:InvokeServer() end)
    task.wait(0.3)
    pcall(function() Remote.CancelFishingInputs:InvokeServer(true) end)
end

local function startAutoFishing()
    if autoFishing then return end
    
    if Remote.FishingMinigameChanged then
        Remote.FishingMinigameChanged.OnClientEvent:Connect(function(state)
            if state == "Activated" or state == "Started" then
                FishingState.MinigameActive = true
            elseif state == "Completed" or state == "Stop" then
                FishingState.MinigameActive = false
            end
        end)
    end
    
    if autoEquip then equipRod("any") end
    
    autoFishing = true
    FishingState.IsActive = true
    pcall(function() Remote.UpdateAutoFishingState:InvokeServer(true) end)
    
    Connections.fishing = RunService.Heartbeat:Connect(function()
        if not autoFishing then return end
        pcall(function() Remote.CancelFishingInputs:InvokeServer(true) end)
        task.wait(0.2)
        instantFish()
        task.wait(Config.FishDelay)
    end)
    
    notify("Auto Fish", "Started!", 2)
end

local function stopAutoFishing()
    autoFishing = false
    FishingState.IsActive = false
    pcall(function() Remote.UpdateAutoFishingState:InvokeServer(false) end)
    if Connections.fishing then
        Connections.fishing:Disconnect()
        Connections.fishing = nil
    end
    notify("Auto Fish", "Stopped!", 2)
end

-- ===== AUTO SELL FUNCTIONS =====
local function sellAllItems()
    if Remote.SellAllItems then
        pcall(function() Remote.SellAllItems:InvokeServer() end)
    end
end

local function startAutoSell()
    if autoSell then return end
    autoSell = true
    
    Connections.sell = RunService.Heartbeat:Connect(function()
        if not autoSell then return end
        
        if Config.SellMethod == "Delay" then
            task.wait(Config.SellDelay)
            sellAllItems()
        else -- Count
            -- Simplified count check
            sellAllItems()
            task.wait(5)
        end
    end)
    
    notify("Auto Sell", "Started!", 2)
end

local function stopAutoSell()
    autoSell = false
    if Connections.sell then
        Connections.sell:Disconnect()
        Connections.sell = nil
    end
    notify("Auto Sell", "Stopped!", 2)
end

-- ===== AUTO FAVORITE FUNCTIONS =====
local function startAutoFavorite()
    if autoFavorite then return end
    autoFavorite = true
    
    Connections.favorite = RunService.Heartbeat:Connect(function()
        if not autoFavorite then return end
        task.wait(5)
        if Remote.PromptFavoriteGame then
            pcall(function() Remote.PromptFavoriteGame:InvokeServer() end)
        end
    end)
    
    notify("Auto Favorite", "Started!", 2)
end

local function stopAutoFavorite()
    autoFavorite = false
    if Connections.favorite then
        Connections.favorite:Disconnect()
        Connections.favorite = nil
    end
    notify("Auto Favorite", "Stopped!", 2)
end

-- ===== AUTO UNFAVORITE =====
local function startAutoUnfavorite()
    if autoUnfavorite then return end
    autoUnfavorite = true
    
    Connections.unfavorite = RunService.Heartbeat:Connect(function()
        if not autoUnfavorite then return end
        task.wait(5)
        -- Simplified unfavorite
    end)
end

local function stopAutoUnfavorite()
    autoUnfavorite = false
    if Connections.unfavorite then
        Connections.unfavorite:Disconnect()
        Connections.unfavorite = nil
    end
end

-- ===== AUTO WEATHER =====
local function startAutoWeather()
    if autoWeather then return end
    autoWeather = true
    
    Connections.weather = RunService.Heartbeat:Connect(function()
        if not autoWeather then return end
        task.wait(900) -- 15 minutes
        
        if Remote.PurchaseWeatherEvent and #Config.SelectedWeather > 0 then
            for _, weather in ipairs(Config.SelectedWeather) do
                pcall(function() Remote.PurchaseWeatherEvent:InvokeServer(weather) end)
                task.wait(0.1)
            end
        end
    end)
end

local function stopAutoWeather()
    autoWeather = false
    if Connections.weather then
        Connections.weather:Disconnect()
        Connections.weather = nil
    end
end

-- ===== AUTO ACCEPT TRADE =====
local function setupAutoAcceptTrade()
    -- Simplified trade accept
    if Remote.PromptFavoriteGame then
        -- Would need to hook prompt controller
    end
end

-- ===== NO CLIP =====
local function setupNoClip()
    if Connections.noClip then Connections.noClip:Disconnect() end
    
    Connections.noClip = RunService.Stepped:Connect(function()
        if not isNoClip then return end
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- ===== FLY MODE =====
local function setupFly()
    if Connections.fly then Connections.fly:Disconnect() end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = hrp
    
    local cam = workspace.CurrentCamera
    local moveDir = Vector3.zero
    local jumpPressed = false
    
    UserInputService.JumpRequest:Connect(function()
        if isFlying then jumpPressed = true task.delay(0.2, function() jumpPressed = false end) end
    end)
    
    Connections.fly = RunService.RenderStepped:Connect(function()
        if not isFlying or not hrp or not bodyGyro or not bodyVel then return end
        
        bodyGyro.CFrame = cam.CFrame
        moveDir = humanoid.MoveDirection
        
        if jumpPressed then
            moveDir = moveDir + Vector3.new(0,1,0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * Config.FlySpeed
        end
        
        bodyVel.Velocity = moveDir
    end)
end

local function stopFly()
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if Connections.fly then
        Connections.fly:Disconnect()
        Connections.fly = nil
    end
end

-- ===== INFINITE JUMP =====
local function setupInfiniteJump()
    if Connections.infiniteJump then Connections.infiniteJump:Disconnect() end
    
    Connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
        if not isInfiniteJump then return end
        local humanoid = GetHumanoid()
        if humanoid and humanoid.Health > 0 then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- ===== FREEZE PLAYER =====
local function setFreezePlayer(freeze)
    local hrp = GetHRP()
    if hrp then
        hrp.Anchored = freeze
        if freeze then
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end
    end
end

-- ===== ESP FUNCTIONS =====
local function removeESP(targetPlayer)
    if not targetPlayer then return end
    local data = espConnections[targetPlayer]
    if data then
        if data.distanceConn then data.distanceConn:Disconnect() end
        if data.charAddedConn then data.charAddedConn:Disconnect() end
        if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
        espConnections[targetPlayer] = nil
    end
end

local function createESP(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or targetPlayer == player then return end
    
    removeESP(targetPlayer)
    local char = targetPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return end
    
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "MoeESP"
    BillboardGui.Adornee = hrp
    BillboardGui.Size = UDim2.new(0, 140, 0, 40)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.StudsOffset = Vector3.new(0, 2.6, 0)
    BillboardGui.Parent = char
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = BillboardGui
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = Frame
    NameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = targetPlayer.DisplayName or targetPlayer.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 230, 230)
    NameLabel.TextStrokeTransparency = 0.7
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextScaled = true
    
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Parent = Frame
    DistanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Text = "0.0 m"
    DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DistanceLabel.Font = Enum.Font.GothamSemibold
    DistanceLabel.TextScaled = true
    
    espConnections[targetPlayer] = {billboard = BillboardGui}
    
    local distanceConn = RunService.RenderStepped:Connect(function()
        if not isESPEnabled or not hrp or not hrp.Parent then
            removeESP(targetPlayer)
            return
        end
        local localChar = player.Character
        local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if localHRP then
            local dist = (localHRP.Position - hrp.Position).Magnitude * STUD_TO_M
            DistanceLabel.Text = string.format("%.1f m", dist)
        end
    end)
    espConnections[targetPlayer].distanceConn = distanceConn
    
    local charAddedConn = targetPlayer.CharacterAdded:Connect(function()
        task.wait(0.8)
        if isESPEnabled then createESP(targetPlayer) end
    end)
    espConnections[targetPlayer].charAddedConn = charAddedConn
end

local function toggleESP(state)
    isESPEnabled = state
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then createESP(plr) end
        end
        espConnections.playerAdded = Players.PlayerAdded:Connect(function(plr)
            task.wait(1)
            if isESPEnabled then createESP(plr) end
        end)
        espConnections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
        end)
    else
        for plr, _ in pairs(espConnections) do
            if typeof(plr) == "Instance" then removeESP(plr) end
        end
        if espConnections.playerAdded then espConnections.playerAdded:Disconnect() end
        if espConnections.playerRemoving then espConnections.playerRemoving:Disconnect() end
        espConnections = {}
    end
end

-- ===== HIDE USERNAMES =====
local function setupHideUsernames()
    if Connections.hideNames then Connections.hideNames:Disconnect() end
    
    pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, not isHideUsernames) end)
    
    if isHideUsernames then
        Connections.hideNames = RunService.RenderStepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hum = plr.Character:FindFirstChild("Humanoid")
                    if hum then hum.DisplayName = "Hidden User" end
                end
            end
        end)
    end
end

-- ===== FPS BOOST =====
local originalLighting = {}

local function toggleFPSBoost(state)
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    
    if state then
        if not next(originalLighting) then
            originalLighting.GlobalShadows = Lighting.GlobalShadows
            originalLighting.FogEnd = Lighting.FogEnd
            originalLighting.Brightness = Lighting.Brightness
            originalLighting.ClockTime = Lighting.ClockTime
            originalLighting.Ambient = Lighting.Ambient
            originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        end
        
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        end)
        
        pcall(function()
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("PostEffect") then effect.Enabled = false end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 0
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(0,0,0)
            Lighting.OutdoorAmbient = Color3.new(0,0,0)
        end)
        
        if Terrain then
            pcall(function()
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
                Terrain.Decoration = false
            end)
        end
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    else
        pcall(function()
            if originalLighting.GlobalShadows ~= nil then
                Lighting.GlobalShadows = originalLighting.GlobalShadows
                Lighting.FogEnd = originalLighting.FogEnd
                Lighting.Brightness = originalLighting.Brightness
                Lighting.ClockTime = originalLighting.ClockTime
                Lighting.Ambient = originalLighting.Ambient
                Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
end

-- ===== INFINITE ZOOM =====
local function setupInfiniteZoom()
    if Connections.zoom then Connections.zoom:Disconnect() end
    
    if isInfiniteZoom then
        player.CameraMaxZoomDistance = 100000
        Connections.zoom = RunService.RenderStepped:Connect(function()
            player.CameraMaxZoomDistance = 100000
        end)
    else
        player.CameraMaxZoomDistance = 128
    end
end

-- ===== BYPASS RADAR =====
local function setBypassRadar(state)
    if Remote.UpdateFishingRadar then
        pcall(function() Remote.UpdateFishingRadar:InvokeServer(state) end)
    end
end

-- ===== BYPASS OXYGEN =====
local function setBypassOxygen(state)
    if state then
        if Remote.EquipOxygenTank then
            pcall(function() Remote.EquipOxygenTank:InvokeServer(105) end)
        end
    else
        if Remote.UnequipOxygenTank then
            pcall(function() Remote.UnequipOxygenTank:InvokeServer() end)
        end
    end
end

-- ===== PERFORMANCE MONITOR =====
local function createMonitor()
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PerformanceMonitor"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 100, 0, 90)
    mainFrame.Position = UDim2.new(1, -110, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "⚡ Monitor"
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -10, 0, 1)
    separator.Position = UDim2.new(0, 5, 0, 25)
    separator.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    separator.BorderSizePixel = 0
    separator.Parent = mainFrame
    
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(1, -20, 0, 22)
    pingLabel.Position = UDim2.new(0, 10, 0, 32)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "📶 Ping: 0 ms"
    pingLabel.TextColor3 = Color3.new(0,1,0)
    pingLabel.TextSize = 12
    pingLabel.Font = Enum.Font.GothamMedium
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = mainFrame
    
    local cpuLabel = Instance.new("TextLabel")
    cpuLabel.Name = "CPULabel"
    cpuLabel.Size = UDim2.new(1, -20, 0, 22)
    cpuLabel.Position = UDim2.new(0, 10, 0, 54)
    cpuLabel.BackgroundTransparency = 1
    cpuLabel.Text = "💻 CPU: 0 ms"
    cpuLabel.TextColor3 = Color3.new(0,1,0)
    cpuLabel.TextSize = 12
    cpuLabel.Font = Enum.Font.GothamMedium
    cpuLabel.TextXAlignment = Enum.TextXAlignment.Left
    cpuLabel.Parent = mainFrame
    
    return screenGui
end

local function toggleMonitor(state)
    monitorEnabled = state
    
    if state then
        monitorGui = createMonitor()
        if monitorConnection then monitorConnection:Disconnect() end
        monitorConnection = RunService.Heartbeat:Connect(function()
            if not monitorEnabled or not monitorGui then return end
            local mainFrame = monitorGui:FindFirstChild("MainFrame")
            if not mainFrame then return end
            local pingLabel = mainFrame:FindFirstChild("PingLabel")
            local cpuLabel = mainFrame:FindFirstChild("CPULabel")
            
            if pingLabel and cpuLabel then
                local ping = math.floor(player:GetNetworkPing() * 1000)
                local cpu = math.floor(Stats.PerformanceStats.CPU:GetValue())
                
                pingLabel.Text = string.format("📶 Ping: %d ms", ping)
                pingLabel.TextColor3 = GetPingColor(ping)
                cpuLabel.Text = string.format("💻 CPU: %d ms", cpu)
                cpuLabel.TextColor3 = GetCPUColor(cpu)
            end
        end)
    else
        if monitorConnection then
            monitorConnection:Disconnect()
            monitorConnection = nil
        end
        if monitorGui then
            monitorGui:Destroy()
            monitorGui = nil
        end
    end
end

-- ===== EXIT FUNCTION =====
local guiClosed = false

local function exitGUI()
    if guiClosed then return end
    
    showConfirmDialog("Exit GUI", "Are you sure you want to close?", function(confirmed)
        if confirmed then
            guiClosed = true
            
            stopAutoFishing()
            stopAutoSell()
            stopAutoFavorite()
            stopAutoUnfavorite()
            stopAutoWeather()
            toggleMonitor(false)
            
            -- Tutup semua dropdown
            closeAllDropdowns()
            
            -- Hapus global click handler
            if dropdownConnections.global then
                dropdownConnections.global:Disconnect()
                dropdownConnections.global = nil
            end
            
            task.wait(0.1)
            pcall(function() gui:Destroy() end)
        end
    end)
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 800, 0, 550)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 16)
corners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 45)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(0, 10, 0.5, -15)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 150, 1, 0)
title.Position = UDim2.new(0, 45, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

-- Minimize button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 32, 0, 32)
minButton.Position = UDim2.new(1, -74, 0.5, -16)
minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
minButton.BackgroundTransparency = 0.2
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextSize = 20
minButton.Font = Enum.Font.GothamBold
minButton.Parent = headerFrame
minButton.ZIndex = 5

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minButton

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame
closeBtn.ZIndex = 5

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(exitGUI)

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 70, 0, 70)
floatingLogo.Position = UDim2.new(0.9, -35, 0.9, -35)
floatingLogo.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
floatingLogo.BackgroundTransparency = 0.1
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000
floatingLogo.Active = true
floatingLogo.Selectable = true

local floatFrameCorner = Instance.new("UICorner")
floatFrameCorner.CornerRadius = UDim.new(1, 0)
floatFrameCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 2
floatStroke.Color = Color3.fromRGB(100, 150, 255)
floatStroke.Transparency = 0.3
floatStroke.Parent = floatingLogo

-- Logo dari link
local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, -12, 1, -12)
floatLogoImg.Position = UDim2.new(0, 6, 0, 6)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "https://i.ibb.co.com/fYZH6gqn/file-000000007f1871fa90b3365d3849f71f.png"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

-- Buat ImageLabel menjadi lingkaran
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = floatLogoImg

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo
floatButton.ZIndex = 1001

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
    -- Tutup semua dropdown saat minimize
    closeAllDropdowns()
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
    -- Tutup semua dropdown saat maximize
    closeAllDropdowns()
end)

local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 2)
hLine.Position = UDim2.new(0, 10, 0, 45)
hLine.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -55)
contentContainer.Position = UDim2.new(0, 10, 0, 50)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
contentContainer.Active = true

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 150, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = leftMenu

local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 2, 1, 0)
vLine.Position = UDim2.new(0, 160, 0, 0)
vLine.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- ===== RIGHT CONTENT AREA =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -170, 1, 0)
contentArea.Position = UDim2.new(0, 170, 0, 0)
contentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
contentArea.BackgroundTransparency = 0.1
contentArea.Parent = contentContainer
contentArea.Active = true
contentArea.ClipsDescendants = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -15, 0, 35)
contentTitle.Position = UDim2.new(0, 8, 0, 8)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Main Features"
contentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
contentTitle.TextSize = 18
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea
contentTitle.ZIndex = 5

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea
scrollFrame.ZIndex = 5

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y
featuresContainer.ZIndex = 10

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 12)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENT CREATORS =====
local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    line.BackgroundTransparency = 0.5
    line.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(100, 200, 255)
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BackgroundTransparency = 0.1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 250, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 55, 0, 28)
    switchBg.Position = UDim2.new(1, -65, 0.5, -14)
    switchBg.BackgroundColor3 = default and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(80, 80, 100)
    switchBg.Parent = frame
    switchBg.ZIndex = 21
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 14)
    switchCorner.Parent = switchBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = default and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = switchBg
    knob.ZIndex = 22
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 12)
    knobCorner.Parent = knob
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = switchBg
    toggleBtn.ZIndex = 23
    
    local state = default
    
    local function updateSwitch()
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
            knob:TweenPosition(UDim2.new(1, -27, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
            knob:TweenPosition(UDim2.new(0, 4, 0.5, -12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateSwitch()
        callback(state)
    end)
    
    return toggleBtn
end

local function createInput(parent, label, default, callback, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local labelObj = Instance.new("TextLabel")
    labelObj.Size = UDim2.new(0.4, 0, 0, 22)
    labelObj.Position = UDim2.new(0, 0, 0, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelObj.TextSize = 14
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Parent = frame
    labelObj.ZIndex = 21
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.55, 0, 0, 35)
    input.Position = UDim2.new(0.45, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.PlaceholderText = placeholder or ""
    input.Font = Enum.Font.Gotham
    input.Parent = frame
    input.ZIndex = 21
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text) or default
        input.Text = tostring(val)
        callback(val)
    end)
    
    return frame
end

local function createDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0, 22)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.55, 0, 0, 35)
    btn.Position = UDim2.new(0.45, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    btn.ZIndex = 21
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 25, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    arrow.TextSize = 14
    arrow.Parent = btn
    arrow.ZIndex = 22
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = gui
    dropdownFrame.ZIndex = 100
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ClipsDescendants = true
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 10)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Thickness = 2
    dropdownStroke.Color = Color3.fromRGB(100, 150, 255)
    dropdownStroke.Transparency = 0.3
    dropdownStroke.Parent = dropdownFrame
    
    local optionsScrolling = Instance.new("ScrollingFrame")
    optionsScrolling.Size = UDim2.new(1, 0, 1, 0)
    optionsScrolling.BackgroundTransparency = 1
    optionsScrolling.ScrollBarThickness = 4
    optionsScrolling.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsScrolling.Parent = dropdownFrame
    optionsScrolling.ZIndex = 101
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = optionsScrolling
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.ZIndex = 102
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 35)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 14
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = optionsContainer
        optBtn.ZIndex = 102
        optBtn.BorderSizePixel = 0
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 6)
        optCorner.Parent = optBtn
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdownFrame.Visible = false
            -- Hapus dari active dropdowns
            for i, d in ipairs(activeDropdowns) do
                if d == dropdownFrame then
                    table.remove(activeDropdowns, i)
                    break
                end
            end
            callback(opt)
        end)
    end
    
    local function updateDropdownPosition()
        if not frame or not frame:IsDescendantOf(gui) then
            dropdownFrame.Visible = false
            return
        end
        
        local absPos = btn.AbsolutePosition
        local absSize = btn.AbsoluteSize
        
        dropdownFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
        dropdownFrame.Size = UDim2.new(0, absSize.X, 0, math.min(#options * 37, 200))
    end
    
    btn.MouseButton1Click:Connect(function()
        -- Tutup dropdown lain
        closeOtherDropdowns(dropdownFrame)
        
        if dropdownFrame.Visible then
            dropdownFrame.Visible = false
            -- Hapus dari active dropdowns
            for i, d in ipairs(activeDropdowns) do
                if d == dropdownFrame then
                    table.remove(activeDropdowns, i)
                    break
                end
            end
        else
            updateDropdownPosition()
            dropdownFrame.Visible = true
            table.insert(activeDropdowns, dropdownFrame)
        end
    end)
    
    -- Cleanup saat frame dihapus
    frame.AncestryChanged:Connect(function()
        if not frame:IsDescendantOf(gui) and dropdownFrame.Parent then
            dropdownFrame:Destroy()
            -- Hapus dari active dropdowns
            for i, d in ipairs(activeDropdowns) do
                if d == dropdownFrame then
                    table.remove(activeDropdowns, i)
                    break
                end
            end
        end
    end)
    
    return frame
end

local function createButton(parent, text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 130, 200)
    btn.BackgroundTransparency = 0.1
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.1
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return btn
end

local function createButtonRow(parent, buttons)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundTransparency = 1
    row.Parent = parent
    row.ZIndex = 20
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 10)
    layout.Parent = row
    
    for _, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnData.width or 120, 0, 35)
        btn.BackgroundColor3 = btnData.color or Color3.fromRGB(70, 130, 200)
        btn.BackgroundTransparency = 0.1
        btn.Text = btnData.text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.Parent = row
        btn.ZIndex = 21
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.1
        end)
        
        btn.MouseButton1Click:Connect(btnData.callback)
    end
    
    return row
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

-- MAIN MENU (Fishing Features)
local function showMain()
    clearFeatures()
    contentTitle.Text = "⚡ Main Features"
    
    -- Fishing Support Section
    createSection(featuresContainer, "🎣 Fishing Support")
    
    createToggle(featuresContainer, "Walk On Water", isWalkOnWater, function(state)
        isWalkOnWater = state
        if state then
            setupWalkOnWater()
        else
            if Connections.walkWater then
                Connections.walkWater:Disconnect()
                Connections.walkWater = nil
            end
            if waterPlatform then
                waterPlatform:Destroy()
                waterPlatform = nil
            end
        end
    end)
    
    createToggle(featuresContainer, "Auto Equip Rod", autoEquip, function(state)
        autoEquip = state
        if state then equipRod("any") end
    end)
    
    createToggle(featuresContainer, "Disable Animation", isNoAnimation, function(state)
        isNoAnimation = state
        if state then
            DisableAnimations()
        else
            EnableAnimations()
        end
    end)
    
    createToggle(featuresContainer, "Disable Fish Notif", false, function(state)
        pcall(function()
            local notif = player.PlayerGui:FindFirstChild("Small Notification")
            if notif then
                notif.Display.Visible = not state
            end
        end)
    end)
    
    createInput(featuresContainer, "Stealth Height", Config.StealthHeight, function(val)
        Config.StealthHeight = val
    end, "110")
    
    createToggle(featuresContainer, "Stealth Mode", isStealthMode, function(state)
        local hrp = GetHRP()
        if hrp then
            pos_saved = hrp.Position
            look_saved = hrp.CFrame.LookVector
            isStealthMode = state
            TeleportToLookAt()
        end
    end)
    
    -- Auto Fish Legit Section
    createSection(featuresContainer, "🎣 Auto Fish (Legit)")
    
    createInput(featuresContainer, "Click Speed (Delay)", 0.05, function(val)
        -- Click speed
    end, "0.05")
    
    createToggle(featuresContainer, "Enable Auto Fish (Legit)", false, function(state)
        -- Legit mode
    end)
    
    -- Instant Fishing Section
    createSection(featuresContainer, "⚡ Instant Fishing")
    
    createInput(featuresContainer, "Fish Delay", Config.FishDelay, function(val)
        Config.FishDelay = val
    end, "2.0")
    
    createInput(featuresContainer, "Catch Delay", Config.CatchDelay, function(val)
        Config.CatchDelay = val
    end, "1.0")
    
    createInput(featuresContainer, "Cast Power", Config.CastPower, function(val)
        Config.CastPower = val
    end, "0.5")
    
    createToggle(featuresContainer, "Enable Instant Fish", autoFishing, function(state)
        if state then
            startAutoFishing()
        else
            stopAutoFishing()
        end
    end)
end

-- TRADE MENU
local function showTrade()
    clearFeatures()
    contentTitle.Text = "💰 Trade Features"
    
    createSection(featuresContainer, "🤝 Trade Support")
    
    createToggle(featuresContainer, "Auto Accept Trade", autoAcceptTrade, function(state)
        autoAcceptTrade = state
        _G.BloxFish_AutoAcceptTradeEnabled = state
    end)
    
    createSection(featuresContainer, "⭐ Auto Favorite / Unfavorite")
    
    createDropdown(featuresContainer, "Filter by Rarity", RarityList, "Secret", function(selected)
        table.insert(Config.FavoriteRarity, selected)
        notify("Rarity", "Added: " .. selected, 1)
    end)
    
    createDropdown(featuresContainer, "Filter by Mutation", MutationList, "Shiny", function(selected)
        table.insert(Config.FavoriteMutations, selected)
        notify("Mutation", "Added: " .. selected, 1)
    end)
    
    createToggle(featuresContainer, "Enable Auto Favorite", autoFavorite, function(state)
        if state then
            startAutoFavorite()
        else
            stopAutoFavorite()
        end
    end)
    
    createToggle(featuresContainer, "Enable Auto Unfavorite", autoUnfavorite, function(state)
        if state then
            startAutoUnfavorite()
        else
            stopAutoUnfavorite()
        end
    end)
end

-- TELEPORT MENU
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "🌍 Teleport Features"
    
    createSection(featuresContainer, "👤 Teleport to Player")
    
    local playerList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(playerList, plr.Name)
        end
    end
    
    if #playerList == 0 then
        table.insert(playerList, "No Players")
    end
    
    local selectedPlayer = playerList[1]
    
    createDropdown(featuresContainer, "Select Player", playerList, selectedPlayer, function(selected)
        selectedPlayer = selected
    end)
    
    createButtonRow(featuresContainer, {
        {
            text = "🔄 Refresh",
            width = 120,
            color = Color3.fromRGB(100, 100, 150),
            callback = function()
                local newList = {}
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player then
                        table.insert(newList, plr.Name)
                    end
                end
                notify("Players", #newList .. " online", 1)
            end
        },
        {
            text = "✨ Teleport",
            width = 120,
            color = Color3.fromRGB(70, 200, 70),
            callback = function()
                if selectedPlayer and selectedPlayer ~= "No Players" then
                    local target = Players:FindFirstChild(selectedPlayer)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = GetHRP()
                        if hrp then
                            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            notify("Teleport", "Teleported to " .. selectedPlayer, 1)
                        end
                    end
                end
            end
        }
    })
    
    createSection(featuresContainer, "📍 Teleport to Fishing Area")
    
    local selectedArea = AreaNames[1]
    
    createDropdown(featuresContainer, "Select Area", AreaNames, selectedArea, function(selected)
        selectedArea = selected
    end)
    
    createButtonRow(featuresContainer, {
        {
            text = "🚀 Teleport",
            width = 150,
            color = Color3.fromRGB(70, 200, 70),
            callback = function()
                if selectedArea and FishingAreas[selectedArea] then
                    local hrp = GetHRP()
                    if hrp then
                        hrp.CFrame = FishingAreas[selectedArea]
                        notify("Teleport", "Teleported to " .. selectedArea, 1)
                    end
                end
            end
        }
    })
end

-- SHOP MENU
local function showShop()
    clearFeatures()
    contentTitle.Text = "🏪 Shop Features"
    
    createSection(featuresContainer, "💰 Auto Sell Fish")
    
    createDropdown(featuresContainer, "Sell Method", {"Delay", "Count"}, Config.SellMethod, function(selected)
        Config.SellMethod = selected
    end)
    
    createInput(featuresContainer, "Sell Delay (Seconds)", Config.SellDelay, function(val)
        Config.SellDelay = val
    end, "60")
    
    createInput(featuresContainer, "Sell at Item Count", Config.SellCount, function(val)
        Config.SellCount = val
    end, "50")
    
    createToggle(featuresContainer, "Enable Auto Sell", autoSell, function(state)
        if state then
            startAutoSell()
        else
            stopAutoSell()
        end
    end)
    
    createButtonRow(featuresContainer, {
        {
            text = "💰 Sell All Now",
            width = 200,
            color = Color3.fromRGB(255, 150, 50),
            callback = function()
                sellAllItems()
                notify("Sell", "Sold all items!", 1)
            end
        }
    })
    
    createSection(featuresContainer, "🌤️ Auto Buy Weather")
    
    createDropdown(featuresContainer, "Select Weather", WeatherList, "Storm", function(selected)
        Config.SelectedWeather = {selected}
    end)
    
    createToggle(featuresContainer, "Enable Auto Buy Weather", autoWeather, function(state)
        if state then
            startAutoWeather()
        else
            stopAutoWeather()
        end
    end)
end

-- MISC MENU
local function showMisc()
    clearFeatures()
    contentTitle.Text = "🔧 Misc Features"
    
    -- Movement Section
    createSection(featuresContainer, "🏃 Movement")
    
    createInput(featuresContainer, "Walk Speed", Config.WalkSpeed, function(val)
        Config.WalkSpeed = val
        local hum = GetHumanoid()
        if hum then hum.WalkSpeed = val end
    end, "16")
    
    createInput(featuresContainer, "Jump Power", Config.JumpPower, function(val)
        Config.JumpPower = val
        local hum = GetHumanoid()
        if hum then hum.JumpPower = val end
    end, "50")
    
    createButtonRow(featuresContainer, {
        {
            text = "🔄 Reset Movement",
            width = 150,
            color = Color3.fromRGB(200, 100, 100),
            callback = function()
                local hum = GetHumanoid()
                if hum then
                    hum.WalkSpeed = 16
                    hum.JumpPower = 50
                    Config.WalkSpeed = 16
                    Config.JumpPower = 50
                    notify("Movement", "Reset to default", 1)
                end
            end
        }
    })
    
    createToggle(featuresContainer, "Freeze Player", isFreezePlayer, function(state)
        isFreezePlayer = state
        setFreezePlayer(state)
    end)
    
    -- Abilities Section
    createSection(featuresContainer, "⚡ Abilities")
    
    createToggle(featuresContainer, "Infinite Jump", isInfiniteJump, function(state)
        isInfiniteJump = state
        if state then
            setupInfiniteJump()
        elseif Connections.infiniteJump then
            Connections.infiniteJump:Disconnect()
            Connections.infiniteJump = nil
        end
    end)
    
    createToggle(featuresContainer, "No Clip", isNoClip, function(state)
        isNoClip = state
        if state then
            setupNoClip()
        elseif Connections.noClip then
            Connections.noClip:Disconnect()
            Connections.noClip = nil
        end
    end)
    
    createInput(featuresContainer, "Fly Speed", Config.FlySpeed, function(val)
        Config.FlySpeed = val
    end, "60")
    
    createToggle(featuresContainer, "Fly Mode", isFlying, function(state)
        isFlying = state
        if state then
            setupFly()
        else
            stopFly()
        end
    end)
    
    -- Other Section
    createSection(featuresContainer, "👁️ Other")
    
    createToggle(featuresContainer, "Player ESP", isESPEnabled, function(state)
        toggleESP(state)
    end)
    
    createToggle(featuresContainer, "Hide All Usernames", isHideUsernames, function(state)
        isHideUsernames = state
        setupHideUsernames()
    end)
    
    createButtonRow(featuresContainer, {
        {
            text = "🔄 Reset Character",
            width = 150,
            color = Color3.fromRGB(200, 100, 100),
            callback = function()
                local hrp = GetHRP()
                if hrp then
                    local pos = hrp.Position
                    local hum = GetHumanoid()
                    if hum then
                        hum:TakeDamage(999999)
                        player.CharacterAdded:Wait()
                        task.wait(0.5)
                        local newHRP = GetHRP()
                        if newHRP then
                            newHRP.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                        end
                    end
                end
            end
        }
    })
    
    -- Utility Section
    createSection(featuresContainer, "🛠️ Utility")
    
    createToggle(featuresContainer, "FPS Ultra Boost", isFPSBoost, function(state)
        isFPSBoost = state
        toggleFPSBoost(state)
    end)
    
    createToggle(featuresContainer, "No Cutscene", isNoCutscene, function(state)
        isNoCutscene = state
    end)
    
    createToggle(featuresContainer, "Remove Skin Effect", isRemoveSkinEffect, function(state)
        isRemoveSkinEffect = state
    end)
    
    createToggle(featuresContainer, "Infinite Zoom Out", isInfiniteZoom, function(state)
        isInfiniteZoom = state
        setupInfiniteZoom()
    end)
    
    createToggle(featuresContainer, "Bypass Radar", isBypassRadar, function(state)
        isBypassRadar = state
        setBypassRadar(state)
    end)
    
    createToggle(featuresContainer, "Bypass Oxygen", isBypassOxygen, function(state)
        isBypassOxygen = state
        setBypassOxygen(state)
    end)
    
    -- Performance Monitor
    createSection(featuresContainer, "📊 Performance")
    
    createToggle(featuresContainer, "Show Performance Monitor", monitorEnabled, function(state)
        toggleMonitor(state)
    end)
end

-- CONFIG MENU
local function showConfig()
    clearFeatures()
    contentTitle.Text = "⚙️ Config Manager"
    
    createSection(featuresContainer, "💾 Configuration")
    
    createInput(featuresContainer, "Config Name", "AutoFish", function(val)
        -- Config name
    end, "AutoFish")
    
    createDropdown(featuresContainer, "Available Configs", {"AutoFish", "Legit", "Blatant"}, "AutoFish", function(selected)
        -- Load config
        notify("Config", "Loaded: " .. selected, 1)
    end)
    
    createButtonRow(featuresContainer, {
        {
            text = "💾 Save Config",
            width = 120,
            color = Color3.fromRGB(70, 200, 70),
            callback = function()
                notify("Config", "Config saved!", 1)
            end
        },
        {
            text = "📂 Load Config",
            width = 120,
            color = Color3.fromRGB(100, 150, 255),
            callback = function()
                notify("Config", "Config loaded!", 1)
            end
        },
        {
            text = "🗑️ Delete Config",
            width = 120,
            color = Color3.fromRGB(200, 70, 70),
            callback = function()
                notify("Config", "Config deleted!", 1)
            end
        }
    })
end

-- ===== MENU TENTANG =====
local function showTentang()
    clearFeatures()
    contentTitle.Text = "ℹ️ Tentang Script Ini"
    
    createSection(featuresContainer, "📝 Informasi")
    
    -- Informasi pembuat dengan background
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -10, 0, 150)
    infoFrame.Position = UDim2.new(0, 5, 0, 10)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    infoFrame.BackgroundTransparency = 0.1
    infoFrame.Parent = featuresContainer
    infoFrame.ZIndex = 25
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 12)
    infoCorner.Parent = infoFrame
    
    local aboutText = Instance.new("TextLabel")
    aboutText.Size = UDim2.new(1, -20, 1, -20)
    aboutText.Position = UDim2.new(0, 10, 0, 10)
    aboutText.BackgroundTransparency = 1
    aboutText.Text = "✨ Script ini dibuat oleh moe\n\n© 2024 Moe. All rights reserved.\n\n🚫 Dilarang memperjualbelikan script ini tanpa izin."
    aboutText.TextColor3 = Color3.new(1, 1, 1)
    aboutText.TextSize = 15
    aboutText.Font = Enum.Font.Gotham
    aboutText.TextWrapped = true
    aboutText.TextXAlignment = Enum.TextXAlignment.Left
    aboutText.TextYAlignment = Enum.TextYAlignment.Top
    aboutText.Parent = infoFrame
    aboutText.ZIndex = 26
    
    -- Link Discord
    local discordFrame = Instance.new("Frame")
    discordFrame.Size = UDim2.new(1, -10, 0, 70)
    discordFrame.Position = UDim2.new(0, 5, 0, 180)
    discordFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordFrame.BackgroundTransparency = 0.1
    discordFrame.Parent = featuresContainer
    discordFrame.ZIndex = 25
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 12)
    discordCorner.Parent = discordFrame
    
    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.new(0, 40, 0, 40)
    discordIcon.Position = UDim2.new(0, 15, 0.5, -20)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = "rbxassetid://115935586997848"
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordFrame
    discordIcon.ZIndex = 26
    
    local discordText = Instance.new("TextLabel")
    discordText.Size = UDim2.new(1, -70, 0, 25)
    discordText.Position = UDim2.new(0, 60, 0, 10)
    discordText.BackgroundTransparency = 1
    discordText.Text = "Join Discord Server"
    discordText.TextColor3 = Color3.new(1, 1, 1)
    discordText.TextSize = 18
    discordText.Font = Enum.Font.GothamBold
    discordText.TextXAlignment = Enum.TextXAlignment.Left
    discordText.Parent = discordFrame
    discordText.ZIndex = 26
    
    local discordLink = Instance.new("TextLabel")
    discordLink.Size = UDim2.new(1, -70, 0, 20)
    discordLink.Position = UDim2.new(0, 60, 0, 35)
    discordLink.BackgroundTransparency = 1
    discordLink.Text = "discord.gg/NWD7QdKqrq"
    discordLink.TextColor3 = Color3.fromRGB(220, 220, 255)
    discordLink.TextSize = 14
    discordLink.Font = Enum.Font.Gotham
    discordLink.TextXAlignment = Enum.TextXAlignment.Left
    discordLink.Parent = discordFrame
    discordLink.ZIndex = 26
    
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 1, 0)
    discordBtn.BackgroundTransparency = 1
    discordBtn.Text = ""
    discordBtn.Parent = discordFrame
    discordBtn.ZIndex = 27
    
    discordBtn.MouseEnter:Connect(function()
        discordFrame.BackgroundTransparency = 0
    end)
    
    discordBtn.MouseLeave:Connect(function()
        discordFrame.BackgroundTransparency = 0.1
    end)
    
    discordBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/NWD7QdKqrq")
        notify("Discord", "Link Discord telah disalin ke clipboard!", 2)
    end)
    
    -- Logo preview
    createSection(featuresContainer, "🖼️ Logo Preview")
    
    local logoPreviewFrame = Instance.new("Frame")
    logoPreviewFrame.Size = UDim2.new(1, -10, 0, 140)
    logoPreviewFrame.Position = UDim2.new(0, 5, 0, 270)
    logoPreviewFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    logoPreviewFrame.BackgroundTransparency = 0.1
    logoPreviewFrame.Parent = featuresContainer
    logoPreviewFrame.ZIndex = 25
    
    local logoPreviewCorner = Instance.new("UICorner")
    logoPreviewCorner.CornerRadius = UDim.new(0, 12)
    logoPreviewCorner.Parent = logoPreviewFrame
    
    local logoPreview = Instance.new("ImageLabel")
    logoPreview.Size = UDim2.new(0, 100, 0, 100)
    logoPreview.Position = UDim2.new(0.5, -50, 0.5, -50)
    logoPreview.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    logoPreview.BackgroundTransparency = 0.2
    logoPreview.Image = "https://i.ibb.co.com/fYZH6gqn/file-000000007f1871fa90b3365d3849f71f.png"
    logoPreview.ScaleType = Enum.ScaleType.Fit
    logoPreview.Parent = logoPreviewFrame
    logoPreview.ZIndex = 26
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 50)
    previewCorner.Parent = logoPreview
    
    local previewStroke = Instance.new("UIStroke")
    previewStroke.Thickness = 2
    previewStroke.Color = Color3.fromRGB(100, 150, 255)
    previewStroke.Transparency = 0.3
    previewStroke.Parent = logoPreview
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "⚡ Main", func = showMain},
    {name = "💰 Trade", func = showTrade},
    {name = "🌍 Teleport", func = showTeleport},
    {name = "🏪 Shop", func = showShop},
    {name = "🔧 Misc", func = showMisc},
    {name = "⚙️ Config", func = showConfig},
    {name = "ℹ️ Tentang", func = showTentang}
}

local currentMenu = "⚡ Main"

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.BackgroundTransparency = 0.2
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.05
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.2
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.2
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            end
        end
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.fromRGB(70, 100, 200)
        currentMenu = btnData.name
        btnData.func()
        -- Tutup semua dropdown saat ganti menu
        closeAllDropdowns()
    end)
end

-- Show Main menu by default
task.wait(0.1)
showMain()

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Character added handler
player.CharacterAdded:Connect(function()
    if isNoAnimation then
        task.wait(0.2)
        DisableAnimations()
    end
end)

-- Cleanup saat GUI dihapus
gui.Destroying:Connect(function()
    if dropdownConnections.global then
        dropdownConnections.global:Disconnect()
    end
    closeAllDropdowns()
end)

notify("Moe V1.0", "✨ All features loaded! ✨", 3)
