local warExtended = warExtended
local EA_ChatWindow = EA_ChatWindow

warExtended.Modules={}

--To create slash commands for modules use the following table format:
--slashCommands = {
--  ["command"] = a
--    {
--      ["function"] = yourFunction,
--      ["description"] = c
--    }
--}
--
--if yourFunction doesn't work do function (...) return yourFunction (...) end
--
--To create options for modules use the following table format:
--options = {
--     ["option1"] = {
--    ["combobox"] ={ ["label"] = L"label", ["contents"] = {L"comboBoxText", L"comboBoxText2"}, ["size"] = small/medium/large/regular, ["onSelect"] = function }
--  ["editbox"] = { ["label"] = L"label", ["size"] = {["type"] = singleLine/multiLine, ["x"] = x, ["y"] = y}, ["onEnter"] = function, ["onTextChanged"]= function}
-- ["tickbox"] = { ["label"] = L"label", ["function"] = function }
--}
--}
--
--Dependency is "warExtended Core", you must name your module "warExtended moduleName" and register with warExtended.RegisterModule("moduleName", slashCommands, moduleOptions)
--All commands will show on running /warext, or individually per module running /warextmoduleName



local function addToSet(set, key)
  set[key] = true
end

local function removeFromSet(set, key)
  set[key] = nil
end

local function setContains(set, key)
  return set[key] ~= nil
end

local function getModuleSelfSlashCommands(module)

    for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
       local CommandDescription = warExtended.Modules[module]["cmd"][Command]["description"]
       warExtended.ModuleChatPrint(module, "/"..Command.." - "..CommandDescription)
    end

 end


local function getModuleHyperlink(module)
  local HyperlinkData = L"WAREXT:"..towstring(module)
  local HyperlinkText = L"[warExt] "
  local HyperlinkColor = DefaultColor.GREEN
    return CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
end


local function getModuleVersion(module)
    local Addons = ModulesGetData()
    local moduleName = "warExtended "..module

    for _, moduleData in ipairs(Addons) do
        if moduleData.name == moduleName then
                return towstring("v"..moduleData.version)
        end
    end
end

 local function registerModuleSlashCommands(module)

  for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
      LibSlash.RegisterSlashCmd(Command, function (...) warExtended.SlashHandler(Command,...) end)
    end

  end

  local function registerModuleSelfSlash(module)
    local selfSlash = "warext"..module
    local selfSlashFunction = function () return getModuleSelfSlashCommands(module) end

    LibSlash.RegisterSlashCmd(selfSlash, selfSlashFunction)

  end

-------
function warExtended.ModuleRegister(module, slashCommands)
  slashCommands = slashCommands or false

  if not warExtended.Modules[module] then
    warExtended.Modules[module]={}
    warExtended.Modules[module]["cmd"]  = slashCommands
    warExtended.Modules[module]["hyperlink"] = getModuleHyperlink(module)
    warExtended.Modules[module]["version"] = getModuleVersion(module)
  end

  if not warExtended.Modules[module]["cmd"] then return end
  registerModuleSlashCommands(module)
  registerModuleSelfSlash(module)

end


function warExtended.ModuleUnregister(module)
  warExtended.Modules[module] = nil
end

function warExtended.IsModuleEnabled(module)
  return setContains(warExtended.Modules, module)
end

function warExtended.ModuleChatPrint(module, text)
  text = towstring(text)
  local moduleHyperlink = warExtended.Modules[module]["hyperlink"]
  EA_ChatWindow.Print(moduleHyperlink..text)
end
