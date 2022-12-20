if not CaptainHook then
    CaptainHook = {}
end

CaptainHook.GlobalFunctionPaths = {}
CaptainHook.SeenTables = {}
CaptainHook.TreePosition = {}
CaptainHook.HookedFunctions = {}

function CaptainHook.GetFullFunctionPath(funcName)
    local path = {}
    for _,v in ipairs(CaptainHook.TreePosition) do 
        table.insert(path,v) 
    end
    table.insert( path, funcName)
    return path
end

function CaptainHook.AddFunctionNamesToTable(tableOfNames)

    for k, v in pairs(tableOfNames) do

        if(type(v) == "function") then

            CaptainHook.GlobalFunctionPaths[v] = CaptainHook.GetFullFunctionPath(k)

        elseif(type(v) == "table" 
                and k ~= "_G" 
                and k ~= "__index" 
                and CaptainHook.SeenTables[v] == nil ) then

            table.insert(CaptainHook.TreePosition, k)
            CaptainHook.SeenTables[v] = true
            CaptainHook.AddFunctionNamesToTable(v)
            table.remove(CaptainHook.TreePosition)
        end
    end
end

function CaptainHook.Hook(func)
    if(type(func) == "function") then 
            
        local globalFunctionPath = CaptainHook.GlobalFunctionPaths[func]
        
        if(globalFunctionPath ~= nil) then

            local wrapperFunction = function(...)
                p(...)
                func(...)
            end

            if(#globalFunctionPath == 1) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]]
                _G[globalFunctionPath[1]] = wrapperFunction
            elseif(#globalFunctionPath == 2) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]] = wrapperFunction
            elseif(#globalFunctionPath == 3) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]] = wrapperFunction
            elseif(#globalFunctionPath == 4) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]] = wrapperFunction
            elseif(#globalFunctionPath == 5) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]] = wrapperFunction
            elseif(#globalFunctionPath == 6) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]] = wrapperFunction
            elseif(#globalFunctionPath == 7) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]] = wrapperFunction
            elseif(#globalFunctionPath == 8) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]] = wrapperFunction
            elseif(#globalFunctionPath == 9) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]] = wrapperFunction
            elseif(#globalFunctionPath == 10) then
                CaptainHook.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]] = wrapperFunction
            end        

        end
    end
end

function CaptainHook.Unhook(wrappedFunc)
    if(type(wrappedFunc) == "function") then 
        local originalFunc = CaptainHook.HookedFunctions[wrappedFunc]

        local globalFunctionPath = CaptainHook.GlobalFunctionPaths[originalFunc]

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

        CaptainHook.HookedFunctions[wrappedFunc] = nil
    end
end

function CaptainHook.Initialise()
    CaptainHook.AddFunctionNamesToTable(_G)
    hook = CaptainHook.Hook
    unhook = CaptainHook.Unhook
end