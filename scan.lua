-- ====================================================================
--     FISHING MECHANIC INVESTIGATOR v2.1 - NO RAYFIELD
-- ====================================================================
-- Versi sederhana tanpa library eksternal
-- ====================================================================

local Investigator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variabel untuk menyimpan hasil
local InvestigationResults = {
    Remotes = {},
    CapturedPackets = {},
    RodInfo = {},
    Comparison = {},
    TestResults = {},
    Timestamp = os.time(),
    Date = os.date("%Y-%m-%d %H:%M:%S")
}

-- ====================================================================
--                     SIMPLE GUI (Tanpa Rayfield)
-- ====================================================================

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishingInvestigator"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Fungsi untuk membuat frame
local function createWindow(title)
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = ScreenGui
    
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
    shadow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🎣 " .. title
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Content
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -50)
    contentFrame.Position = UDim2.new(0, 10, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    return mainFrame, contentFrame
end

-- Fungsi untuk membuat button
local function createButton(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, position)
    btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 140, 220)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    end)
    
    return btn
end

-- Fungsi untuk membuat text box
local function createTextBox(parent, placeholder, position)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 30)
    box.Position = UDim2.new(0, 10, 0, position)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = parent
    
    return box
end

-- Fungsi untuk membuat label
local function createLabel(parent, text, position, sizeY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, sizeY or 20)
    label.Position = UDim2.new(0, 10, 0, position)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- Fungsi untuk membuat scrolling frame hasil
local function createResultsFrame(parent)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -100)
    frame.Position = UDim2.new(0, 10, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 8
    frame.Parent = parent
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = frame
    
    return frame
end

-- ====================================================================
--                     FUNGSI INVESTIGASI
-- ====================================================================

-- 1. SCAN REMOTES
function Investigator.scanRemotes()
    local results = {}
    table.insert(results, "╔════════════════════════════════════════╗")
    table.insert(results, "     📡 FISHING REMOTES SCAN")
    table.insert(results, "╚════════════════════════════════════════╝")
    
    local fishingRemotes = {}
    local searchLocations = {
        ReplicatedStorage,
        game:GetService("ServerStorage"),
        game:GetService("ServerScriptService")
    }
    
    for _, location in ipairs(searchLocations) do
        local descendants = location:GetDescendants()
        for _, obj in ipairs(descendants) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and 
               (obj.Name:lower():match("fish") or 
                obj.Name:lower():match("rod") or
                obj.Name:lower():match("cast") or
                obj.Name:lower():match("reel") or
                obj.Name:lower():match("minigame") or
                obj.Name:lower():match("sell") or
                obj.Name:lower():match("charge") or
                obj.Name:lower():match("catch")) then
                
                table.insert(fishingRemotes, {
                    Name = obj.Name,
                    Class = obj.ClassName,
                    Path = obj:GetFullName()
                })
            end
        end
    end
    
    InvestigationResults.Remotes = fishingRemotes
    
    for i, remote in ipairs(fishingRemotes) do
        table.insert(results, string.format("\n%d. [%s] %s", i, remote.Class, remote.Name))
        table.insert(results, "   📍 Path: " .. remote.Path)
    end
    
    table.insert(results, "\n📊 Total remotes ditemukan: " .. #fishingRemotes)
    
    return results
end

-- 2. CAPTURE PACKETS
function Investigator.capturePackets(duration, callback)
    local results = {}
    table.insert(results, "╔════════════════════════════════════════╗")
    table.insert(results, "     📦 FISHING PACKET CAPTURE")
    table.insert(results, "╚════════════════════════════════════════╝")
    table.insert(results, "Duration: " .. duration .. " detik")
    table.insert(results, "Silahkan fishing manual sekarang...\n")
    
    local captured = {}
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        local self = args[1]
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self)
            if remoteName:match("Fish") or remoteName:match("Rod") or remoteName:match("Cast") or 
               remoteName:match("Reel") or remoteName:match("Sell") or remoteName:match("Charge") then
                local callInfo = {
                    Remote = remoteName,
                    Method = method,
                    Args = {},
                    Time = tick()
                }
                
                for i = 2, #args do
                    table.insert(callInfo.Args, tostring(args[i]))
                end
                
                table.insert(captured, callInfo)
            end
        end
        
        return oldNamecall(...)
    end)
    
    -- Capture selama duration detik
    local startTime = tick()
    while tick() - startTime < duration do
        task.wait(0.1)
        if callback then
            callback(math.floor((tick() - startTime) / duration * 100))
        end
    end
    
    setreadonly(mt, true)
    
    InvestigationResults.CapturedPackets = captured
    
    table.insert(results, "📊 CAPTURE RESULTS:")
    table.insert(results, "Total remote calls: " .. #captured)
    
    if #captured > 0 then
        table.insert(results, "\n🔄 SEQUENCE:")
        for i, call in ipairs(captured) do
            local timeDiff = string.format("%.2f", call.Time - captured[1].Time)
            local args = table.concat(call.Args, ", ")
            table.insert(results, string.format("%d. [+%ss] %s", i, timeDiff, call.Remote))
            if args ~= "" then
                table.insert(results, "   Args: " .. args)
            end
        end
    end
    
    return results
end

-- 3. CHECK ROD
function Investigator.checkRod()
    local results = {}
    table.insert(results, "╔════════════════════════════════════════╗")
    table.insert(results, "     🎣 ROD VALIDATION CHECK")
    table.insert(results, "╚════════════════════════════════════════╝")
    
    local rodInfo = {
        found = false,
        name = nil,
        location = nil
    }
    
    -- Cek di Backpack
    local backpack = LocalPlayer.Backpack
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
            rodInfo.found = true
            rodInfo.name = tool.Name
            rodInfo.location = "Backpack"
            rodInfo.tool = tool
            table.insert(results, "✅ Rod ditemukan di Backpack: " .. tool.Name)
        end
    end
    
    -- Cek di Character
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():match("rod") or tool.Name:lower():match("fishing")) then
                rodInfo.found = true
                rodInfo.name = tool.Name
                rodInfo.location = "Character (equipped)"
                rodInfo.tool = tool
                table.insert(results, "✅ Rod sedang dipegang: " .. tool.Name)
            end
        end
    end
    
    if not rodInfo.found then
        table.insert(results, "❌ TIDAK ADA ROD DITEMUKAN!")
    end
    
    InvestigationResults.RodInfo = rodInfo
    
    return results
}

