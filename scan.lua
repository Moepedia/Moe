-- REMOTE SPY - Lihat semua remote yang dipanggil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logs = {}

-- Cari semua remote
local function scanAllRemotes()
    print("🔍 SCANNING ALL REMOTES...")
    local remotes = {}
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:match("Fish") or obj.Name:match("Rod") or obj.Name:match("Cast") or 
               obj.Name:match("Catch") or obj.Name:match("Reel") or obj.Name:match("Minigame") then
                table.insert(remotes, obj)
            end
        end
    end
    return remotes
end

-- Pasang spy
local remotes = scanAllRemotes()
print("📡 Memata-matai " .. #remotes .. " remote...")
print("🟢 Silahkan FISHING MANUAL sekarang!")
print("========================================")

-- Hook ke semua remote
for _, remote in ipairs(remotes) do
    if remote:IsA("RemoteEvent") then
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            print("📤 REMOTE EVENT:", remote.Name)
            for i, arg in ipairs(args) do
                print("   Arg " .. i .. ": " .. tostring(arg))
            end
            return oldFire(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local args = {...}
            print("📤 REMOTE FUNCTION:", remote.Name)
            for i, arg in ipairs(args) do
                print("   Arg " .. i .. ": " .. tostring(arg))
            end
            local result = {oldInvoke(self, ...)}
            print("   Return: " .. tostring(result[1]))
            return unpack(result)
        end
    end
end
