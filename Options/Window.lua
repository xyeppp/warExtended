local warExtendedOptions = warExtendedOptions
local OPTIONS_WINDOW = "warExtendedOptionsWindow"
local OPTIONS_WINDOW_SCROLL_CHILD = OPTIONS_WINDOW.."MainScrollChild"
local SLASH_WINDOW = "warExtendedOptionsSlashCommands"
local TITLE_BAR_TEXT = L"warExtended Settings"
local DEFAULT_TOPIC = L"Settings"
local DEFAULT_TEXT = L"Select an addon from the list on the left to open it's settings."
local EMPTY_TEXT = L"No warExtended modules registered."
local CLOSE_TEXT = L"Close"

function warExtendedOptions.WindowOnInitialize()
  LabelSetText(OPTIONS_WINDOW.."TitleBarText", TITLE_BAR_TEXT)
  ButtonSetText(OPTIONS_WINDOW.."ExitButton", CLOSE_TEXT)
  LabelSetText( OPTIONS_WINDOW.."HeaderText", DEFAULT_TOPIC)
end

function warExtendedOptions.WindowOnShutdown()

end

function warExtendedOptions.WindowOnShown()
  if #warExtendedOptions.data == 0 then
    LabelSetText( OPTIONS_WINDOW.."MainScrollChildText", EMPTY_TEXT)
  else
    LabelSetText( OPTIONS_WINDOW.."MainScrollChildText", DEFAULT_TEXT)
  end
  
    warExtendedOptions.PrepareData()
    warExtendedOptions.UpdateOptionsWindowRow()
    warExtendedOptions.SetListRowTints()
end


local index = 0
local cmdTemplate = "warExtendedOptionsSlashCommandTemplate"

local function displaySlashWindow(entryData)
local optionParent = warExtendedOptions.GetOptionParent(entryData.parentEntryId)
local slashCommands = warExtended.GetModuleSlashCommands(optionParent.addonName)
  if index > 0 then
    for i=1,index do
      DestroyWindow(cmdTemplate..i)
    end
    index = 0
  end
  
  for k,v in pairs(slashCommands) do
    index = index + 1
    CreateWindowFromTemplate(cmdTemplate..index, "warExtendedOptionsSlashCommandTemplate", SLASH_WINDOW.."ScrollChild")
    LabelSetText(cmdTemplate..index.."Label", towstring("/"..k))
    LabelSetText(cmdTemplate..index.."Text", towstring(v))
    if index == 1 then
      WindowAddAnchor( cmdTemplate..index, "topleft", SLASH_WINDOW.."ScrollChild", "topleft", 5, 5 )
    else
      WindowAddAnchor( cmdTemplate..index, "center", cmdTemplate..index-1, "center", 0, 40 )
    end
  end
end

local function displayDescriptionWindow(entryData)
  LabelSetText( OPTIONS_WINDOW_SCROLL_CHILD.."Text",  warExtended.GetAddonDescription(entryData.addonName))
end

function warExtendedOptions.DisplayEntryWindow(entryData)
  if not DoesWindowExist(entryData.parentWindow) then
    CreateWindow(entryData.parentWindow, true)
  end
  
  if entryData.parentWindow == OPTIONS_WINDOW.."Main" then
    displayDescriptionWindow(entryData)
  elseif entryData.parentWindow == SLASH_WINDOW then
    displaySlashWindow(entryData)
  end
  
  WindowSetShowing(entryData.parentWindow, true)
  WindowSetParent(entryData.parentWindow, OPTIONS_WINDOW)
end

function warExtendedOptions.SetWindowText(entryData)

end

function warExtendedOptions.OnLButtonUpExitButton()
  WindowSetShowing(OPTIONS_WINDOW, false)
end