-- 4. COMPARE OLD VS NEW
function Investigator.compareRemotes()
    local results = {}
    table.insert(results, "╔════════════════════════════════════════╗")
    table.insert(results, "     🔄 OLD VS NEW COMPARISON")
    table.insert(results, "╚════════════════════════════════════════╝")
    
    local oldRemoteNames = {
        "FishingCompleted",
        "SellAllItems", 
        "ChargeFishingRod",
        "RequestFishingMinigameStarted",
        "CancelFishingInputs",
        "EquipToolFromHotbar",
        "UnequipToolFromHotbar",
        "FavoriteItem"
    }
    
    local comparison = {
        masih_ada = {},
        hilang = {},
        mirip = {}
    }
    
    table.insert(results, "\n📋 CHECKING OLD REMOTES:")
    
    for _, oldName in ipairs(oldRemoteNames) do
        local found = false
        for _, current in ipairs(InvestigationResults.Remotes) do
            if current.Name == oldName then
                found = true
                table.insert(comparison.masih_ada, oldName)
                table.insert(results, "✅ " .. oldName .. " - MASIH ADA")
                table.insert(results, "   Path: " .. current.Path)
                break
            end
        end
        if not found then
            table.insert(comparison.hilang, oldName)
            table.insert(results, "❌ " .. oldName .. " - TIDAK ADA / BERUBAH")
            
            -- Cari kemiripan
            for _, current in ipairs(InvestigationResults.Remotes) do
                if current.Name:lower():match(oldName:lower():gsub("fishing",""):gsub("rod","")) then
                    table.insert(comparison.mirip, {old = oldName, new = current.Name})
                    table.insert(results, "   🔍 Mungkin diganti: " .. current.Name)
                end
            end
        end
    end
    
    InvestigationResults.Comparison = comparison
    
    return results
end

-- 5. TEST REMOTES
function Investigator.testRemotes()
    local results = {}
    table.insert(results, "╔════════════════════════════════════════╗")
    table.insert(results, "     🧪 REMOTE TESTING")
    table.insert(results, "╚════════════════════════════════════════╝")
    
    local testResults = {}
    
    for _, remote in ipairs(InvestigationResults.Remotes) do
        if remote.Class == "RemoteFunction" then
            table.insert(results, "\n🔬 Testing: " .. remote.Name)
            
            local testParams = {
                {1755848498.4834},
                {0},
                {1},
                {true},
                {""},
                {LocalPlayer},
                {Vector3.new()},
                {CFrame.new()},
                {1, 2, 3},
            }
            
            local working = false
            for i, params in ipairs(testParams) do
                local success, result = pcall(function()
                    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                        if obj.Name == remote.Name and obj:IsA("RemoteFunction") then
                            return obj:InvokeServer(unpack(params))
                        end
                    end
                end)
                
                if success then
                    table.insert(results, "   ✅ Param set " .. i .. " bekerja!")
                    table.insert(results, "      Args: " .. table.concat(params, ", "))
                    table.insert(testResults, {
                        remote = remote.Name,
                        working_params = params,
                        result = tostring(result)
                    })
                    working = true
                    break
                end
            end
            
            if not working then
                table.insert(results, "   ❌ Tidak ada parameter yang bekerja")
            end
            
        elseif remote.Class == "RemoteEvent" then
            table.insert(results, "\n🔬 Testing Event: " .. remote.Name)
            
            local success = pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj.Name == remote.Name and obj:IsA("RemoteEvent") then
                        obj:FireServer()
                        return true
                    end
                end
            end)
            
            table.insert(results, "   FireServer: " .. (success and "✅ OK" or "❌ Error"))
            table.insert(testResults, {
                remote = remote.Name,
                type = "Event",
                fireable = success
            })
        end
    end
    
    InvestigationResults.TestResults = testResults
    
    return results
