-- Moe V1.0 GUI for FISH IT - MERGED WITH VEL.LUA FEATURES (NO EMOJI WEBHOOK)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== AUTO FISHING VARIABLES =====
local autoFishing = false
local autoSell = false
local autoFavorite = false
local autoEquip = false
local fishingConnection = nil
local sellConnection = nil
local favoriteConnection = nil
local minigameConnection = nil
local isMinigameActive = false
local guiClosed = false

-- ===== WEBHOOK VARIABLES =====
local webhookEnabled = false
local webhookURL = ""
local webhookConnection = nil
local lastNotifiedFish = {}
local webhookCooldown = 5

-- ===== CONFIG VARIABLES =====
local Config = {
    FishDelay = 2.0,
    CatchDelay = 1.0,
    SellDelay = 60,
    FavoriteRarity = "Secret",
    CurrentRod = nil,
    CastPower = 0.5,
    WebhookURL = "",
    WebhookEnabled = false,
    WebhookNotifyRarity = {"Legendary", "Mythic", "Secret"},
    WebhookNotifySell = true,
    WebhookNotifyFavorite = true
}

-- ===== DATA LOKASI TELEPORT (DARI GUI.LUA) =====
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

-- ===== FISHING AREAS DARI VEL.LUA =====
local FishingAreas = {
    ["Ancient Jungle"] = { cframe = Vector3.new(1896.9, 8.4, -578.7), lookup = Vector3.new(0.973, 0.000, 0.229) },
    ["Ancient Ruins"] = { cframe = Vector3.new(6081.4, -585.9, 4634.5), lookup = Vector3.new(-0.619, -0.000, 0.785) },
    ["Ancient Ruins Door "] = { cframe = Vector3.new(6051.0, -538.9, 4386.0), lookup = Vector3.new(-0.000, -0.000, -1.000) },
    ["Christmast Island"] = { cframe = Vector3.new(1175.3,23.5,1545.3), lookup = Vector3.new(-0.787,-0.000,0.616) },
    ["Christmast Cave"] = { cfrane = Vector3.new(743.5,-487.1,8863.5), lookup = Vector3.new(-0.020,-0.000,1.000) },
    ["Classic Event"] = { cframe = Vector3.new(1171.3, 4.0, 2839.4), lookup = Vector3.new(-0.994, 0.000, -0.107) },
    ["Classic Event River "] = { cframe = Vector3.new(1439.7, 46.0, 2778.1), lookup = Vector3.new(0.894, 0.000, -0.448) },
    ["Coral Reefs"] = { cframe = Vector3.new(-2935.1,4.8,2050.9), lookup = Vector3.new(-0.306,-0.000,0.952) },
    ["Crater Island "] = { cframe = Vector3.new(1077.6, 2.8, 5080.9), lookup = Vector3.new(-0.987, 0.000, -0.159) },
    ["Esoteric Deep"] = { cframe = Vector3.new(3202.2, -1302.9, 1432.7), lookup = Vector3.new(0.896, 0.000, -0.444) },
    ["Iron Cavern "] = { cframe = Vector3.new(-8794.5, -585.0, 89.0), lookup = Vector3.new(0.741, -0.000, -0.672) },
    ["Iron Cave"] = { cframe = Vector3.new(-8641.3, -547.5, 162.0), lookup = Vector3.new(1.000, 0.000, -0.016) },
    ["Kohana"] = { cframe = Vector3.new(-367.8, 6.8, 521.9), lookup = Vector3.new(0.000, -0.000, -1.000) },
    ["Kohana Volcano "] = { cframe = Vector3.new(-561.6, 21.1, 158.6), lookup = Vector3.new(-0.403, -0.000, 0.915) },
    ["Sacred Temple "] = { cframe = Vector3.new(1466.6, -22.8, -618.8), lookup = Vector3.new(-0.389, 0.000, 0.921) },
    ["Sisyphus Statue "] = { cframe = Vector3.new(-3715.1, -136.8, -1010.6), lookup = Vector3.new(-0.764, 0.000, 0.646) },
    ["Treasure Room "] = { cframe = Vector3.new(-3604.2, -283.2, -1613.7), lookup = Vector3.new(-0.557, -0.000, -0.831) },
    ["Tropical Grove "] = { cframe = Vector3.new(-2173.3,53.5,3632.3), lookup = Vector3.new(0.729,0.000,0.684) },
    ["Underground Cellar"] = { cframe = Vector3.new(2136.0, -91.2, -699.0), lookup = Vector3.new(-0.000, 0.000, -1.000) }
}

-- Gabungkan kedua lokasi teleport
for name, data in pairs(FishingAreas) do
    LOCATIONS[name] = CFrame.new(data.cframe, data.cframe + data.lookup)
end

local TeleportLocations = {}
for loc, _ in pairs(LOCATIONS) do
    table.insert(TeleportLocations, loc)
end
table.sort(TeleportLocations)

-- ===== REMOTE FUNCTIONS DARI PACKAGES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Net = Packages and Packages:FindFirstChild("_Index") and 
           Packages._Index:FindFirstChild("sleitnick_net@0.2.0") and 
           Packages._Index["sleitnick_net@0.2.0"].net

-- ===== REMOTE YANG DIGUNAKAN =====
local Remote = {
    -- Equip Rod
    EquipTool = Net and Net["RE/c6dd8019183b4837632988a186ea356b21b8ff046bb0151182a1167e3936bc9f"],
    
    -- Fishing Remotes
    CancelFishingInputs = Net and Net["RF/f9a876154b063e332e1667cef846eeab3bd7fe8485cf1491fc927f0f9718b436"],
    ChargeFishingRod = Net and Net["RF/e4017e43355f4661b1e07f77fe2bfe13b5a48f4eff9ba55b0398ec0ef3c66765"],
    RequestFishingMinigame = Net and Net["RF/4d6dc93c9ecb915a8ae6425c83c8bb597b015e0bc4f874181ea308dcc7ae5015"],
    FishingMinigameChanged = Net and Net["RE/7c2a0bc8cd87d3e65a3d502bac59e416b8b1254902a83b5694a5648f80d817a0"],
    FishingStopped = Net and Net["RE/0192cc0d52f0942ba3d7889284f1bf758985abcad37cc1d781f9f4c90270d5d3"],
    UpdateChargeState = Net and Net["RE/8667b244d7c57a62d1c5fe72d42edc5726adb4ca70a4cad7a303c3bf396eafcb"],
    CatchFishCompleted = Net and Net["RF/76a108e0c7fed0fe6174984ba5c748621c6d347466644a819a806ed594a344b4"],
    FishCaught = Net and Net["RE/26bf5726781d1f44792109ce394bcf1e11fa41ae5bf157bb143ae79cbe6d44da"],
    
    -- Anti-Cheat
    UpdateAutoFishingState = Net and Net["RF/c68d9e2817eb664656e9e9076a0591c6b9e1a2ab03d8b8b8bce02bfe0af47fe0"],
    MarkAutoFishingUsed = Net and Net["RF/3369617d84c7299bdf2c8122e364d61a9f03d680e8faec8dfcb77529ef57d841"],
    
    -- Sell
    SellAllItems = Net and Net["RF/4417ef209575b73e441890816440faf3f5fa6a503ff1805d70afa5cf2b6d1453"],
    SellItem = Net and Net["RF/ca4e553b1bac1d59fea0f81bf7a3cedb46f0e11a90e7f72755009716dda575e9"],
    
    -- Favorite
    FavoriteItem = Net and Net["RE/f0e8ec714246b48fc2056f81a5106252267b280570723e12fef90d8cf1c4cc8e"],
    PromptFavoriteGame = Net and Net["RF/faec503b4c4a1859c79435903a10bed7e880cb893277e19692fa37d10991b011"],
    
    -- Additional from VEL.lua
    RE_EquipToolFromHotbar = Net and Net["RE/EquipToolFromHotbar"],
    RF_UpdateFishingRadar = Net and Net["RF/UpdateFishingRadar"],
    RF_EquipOxygenTank = Net and Net["RF/EquipOxygenTank"],
    RF_UnequipOxygenTank = Net and Net["RF/UnequipOxygenTank"]
}

