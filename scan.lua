-- TEST CATCH FISH COMPLETED
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local CatchFish = Net["RF/CatchFishCompleted"]

print("🧪 TESTING CATCH FISH COMPLETED")
print("================================")

-- Test 1: Panggil tanpa apa-apa
local success1, result1 = pcall(function()
    return CatchFish:InvokeServer()
end)
print("Test 1 (tanpa rod):", success1 and "✅" or "❌", result1)

-- Test 2: Panggil dengan rod di tangan
-- (Equip rod dulu manual)
task.wait(2)
print("\n🎣 Equip rod dulu...")
task.wait(3)

local success2, result2 = pcall(function()
    return CatchFish:InvokeServer()
end)
print("Test 2 (dengan rod):", success2 and "✅" or "❌", result2)

-- Test 3: Coba spam
print("\n⚡ Spam test...")
for i = 1, 5 do
    local s, r = pcall(function()
        return CatchFish:InvokeServer()
    end)
    print("Spam " .. i .. ":", s and "✅" or "❌")
    task.wait(0.1)
endtextBox.TextEditable = false  -- Tidak bisa diedit, tapi bisa di-select
textBox.Parent = frame

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 6)
textCorner.Parent = textBox

-- Scrolling frame otomatis untuk text box
textBox.AutomaticSize = Enum.AutomaticSize.Y
textBox.Size = UDim2.new(1, -20, 0, 300)  -- Fixed height with scroll

-- ===== BUTTONS FRAME =====
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -20, 0, 80)
buttonsFrame.Position = UDim2.new(0, 10, 1, -90)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = frame

-- Fungsi buat button
local function createButton(parent, text, posX, posY, width, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width or 140, 0, 35)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Buttons row 1
local scanBtn = createButton(buttonsFrame, "🔍 SCAN SYSTEM", 0, 0, 150, Color3.fromRGB(0, 120, 200))
local copyBtn = createButton(buttonsFrame, "📋 SELECT ALL", 160, 0, 150, Color3.fromRGB(200, 120, 0))
local clearBtn = createButton(buttonsFrame, "🗑️ CLEAR", 320, 0, 150, Color3.fromRGB(150, 60, 60))

-- Buttons row 2
local instructionBtn = createButton(buttonsFrame, "ℹ️ INSTRUKSI", 0, 45, 200, Color3.fromRGB(100, 100, 150))
local closeBtn2 = createButton(buttonsFrame, "✕ CLOSE", 210, 45, 200, Color3.fromRGB(100, 100, 100), function()
    gui:Destroy()
end)

-- ===== FUNGSI UPDATE HASIL =====
local function updateResults(text)
    textBox.Text = text
    textBox.CursorPosition = #text + 1  -- Move cursor to end
end

