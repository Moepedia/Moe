-- MOE FISHING PARAMETER TESTER
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeParamTester"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 600)
frame.Position = UDim2.new(0.5, -250, 0.5, -300)
frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Text = "🎣 MOE PARAMETER FINDER"
header.TextColor3 = Color3.new(0, 1, 0)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 2.5)
close.BackgroundColor3 = Color3.new(1, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.Parent = header

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Scroll frame untuk konten
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0, 0)
container.BackgroundTransparency = 1
container.Parent = scroll
container.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = container

-- ===== REMOTE SETUP =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local RF = Net:FindFirstChild("RF")

local Remote = {
    RequestMinigame = RF and RF:FindFirstChild("1239e94e6397b16cef3f55f2d4dbc4b8de29b5552820cb62e0477b58bad3b47f"),
    CastRod = RF and RF:FindFirstChild("0f54ec0060b2b41e6d662c98f5f5e329065210ef504926fc89577dceb774915c"),
    CatchFish = RF and RF:FindFirstChild("c8f3fe1d1a51c63b116e59e52aa538562a03a0e273fab6ef8a5768bf936df31d"),
}

-- ===== FUNGSI BUAT INPUT =====
local function createInputRow(name, default1, default2, default3)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 100)
    row.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    row.Parent = container
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.new(1, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = row
    
    local input1 = Instance.new("TextBox")
    input1.Size = UDim2.new(0.3, -5, 0, 30)
    input1.Position = UDim2.new(0, 5, 0, 35)
    input1.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input1.Text = tostring(default1 or "")
    input1.PlaceholderText = "Arg 1"
    input1.TextColor3 = Color3.new(1, 1, 1)
    input1.Font = Enum.Font.Code
    input1.Parent = row
    
    local input2 = Instance.new("TextBox")
    input2.Size = UDim2.new(0.3, -5, 0, 30)
    input2.Position = UDim2.new(0.35, 0, 0, 35)
    input2.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input2.Text = tostring(default2 or "")
    input2.PlaceholderText = "Arg 2"
    input2.TextColor3 = Color3.new(1, 1, 1)
    input2.Font = Enum.Font.Code
    input2.Parent = row
    
    local input3 = Instance.new("TextBox")
    input3.Size = UDim2.new(0.3, -5, 0, 30)
    input3.Position = UDim2.new(0.7, 0, 0, 35)
    input3.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    input3.Text = tostring(default3 or "")
    input3.PlaceholderText = "Arg 3"
    input3.TextColor3 = Color3.new(1, 1, 1)
    input3.Font = Enum.Font.Code
    input3.Parent = row
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 70)
    btn.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
    btn.Text = "TEST " .. name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return row, {input1, input2, input3}, btn
end

