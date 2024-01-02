local warExtended                 = warExtended
local WINDOW_NAME = "warExtendedSettings"
local WINDOW_SCROLL_CHILD_NAME = WINDOW_NAME.."MainScrollChild"
local SLASH_WINDOW = WINDOW_NAME.."SlashWindow"
local MOD_DETAILS_WINDOW_NAME = WINDOW_NAME.."ModDetails"

local HEADER_TEXT             = 1
local TITLEBAR       = 2
local RESET_BTN  = 3
local RESET_ALL_BTN  = 4
local SAVE_BTN            = 5
local CLOSE_BTN               = 6

local WINDOW                 = Frame:Subclass(WINDOW_NAME)
local MOD_LIST              = ExpandableListBox:Subclass(WINDOW_NAME .. "List")
local MOD_DETAILS_FRAME = Frame:Subclass("warExtendedSettings_ModInfoTemplate")
local RESET_BUTTON         = ButtonFrame:Subclass(WINDOW_NAME .. "OutputRefreshButton")
local RESET_ALL_BUTTON         = ButtonFrame:Subclass(WINDOW_NAME .. "OutputRefreshButton")
local SAVE_BUTTON         = ButtonFrame:Subclass(WINDOW_NAME .. "OutputRefreshButton")
local CLOSE_BUTTON         = ButtonFrame:Subclass(WINDOW_NAME .. "OutputRefreshButton")

local function resetCurrentSection()
    --config_dlg.currentSection.onReset(config_dlg.currentSection)
end

function RESET_BUTTON:OnLButtonUp()
    --[[  if  self:IsDisabled() or not config_dlg.currentSection) then return end
    --
    --  DialogManager.MakeTwoButtonDialog(L"warExtendedSettings addon\n\nThis will reset " .. config_dlg.currentSection.title:lower() .. L" section settings.\n\nContinue?\n\n(you may have to wait for game interface to reload)",
    --		  L"Yes", warExtendedSettings.UI_ConfigDialog_ResetCurrentSection,
    --		  L"No")]]
end

function RESET_ALL_BUTTON:OnLButtonUp()
    --[[if self:IsDisabled() then return end
    --
    --  DialogManager.MakeTwoButtonDialog(L"warExtendedSettings addon\n\nAre you sure you want to reset all settings to their default values?\n\n(you will have to wait for game interface to reload)",
    --		  L"Yes", warExtended._Settings.ResetSettings,
    --		  L"No")]]
end

function SAVE_BUTTON:OnLButtonUp()
    --[[ for _, section in ipairs(config_dlg.sections)
    --  do
    --	section.isActive = false
    --
    --	if (not section.isInitialized
    --			or not section.isLoaded
    --			or not section.onSave) then continue end
    --
    --	if (not section.onSave(section))
    --	then
    --	  ComboBoxSetSelectedMenuItem("warExtendedSettingsConfigDialogSection", section.index)
    --	  warExtendedSettings.UI_ConfigDialog_OnSectionSelChanged()
    --	  return
    --	end
    --  end
    --
    --  self:GetParent():Show(false)
    --  warExtendedSettings.FixSettings()]]
end

function CLOSE_BUTTON:OnLButtonUp()
    self:GetParent():Show(false)
end

function WINDOW:Create()
    self:CreateFromTemplate(WINDOW_NAME)

    self.m_Windows = {
        [TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
        [HEADER_TEXT] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "HeaderText"),
        [RESET_BTN] = RESET_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME .. "ResetButton"),
        [RESET_ALL_BTN] = RESET_ALL_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME .. "ResetAllButton"),
        [SAVE_BTN] = SAVE_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME .. "SaveButton"),
        [CLOSE_BTN] = CLOSE_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME .. "ExitButton"),
        [MOD_LIST] = MOD_LIST:CreateFrameForExistingWindow(WINDOW_NAME .. "List"),
    }

    self.onChangeHandlers = {}
    self.properties = {}

    local win      = self.m_Windows

    win[MOD_LIST]:SetSelfTable(warExtendedSettingsList)

     local nameSort = {
          [1] = {text=L"Name",  sortFunc = function (a, b) p(a,b) return(WStringsCompare(a.name, b.name) == -1) end},
      }

   -- win[MOD_LIST]:SetSortButtons(nameSort, WINDOW_NAME.."List", 1)

    win[TITLEBAR]:SetText(L"warExtended Settings")
    win[HEADER_TEXT]:SetText(L"Settings")
    win[RESET_BTN]:SetText(L"Reset")
    win[RESET_ALL_BTN]:SetText(L"Reset All")
    win[SAVE_BTN]:SetText(L"Save")
    win[CLOSE_BTN]:SetText(L"Close")

    warExtended:AddEventHandler("InitUiModSettings", "CoreInitialized", function()
        local modDetails = MOD_DETAILS_FRAME:CreateFromTemplate(MOD_DETAILS_WINDOW_NAME, WINDOW_NAME.."Sections")
        modDetails:SetParent(WINDOW_NAME.."Sections")
        UiModWindow.InitModDetails( modDetails:GetName() )
    end )
