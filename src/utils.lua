-- why this doesn't exist in stdlib is beyond me
function math.round(x)
    return math.floor(x + 0.5)
end

function string.startsWith(str, substr)
   return string.sub(str, 1, string.len(substr)) == substr
end

function string.split(str)
    words = {}
    for word in str:gmatch("%S+") do
        table.insert(words, word)
    end
    return words
end

function table.cat(tbl1,tbl2)
    for i = 1, #tbl2 do
        tbl1[#tbl1 + 1] = tbl2[i]
    end
    return tbl1
end

function table.random(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    return tbl[keys[math.random(#keys)]]
end

function table.randomKey(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys[math.random(#keys)]
end

function cantor(x, y)
    return (x + y) * (x + y + 1) / 2 + y
end

function inverseCantor(z)
    local w = math.floor((math.sqrt(8 * z + 1) - 1) / 2)
    local t = (w^2 + w) / 2
    local y = z - t
    local x = w - y
    return x, y
end
