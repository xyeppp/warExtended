local warExtended = warExtended
if not warExtendedHooks then
    warExtendedHooks = {}
end

local hooks = {}

warExtendedHooks.GlobalFunctionPaths = {}
warExtendedHooks.SeenTables = {}
warExtendedHooks.TreePosition = {}
warExtendedHooks.HookedFunctions = {}
warExtendedHooks.HookedNames={}

function warExtended.GetFullFunctionPath(funcName)
    local path = {}
    for _,v in ipairs(warExtendedHooks.TreePosition) do
        table.insert(path,v)
    end
    table.insert( path, funcName)
    return path
end

function warExtended.AddFunctionNamesToTable(tableOfNames)

    for k, v in pairs(tableOfNames) do
	if not warExtendedHooks.GlobalFunctionPaths[k] then

        if(type(v) == "function") then
            warExtendedHooks.GlobalFunctionPaths[v] = warExtended.GetFullFunctionPath(k)

        elseif(type(v) == "table"
                and k ~= "_G"
                and k ~= "__index"
                and warExtendedHooks.SeenTables[v] == nil ) then

            table.insert(warExtendedHooks.TreePosition, k)
            warExtendedHooks.SeenTables[v] = true
            warExtended.AddFunctionNamesToTable(v)
            table.remove(warExtendedHooks.TreePosition)
        end
    end
end
end


function warExtended:Hook(func, newFunc)
    p(func)
    p("---new top / old bottom---")
    p(newFunc)
    warExtended.AddFunctionNamesToTable(_G)
    if not self.HookedFunctions then
        self.HookedFunctions={}
    end

    self.module.hooks[newFunc]=func

    --self.HookedFunctions[newFunc][]
   -- --if not self.HookedNames[func] then
       -- self.HookedNames[func]=towstring(func)
   -- end
    if(type(func) == "function") then


        local globalFunctionPath = warExtendedHooks.GlobalFunctionPaths[func]

        if(globalFunctionPath ~= nil) then

            local wrapperFunction = function(...)
				newFunc(...)
                return func(...)
            end

            if(#globalFunctionPath == 1) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]]
                _G[globalFunctionPath[1]] = wrapperFunction
            elseif(#globalFunctionPath == 2) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]] = wrapperFunction
            elseif(#globalFunctionPath == 3) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]] = wrapperFunction
            elseif(#globalFunctionPath == 4) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]] = wrapperFunction
            elseif(#globalFunctionPath == 5) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]] = wrapperFunction
            elseif(#globalFunctionPath == 6) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]] = wrapperFunction
            elseif(#globalFunctionPath == 7) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]] = wrapperFunction
            elseif(#globalFunctionPath == 8) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]] = wrapperFunction
            elseif(#globalFunctionPath == 9) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]] = wrapperFunction
            elseif(#globalFunctionPath == 10) then
                self.HookedFunctions[wrapperFunction] = _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]]
                _G[globalFunctionPath[1]][globalFunctionPath[2]][globalFunctionPath[3]][globalFunctionPath[4]][globalFunctionPath[5]][globalFunctionPath[6]][globalFunctionPath[7]][globalFunctionPath[8]][globalFunctionPath[9]][globalFunctionPath[10]] = wrapperFunction
            end

        end
    end
end

function warExtended:Unhook(wrappedFunc)
    if(type(wrappedFunc) == "function") then

        local originalFunc = self.module.hooks[wrappedFunc]

        local globalFunctionPath = warExtendedHooks.GlobalFunctionPaths[originalFunc]

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

        self.HookedFunctions[wrappedFunc] = nil
    end
end

function warExtended.Initialise()
    warExtended.AddFunctionNamesToTable(_G)
   -- hook = warExtended.Hook
    --unhook = warExtended.Unhook
end
