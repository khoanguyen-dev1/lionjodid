local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local key = "lionsextoy"

local function base64decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1,8 do c = c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function xor_deobfuscate(data, key)
    local result = {}
    for i = 1, #data do
        local keyByte = key:byte((i - 1) % #key + 1)
        local dataByte = data:byte(i)
        table.insert(result, string.char(bit32.bxor(dataByte, keyByte)))
    end
    return table.concat(result)
end

if getgenv().jodid and getgenv().jodid:sub(1,5) == "lion_" then
    local encoded = getgenv().jodid:sub(6)
    local decoded = base64decode(encoded)
    local jobId = xor_deobfuscate(decoded, key)
    
    print("Teleporting : " .. jobId)
    
    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",jobId)
else
    warn("⚠️ sextoy not found in getgenv().jodid")
    warn("⚠️ Please set getgenv().jodid = 'add' before running this script.")
end
