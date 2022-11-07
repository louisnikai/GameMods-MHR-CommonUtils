local debugUtils = {
    debugCache = {}
}

function debugUtils.clone(object, exceptFields)
    local lookup_table = {}
    local function copyObj(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            if type(exceptFields) == "table" then
                for efKey, efValue in pairs(exceptFields) do
                    if tostring(efValue) == key then
                        goto continue
                    end
                end
            elseif type(exceptFields) == "string" then
                if exceptFields == key then goto continue end
            end
            new_table[copyObj(key)] = copyObj(value)
            ::continue::
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return copyObj(object)
end

function debugUtils.debugCache.haveChanges()
    if debugUtils.debugCache._prevData == nil then return true end

    for key, value in pairs(debugUtils.debugCache) do
        if key == "_prevData" then goto continue end
        if value ~= debugUtils.debugCache._prevData[key] then return true end
        ::continue::
    end

    return false
end
function debugUtils.debugCache.saveChanges()
    debugUtils.debugCache._prevData = debugUtils.clone(debugUtils.debugCache, "_prevData")
end

return debugUtils