-- ===== FUNGSI FORMAT RESULTS =====
local function formatResults()
    local lines = {}
    table.insert(lines, "🔍 FISHING SYSTEM SCAN RESULTS")
    table.insert(lines, "Generated: " .. ScanResults.Date)
    table.insert(lines, string.rep("=", 60))
    table.insert(lines, "")
    
    table.insert(lines, "📡 REMOTES FOUND (" .. #ScanResults.Remotes .. "):")
    for i, r in ipairs(ScanResults.Remotes) do
        table.insert(lines, string.format("%d. [%s] %s", i, r.Class, r.Name))
        table.insert(lines, "   Path: " .. r.Path)
    end
    table.insert(lines, "")
    
    table.insert(lines, "📚 MODULES FOUND (" .. #ScanResults.Modules .. "):")
    for i, m in ipairs(ScanResults.Modules) do
        table.insert(lines, string.format("%d. %s", i, m.Name))
        table.insert(lines, "   Path: " .. m.Path)
    end
    table.insert(lines, "")
    
    table.insert(lines, "🛡️ ANTI-CHEAT REMOTES (" .. #ScanResults.AntiCheat .. "):")
    for _, name in ipairs(ScanResults.AntiCheat) do
        table.insert(lines, "   • " .. name)
    end
    table.insert(lines, "")
    
    table.insert(lines, "🎣 FISHING REMOTES:")
    for _, r in ipairs(ScanResults.Remotes) do
        if r.Name:match("Fish") or r.Name:match("Rod") or r.Name:match("Cast") or
           r.Name:match("Reel") or r.Name:match("Catch") or r.Name:match("Charge") then
            table.insert(lines, "   • " .. r.Name)
        end
    end
    table.insert(lines, "")
    
    table.insert(lines, "💰 SELL REMOTES:")
    for _, r in ipairs(ScanResults.Remotes) do
        if r.Name:match("Sell") then
            table.insert(lines, "   • " .. r.Name)
        end
    end
    table.insert(lines, "")
    
    table.insert(lines, "⭐ FAVORITE REMOTES:")
    for _, r in ipairs(ScanResults.Remotes) do
        if r.Name:match("Favorite") or r.Name:match("Favorit") then
            table.insert(lines, "   • " .. r.Name)
        end
    end
    
    table.insert(lines, "")
    table.insert(lines, string.rep("=", 60))
    
    return table.concat(lines, "\n")
end

-- ===== FUNGSI SCANNER =====
local function scanFishingSystem()
    statusText.Text = "⏳ Scanning remotes..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Reset results
    ScanResults.Remotes = {}
    ScanResults.Modules = {}
    ScanResults.AntiCheat = {}
    ScanResults.Date = os.date("%Y-%m-%d %H:%M:%S")
    
    -- 1. SCAN REMOTES
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:match("fish") or name:match("rod") or name:match("cast") or
               name:match("reel") or name:match("catch") or name:match("charge") or
               name:match("minigame") or name:match("sell") or name:match("favorite") then
                
                table.insert(ScanResults.Remotes, {
                    Name = obj.Name,
                    Class = obj.ClassName,
                    Path = obj:GetFullName()
                })
                
                -- Anti-cheat detection
                if obj.Name:match("AutoFishing") or obj.Name:match("Mark") then
                    table.insert(ScanResults.AntiCheat, obj.Name)
                end
            end
        end
    end
    
    -- Sort remotes
    table.sort(ScanResults.Remotes, function(a, b) return a.Name < b.Name end)
    
    -- 2. SCAN MODULES
    statusText.Text = "⏳ Scanning modules..."
    
    local searchFolders = {
        ReplicatedStorage:FindFirstChild("Shared"),
        ReplicatedStorage:FindFirstChild("Controllers"),
        ReplicatedStorage:FindFirstChild("Modules")
    }
    
    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("ModuleScript") and 
                   (obj.Name:lower():match("fish") or obj.Name:lower():match("rod") or
                    obj.Name:lower():match("cast") or obj.Name:lower():match("inventory")) then
                    
                    table.insert(ScanResults.Modules, {
                        Name = obj.Name,
                        Path = obj:GetFullName()
                    })
                end
            end
        end
    end
    
    -- Update display
    local results = formatResults()
    updateResults(results)
    
    statusText.Text = string.format("✅ Scan complete! Found %d remotes, %d modules", 
        #ScanResults.Remotes, #ScanResults.Modules)
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- ===== FUNGSI SELECT ALL =====
local function selectAllText()
    textBox:CaptureFocus()
    textBox.Text = textBox.Text  -- Refresh
    textBox.CursorPosition = #textBox.Text + 1
    textBox.SelectionStart = 1
    textBox.SelectionLength = #textBox.Text
    
    statusText.Text = "✅ Text selected! Press Ctrl+C to copy"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- ===== FUNGSI CLEAR =====
local function clearResults()
    textBox.Text = "Klik SCAN untuk memulai..."
    statusText.Text = "⏳ Ready to scan..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    ScanResults.Remotes = {}
    ScanResults.Modules = {}
    ScanResults.AntiCheat = {}
    ScanResults.Date = os.date("%Y-%m-%d %H:%M:%S")
end

-- ===== TAMPILKAN INSTRUKSI =====
local function showInstructions()
    local instructions = {}
    table.insert(instructions, "📋 INSTRUKSI COPY MANUAL:")
    table.insert(instructions, "")
    table.insert(instructions, "1. Klik SCAN SYSTEM untuk scan")
    table.insert(instructions, "2. Klik SELECT ALL untuk memilih semua text")
    table.insert(instructions, "3. Tekan Ctrl+C (atau tap dan tahan di HP)")
    table.insert(instructions, "4. Paste hasilnya di chat")
    table.insert(instructions, "")
    table.insert(instructions, "Atau bisa juga:")
    table.insert(instructions, "- Drag mouse untuk select manual")
    table.insert(instructions, "- Klik kanan → Copy (di PC)")
    table.insert(instructions, "- Tap dan tahan → Copy (di HP)")
    
    updateResults(table.concat(instructions, "\n"))
end

-- ===== BUTTON FUNCTIONS =====
scanBtn.MouseButton1Click:Connect(scanFishingSystem)

copyBtn.MouseButton1Click:Connect(function()
    if #ScanResults.Remotes == 0 then
        statusText.Text = "⚠️ Scan first before copying!"
        statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
        return
    end
    selectAllText()
end)

clearBtn.MouseButton1Click:Connect(clearResults)

instructionBtn.MouseButton1Click:Connect(showInstructions)

-- ===== AUTO SCAN ON LOAD =====
task.spawn(function()
    task.wait(1)
    scanFishingSystem()
end)

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🔍 Fishing System Scanner v2.1 loaded - Manual Copy Edition")local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -20)
scrollingFrame.Position = UDim2.new(0, 10, 0, 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = resultsFrame

local resultsLayout = Instance.new("UIListLayout")
resultsLayout.Padding = UDim.new(0, 4)
resultsLayout.Parent = scrollingFrame

-- ===== BUTTONS FRAME =====
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -20, 0, 40)
buttonsFrame.Position = UDim2.new(0, 10, 1, -50)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = frame

-- Fungsi buat button
local function createButton(parent, text, posX, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Buttons
local scanBtn = createButton(buttonsFrame, "🔍 SCAN SYSTEM", 0, Color3.fromRGB(0, 120, 200))
local copyBtn = createButton(buttonsFrame, "📋 COPY RESULTS", 140, Color3.fromRGB(200, 120, 0))
local clearBtn = createButton(buttonsFrame, "🗑️ CLEAR", 280, Color3.fromRGB(150, 60, 60))
local closeBtn2 = createButton(buttonsFrame, "✕ CLOSE", 420, Color3.fromRGB(100, 100, 100), function()
    gui:Destroy()
end)

-- ===== FUNGSI UPDATE HASIL =====
local function updateResults(lines)
    -- Clear
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Add lines
    for _, line in ipairs(lines) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = scrollingFrame
    end
end

-- ===== FUNGSI SCANNER =====
local function scanFishingSystem()
    statusText.Text = "⏳ Scanning remotes..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local lines = {}
    table.insert(lines, "╔════════════════════════════════════════╗")
    table.insert(lines, "     🔍 FISHING SYSTEM SCAN RESULTS")
    table.insert(lines, "╚════════════════════════════════════════╝")
    table.insert(lines, "Generated: " .. ScanResults.Date)
    table.insert(lines, "")
    
    -- Reset results
    ScanResults.Remotes = {}
    ScanResults.Modules = {}
    ScanResults.AntiCheat = {}
    
    -- 1. SCAN REMOTES
    table.insert(lines, "📡 REMOTES FOUND:")
    statusText.Text = "⏳ Scanning remotes..."
    task.wait(0.5)
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local foundRemotes = {}
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:match("fish") or name:match("rod") or name:match("cast") or
               name:match("reel") or name:match("catch") or name:match("charge") or
               name:match("minigame") or name:match("sell") or name:match("favorite") then
                
                table.insert(foundRemotes, {
                    Name = obj.Name,
                    Class = obj.ClassName,
                    Path = obj:GetFullName()
                })
                
                -- Kategorisasi
                if obj.Name:match("AutoFishing") or obj.Name:match("Mark") then
                    table.insert(ScanResults.AntiCheat, obj.Name)
                end
            end
        end
    end
    
    -- Urutkan berdasarkan nama
    table.sort(foundRemotes, function(a, b) return a.Name < b.Name end)
    ScanResults.Remotes = foundRemotes
    
    -- Tampilkan
    for i, r in ipairs(foundRemotes) do
        table.insert(lines, string.format("%d. [%s] %s", i, r.Class, r.Name))
        table.insert(lines, "   📍 " .. r.Path)
    end
    table.insert(lines, "")
    
    -- 2. SCAN MODULES
    table.insert(lines, "📚 FISHING MODULES:")
    statusText.Text = "⏳ Scanning modules..."
    task.wait(0.5)
    
    local searchFolders = {
        ReplicatedStorage:FindFirstChild("Shared"),
        ReplicatedStorage:FindFirstChild("Controllers"),
        ReplicatedStorage:FindFirstChild("Modules")
    }
    
    local foundModules = {}
    
    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("ModuleScript") and 
                   (obj.Name:lower():match("fish") or obj.Name:lower():match("rod") or
                    obj.Name:lower():match("cast") or obj.Name:lower():match("inventory")) then
                    
                    table.insert(foundModules, {
                        Name = obj.Name,
                        Path = obj:GetFullName()
                    })
                end
            end
        end
    end
    
    ScanResults.Modules = foundModules
    
    for i, m in ipairs(foundModules) do
        table.insert(lines, string.format("%d. %s", i, m.Name))
        table.insert(lines, "   📍 " .. m.Path)
    end
    table.insert(lines, "")
    
    -- 3. ANTI-CHEAT ANALYSIS
    table.insert(lines, "🛡️ ANTI-CHEAT DETECTION:")
    statusText.Text = "⏳ Analyzing anti-cheat..."
    task.wait(0.5)
    
    if #ScanResults.AntiCheat > 0 then
        table.insert(lines, "⚠️ ANTI-CHEAT REMOTES FOUND:")
        for _, name in ipairs(ScanResults.AntiCheat) do
            table.insert(lines, "   • " .. name)
        end
    else
        table.insert(lines, "✅ No anti-cheat remotes detected")
    end
    table.insert(lines, "")
    
    -- 4. FISHING REMOTES (kategorisasi)
    table.insert(lines, "🎣 FISHING REMOTES CATEGORIZATION:")
    
    local fishing = {}
    local sell = {}
    local favorite = {}
    
    for _, r in ipairs(foundRemotes) do
        if r.Name:match("Fish") or r.Name:match("Rod") or r.Name:match("Cast") or
           r.Name:match("Reel") or r.Name:match("Catch") or r.Name:match("Charge") or
           r.Name:match("Minigame") then
            table.insert(fishing, r.Name)
        elseif r.Name:match("Sell") then
            table.insert(sell, r.Name)
        elseif r.Name:match("Favorite") or r.Name:match("Favorit") then
            table.insert(favorite, r.Name)
        end
    end
    
    table.insert(lines, "\n🎣 FISHING (" .. #fishing .. "):")
    for _, name in ipairs(fishing) do
        table.insert(lines, "   • " .. name)
    end
    
    table.insert(lines, "\n💰 SELL (" .. #sell .. "):")
    for _, name in ipairs(sell) do
        table.insert(lines, "   • " .. name)
    end
    
    table.insert(lines, "\n⭐ FAVORITE (" .. #favorite .. "):")
    for _, name in ipairs(favorite) do
        table.insert(lines, "   • " .. name)
    end
    
    table.insert(lines, "")
    table.insert(lines, "╚════════════════════════════════════════╝")
    
    -- Update display
    updateResults(lines)
    statusText.Text = "✅ Scan complete! Found " .. #foundRemotes .. " remotes, " .. #foundModules .. " modules"
    statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- ===== FUNGSI COPY RESULTS =====
local function copyResults()
    -- Kumpulkan semua text
    local lines = {}
    table.insert(lines, "🔍 FISHING SYSTEM SCAN RESULTS")
    table.insert(lines, "Generated: " .. ScanResults.Date)
    table.insert(lines, string.rep("=", 60))
    table.insert(lines, "")
    
    table.insert(lines, "📡 REMOTES FOUND (" .. #ScanResults.Remotes .. "):")
    for i, r in ipairs(ScanResults.Remotes) do
        table.insert(lines, string.format("%d. [%s] %s", i, r.Class, r.Name))
        table.insert(lines, "   Path: " .. r.Path)
    end
    table.insert(lines, "")
    
    table.insert(lines, "📚 MODULES FOUND (" .. #ScanResults.Modules .. "):")
    for i, m in ipairs(ScanResults.Modules) do
        table.insert(lines, string.format("%d. %s", i, m.Name))
        table.insert(lines, "   Path: " .. m.Path)
    end
    table.insert(lines, "")
    
    table.insert(lines, "🛡️ ANTI-CHEAT REMOTES (" .. #ScanResults.AntiCheat .. "):")
    for _, name in ipairs(ScanResults.AntiCheat) do
        table.insert(lines, "   • " .. name)
    end
    
    local fullText = table.concat(lines, "\n")
    
    -- Copy ke clipboard
    local success = pcall(function()
        setclipboard(fullText)
    end)
    
    if success then
        statusText.Text = "✅ Results copied to clipboard!"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Flash effect
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(0.2)
        copyBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
    else
        statusText.Text = "❌ Copy failed - Select manually"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    return fullText
end

-- ===== FUNGSI CLEAR =====
local function clearResults()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    statusText.Text = "⏳ Ready to scan..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Reset results
    ScanResults.Remotes = {}
    ScanResults.Modules = {}
    ScanResults.AntiCheat = {}
    ScanResults.Date = os.date("%Y-%m-%d %H:%M:%S")
end

-- ===== BUTTON FUNCTIONS =====
scanBtn.MouseButton1Click:Connect(scanFishingSystem)

copyBtn.MouseButton1Click:Connect(function()
    if #ScanResults.Remotes == 0 then
        statusText.Text = "⚠️ Scan first before copying!"
        statusText.TextColor3 = Color3.fromRGB(255, 255, 0)
        return
    end
    copyResults()
end)

clearBtn.MouseButton1Click:Connect(clearResults)

-- ===== AUTO SCAN ON LOAD =====
task.spawn(function()
    task.wait(1)
    scanFishingSystem()
end)

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🔍 Fishing System Scanner v2.0 loaded!")