-- ===== CREATE INPUT ROWS =====
local function createInputs()
    -- Request Minigame
    local row1, inputs1, btn1 = createInputRow("Request Minigame", "true")
    btn1.MouseButton1Click:Connect(function()
        local arg = inputs1[1].Text == "true" and true or false
        local success, result = pcall(function()
            return Remote.RequestMinigame:InvokeServer(arg)
        end)
        print("RequestMinigame:", success, result)
    end)
    
    -- Cast Rod (dengan parameter dari log)
    local row2, inputs2, btn2 = createInputRow("Cast Rod", "-1.233184814453125", "0.5", "1772552798.43857")
    btn2.MouseButton1Click:Connect(function()
        local arg1 = tonumber(inputs2[1].Text) or -1.233
        local arg2 = tonumber(inputs2[2].Text) or 0.5
        local arg3 = tonumber(inputs2[3].Text) or tick()
        local success, result = pcall(function()
            return Remote.CastRod:InvokeServer(arg1, arg2, arg3)
        end)
        print("CastRod:", success, result)
    end)
    
    -- Catch Fish
    local row3, inputs3, btn3 = createInputRow("Catch Fish")
    btn3.MouseButton1Click:Connect(function()
        local success, result = pcall(function()
            return Remote.CatchFish:InvokeServer()
        end)
        print("CatchFish:", success, result)
    end)
    
    -- Sequence
    local seqRow = Instance.new("Frame")
    seqRow.Size = UDim2.new(1, 0, 0, 70)
    seqRow.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    seqRow.Parent = container
    
    local seqCorner = Instance.new("UICorner")
    seqCorner.CornerRadius = UDim.new(0, 6)
    seqCorner.Parent = seqRow
    
    local seqTitle = Instance.new("TextLabel")
    seqTitle.Size = UDim2.new(1, -10, 0, 25)
    seqTitle.Position = UDim2.new(0, 5, 0, 5)
    seqTitle.BackgroundTransparency = 1
    seqTitle.Text = "FULL SEQUENCE"
    seqTitle.TextColor3 = Color3.new(1, 1, 0)
    seqTitle.Font = Enum.Font.GothamBold
    seqTitle.TextXAlignment = Enum.TextXAlignment.Left
    seqTitle.Parent = seqRow
    
    local seqBtn = Instance.new("TextButton")
    seqBtn.Size = UDim2.new(1, -10, 0, 35)
    seqBtn.Position = UDim2.new(0, 5, 0, 35)
    seqBtn.BackgroundColor3 = Color3.new(0.9, 0.6, 0)
    seqBtn.Text = "RUN SEQUENCE (Request → Cast → Catch)"
    seqBtn.TextColor3 = Color3.new(1, 1, 1)
    seqBtn.Font = Enum.Font.GothamBold
    seqBtn.Parent = seqRow
    
    local seqBtnCorner = Instance.new("UICorner")
    seqBtnCorner.CornerRadius = UDim.new(0, 6)
    seqBtnCorner.Parent = seqBtn
    
    seqBtn.MouseButton1Click:Connect(function()
        local results = {}
        
        -- Request
        local success1, res1 = pcall(function()
            return Remote.RequestMinigame:InvokeServer(true)
        end)
        table.insert(results, "Req: " .. tostring(success1))
        
        -- Cast (pake parameter dari input)
        local arg1 = tonumber(inputs2[1].Text) or -1.233
        local arg2 = tonumber(inputs2[2].Text) or 0.5
        local arg3 = tonumber(inputs2[3].Text) or tick()
        local success2, res2 = pcall(function()
            return Remote.CastRod:InvokeServer(arg1, arg2, arg3)
        end)
        table.insert(results, "Cast: " .. tostring(success2))
        
        -- Catch
        local success3, res3 = pcall(function()
            return Remote.CatchFish:InvokeServer()
        end)
        table.insert(results, "Catch: " .. tostring(success3))
        
        print("SEQUENCE:", table.concat(results, " | "))
    end)
end

createInputs()

-- Output box
local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(1, -20, 0, 100)
outputBox.Position = UDim2.new(0, 10, 1, -105)
outputBox.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
outputBox.TextColor3 = Color3.new(0, 1, 0)
outputBox.Font = Enum.Font.Code
outputBox.TextSize = 12
outputBox.TextWrapped = true
outputBox.ClearTextOnFocus = false
outputBox.MultiLine = true
outputBox.Text = "Hasil akan muncul di console (F9)\n"
outputBox.Parent = frame

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 6)
outputCorner.Parent = outputBox

-- Copy button di bawah
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 100, 0, 30)
copyBtn.Position = UDim2.new(1, -110, 1, -35)
copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
copyBtn.Text = "📋 COPY"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = frame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

copyBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        setclipboard(outputBox.Text)
    end)
    if success then
        copyBtn.Text = "✅ COPIED!"
        task.wait(1)
        copyBtn.Text = "📋 COPY"
    end
end)

print("✅ Parameter Tester Loaded - Coba berbagai kombinasi parameter!")leftContainer.AutomaticSize = Enum.AutomaticSize.Y

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 5)
leftLayout.Parent = leftContainer

-- ===== RIGHT PANEL (RESULTS) =====
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(1, -230, 1, -120)
rightPanel.Position = UDim2.new(0, 220, 0, 80)
rightPanel.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
rightPanel.Parent = mainFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightPanel

local rightTitle = Instance.new("TextLabel")
rightTitle.Size = UDim2.new(1, -10, 0, 25)
rightTitle.Position = UDim2.new(0, 5, 0, 5)
rightTitle.BackgroundTransparency = 1
rightTitle.Text = "📋 TEST RESULTS"
rightTitle.TextColor3 = Color3.new(0, 1, 0)
rightTitle.TextSize = 14
rightTitle.Font = Enum.Font.GothamBold
rightTitle.TextXAlignment = Enum.TextXAlignment.Left
rightTitle.Parent = rightPanel

local resultBox = Instance.new("TextBox")
resultBox.Size = UDim2.new(1, -10, 1, -35)
resultBox.Position = UDim2.new(0, 5, 0, 30)
resultBox.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
resultBox.TextColor3 = Color3.new(0, 1, 0)
resultBox.Font = Enum.Font.Code
resultBox.TextSize = 12
resultBox.TextXAlignment = Enum.TextXAlignment.Left
resultBox.TextYAlignment = Enum.TextYAlignment.Top
resultBox.TextWrapped = true
resultBox.ClearTextOnFocus = false
resultBox.MultiLine = true
resultBox.Text = "Klik tombol di kiri untuk testing...\n"
resultBox.Parent = rightPanel

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 6)
resultCorner.Parent = resultBox