end

function WINDOW:OnShown()
        if not self.config_dlg then
            self.config_dlg = {
                sections = {},
            }

            warExtended:TriggerEvent("warExtendedSettingsInitializeSections", self.config_dlg.sections)

            for _, section in ipairs(self.config_dlg.sections) do
                section.isInitialized = false
            end
        end

        --local open_section_index = ComboBoxGetSelectedMenuItem("warExtendedSettingsConfigDialogSection")
        for section_index, section in ipairs(self.config_dlg.sections) do
            section.isActive = false

            if section.name == openSection then
                open_section_index = section_index
            end

            section.index    = section_index
            section.isLoaded = false
        end

        if open_section_index == 0 then
            open_section_index = 1
        end

        -- warExtendedSettings.UI_ConfigDialog_OnSectionSelChanged()
        if scroll ~= nil then
            ScrollWindowSetOffset(self.config_dlg.currentSection.windowName .. "Content", scroll)
        end


        local win = self.m_Windows
        win[MOD_LIST]:PrepareData()
        win[MOD_LIST]:UpdateOptionsWindowRow()
     --   win[MOD_LIST]:SetRowTints()

    --[[  if (not config_dlg)
    --    then
    --        config_dlg =
    --        {
    --            sections = {}
    --        }
    --
    --        CreateWindow ("EnemyConfigDialog", false)
    --        LabelSetText ("EnemyConfigDialogTitleBarText", L"Enemy addon configuration")
    --        ButtonSetText ("EnemyConfigDialogOkButton", L"OK")
    --        ButtonSetText ("EnemyConfigDialogCancelButton", L"Cancel")
    --        ButtonSetText ("EnemyConfigDialogResetButton", L"Reset")
    --        ButtonSetText ("EnemyConfigDialogResetAllButton", L"Reset all")
    --
    --        LabelSetText ("EnemyConfigDialogSectionLabel", L"Section")
    --        config_dlg.sections = {}
    --
    --        Enemy.TriggerEvent ("ConfigDialogInitializeSections", config_dlg.sections)
    --
    --        for _, section in ipairs (config_dlg.sections)
    --        do
    --            section.isInitialized = false
    --            ComboBoxAddMenuItem ("EnemyConfigDialogSection", section.title)
    --        end
    --    end
    --
    --    local open_section_index = ComboBoxGetSelectedMenuItem ("EnemyConfigDialogSection")
    --    for section_index, section in ipairs (config_dlg.sections)
    --    do
    --        section.isActive = false
    --
    --        if (section.name == openSection)
    --        then
    --            open_section_index = section_index
    --        end
    --
    --        section.index = section_index
    --        section.isLoaded = false
    --    end
    --
    --    WindowSetShowing ("EnemyConfigDialog", true)
    --
    --    if (open_section_index == 0) then open_section_index = 1 end
    --    ComboBoxSetSelectedMenuItem ("EnemyConfigDialogSection", open_section_index)
    --
    --    Enemy.UI_ConfigDialog_OnSectionSelChanged ()
    --    if (scroll ~= nil) then ScrollWindowSetOffset (config_dlg.currentSection.windowName.."Content", scroll) end]]
end


function WINDOW:OnHidden()
    --[[for _, section in ipairs (config_dlg.sections)
    do
        section.isActive = false

        if (not section.isInitialized
                or not section.isLoaded
                or not section.onClose) then continue end

        section.onClose (section)
    end

     warExtended:TriggerEvent("SettingsChanged", warExtendedSettings.Settings)
]]
end



local function getDepthText(entryId)
    local depthText = {}

    local function delve(entryId)
        local win = WINDOW.m_Windows[MOD_LIST]
        for _,v in pairs(win.m_rowToEntryMap) do
            if v.id == entryId then
                table.insert(depthText, tostring(v.name))
                if v.parentEntryId ~= 0 then
                    delve(v.parentEntryId)
                end
            end
        end
    end

    delve(entryId)
    table.sort(depthText, function(a,b) return a < b end)
    local headerText = towstring(table.concat(depthText, "/"))
    return headerText
end


local function getHeaderText(entryData)
    if entryData.parentEntryId ~= 0 then
        local headerText = getDepthText(entryData.id)
        return headerText
    end

    return entryData.name
end



