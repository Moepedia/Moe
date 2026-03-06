-- AUTO DETECT HASH REMOTE
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- Cari semua remote ber-hash
print("🔍 MENCARI REMOTE HASH...")
print("==========================")

local hashRemotes = {}

for _, remote in pairs(Net:GetChildren()) do
    local name = remote.Name
    -- Cek apakah nama seperti hash (64 karakter hex)
    if string.match(name, "^[RF][E/F]/[a-f0-9]+$") then
        table.insert(hashRemotes, {
            Name = name,
            Class = remote.ClassName,
            FullName = remote:GetFullName()
        })
    end
end

print("📊 DITEMUKAN " .. #hashRemotes .. " HASH REMOTE:")
for i, r in ipairs(hashRemotes) do
    print(i .. ". " .. r.Name)
end

print("\n💡 SIMPAN DAFTAR INI!")
print("Gunakan hash ini di script auto fish")
