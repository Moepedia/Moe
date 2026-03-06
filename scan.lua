-- DEBUG EQUIP ROD - COBA SEMUA KEMUNGKINAN
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- GUI sederhana
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "🔧 EQUIP DEBUGGER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 2)
close.BackgroundColor3 = Color3.new(0.8, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = title
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Log area
local log = Instance.new("TextLabel")
log.Size = UDim2.new(1, -10, 0, 150)
log.Position = UDim2.new(0, 5, 0, 35)
log.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
log.Text = "Ready to test..."
log.TextColor3 = Color3.new(0.8, 0.8, 0.8)
log.Font = Enum.Font.Gotham
log.TextSize = 11
log.TextWrapped = true
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top
log.Parent = frame

-- Fungsi log
local function addLog(msg)
    log.Text = log.Text .. "\n" .. msg
    -- Scroll ke bawah
    task.wait()
    log.TextYAlignment = Enum.TextYAlignment.Top
end

-- Cari semua remote event yang mungkin untuk equip
addLog("🔍 Mencari remote equip...")

local equipCandidates = {}
for _, obj in ipairs(Net:GetChildren()) do
    if obj:IsA("RemoteEvent") then
        if obj.Name:lower():match("equip") or 
           obj.Name:lower():match("tool") or 
           obj.Name:lower():match("hotbar") then
            table.insert(equipCandidates, obj)
            addLog("✅ Kandidat: " .. obj.Name)
        end
    end
end

-- Test setiap kandidat
addLog("\n🧪 Testing " .. #equipCandidates .. " kandidat...")

local function testEquip(remote, paramSet)
    local success = pcall(function()
        remote:FireServer(unpack(paramSet))
    end)
    return success
end

-- Parameter sets to try
local paramSets = {
    {1},
    {tonumber(1)},
    {"1"},
    {player.Character},
    {player.Backpack:FindFirstChildWhichIsA("Tool")},
    {player.Backpack:FindFirstChildWhichIsA("Tool"), 1},
    {}
}

for i, remote in ipairs(equipCandidates) do
    addLog("\n" .. string.rep("=", 30))
    addLog("Remote " .. i .. ": " .. remote.Name)
    
    for p, params in ipairs(paramSets) do
        local success = testEquip(remote, params)
        addLog("  Param set " .. p .. ": " .. (success and "✅" or "❌"))
        
        if success then
            task.wait(0.5)
            -- Cek apakah rod pindah
            local rodFound = false
            if player.Character then
                for _, tool in ipairs(player.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():match("rod") then
                        rodFound = true
                        addLog("  🎣 ROD DITEMUKAN DI TANGAN: " .. tool.Name)
                        break
                    end
                end
            end
            if rodFound then
                addLog("  ✅ EQUIP BERHASIL!")
                break
            end
        end
    end
end

-- Cek rod di backpack
addLog("\n📦 ROD DI BACKPACK:")
local rods = {}
for _, tool in ipairs(player.Backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name:lower():match("rod") then
        table.insert(rods, tool)
        addLog("  🎣 " .. tool.Name)
    end
end

if #rods == 0 then
    addLog("  ❌ TIDAK ADA ROD DI BACKPACK!")
end

addLog("\n✅ Selesai testing")