end

-- 6. COPY RESULTS
function Investigator.copyResults()
    local allText = {}
    
    table.insert(allText, "🔍 FISHING MECHANIC INVESTIGATION RESULTS")
    table.insert(allText, "Generated: " .. InvestigationResults.Date)
    table.insert(allText, string.rep("=", 60))
    table.insert(allText, "")
    
    -- Scan Remotes
    table.insert(allText, "📡 REMOTES FOUND:")
    for i, remote in ipairs(InvestigationResults.Remotes) do
        table.insert(allText, string.format("%d. %s (%s)", i, remote.Name, remote.Class))
        table.insert(allText, "   Path: " .. remote.Path)
    end
    
    table.insert(allText, "")
    table.insert(allText, string.rep("=", 60))
    table.insert(allText, "")
    
    -- Captured Packets
    table.insert(allText, "📦 CAPTURED PACKETS (" .. #InvestigationResults.CapturedPackets .. " calls):")
    if #InvestigationResults.CapturedPackets > 0 then
        local startTime = InvestigationResults.CapturedPackets[1].Time
        for i, call in ipairs(InvestigationResults.CapturedPackets) do
            local timeDiff = string.format("%.2f", call.Time - startTime)
            local args = table.concat(call.Args, ", ")
            table.insert(allText, string.format("%d. [+%ss] %s", i, timeDiff, call.Remote))
            if args ~= "" then
                table.insert(allText, "   Args: " .. args)
            end
        end
    end
    
    table.insert(allText, "")
    table.insert(allText, string.rep("=", 60))
    table.insert(allText, "")
    
    -- Comparison
    table.insert(allText, "🔄 OLD VS NEW COMPARISON:")
    table.insert(allText, "✅ Masih ada: " .. table.concat(InvestigationResults.Comparison.masih_ada or {}, ", "))
    table.insert(allText, "❌ Hilang: " .. table.concat(InvestigationResults.Comparison.hilang or {}, ", "))
    if InvestigationResults.Comparison.mirip and #InvestigationResults.Comparison.mirip > 0 then
        table.insert(allText, "🔍 Mirip:")
        for _, m in ipairs(InvestigationResults.Comparison.mirip) do
            table.insert(allText, "   " .. m.old .. " → " .. m.new)
        end
    end
    
    table.insert(allText, "")
    table.insert(allText, string.rep("=", 60))
    table.insert(allText, "")
    
    -- Rod Info
    table.insert(allText, "🎣 ROD INFO:")
    if InvestigationResults.RodInfo.found then
        table.insert(allText, "✅ Rod: " .. InvestigationResults.RodInfo.name)
        table.insert(allText, "📍 Location: " .. InvestigationResults.RodInfo.location)
    else
        table.insert(allText, "❌ No rod found!")
    end
    
    local fullText = table.concat(allText, "\n")
    
    -- Copy to clipboard
    local success, err = pcall(function()
        setclipboard(fullText)
    end)
    
    return fullText, success
end

-- ====================================================================
--                     GUI SETUP
-- ====================================================================

local mainFrame, contentFrame = createWindow("Fishing Investigator v2.1")

local yPos = 10

-- Title
local titleLabel = createLabel(contentFrame, "Fishing Mechanic Investigator", yPos, 25)
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
yPos = yPos + 30

-- Buttons
createButton(contentFrame, "1. SCAN REMOTES", yPos, function()
    local results = Investigator.scanRemotes()
    
    -- Clear dan tampilkan hasil
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local resultsFrame = createResultsFrame(contentFrame)
    for _, line in ipairs(results) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = resultsFrame
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #results * 25)
end)
yPos = yPos + 40

createButton(contentFrame, "2. CAPTURE PACKETS (10s)", yPos, function()
    -- Clear dan tampilkan progress
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local progressFrame = createResultsFrame(contentFrame)
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Size = UDim2.new(1, -10, 0, 30)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "Capturing... 0%"
    progressLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    progressLabel.Font = Enum.Font.GothamBold
    progressLabel.TextSize = 16
    progressLabel.Parent = progressFrame
    
    -- Capture packets
    task.spawn(function()
        local results = Investigator.capturePackets(10, function(percent)
            progressLabel.Text = "Capturing... " .. percent .. "%"
        end)
        
        -- Tampilkan hasil
        for _, child in ipairs(progressFrame:GetChildren()) do
            child:Destroy()
        end
        
        for _, line in ipairs(results) do
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = line
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = progressFrame
        end
        
        progressFrame.CanvasSize = UDim2.new(0, 0, 0, #results * 25)
    end)
end)
yPos = yPos + 40

createButton(contentFrame, "3. CHECK ROD", yPos, function()
    local results = Investigator.checkRod()
    
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local resultsFrame = createResultsFrame(contentFrame)
    for _, line in ipairs(results) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = resultsFrame
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #results * 25)
end)
yPos = yPos + 40

createButton(contentFrame, "4. COMPARE OLD VS NEW", yPos, function()
    local results = Investigator.compareRemotes()
    
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local resultsFrame = createResultsFrame(contentFrame)
    for _, line in ipairs(results) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = resultsFrame
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #results * 25)
end)
yPos = yPos + 40

createButton(contentFrame, "5. TEST REMOTES", yPos, function()
    local results = Investigator.testRemotes()
    
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local resultsFrame = createResultsFrame(contentFrame)
    for _, line in ipairs(results) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = resultsFrame
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #results * 25)
end)
yPos = yPos + 40

createButton(contentFrame, "🔄 FULL INVESTIGATION", yPos, function()
    for _, child in ipairs(contentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
    
    local resultsFrame = createResultsFrame(contentFrame)
    
    -- Progress label
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Size = UDim2.new(1, -10, 0, 30)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "Starting investigation..."
    progressLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    progressLabel.Font = Enum.Font.GothamBold
    progressLabel.TextSize = 16
    progressLabel.Parent = resultsFrame
    
    task.spawn(function()
        -- Scan remotes
        progressLabel.Text = "Scanning remotes..."
        local r1 = Investigator.scanRemotes()
        
        -- Capture packets
        progressLabel.Text = "Capture packets (10s) - Fishing manual!"
        local r2 = Investigator.capturePackets(10)
        
        -- Check rod
        progressLabel.Text = "Checking rod..."
        local r3 = Investigator.checkRod()
        
        -- Compare
        progressLabel.Text = "Comparing..."
        local r4 = Investigator.compareRemotes()
        
        -- Test
        progressLabel.Text = "Testing remotes..."
        local r5 = Investigator.testRemotes()
        
        -- Gabungkan hasil
        local allResults = {}
        for _, res in ipairs({r1, r2, r3, r4, r5}) do
            for _, line in ipairs(res) do
                table.insert(allResults, line)
            end
            table.insert(allResults, "\n" .. string.rep("=", 50) .. "\n")
        end
        
        -- Tampilkan
        progressLabel:Destroy()
        
        for _, line in ipairs(allResults) do
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = line
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = resultsFrame
        end
        
        resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #allResults * 25)
    end)
end)
yPos = yPos + 50

createButton(contentFrame, "📋 COPY ALL RESULTS", yPos, function()
    local text, success = Investigator.copyResults()
    
    if success then
        -- Show notification
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(1, -20, 0, 30)
        notif.Position = UDim2.new(0, 10, 0, yPos + 10)
        notif.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
        notif.Text = "✅ Copied to clipboard!"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.Gotham
        notif.TextSize = 14
        notif.Parent = contentFrame
        
        task.delay(3, function()
            notif:Destroy()
        end)
    else
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(1, -20, 0, 30)
        notif.Position = UDim2.new(0, 10, 0, yPos + 10)
        notif.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        notif.Text = "❌ Copy failed - Select manually"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.Gotham
        notif.TextSize = 14
        notif.Parent = contentFrame
        
        task.delay(3, function()
            notif:Destroy()
        end)
    end
end)

print([[
╔════════════════════════════════════════╗
║   FISHING INVESTIGATOR v2.1 LOADED     ║
║         (No Rayfield Version)          ║
╚════════════════════════════════════════╝

📝 CARA PAKAI:
1. Klik tombol yang diinginkan
2. Untuk FULL INVESTIGATION, klik tombol 🔄
3. Tunggu proses selesai
4. Klik COPY ALL RESULTS
5. Paste hasilnya di sini
]])