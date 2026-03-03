-- MOE FISHING TESTER v2.0 - GUI VERSION (COPY ALL)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeFishingTester"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 MOE FISHING TESTER v2.0"
title.TextColor3 = Color3.new(0, 1, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -20, 0, 30)
statusBar.Position = UDim2.new(0, 10, 0, 45)
statusBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusBar.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusBar

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -10, 1, 0)
statusText.Position = UDim2.new(0, 5, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "⏳ Ready to test"
statusText.TextColor3 = Color3.new(1, 1, 0)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- ===== LEFT PANEL (BUTTONS) =====
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 200, 1, -120)
leftPanel.Position = UDim2.new(0, 10, 0, 80)
leftPanel.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
leftPanel.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftPanel

local leftTitle = Instance.new("TextLabel")
leftTitle.Size = UDim2.new(1, -10, 0, 25)
leftTitle.Position = UDim2.new(0, 5, 0, 5)
leftTitle.BackgroundTransparency = 1
leftTitle.Text = "🎮 TEST BUTTONS"
leftTitle.TextColor3 = Color3.new(1, 1, 0)
leftTitle.TextSize = 14
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextXAlignment = Enum.TextXAlignment.Left
leftTitle.Parent = leftPanel

local leftScroll = Instance.new("ScrollingFrame")
leftScroll.Size = UDim2.new(1, -10, 1, -35)
leftScroll.Position = UDim2.new(0, 5, 0, 30)
leftScroll.BackgroundTransparency = 1
leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
leftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
leftScroll.ScrollBarThickness = 4
leftScroll.Parent = leftPanel

local leftContainer = Instance.new("Frame")
leftContainer.Size = UDim2.new(1, 0, 0, 0)
leftContainer.BackgroundTransparency = 1
leftContainer.Parent = leftScroll
leftContainer.AutomaticSize = Enum.AutomaticSize.Y

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