-- ===== BOTTOM BUTTONS =====
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, -20, 0, 40)
btnFrame.Position = UDim2.new(0, 10, 1, -45)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = mainFrame

-- Copy button
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 35)
copyBtn.Position = UDim2.new(0, 0, 0.5, -17.5)
copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
copyBtn.Text = "📋 COPY ALL"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 14
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = btnFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

-- Clear button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 100, 0, 35)
clearBtn.Position = UDim2.new(0, 130, 0.5, -17.5)
clearBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
clearBtn.Text = "🗑️ CLEAR"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = btnFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Save button
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 100, 0, 35)
saveBtn.Position = UDim2.new(1, -105, 0.5, -17.5)
saveBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
saveBtn.Text = "💾 SAVE"
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextSize = 14
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = btnFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- ===== FUNCTIONS =====
local function log(message, ...)
    local timestamp = os.date("%H:%M:%S")
    local fullMsg = string.format("[%s] " .. message .. "\n", timestamp, ...)
    resultBox.Text = resultBox.Text .. fullMsg
    resultBox.CursorPosition = #resultBox.Text
    print(fullMsg)
end

local function clearLog()
    resultBox.Text = "Klik tombol di kiri untuk testing...\n"
end

-- ===== REMOTE SETUP =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local RF = Net:FindFirstChild("RF")
local RE = Net:FindFirstChild("RE")

-- Kumpulkan remote dari log
local Remote = {
    -- Dari log pertama (fishing)
    UnknownLoop = RF and RF:FindFirstChild("58a6e01eaa04a83c7b798f9b65690793994aaa3be341c048d05324df65841dad"),
    RequestMinigame = RF and RF:FindFirstChild("1239e94e6397b16cef3f55f2d4dbc4b8de29b5552820cb62e0477b58bad3b47f"),
    CastRod = RF and RF:FindFirstChild("0f54ec0060b2b41e6d662c98f5f5e329065210ef504926fc89577dceb774915c"),
    CatchFish = RF and RF:FindFirstChild("c8f3fe1d1a51c63b116e59e52aa538562a03a0e273fab6ef8a5768bf936df31d"),
    
    -- Dari log kedua (idle)
    UnknownRE1 = RE and RE:FindFirstChild("477cc2d898da8af6395af6c6e0160bf0aaef76e1f4e68ceed269ad5a52ee3e99"),
    UnknownRE2 = RE and RE:FindFirstChild("8581697fd6df319d2e17b7805b4d5cf580ec02a7cae318b40c364df6821648e5"),
    UnknownRF2 = RF and RF:FindFirstChild("285a699b79b831b980bd5a50a1bb9b3d309699f17a8daffe36f38c6c24594b33"),
    
    -- Remote metrics
    EventMetrics = ReplicatedStorage:FindFirstChild("Modules") and 
                   ReplicatedStorage.Modules.Gamebeast.Infra.Shared.Modules.GetRemote.Remotes.EventExportClientMetrics,
    GameAnalyticsError = ReplicatedStorage:FindFirstChild("GameAnalyticsError"),
}

-- Tampilkan status
log("=== REMOTE STATUS ===")
for name, remote in pairs(Remote) do
    if remote then
        log("✅ %s: %s", name, remote:GetFullName())
    else
        log("❌ %s: NOT FOUND", name)
    end
end
log("")

-- ===== CREATE BUTTONS =====
local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = color or Color3.new(0.3, 0.3, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = leftContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local success, result = pcall(callback)
        if success then
            log("✅ %s - Success", text)
        else
            log("❌ %s - Error: %s", text, tostring(result))
        end
    end)
end

-- Test buttons
if Remote.RequestMinigame then
    createButton("1. REQUEST MINIGAME (true)", function()
        return Remote.RequestMinigame:InvokeServer(true)
    end, Color3.new(0.2, 0.5, 0.8))
end

if Remote.CastRod then
    createButton("2. CAST ROD (random)", function()
        local pos = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) and 
                    player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
        return Remote.CastRod:InvokeServer(pos.X, 0.5, tick())
    end, Color3.new(0.2, 0.8, 0.5))
    
    createButton("2a. CAST ROD (fixed)", function()
        return Remote.CastRod:InvokeServer(-1.233184814453125, 0.5, 1772552798.43857)
    end, Color3.new(0.2, 0.8, 0.5))