-- ===== HELPER FUNCTIONS FROM VEL.LUA =====
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local function SafeWait(parent, childName, timeout)
    if not parent then return nil end
    local ok, result = pcall(function()
        return parent:WaitForChild(childName, timeout)
    end)
    if ok then return result end
    return nil
end

local function SafeRequire(moduleScript)
    if not moduleScript then return nil end
    local ok, result = pcall(require, moduleScript)
    if ok then return result end
    return nil
end

local SharedFolder = SafeWait(ReplicatedStorage, "Shared", 10)
local ItemUtility = SafeRequire(SafeWait(SharedFolder, "ItemUtility", 10))
local TierUtility = SafeRequire(SafeWait(SharedFolder, "TierUtility", 10))

local PlayerDataReplion = nil
local function GetPlayerDataReplion()
    if PlayerDataReplion then return PlayerDataReplion end
    local ReplionModule = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion", 10)
    if not ReplionModule then return nil end
    local ReplionClient = require(ReplionModule).Client
    PlayerDataReplion = ReplionClient:WaitReplion("Data", 5)
    return PlayerDataReplion
end

local function GetHumanoid()
    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    return Character:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    return Character:WaitForChild("HumanoidRootPart", 5)
end

local function GetFishNameAndRarity(item)
    local name = item.Identifier or "Unknown"
    local rarity = item.Metadata and item.Metadata.Rarity or "COMMON"
    local itemID = item.Id

    local itemData = nil

    if ItemUtility and itemID then
        pcall(function()
            itemData = ItemUtility:GetItemData(itemID)
            if not itemData then
                local numericID = tonumber(item.Id) or tonumber(item.Identifier)
                if numericID then
                    itemData = ItemUtility:GetItemData(numericID)
                end
            end
        end)
    end

    if itemData and itemData.Data and itemData.Data.Name then
        name = itemData.Data.Name
    end

    if item.Metadata and item.Metadata.Rarity then
        rarity = item.Metadata.Rarity
    elseif itemData and itemData.Probability and itemData.Probability.Chance and TierUtility then
        local tierObj = nil
        pcall(function()
            tierObj = TierUtility:GetTierFromRarity(itemData.Probability.Chance)
        end)

        if tierObj and tierObj.Name then
            rarity = tierObj.Name
        end
    end

    return name, rarity
end

local function GetItemMutationString(item)
    if item.Metadata and item.Metadata.Shiny == true then return "Shiny" end
    return item.Metadata and item.Metadata.VariantId or ""
end

local function CensorName(name)
    if not name or type(name) ~= "string" or #name < 1 then
        return "N/A" 
    end
    
    if #name <= 3 then
        return name
    end

    local prefix = name:sub(1, 3)
    local censureLength = #name - 3
    local censorString = string.rep("*", censureLength)
    
    return prefix .. censorString
end

-- ===== ANTI AFK =====
pcall(function()
    local player = Players.LocalPlayer
    for i, v in pairs(getconnections(player.Idled)) do
        if v.Disable then
            v:Disable()
        end
    end
end)

