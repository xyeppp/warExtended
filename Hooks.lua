local warExtended = warExtended
local pairs = pairs
local ipairs = ipairs
local table = table

local GlobalFunctionPaths = {}
local SeenTables = {}
local TreePosition = {}
local HookedFunctions = {}

local function getFullFunctionPath(funcName)
    local path = {}
    for _,v in ipairs(TreePosition) do
        table.insert(path,v)
    end
    table.insert( path, funcName)
    return path
end

local function addFunctionNamesToTable(tableOfNames)

    for k, v in pairs(tableOfNames) do
	if not GlobalFunctionPaths[k] then

        if(type(v) == "function") then
            GlobalFunctionPaths[v] = getFullFunctionPath(k)

        elseif(type(v) == "table"
                and k ~= "_G"
                and k ~= "__index"
                and SeenTables[v] == nil ) then

            table.insert(TreePosition, k)
            SeenTables[v] = true
            addFunctionNamesToTable(v)
            table.remove(TreePosition)
        end
    end
end
end


function warExtended:Hook(func, newFunc)

    if not GlobalFunctionPaths[func] then
        addFunctionNamesToTable(_G)
    end

    if not HookedFunctions[newFunc] then
        HookedFunctions[newFunc] = {}
    end

    if(type(func) == "function") then


        local globalFunctionPath = GlobalFunctionPaths[func]

        if(globalFunctionPath ~= nil) then

            local wrapperFunction = function(...)
				newFunc(...)
                return func(...)
            end

            if(#globalFunctionPath == 1) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]]
                _G[globalFunctionPath[1]] = wrapperFunction
            elseif(#globalFunctionPath == 2) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]] = wrapperFunction
            elseif(#globalFunctionPath == 3) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]] = wrapperFunction
            elseif(#globalFunctionPath == 4) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]] = wrapperFunction
            elseif(#globalFunctionPath == 5) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]] = wrapperFunction
            elseif(#globalFunctionPath == 6) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]] = wrapperFunction
            elseif(#globalFunctionPath == 7) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]] = wrapperFunction
            elseif(#globalFunctionPath == 8) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]] = wrapperFunction
            elseif(#globalFunctionPath == 9) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]] = wrapperFunction
            elseif(#globalFunctionPath == 10) then
                HookedFunctions[newFunc][wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]] = wrapperFunction
            end

        end
    end
end

function warExtended:Unhook(wrappedFunc)
    if(type(wrappedFunc) == "function") then

        for Func,_ in pairs(HookedFunctions[wrappedFunc]) do
            local originalFunc = HookedFunctions[wrappedFunc][Func]

            local globalFunctionPath = GlobalFunctionPaths[originalFunc]

            if(#globalFunctionPath == 1) then
                _G[globalFunctionPath[1]] = originalFunc
            elseif(#globalFunctionPath == 2) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]] = originalFunc
            elseif(#globalFunctionPath == 3) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]] = originalFunc
            elseif(#globalFunctionPath == 4) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]] = originalFunc
            elseif(#globalFunctionPath == 5) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]] = originalFunc
            elseif(#globalFunctionPath == 6) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]] = originalFunc
            elseif(#globalFunctionPath == 7) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]] = originalFunc
            elseif(#globalFunctionPath == 8) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]] = originalFunc
            elseif(#globalFunctionPath == 9) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]] = originalFunc
            elseif(#globalFunctionPath == 10) then
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]] = originalFunc
            end
        end

        HookedFunctions[wrappedFunc] = nil

    end
end
