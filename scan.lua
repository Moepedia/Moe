-- ====================================================================
--     FISHING MECHANIC INVESTIGATOR v2.0 - WITH COPY FEATURE
-- ====================================================================
-- Bisa copy semua hasil investigasi dan kirim ke sini
-- ====================================================================

local Investigator = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Variabel untuk menyimpan hasil investigasi
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
--                     GUI INTERFACE
-- ====================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🎣 Fishing Mechanic Investigator v2.0",
    LoadingTitle = "Forensic Tools",
    LoadingSubtitle = "Dengan Fitur Copy Results",
    ConfigurationSaving = { Enabled = false }
})

-- Main Tab
local MainTab = Window:CreateTab("🔬 Investigate", nil)

-- Results Tab untuk menampilkan hasil
local ResultsTab = Window:CreateTab("📋 Results", nil)
local ResultsLabel = nil

-- Copy Tab
local CopyTab = Window:CreateTab("📋 Copy Results", nil)

-- ====================================================================
--                     FUNGSI INVESTIGASI
-- ====================================================================

-- 1. SCAN REMOTES
function Investigator.scanRemotes()
    local results = {
        title = "📡 SCAN REMOTE EVENTS",
        data = {}
    }
    
    table.insert(results.data, "╔════════════════════════════════════════╗")
    table.insert(results.data, "     📡 FISHING REMOTES SCAN")
    table.insert(results.data, "╚════════════════════════════════════════╝")
    
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
        table.insert(results.data, string.format("\n%d. [%s] %s", i, remote.Class, remote.Name))
        table.insert(results.data, "   📍 Path: " .. remote.Path)
    end
    
    table.insert(results.data, "\n📊 Total remotes ditemukan: " .. #fishingRemotes)
    
    return results
end

-- 2. CAPTURE PACKETS
function Investigator.capturePackets(duration)
    local results = {
        title = "📦 CAPTURE FISHING PACKETS",
        data = {}
    }
    
    table.insert(results.data, "╔════════════════════════════════════════╗")
    table.insert(results.data, "     📦 FISHING PACKET CAPTURE")
    table.insert(results.data, "╚════════════════════════════════════════╝")
    table.insert(results.data, "Duration: " .. duration .. " detik")
    table.insert(results.data, "Silahkan fishing manual sekarang...\n")
    
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
                
                -- Catat arguments
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
        -- Update progress
    end
    
    setreadonly(mt, true)
    
    InvestigationResults.CapturedPackets = captured
    
    table.insert(results.data, "📊 CAPTURE RESULTS:")
    table.insert(results.data, "Total remote calls: " .. #captured)
    
    if #captured > 0 then
        table.insert(results.data, "\n🔄 SEQUENCE:")
        for i, call in ipairs(captured) do
            local timeDiff = string.format("%.2f", call.Time - captured[1].Time)
            local args = table.concat(call.Args, ", ")
            table.insert(results.data, string.format("%d. [+%ss] %s - %s", i, timeDiff, call.Remote, call.Method))
            if args ~= "" then
                table.insert(results.data, "   Args: " .. args)
            end
        end
    end
    
    return results
end

-- 3. CHECK ROD
function Investigator.checkRod()
    local results = {
        title = "🎣 ROD VALIDATION CHECK",
        data = {}
    }
    
    table.insert(results.data, "╔════════════════════════════════════════╗")
    table.insert(results.data, "     🎣 ROD VALIDATION CHECK")
    table.insert(results.data, "╚════════════════════════════════════════╝")
    
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
            table.insert(results.data, "✅ Rod ditemukan di Backpack: " .. tool.Name)
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
                table.insert(results.data, "✅ Rod sedang dipegang: " .. tool.Name)
            end
        end
    end
    
    if not rodInfo.found then
        table.insert(results.data, "❌ TIDAK ADA ROD DITEMUKAN!")
    end
    
    InvestigationResults.RodInfo = rodInfo
    
    return results
end

-- 4. COMPARE OLD VS NEW
function Investigator.compareRemotes()
    local results = {
        title = "🔄 OLD VS NEW COMPARISON",
        data = {}
    }
    
    table.insert(results.data, "╔════════════════════════════════════════╗")
    table.insert(results.data, "     🔄 OLD VS NEW COMPARISON")
    table.insert(results.data, "╚════════════════════════════════════════╝")
    
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
    
    table.insert(results.data, "\n📋 CHECKING OLD REMOTES:")
    
    for _, oldName in ipairs(oldRemoteNames) do
        local found = false
        for _, current in ipairs(InvestigationResults.Remotes) do
            if current.Name == oldName then
                found = true
                table.insert(comparison.masih_ada, oldName)
                table.insert(results.data, "✅ " .. oldName .. " - MASIH ADA")
                table.insert(results.data, "   Path: " .. current.Path)
                break
            end
        end
        if not found then
            table.insert(comparison.hilang, oldName)
            table.insert(results.data, "❌ " .. oldName .. " - TIDAK ADA / BERUBAH")
            
            -- Cari kemiripan
            for _, current in ipairs(InvestigationResults.Remotes) do
                if current.Name:lower():match(oldName:lower():gsub("fishing",""):gsub("rod","")) then
                    table.insert(comparison.mirip, {old = oldName, new = current.Name})
                    table.insert(results.data, "   🔍 Mungkin diganti: " .. current.Name)
                end
            end
        end
    end
    
    InvestigationResults.Comparison = comparison
    
    return results
end

-- 5. TEST REMOTES
function Investigator.testRemotes()
    local results = {
        title = "🧪 REMOTE TESTING RESULTS",
        data = {}
    }
    
    table.insert(results.data, "╔════════════════════════════════════════╗")
    table.insert(results.data, "     🧪 REMOTE TESTING")
    table.insert(results.data, "╚════════════════════════════════════════╝")
    
    local testResults = {}
    
    for _, remote in ipairs(InvestigationResults.Remotes) do
        if remote.Class == "RemoteFunction" then
            table.insert(results.data, "\n🔬 Testing: " .. remote.Name)
            
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
                    table.insert(results.data, "   ✅ Param set " .. i .. " bekerja!")
                    table.insert(results.data, "      Args: " .. table.concat(params, ", "))
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
                table.insert(results.data, "   ❌ Tidak ada parameter yang bekerja")
            end
            
        elseif remote.Class == "RemoteEvent" then
            table.insert(results.data, "\n🔬 Testing Event: " .. remote.Name)
            
            local success = pcall(function()
                for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                    if obj.Name == remote.Name and obj:IsA("RemoteEvent") then
                        obj:FireServer()
                        return true
                    end
                end
            end)
            
            table.insert(results.data, "   FireServer: " .. (success and "✅ OK" or "❌ Error"))
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

-- 6. FULL INVESTIGATION
function Investigator.fullInvestigation()
    local allResults = {}
    
    -- Jalankan semua investigasi berurutan
    table.insert(allResults, Investigator.scanRemotes())
    
    -- Notify user untuk fishing manual
    Rayfield:Notify({
        Title = "🎣 Fishing Manual Required",
        Content = "Silahkan fishing manual selama 10 detik...",
        Duration = 3
    })
    
    task.wait(1)
    table.insert(allResults, Investigator.capturePackets(10))
    
    table.insert(allResults, Investigator.checkRod())
    table.insert(allResults, Investigator.compareRemotes())
    table.insert(allResults, Investigator.testRemotes())
    
    -- Gabungkan semua hasil
    local finalResults = {
        title = "📊 FULL INVESTIGATION RESULTS",
        data = {}
    }
    
    for _, res in ipairs(allResults) do
        for _, line in ipairs(res.data) do
            table.insert(finalResults.data, line)
        end
        table.insert(finalResults.data, "\n" .. string.rep("=", 50) .. "\n")
    end
    
    -- Update results label
    updateResultsDisplay(finalResults)
    
    return finalResults
end

-- ====================================================================
--                     DISPLAY FUNCTIONS
-- ====================================================================

local currentResults = {}

function updateResultsDisplay(results)
    currentResults = results
    
    if ResultsLabel then
        local text = table.concat(results.data, "\n")
        ResultsLabel:Set(text)
    end
end

function copyAllResults()
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
    
    -- Final full text
    local fullText = table.concat(allText, "\n")
    
    -- Copy to clipboard
    setclipboard and setclipboard(fullText)
    
    return fullText
end

-- ====================================================================
--                     GUI BUTTONS
-- ====================================================================

-- MAIN TAB BUTTONS
MainTab:CreateButton({
    Name = "1️⃣ Scan All Fishing Remotes",
    Callback = function()
        local results = Investigator.scanRemotes()
        updateResultsDisplay(results)
        Rayfield:Notify({
            Title = "✅ Scan Complete",
            Content = "Ditemukan " .. #InvestigationResults.Remotes .. " remotes",
            Duration = 3
        })
    end
})

MainTab:CreateButton({
    Name = "2️⃣ Capture Packets (10 detik)",
    Callback = function()
        Rayfield:Notify({
            Title = "🎣 Capture Started",
            Content = "Fishing manual selama 10 detik...",
            Duration = 2
        })
        local results = Investigator.capturePackets(10)
        updateResultsDisplay(results)
    end
})

MainTab:CreateButton({
    Name = "3️⃣ Check Rod Validation",
    Callback = function()
        local results = Investigator.checkRod()
        updateResultsDisplay(results)
    end
})

MainTab:CreateButton({
    Name = "4️⃣ Compare Old vs New",
    Callback = function()
        local results = Investigator.compareRemotes()
        updateResultsDisplay(results)
    end
})

MainTab:CreateButton({
    Name = "5️⃣ Test All Remotes",
    Callback = function()
        local results = Investigator.testRemotes()
        updateResultsDisplay(results)
    end
})

MainTab:CreateButton({
    Name = "🔄 FULL INVESTIGATION (Recommended)",
    Callback = function()
        local results = Investigator.fullInvestigation()
        Rayfield:Notify({
            Title = "✅ Investigation Complete",
            Content = "Buka tab Results untuk melihat",
            Duration = 3
        })
    end
})

-- RESULTS TAB
ResultsLabel = ResultsTab:CreateParagraph({
    Title = "📊 Investigation Results",
    Content = "Belum ada hasil. Jalankan investigasi dulu!"
})

-- COPY TAB
CopyTab:CreateParagraph({
    Title = "📋 Copy Results",
    Content = [[
Klik tombol di bawah untuk copy semua hasil investigasi.
Hasil akan otomatis ter-copy ke clipboard.
    ]]
})

CopyTab:CreateButton({
    Name = "📋 COPY ALL RESULTS",
    Callback = function()
        local text = copyAllResults()
        Rayfield:Notify({
            Title = "✅ Copied!",
            Content = "Hasil sudah di copy. Paste dan kirim ke saya!",
            Duration = 5
        })
    end
})

CopyTab:CreateButton({
    Name = "📤 Kirim ke Forum/Developer",
    Callback = function()
        local text = copyAllResults()
        Rayfield:Notify({
            Title = "✅ Siap Dikirim!",
            Content = "Hasil sudah di copy. Paste di sini!",
            Duration = 5
        })
    end
})

CopyTab:CreateParagraph({
    Title = "📝 Format untuk dikirim:",
    Content = [[
1. Jalankan FULL INVESTIGATION
2. Klik COPY ALL RESULTS
3. Paste hasilnya di sini
4. Saya akan analisis perubahannya
    ]]
})

-- Info Tab
local InfoTab = Window:CreateTab("ℹ️ I