-- ===== WEBHOOK FUNCTIONS (NO EMOJI) =====
local function sendWebhook(message, embedData)
    if not Config.WebhookEnabled or Config.WebhookURL == "" then return end
    
    local data = {
        ["content"] = message or "",
        ["username"] = "Moe V1.0",
        ["avatar_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    }
    
    if embedData then
        data["embeds"] = {embedData}
    end
    
    local jsonData = HttpService:JSONEncode(data)
    
    local success = pcall(function()
        request = syn and syn.request or http and http.request or request
        if request then
            request({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end
    end)
    
    if not success then
        print("Failed to send webhook")
    end
end

local function createFishEmbed(fishData)
    local rarityColors = {
        Common = 8421504,
        Uncommon = 43520,
        Rare = 255,
        Epic = 12745742,
        Legendary = 16766720,
        Mythic = 16711935,
        Secret = 16711680
    }
    
    local color = rarityColors[fishData.rarity] or 3092790
    
    local embed = {
        ["title"] = "Fish Caught!",
        ["description"] = fishData.name,
        ["color"] = color,
        ["fields"] = {
            {
                ["name"] = "Rarity",
                ["value"] = fishData.rarity or "Unknown",
                ["inline"] = true
            },
            {
                ["name"] = "Value",
                ["value"] = fishData.value or "Unknown",
                ["inline"] = true
            },
            {
                ["name"] = "Player",
                ["value"] = player.Name,
                ["inline"] = true
            }
        },
        ["footer"] = {
            ["text"] = "Moe V1.0 • " .. os.date("%H:%M:%S")
        },
        ["thumbnail"] = {
            ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
        }
    }
    
    return embed
end

local function createSellEmbed(totalAmount, itemCount)
    local embed = {
        ["title"] = "Items Sold",
        ["description"] = "Sold " .. itemCount .. " items",
        ["color"] = 16776960,
        ["fields"] = {
            {
                ["name"] = "Total Value",
                ["value"] = "$" .. tostring(totalAmount),
                ["inline"] = true
            },
            {
                ["name"] = "Player",
                ["value"] = player.Name,
                ["inline"] = true
            }
        },
        ["footer"] = {
            ["text"] = "Moe V1.0 • " .. os.date("%H:%M:%S")
        }
    }
    
    return embed
end

local function createFavoriteEmbed(itemData)
    local embed = {
        ["title"] = "Item Favorited",
        ["description"] = itemData.name .. " has been favorited!",
        ["color"] = 16744703,
        ["fields"] = {
            {
                ["name"] = "Rarity",
                ["value"] = itemData.rarity or "Unknown",
                ["inline"] = true
            },
            {
                ["name"] = "Player",
                ["value"] = player.Name,
                ["inline"] = true
            }
        },
        ["footer"] = {
            ["text"] = "Moe V1.0 • " .. os.date("%H:%M:%S")
        }
    }
    
    return embed
end

-- Setup FishCaught listener untuk webhook
local function setupWebhookListeners()
    if Remote.FishCaught then
        Remote.FishCaught.OnClientEvent:Connect(function(fishData)
            if Config.WebhookEnabled and Config.WebhookURL ~= "" then
                local rarity = fishData.rarity or "Common"
                
                local shouldNotify = false
                for _, r in ipairs(Config.WebhookNotifyRarity) do
                    if r == rarity then
                        shouldNotify = true
                        break
                    end
                end
                
                if shouldNotify then
                    local fishKey = fishData.name .. "_" .. rarity
                    local currentTime = os.time()
                    
                    if not lastNotifiedFish[fishKey] or (currentTime - lastNotifiedFish[fishKey]) > webhookCooldown then
                        lastNotifiedFish[fishKey] = currentTime
                        sendWebhook(nil, createFishEmbed(fishData))
                    end
                end
            end
        end)
    end
end

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
    dialogFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    dialogFrame.BackgroundTransparency = 0.1
    dialogFrame.BorderSizePixel = 0
    dialogFrame.Parent = gui
    dialogFrame.ZIndex = 1000
    
    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 8)
    dialogCorner.Parent = dialogFrame
    
    local dialogStroke = Instance.new("UIStroke")
    dialogStroke.Thickness = 1
    dialogStroke.Color = Color3.new(1, 1, 1)
    dialogStroke.Transparency = 0.5
    dialogStroke.Parent = dialogFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = dialogFrame
    titleLabel.ZIndex = 1001
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextWrapped = true
    msgLabel.Parent = dialogFrame
    msgLabel.ZIndex = 1001
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -5, 0, 35)
    yesBtn.Position = UDim2.new(0.1, 0, 0, 95)
    yesBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = dialogFrame
    yesBtn.ZIndex = 1001
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -5, 0, 35)
    noBtn.Position = UDim2.new(0.5, 5, 0, 95)
    noBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = dialogFrame
    noBtn.ZIndex = 1001
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
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

-- ===== EQUIP ROD SYSTEM =====
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

local function equipRodViaRemote(slot)
    if Remote.EquipTool then
        local success = pcall(function()
            Remote.EquipTool:FireServer(slot or 1)
        end)
        return success
    end
    return false
end

local function equipRod(rodName)
    local rods = findFishingRods()
    for _, rod in ipairs(rods) do
        if rod.Name == rodName or rodName == "any" then
            if rod.Location == "Backpack" then
                if equipRodViaRemote(1) then
                    Config.CurrentRod = rod.Name
                    notify("Equip", "Equipped: " .. rod.Name, 1)
                    return true
                else
                    rod.Instance.Parent = player.Character
                    Config.CurrentRod = rod.Name
                    notify("Equip", "Equipped: " .. rod.Name .. " (manual)", 1)
                    return true
                end
            elseif rod.Location == "Character" then
                Config.CurrentRod = rod.Name
                return true
            end
        end
    end
    return false
end

-- ===== ANTI-CHEAT BYPASS =====
local function disableAntiCheat()
    if Remote.UpdateAutoFishingState then
        pcall(function() Remote.UpdateAutoFishingState:InvokeServer(false) end)
    end
    if Remote.MarkAutoFishingUsed then
        pcall(function() Remote.MarkAutoFishingUsed:InvokeServer(0) end)
    end
end

-- ===== GET WATER HEIGHT =====
local function getWaterHeight()
    local character = player.Character
    if not character then return 0 end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return 0 end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {character}
    rayParams.IgnoreWater = false
    
    local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -100, 0), rayParams)
    if rayResult and rayResult.Material == Enum.Material.Water then
        return rayResult.Position.Y
    end
    return 0
end

-- ===== AUTO FISHING FUNCTIONS =====
local function setupMinigameListener()
    if minigameConnection then
        minigameConnection:Disconnect()
    end
    
    if Remote.FishingMinigameChanged then
        minigameConnection = Remote.FishingMinigameChanged.OnClientEvent:Connect(function(state, data)
            if state == "Activated" or state == "Started" then
                isMinigameActive = true
            elseif state == "Completed" or state == "Stop" then
                isMinigameActive = false
                
                if autoFishing and Remote.CatchFishCompleted then
                    task.spawn(function()
                        pcall(function()
                            Remote.CatchFishCompleted:InvokeServer()
                        end)
                    end)
                end
            end
        end)
    end
end

local function startFishing()
    if not Remote.ChargeFishingRod then return false end
    
    local serverTime = workspace:GetServerTimeNow()
    
    local chargeSuccess = pcall(function()
        return Remote.ChargeFishingRod:InvokeServer(nil, nil, serverTime, nil)
    end)
    
    if not chargeSuccess then 
        return false 
    end
    
    task.wait(0.5)
    
    local waterY = getWaterHeight()
    if waterY == 0 then waterY = -50 end
    
    local minigameSuccess = pcall(function()
        return Remote.RequestFishingMinigame:InvokeServer(waterY, Config.CastPower, serverTime)
    end)
    
    return minigameSuccess
end

local function cancelFishing()
    if Remote.CancelFishingInputs then
        pcall(function() Remote.CancelFishingInputs:InvokeServer(true) end)
    end
end

-- ===== AUTO SELL =====
local function sellAllItems()
    if Remote.SellAllItems then
        local success = pcall(function() Remote.SellAllItems:InvokeServer() end)
        notify("Sell", success and "All items sold!" or "Sell failed", 2)
        
        if success and Config.WebhookEnabled and Config.WebhookNotifySell and Config.WebhookURL ~= "" then
            sendWebhook(nil, createSellEmbed("?", "?"))
        end
    end
end

-- ===== AUTO FAVORITE =====
local function promptFavorite()
    if Remote.PromptFavoriteGame then
        pcall(function() Remote.PromptFavoriteGame:InvokeServer() end)
    end
end

