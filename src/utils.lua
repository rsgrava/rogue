-- why this doesn't exist in stdlib is beyond me
function math.round(x)
    return math.floor(x + 0.5)
end

function string.startsWith(str, substr)
   return string.sub(str, 1, string.len(substr)) == substr
end

function table.random(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    return tbl[keys[math.random(#keys)]]
end

function cantor(node)
    return (node.x + node.y) * (node.x + node.y + 1) / 2 + node.y
end