function MOD_LIST:DisplayManualEntry(entryData)
    local win = WINDOW.m_Windows


    win[HEADER_TEXT]:SetText(getHeaderText(entryData))

    if warExtended._Settings.lastParentWindow ~= nil then
        local frame = GetFrame(warExtended._Settings.lastParentWindow)
        frame:Show(false)
    end

    local name = entryData.addonName or entryData.name
    warExtended._Settings.lastParentWindow = entryData.parentWindow or WINDOW_NAME..tostring(name)

    ScrollWindowSetOffset( WINDOW_NAME.."Main", 0 )        -- reset the scroll bar.
    ScrollWindowUpdateScrollRect(WINDOW_NAME.."Main")      -- reset the sc

    --[[if parentWindow then
        if not DoesWindowExist(entryData.parentWindow) then
            CreateWindow(entryData.parentWindow, true)
        end
        elseif entryData.parentWindow == SLASH_WINDOW then
            displaySlashWindow(entryData)
        end
        WindowSetShowing(entryData.parentWindow, true)
        WindowSetParent(entryData.parentWindow, WINDOW_NAME)
    end]]

    if entryData.parentWindow == MOD_DETAILS_WINDOW_NAME then
        local modFrame = GetFrame(MOD_DETAILS_WINDOW_NAME)
        local modName =  entryData.addonName or entryData.name
        modFrame:Show(true)
        UiModWindow.UpdateModDetailsData( MOD_DETAILS_WINDOW_NAME, warExtended.GetAddonTable(tostring(modName) ))
        elseif entryData.parentWindow == "warExtendedSettings_SlashTemplate" then

        elseif entryData.parentWindow then
        local frame = GetFrame(entryData.parentWindow)
        frame:Show(true)

    end

    --[[
    local index = ComboBoxGetSelectedMenuItem ("EnemyConfigDialogSection")
    if (index < 1) then return end

    local section = config_dlg.sections[index]

    if (config_dlg.currentSection)
    then
        config_dlg.currentSection.isActive = false
    end

    if (not section.isInitialized)
    then
        section.windowName = "EnemyConfigDialogSections"..section.name
        CreateWindowFromTemplate (section.windowName, section.templateName, "EnemyConfigDialogSections")

        WindowClearAnchors (section.windowName)
        WindowAddAnchor (section.windowName, "topleft", "EnemyConfigDialogSections", "topleft", 0, 0)
        WindowAddAnchor (section.windowName, "bottomright", "EnemyConfigDialogSections", "bottomright", 0, 0)

        if (section.onInitialize) then section.onInitialize (section) end
        section.isInitialized = true
    end

    if (not section.isLoaded and section.onLoad)
    then
        section.onLoad (section)
    end

    for section_index, section in ipairs (config_dlg.sections)
    do
        if (not section.isInitialized) then continue end
        WindowSetShowing (section.windowName, section_index == index)
    end

    section.isActive = true
    section.isLoaded = true
    config_dlg.currentSection = section

    ButtonSetDisabledFlag ("EnemyConfigDialogResetButton", section.onReset == nil)

    -- warext below

    local section = config_dlg.sections[index]

  if (config_dlg.currentSection)
  then
    config_dlg.currentSection.isActive = false
  end

  if (not section.isInitialized)
  then
    section.windowName = "warExtendedSettingsConfigDialogSections" .. section.name
    CreateWindowFromTemplate(section.windowName, section.templateName, "warExtendedSettingsConfigDialogSections")

    WindowClearAnchors(section.windowName)
    WindowAddAnchor(section.windowName, "topleft", "warExtendedSettingsConfigDialogSections", "topleft", 0, 0)
    WindowAddAnchor(section.windowName, "bottomright", "warExtendedSettingsConfigDialogSections", "bottomright", 0, 0)

    if (section.onInitialize) then section.onInitialize(section) end
    section.isInitialized = true
  end

  if (not section.isLoaded and section.onLoad)
  then
    section.onLoad(section)
  end

  for section_index, section in ipairs(config_dlg.sections)
  do
    if (not section.isInitialized) then continue end
    WindowSetShowing(section.windowName, section_index == index)
  end

  section.isActive          = true
  section.isLoaded          = true
  config_dlg.currentSection = section

  ButtonSetDisabledFlag("warExtendedSettingsConfigDialogResetButton", section.onReset == nil)]]
end


WINDOW:Create()

function warExtended._Settings.OnPopulate()
    local win = WINDOW.m_Windows
    win[MOD_LIST]:UpdateOptionsWindowRow()
    win[MOD_LIST]:SetRowTints()
end


function warExtendedSettings.WindowOnShutdown() end

function warExtendedSettings.OnVertScrollLButtonUp() end

--[[
local index = 0
local cmdTemplate = "warExtendedSettings_SlashTemplate"

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
end]]
--


function warExtendedSettings.SetWindowText(entryData) end