-- ===== TELEPORT =====
local function teleportTo(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = cframe
        notify("Teleport", "Teleported to " .. locationName, 1.5)
    end
end

-- ===== MAIN FISHING LOOP =====
local function startAutoFishing()
    if autoFishing or guiClosed then return end
    
    setupMinigameListener()
    
    if autoEquip and not Config.CurrentRod then
        equipRod("any")
    end
    
    autoFishing = true
    notify("Auto Fish", "Started!", 2)
    
    fishingConnection = RunService.Heartbeat:Connect(function()
        if not autoFishing or guiClosed then return end
        
        disableAntiCheat()
        cancelFishing()
        task.wait(0.2)
        
        startFishing()
        
        task.wait(Config.FishDelay + Config.CatchDelay)
    end)
end

local function stopAutoFishing()
    autoFishing = false
    if fishingConnection then
        fishingConnection:Disconnect()
        fishingConnection = nil
    end
    if minigameConnection then
        minigameConnection:Disconnect()
        minigameConnection = nil
    end
    cancelFishing()
    notify("Auto Fish", "Stopped!", 2)
end

-- ===== AUTO SELL LOOP =====
local function startAutoSell()
    if autoSell or guiClosed then return end
    autoSell = true
    
    sellConnection = RunService.Heartbeat:Connect(function()
        if not autoSell or guiClosed then return end
        task.wait(Config.SellDelay)
        sellAllItems()
    end)
end

local function stopAutoSell()
    autoSell = false
    if sellConnection then
        sellConnection:Disconnect()
        sellConnection = nil
    end
end

-- ===== AUTO FAVORITE LOOP =====
local function startAutoFavorite()
    if autoFavorite or guiClosed then return end
    autoFavorite = true
    
    favoriteConnection = RunService.Heartbeat:Connect(function()
        if not autoFavorite or guiClosed then return end
        task.wait(30)
        promptFavorite()
    end)
end

local function stopAutoFavorite()
    autoFavorite = false
    if favoriteConnection then
        favoriteConnection:Disconnect()
        favoriteConnection = nil
    end
end

-- ===== WALK ON WATER =====
local walkOnWaterConnection = nil
local isWalkOnWater = false
local waterPlatform = nil

local function WoW()
    if not waterPlatform then
        waterPlatform = Instance.new("Part")
        waterPlatform.Name = "WaterPlatform"
        waterPlatform.Anchored = true
        waterPlatform.CanCollide = true
        waterPlatform.Transparency = 1 
        waterPlatform.Size = Vector3.new(15, 1, 15)
        waterPlatform.Parent = workspace
    end
    
    if walkOnWaterConnection then walkOnWaterConnection:Disconnect() end
    
    walkOnWaterConnection = RunService.RenderStepped:Connect(function()
        local character = player.Character
        if not isWalkOnWater or not character then return end
        
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
    
        local rayOrigin = hrp.Position + Vector3.new(0, 5, 0) 
        local rayDirection = Vector3.new(0, -200, 0)
    
        local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    
        if result and result.Material == Enum.Material.Water then
            local waterSurfaceHeight = result.Position.Y
            
            waterPlatform.Position = Vector3.new(hrp.Position.X, waterSurfaceHeight, hrp.Position.Z)
            
            if hrp.Position.Y < (waterSurfaceHeight + 2) and hrp.Position.Y > (waterSurfaceHeight - 5) then
                if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.CFrame = CFrame.new(hrp.Position.X, waterSurfaceHeight + 3.2, hrp.Position.Z)
                end
            end
        else
            waterPlatform.Position = Vector3.new(hrp.Position.X, -500, hrp.Position.Z)
        end
    end)
end

-- ===== DISABLE ANIMATIONS =====
local isNoAnimationActive = false
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

function OnCharacterAdded(newCharacter)
    if isNoAnimationActive then
        task.wait(0.2)
        DisableAnimations()
    end
end

-- ===== EXIT FUNCTION =====
local function exitGUI()
    if guiClosed then return end
    
    showConfirmDialog("Exit GUI", "Are you sure you want to close?", function(confirmed)
        if confirmed then
            guiClosed = true
            
            stopAutoFishing()
            stopAutoSell()
            stopAutoFavorite()
            
            if activeDropdown then
                activeDropdown.Visible = false
                activeDropdown = nil
            end
            
            task.wait(0.1)
            pcall(function() gui:Destroy() end)
        end
    end)
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Selectable = true

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 1, 0)
title.Position = UDim2.new(0, 38, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

-- Minimize button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -60, 0.5, -12.5)
minButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = headerFrame
minButton.ZIndex = 5

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minButton

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame
closeBtn.ZIndex = 5

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(exitGUI)

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
floatingLogo.BackgroundTransparency = 0.2
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000
floatingLogo.Active = true
floatingLogo.Selectable = true

local floatFrameCorner = Instance.new("UICorner")
floatFrameCorner.CornerRadius = UDim.new(0, 25)
floatFrameCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.5
floatStroke.Parent = floatingLogo

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, -10, 1, -10)
floatLogoImg.Position = UDim2.new(0, 5, 0, 5)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo
floatButton.ZIndex = 1001

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
contentContainer.Active = true

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 130, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- ===== RIGHT CONTENT AREA =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer
contentArea.Active = true
contentArea.ClipsDescendants = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 25)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Main Features"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 14
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea
contentTitle.ZIndex = 5

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
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
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== DROPDOWN FUNCTIONS =====
local activeDropdown = nil

local function closeAllDropdowns()
    if activeDropdown then
        activeDropdown.Visible = false
        activeDropdown = nil
    end
end

local function setupInputTracking()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            task.wait(0.05)
            if not activeDropdown then return end
            
            local mousePos = UserInputService:GetMouseLocation()
            local objects = gui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)
            
            local clickedOnDropdown = false
            for _, obj in ipairs(objects) do
                local current = obj
                while current do
                    if current == activeDropdown or current == activeDropdown.Parent then
                        clickedOnDropdown = true
                        break
                    end
                    current = current.Parent
                end
                if clickedOnDropdown then break end
            end
            
            if not clickedOnDropdown then
                closeAllDropdowns()
            end
        end
    end)
end

setupInputTracking()

