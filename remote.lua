-- MOE REMOTE SPY v1.0 - Capture semua remote pas fishing
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeSpyGUI"
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
title.Text = "🔍 MOE REMOTE SPY - Fishing Mode"
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
statusText.Text = "⏳ Status: Menunggu aktivitas fishing..."
statusText.TextColor3 = Color3.new(1, 1, 0)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

-- Counter
local counterText = Instance.new("TextLabel")
counterText.Size = UDim2.new(0, 100, 1, 0)
counterText.Position = UDim2.new(1, -110, 0, 0)
counterText.BackgroundTransparency = 1
counterText.Text = "0 remotes"
counterText.TextColor3 = Color3.new(0, 1, 0)
counterText.TextSize = 14
counterText.Font = Enum.Font.GothamBold
counterText.TextXAlignment = Enum.TextXAlignment.Right
counterText.Parent = statusBar

-- Text box hasil spy (bisa copy)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -120)
textBox.Position = UDim2.new(0, 10, 0, 80)
textBox.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
textBox.TextColor3 = Color3.new(0, 1, 0)
textBox.Font = Enum.Font.Code
textBox.TextSize = 12
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextWrapped = true
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.Text = "🔍 MOE REMOTE SPY - AKTIF\n"
textBox.Text = textBox.Text .. "================================\n"
textBox.Text = textBox.Text .. "Silakan lakukan FISHING NORMAL sekarang...\n"
textBox.Text = textBox.Text .. "Semua remote akan tercatat di sini\n\n"
textBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- Button frame
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

-- Start/Stop spy button
local spyBtn = Instance.new("TextButton")
spyBtn.Size = UDim2.new(0, 100, 0, 35)
spyBtn.Position = UDim2.new(0, 240, 0.5, -17.5)
spyBtn.BackgroundColor3 = Color3.new(0, 1, 0)
spyBtn.Text = "🔴 STOP SPY"
spyBtn.TextColor3 = Color3.new(1, 1, 1)
spyBtn.TextSize = 14
spyBtn.Font = Enum.Font.GothamBold
spyBtn.Parent = btnFrame

local spyCorner = Instance.new("UICorner")
spyCorner.CornerRadius = UDim.new(0, 6)
spyCorner.Parent = spyBtn

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

-- ===== VARIABLES =====
local spyActive = true
local remoteLog = {}
local remoteCount = 0

-- ===== REMOTE SPY FUNCTION =====
local function setupSpy()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if spyActive and (method == "FireServer" or method == "InvokeServer") then
            remoteCount = remoteCount + 1
            
            -- Format pesan
            local timestamp = os.date("%H:%M:%S")
            local remotePath = self:GetFullName()
            local argStr = ""
            
            for i, arg in ipairs(args) do
                if type(arg) == "string" then
                    argStr = argStr .. string.format("   Arg %d: %q\n", i, arg)
                elseif type(arg) == "number" then
                    argStr = argStr .. string.format("   Arg %d: %s\n", i, tostring(arg))
                elseif type(arg) == "boolean" then
                    argStr = argStr .. string.format("   Arg %d: %s\n", i, tostring(arg))
                elseif type(arg) == "table" then
                    argStr = argStr .. string.format("   Arg %d: [TABLE]\n", i)
                elseif type(arg) == "userdata" then
                    argStr = argStr .. string.format("   Arg %d: [USERDATA]\n", i)
                else
                    argStr = argStr .. string.format("   Arg %d: %s\n", i, tostring(arg))
                end
            end
            
            local logEntry = string.format("[%s] 🔴 %s\n   METHOD: %s\n%s\n", 
                timestamp, remotePath, method, argStr)
            
            table.insert(remoteLog, logEntry)
            
            -- Update text box
            local displayText = "🔍 MOE REMOTE SPY - AKTIF\n"
            displayText = displayText .. "================================\n"
            displayText = displayText .. string.format("Total remotes tercatat: %d\n\n", remoteCount)
            displayText = displayText .. table.concat(remoteLog, "\n")
            textBox.Text = displayText
            counterText.Text = remoteCount .. " remotes"
            statusText.Text = "🔴 Merekam... (" .. remoteCount .. " remotes)"
            
            -- Auto scroll ke bawah
            textBox.CursorPosition = #textBox.Text
        end
        
        return old(self, ...)
    end)
    
    print("✅ Remote Spy Aktif!")
end

-- ===== START SPY =====
setupSpy()

-- ===== BUTTON FUNCTIONS =====
copyBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard(textBox.Text)
    end)
    
    if success then
        statusText.Text = "✅ Copied to clipboard!"
        statusText.TextColor3 = Color3.new(0, 1, 0)
    else
        statusText.Text = "⚠️ Manual copy: Ctrl+A then Ctrl+C"
        statusText.TextColor3 = Color3.new(1, 1, 0)
        textBox:CaptureFocus()
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    remoteLog = {}
    remoteCount = 0
    textBox.Text = "🔍 MOE REMOTE SPY - AKTIF\n"
    textBox.Text = textBox.Text .. "================================\n"
    textBox.Text = textBox.Text .. "Silakan lakukan FISHING NORMAL sekarang...\n\n"
    counterText.Text = "0 remotes"
    statusText.Text = "🔄 Cleared - Menunggu aktivitas..."
end)

spyBtn.MouseButton1Click:Connect(function()
    spyActive = not spyActive
    if spyActive then
        spyBtn.Text = "🔴 STOP SPY"
        spyBtn.BackgroundColor3 = Color3.new(1, 0, 0)
        statusText.Text = "🔴 Merekam... (" .. remoteCount .. " remotes)"
        statusText.TextColor3 = Color3.new(1, 0, 0)
    else
        spyBtn.Text = "🟢 START SPY"
        spyBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        statusText.Text = "⏸️ Paused"
        statusText.TextColor3 = Color3.new(1, 1, 0)
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        writefile("MoeSpyLog_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", textBox.Text)
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
instr.Text = "💡 Lakukan FISHING NORMAL sekarang! Semua remote akan tercatat"
instr.TextColor3 = Color3.new(0.5, 0.5, 0.5)
instr.TextSize = 11
instr.Font = Enum.Font.Gotham
instr.Parent = mainFrame

-- Drag functionality
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
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

print("✅ Moe Remote Spy Loaded - Lakukan fishing normal sekarang!")