end

if Remote.CatchFish then
    createButton("3. CATCH FISH", function()
        return Remote.CatchFish:InvokeServer()
    end, Color3.new(0.8, 0.5, 0.2))
end

if Remote.UnknownLoop then
    createButton("4. UNKNOWN LOOP", function()
        return Remote.UnknownLoop:InvokeServer()
    end, Color3.new(0.5, 0.3, 0.7))
end

if Remote.UnknownRE1 then
    createButton("5. UNKNOWN RE1 (arg 1)", function()
        return Remote.UnknownRE1:FireServer(1)
    end, Color3.new(0.7, 0.3, 0.5))
end

if Remote.UnknownRE2 then
    createButton("6. UNKNOWN RE2 (arg 'Fish')", function()
        return Remote.UnknownRE2:FireServer("Fish")
    end, Color3.new(0.7, 0.5, 0.3))
    
    createButton("6a. UNKNOWN RE2 (arg 'Cast')", function()
        return Remote.UnknownRE2:FireServer("Cast")
    end)
end

if Remote.UnknownRF2 then
    createButton("7. UNKNOWN RF2", function()
        return Remote.UnknownRF2:InvokeServer()
    end, Color3.new(0.5, 0.5, 0.5))
end

-- Sequence buttons
createButton("🔄 SEQUENCE 1-2-3", function()
    local results = {}
    if Remote.RequestMinigame then
        table.insert(results, "ReqMinigame: " .. tostring(Remote.RequestMinigame:InvokeServer(true)))
    end
    if Remote.CastRod then
        local pos = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) and 
                    player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
        table.insert(results, "Cast: " .. tostring(Remote.CastRod:InvokeServer(pos.X, 0.5, tick())))
    end
    if Remote.CatchFish then
        table.insert(results, "Catch: " .. tostring(Remote.CatchFish:InvokeServer()))
    end
    return table.concat(results, " | ")
end, Color3.new(0.9, 0.6, 0))

createButton("🔄 SEQUENCE 2-3", function()
    local results = {}
    if Remote.CastRod then
        local pos = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) and 
                    player.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
        table.insert(results, "Cast: " .. tostring(Remote.CastRod:InvokeServer(pos.X, 0.5, tick())))
    end
    if Remote.CatchFish then
        table.insert(results, "Catch: " .. tostring(Remote.CatchFish:InvokeServer()))
    end
    return table.concat(results, " | ")
end, Color3.new(0.9, 0.6, 0))

-- Utility buttons
createButton("🔄 RESET CHARACTER", function()
    if player.Character then
        player.Character:BreakJoints()
        task.wait(1)
        player.LoadCharacter:Wait()
        return "Character reset"
    end
end, Color3.new(0.8, 0.2, 0.2))

createButton("📊 GET POSITION", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        return string.format("Position: X=%.2f, Y=%.2f, Z=%.2f", pos.X, pos.Y, pos.Z)
    end
    return "No character"
end, Color3.new(0.4, 0.4, 0.4))

-- ===== BUTTON FUNCTIONS =====
copyBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        setclipboard(resultBox.Text)
    end)
    
    if success then
        statusText.Text = "✅ Copied to clipboard!"
        statusText.TextColor3 = Color3.new(0, 1, 0)
    else
        statusText.Text = "⚠️ Use Ctrl+A then Ctrl+C"
        statusText.TextColor3 = Color3.new(1, 1, 0)
        resultBox:CaptureFocus()
    end
end)

clearBtn.MouseButton1Click:Connect(clearLog)

saveBtn.MouseButton1Click:Connect(function()
    local success = pcall(function()
        writefile("MoeFishingTest_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", resultBox.Text)
    end)
    
    if success then
        statusText.Text = "✅ Saved to file!"
        statusText.TextColor3 = Color3.new(0, 1, 0)
    else
        statusText.Text = "❌ Save failed"
        statusText.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- Instructions
local instr = Instance.new("TextLabel")
instr.Size = UDim2.new(1, -20, 0, 20)
instr.Position = UDim2.new(0, 10, 1, -22)
instr.BackgroundTransparency = 1
instr.Text = "💡 Klik tombol satu per satu atau gunakan sequence. Hasil akan tercatat di kanan."
instr.TextColor3 = Color3.new(0.5, 0.5, 0.5)
instr.TextSize = 11
instr.Font = Enum.Font.Gotham
instr.Parent = mainFrame

print("✅ Moe Fishing Tester v2.0 Loaded!")