local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 20
    frame.Active = true
    frame.Selectable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    btn.ZIndex = 21
    btn.AutoButtonColor = false
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 21
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = gui
    dropdownFrame.ZIndex = 1000
    dropdownFrame.BorderSizePixel = 1
    dropdownFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local optionsScrolling = Instance.new("ScrollingFrame")
    optionsScrolling.Size = UDim2.new(1, 0, 1, 0)
    optionsScrolling.BackgroundTransparency = 1
    optionsScrolling.ScrollBarThickness = 4
    optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    optionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    optionsScrolling.Parent = dropdownFrame
    optionsScrolling.ZIndex = 1001
    
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, 0, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.Parent = optionsScrolling
    optionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    optionsContainer.ZIndex = 1002
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    local function updateDropdownPosition()
        if not frame or not frame:IsDescendantOf(gui) or not frame.Visible then
            dropdownFrame.Visible = false
            return
        end
        if not mainFrame.Visible then
            dropdownFrame.Visible = false
            return
        end
        
        local absPos = frame.AbsolutePosition
        local absSize = frame.AbsoluteSize
        
        dropdownFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y)
        dropdownFrame.Size = UDim2.new(0, absSize.X, 0, math.min(#options * 32, 200))
    end
    
    local function updateDropdown(newOptions)
        for _, child in pairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, opt in ipairs(newOptions) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.TextSize = 13
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = optionsContainer
            optBtn.ZIndex = 1002
            optBtn.BorderSizePixel = 0
            
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn
            
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
            end)
            
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                btn.Text = opt
                dropdownFrame.Visible = false
                activeDropdown = nil
                callback(opt)
            end)
        end
        
        task.wait()
        local contentHeight = #newOptions * 32 + (#newOptions - 1) * 2
        optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end
    
    updateDropdown(options)
    
    btn.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown ~= dropdownFrame then
            activeDropdown.Visible = false
        end
        if not mainFrame.Visible then return end
        
        updateDropdownPosition()
        dropdownFrame.Visible = not dropdownFrame.Visible
        activeDropdown = dropdownFrame.Visible and dropdownFrame or nil
    end)
    
    frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if dropdownFrame.Visible then updateDropdownPosition() end
    end)
    
    frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if dropdownFrame.Visible then updateDropdownPosition() end
    end)
    
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if not mainFrame.Visible and dropdownFrame.Visible then
            dropdownFrame.Visible = false
            activeDropdown = nil
        end
    end)
    
    frame.Destroying:Connect(function() dropdownFrame:Destroy() end)
    
    return frame, updateDropdown
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        callback()
    end)
    
    return btn
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    label.ZIndex = 20
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    frame.ZIndex = 20
    frame.Active = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 50, 0, 25)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12.5)
    switchBg.BackgroundColor3 = default and Color3.new(0, 0.6, 0) or Color3.new(0.4, 0.4, 0.4)
    switchBg.Parent = frame
    switchBg.ZIndex = 21
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 15)
    switchCorner.Parent = switchBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 21, 0, 21)
    knob.Position = default and UDim2.new(1, -25, 0.5, -10.5) or UDim2.new(0, 4, 0.5, -10.5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = switchBg
    knob.ZIndex = 22
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
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
            switchBg.BackgroundColor3 = Color3.new(0, 0.6, 0)
            knob:TweenPosition(UDim2.new(1, -25, 0.5, -10.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            switchBg.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
            knob:TweenPosition(UDim2.new(0, 4, 0.5, -10.5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        state = not state
        updateSwitch()
        callback(state)
    end)
    
    return toggleBtn
end

local function createInput(parent, labelText, default, callback, min, max)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 0, 25)
    input.Position = UDim2.new(0.5, 0, 0.5, -12.5)
    input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.Parent = frame
    input.ZIndex = 21
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local val = tonumber(input.Text) or default
        if min and max then
            val = math.max(min, math.min(max, val))
        end
        input.Text = tostring(val)
        callback(val)
    end)
    
    return frame
end

local function createSlider(parent, title, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ZIndex = 20
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    label.ZIndex = 21
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    sliderBg.Parent = frame
    sliderBg.ZIndex = 21
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.new(0, 0.6, 1)
    fill.Parent = sliderBg
    fill.ZIndex = 22
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = sliderBg
    button.ZIndex = 23
    
    local dragging = false
    
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local absSize = sliderBg.AbsoluteSize
            
            local relativeX = math.clamp(mousePos.X - absPos.X, 0, absSize.X)
            local percent = relativeX / absSize.X
            local value = min + (percent * (max - min))
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = title .. ": " .. string.format("%.2f", value)
            callback(value)
        end
    end)
    
    return frame
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== REFERENCE UNTUK TOGGLE =====
local autoFishToggle = nil
local autoSellToggle = nil
local autoFavoriteToggle = nil
local autoEquipToggle = nil

-- ===== MAIN MENU (FITUR DARI VEL.LUA) =====
local function showMain()
    clearFeatures()
    contentTitle.Text = "Main Features"
    
    createLabel(featuresContainer, "AUTO FISHING")
    
    autoFishToggle = createToggle(featuresContainer, "Auto Fish", false, function(state)
        if state then
            startAutoFishing()
        else
            stopAutoFishing()
        end
    end)
    
    autoEquipToggle = createToggle(featuresContainer, "Auto Equip Rod", autoEquip, function(state)
        autoEquip = state
        if state then
            equipRod("any")
        end
    end)
    
    createLabel(featuresContainer, "FISHING SETTINGS")
    
    createInput(featuresContainer, "Fish Delay (s)", Config.FishDelay, function(val)
        Config.FishDelay = val
    end, 0.1, 10)
    
    createInput(featuresContainer, "Catch Delay (s)", Config.CatchDelay, function(val)
        Config.CatchDelay = val
    end, 0.1, 10)
    
    createSlider(featuresContainer, "Cast Power", 0.1, 1.0, Config.CastPower, function(val)
        Config.CastPower = val
    end)
    
    createLabel(featuresContainer, "FISHING SUPPORT")
    
    createToggle(featuresContainer, "Walk On Water", false, function(state)
        isWalkOnWater = state
        if state then
            WoW()
        else
            isWalkOnWater = false
            if walkOnWaterConnection then walkOnWaterConnection:Disconnect() walkOnWaterConnection = nil end
            if waterPlatform then waterPlatform:Destroy() waterPlatform = nil end
        end
    end)
    
    createToggle(featuresContainer, "Disable Animation", isNoAnimationActive, function(state)
        isNoAnimationActive = state
        if state then
            DisableAnimations()
        else
            EnableAnimations()
        end
    end)
    
    createToggle(featuresContainer, "Disable Fish Notif", false, function(state)
        pcall(function()
            local notif = player.PlayerGui:FindFirstChild("Small Notification")
            if notif and notif:FindFirstChild("Display") then
                notif.Display.Visible = not state
            end
        end)
    end)
    
    createLabel(featuresContainer, "ROD SELECTION")
    local rods = findFishingRods()
    local rodNames = {"any"}
    for _, rod in ipairs(rods) do
        table.insert(rodNames, rod.Name)
    end
    if #rodNames > 1 then
        createDropdown(featuresContainer, rodNames, rodNames[1], function(selected)
            equipRod(selected)
        end)
    else
        createLabel(featuresContainer, "No rods found")
    end
end

-- ===== SELL MENU =====
local function showSell()
    clearFeatures()
    contentTitle.Text = "Sell Features"
    
    createLabel(featuresContainer, "AUTO SELL")
    
    autoSellToggle = createToggle(featuresContainer, "Auto Sell", false, function(state)
        if state then
            startAutoSell()
        else
            stopAutoSell()
        end
    end)
    
    createLabel(featuresContainer, "SELL DELAY (Default: 60s)")
    createInput(featuresContainer, "Sell Delay (s)", Config.SellDelay, function(val)
        Config.SellDelay = val
    end, 10, 300)
    
    createLabel(featuresContainer, "MANUAL SELL")
    createButton(featuresContainer, "SELL ALL NOW", function()
        sellAllItems()
    end)
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 60)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 0, 40)
    statusText.Position = UDim2.new(0, 5, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = "SellAllItems: " .. (Remote.SellAllItems and "✅" or "❌") .. "\n" ..
                      "SellItem: " .. (Remote.SellItem and "✅" or "❌")
    statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextWrapped = true
    statusText.Parent = statusFrame
end

-- ===== FAVORITE MENU =====
local function showFavorite()
    clearFeatures()
    contentTitle.Text = "Favorite Features"
    
    createLabel(featuresContainer, "AUTO FAVORITE")
    
    autoFavoriteToggle = createToggle(featuresContainer, "Auto Favorite", false, function(state)
        if state then
            startAutoFavorite()
        else
            stopAutoFavorite()
        end
    end)
    
    createLabel(featuresContainer, "Rarity Settings (Default: Secret)")
    local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}
    createDropdown(featuresContainer, rarities, Config.FavoriteRarity, function(selected)
        Config.FavoriteRarity = selected
    end)
    
    createLabel(featuresContainer, "MANUAL FAVORITE")
    createButton(featuresContainer, "PROMPT FAVORITE", function()
        promptFavorite()
    end)
    
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 60)
    statusFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.Parent = featuresContainer
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -10, 0, 40)
    statusText.Position = UDim2.new(0, 5, 0, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = "FavoriteItem: " .. (Remote.FavoriteItem and "✅" or "❌") .. "\n" ..
                      "PromptFavorite: " .. (Remote.PromptFavoriteGame and "✅" or "❌")
    statusText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextWrapped = true
    statusText.Parent = statusFrame
end

-- ===== ABILITIES MENU (DARI VEL.LUA) =====
local function showAbilities()
    clearFeatures()
    contentTitle.Text = "Abilities"
    
    createLabel(featuresContainer, "MOVEMENT")
    
    local DEFAULT_SPEED = 18
    local DEFAULT_JUMP = 50
    
    createSlider(featuresContainer, "WalkSpeed", 16, 200, DEFAULT_SPEED, function(val)
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end)
    
    createSlider(featuresContainer, "JumpPower", 50, 200, DEFAULT_JUMP, function(val)
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = val
        end
    end)
    
    createButton(featuresContainer, "Reset Movement", function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = DEFAULT_SPEED
            humanoid.JumpPower = DEFAULT_JUMP
        end
    end)
    
    createToggle(featuresContainer, "Freeze Player", false, function(state)
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = state
            if state then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    createLabel(featuresContainer, "ABILITIES")
    
    local infinityJumpConnection = nil
    createToggle(featuresContainer, "Infinite Jump", false, function(state)
        if state then
            infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
                local humanoid = GetHumanoid()
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infinityJumpConnection then
                infinityJumpConnection:Disconnect()
                infinityJumpConnection = nil
            end
        end
    end)
    
    local noclipConnection = nil
    local isNoClipActive = false
    createToggle(featuresContainer, "No Clip", false, function(state)
        isNoClipActive = state
        local character = player.Character
        
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                if isNoClipActive and character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
    
    local flyConnection = nil
    local isFlying = false
    local flySpeed = 60
    local bodyGyro, bodyVel
    createToggle(featuresContainer, "Fly Mode", false, function(state)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        if state then
            isFlying = true

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 9e4
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = humanoidRootPart.CFrame
            bodyGyro.Parent = humanoidRootPart

            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Velocity = Vector3.zero
            bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVel.Parent = humanoidRootPart

            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero
            local jumpPressed = false

            UserInputService.JumpRequest:Connect(function()
                if isFlying then jumpPressed = true task.delay(0.2, function() jumpPressed = false end) end
            end)

            flyConnection = RunService.RenderStepped:Connect(function()
                if not isFlying or not humanoidRootPart or not bodyGyro or not bodyVel then return end
                
                bodyGyro.CFrame = cam.CFrame
                moveDir = humanoid.MoveDirection

                if jumpPressed then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end

                if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * flySpeed end

                bodyVel.Velocity = moveDir
            end)

        else
            isFlying = false

            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
            if bodyVel then bodyVel:Destroy() bodyVel = nil end
        end
    end)
end

-- ===== TELEPORT MENU (DARI GUI.LUA + VEL.LUA) =====
local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel(featuresContainer, "TELEPORT TO LOCATION")
    
    local selectedLoc = TeleportLocations[1]
    
    createDropdown(featuresContainer, TeleportLocations, TeleportLocations[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(featuresContainer, "TELEPORT", function()
        teleportTo(selectedLoc)
    end)
    
    createLabel(featuresContainer, "TELEPORT TO PLAYER")
    
    local function getPlayerList()
        local players = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p.Name)
            end
        end
        return players
    end
    
    local playerList = getPlayerList()
    local selectedPlayer = playerList[1] or "No players"
    
    createDropdown(featuresContainer, playerList, playerList[1] or "No players", function(selected)
        selectedPlayer = selected
    end)
    
    createButton(featuresContainer, "REFRESH PLAYERS", function()
        local newPlayerList = getPlayerList()
        local dropdown = featuresContainer:FindFirstChildWhichIsA("Frame")
        if dropdown then
            -- Refresh dropdown logic here if needed
        end
        notify("Players", #newPlayerList .. " online", 1)
    end)
    
    createButton(featuresContainer, "TELEPORT TO PLAYER", function()
        if selectedPlayer and selectedPlayer ~= "No players" then
            local target = Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    notify("Teleport", "Teleported to " .. selectedPlayer)
                end
            end
        end
    end)
    
    createLabel(featuresContainer, "STEALTH MODE")
    
    local stealthHeight = 110
    local stealthMode = false
    local pos_saved = nil
    local look_saved = nil
    
    createInput(featuresContainer, "Stealth Height", stealthHeight, function(val)
        stealthHeight = val
    end, 10, 500)
    
    createToggle(featuresContainer, "Stealth Mode", false, function(state)
        local hrp = GetHRP()
        if not hrp then return end
        
        pos_saved = hrp.Position
        look_saved = hrp.CFrame.LookVector
        
        stealthMode = state
        if state then
            hrp.CFrame = CFrame.new(pos_saved, pos_saved + look_saved) * CFrame.new(0, stealthHeight, 0)
            hrp.Anchored = true
        else
            hrp.Anchored = false
            hrp.CFrame = CFrame.new(pos_saved, pos_saved + look_saved) * CFrame.new(0, 0.5, 0)
        end
    end)
end

-- ===== WEBHOOK MENU (NO EMOJI) =====
local function showWebhook()
    clearFeatures()
    contentTitle.Text = "Discord Webhook"
    
    createLabel(featuresContainer, "WEBHOOK SETTINGS")
    
    local urlFrame = Instance.new("Frame")
    urlFrame.Size = UDim2.new(1, 0, 0, 60)
    urlFrame.BackgroundTransparency = 1
    urlFrame.Parent = featuresContainer
    
    local urlLabel = Instance.new("TextLabel")
    urlLabel.Size = UDim2.new(1, 0, 0, 25)
    urlLabel.BackgroundTransparency = 1
    urlLabel.Text = "Webhook URL"
    urlLabel.TextColor3 = Color3.new(1, 1, 1)
    urlLabel.TextSize = 13
    urlLabel.Font = Enum.Font.GothamBold
    urlLabel.TextXAlignment = Enum.TextXAlignment.Left
    urlLabel.Parent = urlFrame
    
    local urlInput = Instance.new("TextBox")
    urlInput.Size = UDim2.new(1, 0, 0, 30)
    urlInput.Position = UDim2.new(0, 0, 0, 25)
    urlInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    urlInput.Text = Config.WebhookURL
    urlInput.TextColor3 = Color3.new(1, 1, 1)
    urlInput.PlaceholderText = "https://discord.com/api/webhooks/..."
    urlInput.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    urlInput.Font = Enum.Font.Gotham
    urlInput.TextSize = 12
    urlInput.Parent = urlFrame
    
    local urlCorner = Instance.new("UICorner")
    urlCorner.CornerRadius = UDim.new(0, 6)
    urlCorner.Parent = urlInput
    
    urlInput.FocusLost:Connect(function()
        Config.WebhookURL = urlInput.Text
    end)
    
    createToggle(featuresContainer, "Enable Webhook", Config.WebhookEnabled, function(state)
        Config.WebhookEnabled = state
        if state and Config.WebhookURL ~= "" then
            sendWebhook("Webhook Connected - Moe V1.0 is now sending notifications to this channel.")
            setupWebhookListeners()
        end
    end)
    
    createLabel(featuresContainer, "NOTIFICATION SETTINGS")
    
    local rarityFrame = Instance.new("Frame")
    rarityFrame.Size = UDim2.new(1, 0, 0, 60)
    rarityFrame.BackgroundTransparency = 1
    rarityFrame.Parent = featuresContainer
    
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Size = UDim2.new(1, 0, 0, 25)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "Notify Rarities (Separate with commas)"
    rarityLabel.TextColor3 = Color3.new(1, 1, 1)
    rarityLabel.TextSize = 13
    rarityLabel.Font = Enum.Font.Gotham
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = rarityFrame
    
    local rarityInput = Instance.new("TextBox")
    rarityInput.Size = UDim2.new(1, 0, 0, 30)
    rarityInput.Position = UDim2.new(0, 0, 0, 25)
    rarityInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    rarityInput.Text = table.concat(Config.WebhookNotifyRarity, ", ")
    rarityInput.TextColor3 = Color3.new(1, 1, 1)
    rarityInput.PlaceholderText = "Legendary, Mythic, Secret"
    rarityInput.Font = Enum.Font.Gotham
    rarityInput.TextSize = 12
    rarityInput.Parent = rarityFrame
    
    local rarityCorner = Instance.new("UICorner")
    rarityCorner.CornerRadius = UDim.new(0, 6)
    rarityCorner.Parent = rarityInput
    
    rarityInput.FocusLost:Connect(function()
        local rarities = {}
        for rarity in string.gmatch(rarityInput.Text, "([^,]+)") do
            local trimmed = rarity:match("^%s*(.-)%s*$")
            if trimmed ~= "" then
                table.insert(rarities, trimmed)
            end
        end
        if #rarities > 0 then
            Config.WebhookNotifyRarity = rarities
        end
    end)
    
    createToggle(featuresContainer, "Notify on Sell", Config.WebhookNotifySell, function(state)
        Config.WebhookNotifySell = state
    end)
    
    createToggle(featuresContainer, "Notify on Favorite", Config.WebhookNotifyFavorite, function(state)
        Config.WebhookNotifyFavorite = state
    end)
    
    createLabel(featuresContainer, "TEST WEBHOOK")
    
    local testBtn = Instance.new("TextButton")
    testBtn.Size = UDim2.new(1, 0, 0, 40)
    testBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
    testBtn.Text = "SEND TEST MESSAGE"
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.TextSize = 14
    testBtn.Font = Enum.Font.GothamBold
    testBtn.Parent = featuresContainer
    
    local testCorner = Instance.new("UICorner")
    testCorner.CornerRadius = UDim.new(0, 6)
    testCorner.Parent = testBtn
    
    testBtn.MouseButton1Click:Connect(function()
        if Config.WebhookURL == "" then
            notify("Webhook", "Please enter a webhook URL first!", 3)
            return
        end
        
        local testEmbed = {
            ["title"] = "Test Notification",
            ["description"] = "Moe V1.0 webhook is working properly!",
            ["color"] = 3066993,
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = player.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Status",
                    ["value"] = "Connected",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Moe V1.0 • " .. os.date("%H:%M:%S")
            }
        }
        
        sendWebhook(nil, testEmbed)
        notify("Webhook", "Test message sent!", 2)
    end)
    
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 80)
    infoFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    infoFrame.BackgroundTransparency = 0.2
    infoFrame.Parent = featuresContainer
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, -10, 1, -10)
    infoText.Position = UDim2.new(0, 5, 0, 5)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Webhook Info:\n• Sends notifications for rare fish catches\n• Notifies when items are sold\n• Can be tested with the button above\n• Supports multiple rarity filters"
    infoText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    infoText.TextSize = 11
    infoText.Font = Enum.Font.Gotham
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextWrapped = true
    infoText.Parent = infoFrame
end

-- ===== MISC MENU =====
local function showMisc()
    clearFeatures()
    contentTitle.Text = "Miscellaneous"
    
    createLabel(featuresContainer, "BYPASSES")
    
    createToggle(featuresContainer, "Bypass Oxygen", false, function(state)
        if state then
            if Remote.RF_EquipOxygenTank then
                pcall(function() Remote.RF_EquipOxygenTank:InvokeServer(105) end)
            end
        else
            if Remote.RF_UnequipOxygenTank then
                pcall(function() Remote.RF_UnequipOxygenTank:InvokeServer() end)
            end
        end
    end)
    
    createToggle(featuresContainer, "Bypass Radar", false, function(state)
        if Remote.RF_UpdateFishingRadar then
            pcall(function() Remote.RF_UpdateFishingRadar:InvokeServer(state) end)
        end
    end)
    
    createLabel(featuresContainer, "CINEMATIC")
    
    createToggle(featuresContainer, "Infinite Zoom", false, function(state)
        if state then
            player.CameraMaxZoomDistance = 100000
        else
            player.CameraMaxZoomDistance = 128
        end
    end)
    
    createToggle(featuresContainer, "Disable 3D Rendering", false, function(state)
        local PlayerGui = player:WaitForChild("PlayerGui")
        local Camera = workspace.CurrentCamera
        
        if state then
            if not _G.BlackScreenGUI then
                _G.BlackScreenGUI = Instance.new("ScreenGui")
                _G.BlackScreenGUI.Name = "AutoFish_BlackBackground"
                _G.BlackScreenGUI.IgnoreGuiInset = true
                _G.BlackScreenGUI.DisplayOrder = -999
                _G.BlackScreenGUI.Parent = PlayerGui
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 1, 0)
                Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                Frame.BorderSizePixel = 0
                Frame.Parent = _G.BlackScreenGUI
            end
            
            _G.BlackScreenGUI.Enabled = true
            _G.OldCamType = Camera.CameraType
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = CFrame.new(0, 100000, 0) 
        else
            if _G.OldCamType then
                Camera.CameraType = _G.OldCamType
            else
                Camera.CameraType = Enum.CameraType.Custom
            end
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = player.Character.Humanoid
            end
            
            if _G.BlackScreenGUI then
                _G.BlackScreenGUI.Enabled = false
            end
        end
    end)
    
    createLabel(featuresContainer, "PERFORMANCE")
    
    local monitorEnabled = false
    local monitorGui = nil
    local monitorConnection = nil
    
    local function createMonitorGui()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PerformanceMonitor"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = player:WaitForChild("PlayerGui")
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 90, 0, 80)
        mainFrame.Position = UDim2.new(1, -220, 0, 20)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = mainFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(60, 60, 80)
        stroke.Thickness = 2
        stroke.Parent = mainFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, 0, 0, 25)
        titleLabel.Position = UDim2.new(0, 0, 0, 0)
        titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        titleLabel.BorderSizePixel = 0
        titleLabel.Text = "Monitor"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = mainFrame
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 8)
        titleCorner.Parent = titleLabel
        
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, -10, 0, 1)
        separator.Position = UDim2.new(0, 5, 0, 25)
        separator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        separator.BorderSizePixel = 0
        separator.Parent = mainFrame
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingLabel"
        pingLabel.Size = UDim2.new(1, -20, 0, 20)
        pingLabel.Position = UDim2.new(0, 10, 0, 32)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Text = "Ping : 0 ms"
        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        pingLabel.TextSize = 12
        pingLabel.Font = Enum.Font.GothamMedium
        pingLabel.TextXAlignment = Enum.TextXAlignment.Left
        pingLabel.Parent = mainFrame
        
        local cpuLabel = Instance.new("TextLabel")
        cpuLabel.Name = "CPULabel"
        cpuLabel.Size = UDim2.new(1, -20, 0, 20)
        cpuLabel.Position = UDim2.new(0, 10, 0, 52)
        cpuLabel.BackgroundTransparency = 1
        cpuLabel.Text = "CPU  : 0 ms"
        cpuLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        cpuLabel.TextSize = 12
        cpuLabel.Font = Enum.Font.GothamMedium
        cpuLabel.TextXAlignment = Enum.TextXAlignment.Left
        cpuLabel.Parent = mainFrame
        
        return screenGui
    end
    
    createToggle(featuresContainer, "Performance Monitor", false, function(state)
        if state then
            if monitorEnabled then return end
            monitorEnabled = true
            monitorGui = createMonitorGui()
            
            monitorConnection = RunService.Heartbeat:Connect(function()
                if not monitorEnabled or not monitorGui then return end
                
                local mainFrame = monitorGui:FindFirstChild("MainFrame")
                if not mainFrame then return end
                
                local pingLabel = mainFrame:FindFirstChild("PingLabel")
                local cpuLabel = mainFrame:FindFirstChild("CPULabel")
                
                if pingLabel and cpuLabel then
                    local ping = math.floor(player:GetNetworkPing() * 1000)
                    local cpu = math.floor(Stats.PerformanceStats.CPU:GetValue())
                    
                    pingLabel.Text = string.format("Ping : %d ms", ping)
                    cpuLabel.Text = string.format("CPU  : %d ms", cpu)
                    
                    if ping <= 50 then
                        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif ping <= 100 then
                        pingLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    elseif ping <= 300 then
                        pingLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                    else
                        pingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    
                    if cpu <= 50 then
                        cpuLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif cpu <= 100 then
                        cpuLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    elseif cpu <= 300 then
                        cpuLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                    else
                        cpuLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end)
        else
            if not monitorEnabled then return end
            monitorEnabled = false
            if monitorConnection then monitorConnection:Disconnect() monitorConnection = nil end
            if monitorGui then monitorGui:Destroy() monitorGui = nil end
        end
    end)
    
    createLabel(featuresContainer, "MISC")
    
    createButton(featuresContainer, "Reset Character", function()
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not character or not hrp or not humanoid then
            notify("Error", "Character not found!", 3)
            return
        end
        
        local lastPos = hrp.Position
        notify("Reset", "Respawning...", 2)
        humanoid:TakeDamage(999999)
        
        player.CharacterAdded:Wait()
        task.wait(0.5)
        local newChar = player.Character
        local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
        
        if newHRP then
            newHRP.CFrame = CFrame.new(lastPos + Vector3.new(0, 3, 0))
            notify("Success", "Character reset!", 2)
        end
    end)
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Main", func = showMain},
    {name = "Sell", func = showSell},
    {name = "Favorite", func = showFavorite},
    {name = "Abilities", func = showAbilities},
    {name = "Teleport", func = showTeleport},
    {name = "Webhook", func = showWebhook},
    {name = "Misc", func = showMisc}
}

local currentMenu = ""

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    btn.ZIndex = 20
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.1
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        closeAllDropdowns()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        currentMenu = btnData.name
        btnData.func()
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

-- Setup webhook listeners
setupWebhookListeners()

-- Auto Reload saat Respawn
player.CharacterAdded:Connect(function(char)
    if type(OnCharacterAdded) == "function" then
        OnCharacterAdded(char)
    end
end)

-- Status remote di console
print("=== MOE V1.0 REMOTE STATUS ===")
print("ChargeFishingRod:", Remote.ChargeFishingRod ~= nil and "✅" or "❌")
print("RequestFishingMinigame:", Remote.RequestFishingMinigame ~= nil and "✅" or "❌")
print("CatchFishCompleted:", Remote.CatchFishCompleted ~= nil and "✅" or "❌")
print("FishingMinigameChanged:", Remote.FishingMinigameChanged ~= nil and "✅" or "❌")
print("SellAllItems:", Remote.SellAllItems ~= nil and "✅" or "❌")
print("===============================")

notify("Moe V1.0", "Merged with VEL.lua features + Webhook (No Emoji)!", 3)