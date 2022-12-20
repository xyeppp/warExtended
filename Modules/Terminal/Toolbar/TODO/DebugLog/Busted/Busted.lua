Busted = {}
-- Local-alias addon table for speed efficiency
-- (avoids a global lookup each time we call a function)
local Busted = Busted

-- Local-alias functions for speed efficiency
local tremove = table.remove
local pcall = pcall
local towstring = towstring
local TextLogGetEntry = TextLogGetEntry
local TextLogGetNumEntries = TextLogGetNumEntries
local ButtonSetDisabledFlag = ButtonSetDisabledFlag
local DoesWindowExist = DoesWindowExist
Busted.Show={false}
bustedloaded=false;


---------------------------------------------------------------
-- The error list will store any noted error events
-- that have occured for each addon (and for L"<Non-addon specific>"
-- in the case of no addon specified) up to 100 events
-- for each addon.
--
-- Fields in the error list (after indexing the name):
--    + timeStamp = Timestamp
--    + addonName = Addon name (if specified)
--    + errorText = Error text
--    + repeatCount = # of times in a row
---------------------------------------------------------------
Busted.errorList = { [L"<Non-addon specific>"] = {} }
Busted.errorCount = 0

---------------------------------------------------------------
-- Ui Log Filter Types of Interest:
-- 1 is SYSTEM
-- 2 is WARNING
-- 3 is ERROR
-- 4 is DEBUG
-- 5 is FUNCTION
-- 6 is LOADING
--
-- These constants are in SystemData.UiLogFilters
---------------------------------------------------------------

--*******************************************************
-- ERROR LOGGING FUNCTIONS (SEPARATE FROM THE GUI)
--*******************************************************

function Busted.ProcessUiLogUpdate(updateType, filterType)

    -- For now, all we care about is new messages
    if updateType ~= SystemData.TextLogUpdate.ADDED then return end

    -- For now, all we care about are error messages
    if filterType ~= SystemData.UiLogFilters.ERROR then return end

    -- The entries of a text log are zero-indexed, and the most recently added one will
    -- be the highest-indexed entry in the log. Note that entries are wstrings, not strings.
    local lastEntryNum = TextLogGetNumEntries("UiLog") - 1
    local entryTime, entryFilter, entryText = TextLogGetEntry("UiLog", lastEntryNum)

    -- Pull out the addon which generated the error, if it's specified
    local addonName, errorMessage = entryText:match(L"^%(([^)]+)%):  (.*)")

    -- But if no addon name was specified, set it blank and pull the entire line as the message
    if not addonName then
        addonName, errorMessage = L"<Non-addon specific>", entryText
    end

    -- Grab the error list for this addon
    if not Busted.errorList[addonName] then Busted.errorList[addonName] = {} end
    local addonErrorList = Busted.errorList[addonName]

    -- If we've seen any errors already, check to see if this is a repeat.
    local numPastErrors = #addonErrorList
    if numPastErrors > 0 then
        local previousError = addonErrorList[numPastErrors]
        if addonName == previousError.addonName and
           errorMessage == previousError.errorText then
            -- If it is, then just up the repeat count and we're done handling this message.
            previousError.repeatCount = previousError.repeatCount + 1
            return
        end
    end

    -- If we've already seen 100 errors for this addon, stop recording
    -- (since this only tracks errors since the last UI load, if there are 100+
    -- errors for an addon we probably want to see the initial causes).
    if numPastErrors >= 100 then return end

    -- If it's not a repeat, and we've seen fewer than 100 errors already
    -- for this addon, add it to the list.
    addonErrorList[numPastErrors+1] =
        {
            addonName   = addonName,
            timeStamp   = entryTime,
            errorText   = errorMessage,
            repeatCount = 1,
        }

    -- Increment the total error count
    Busted.errorCount = Busted.errorCount + 1

    -- Tell the GUI that there's a new error to know about
    pcall(BustedGUI.NewErrorRecorded, addonName)

end

function Busted.ProcessUiLogUpdateProxy(...)

    -- This is a proxy to invoke ProcessUiLogUpdate using pcall.
    -- We really don't want to be generating ui log messages from within an event handler
    -- that was triggered by a generated ui log message (infinite recursion is bad).
    if not Busted or not Busted.ProcessUiLogUpdate then return end

    pcall(Busted.ProcessUiLogUpdate, ...)

end

--*******************************************************
-- GUI FUNCTIONS, SEPARATE FROM THE LOGGING
--*******************************************************

BustedGUI = {}
BustedGUI.addonMenuItems = { [L"<Non-addon specific>"] = true } -- Addons already listed in the select box
BustedGUI.currentView = L"<Non-addon specific>" -- The addon we're currently displaying errors for
BustedGUI.currentError = 0 -- The error we're currently displaying (0 = none)

-- So that the user can tell Busted to shut up temporarily
BustedGUI.alertActive = false

function BustedGUI.UpdateNextPrevButtonStatus()
    -- Don't try to call this after the interface is shutting down (causes CTD)
    if not DoesWindowExist("BustedGUIPrevError") then return end
    if not DoesWindowExist("BustedGUINextError") then return end

    -- Grab the current error table
    local errorTable = Busted.errorList[BustedGUI.currentView]

    -- If the table is invalid or empty, disable both buttons
    if not errorTable or #errorTable == 0 then
        ButtonSetDisabledFlag("BustedGUIPrevError", true)
        ButtonSetDisabledFlag("BustedGUINextError", true)
        return
    end

    -- If we're at the beginning of the error list, disable the Prev button,
    -- otherwise enable it.
    if BustedGUI.currentError <= 1 then
        ButtonSetDisabledFlag("BustedGUIPrevError", true)
    else
        ButtonSetDisabledFlag("BustedGUIPrevError", false)
    end

    -- If we're at the end of the error list, disable the Next button,
    -- otherwise enable it.
    if BustedGUI.currentError >= #errorTable then
        ButtonSetDisabledFlag("BustedGUINextError", true)
    else
        ButtonSetDisabledFlag("BustedGUINextError", false)
    end
end

function BustedGUI.NewErrorRecorded(addonName)

    -- Don't try to call this after the interface is shutting down (causes CTD)
    if not DoesWindowExist("BustedGUIAddonSelect") then return end
    if not DoesWindowExist("DebugWindowMiniGUIErrorText") then return end
    if not DoesWindowExist("DebugWindowMiniGUI") then return end

    -- If this is an addon that isn't in our select list yet, add it
    if not BustedGUI.addonMenuItems[addonName] then
        ComboBoxAddMenuItem("BustedGUIAddonSelect", addonName)
        BustedGUI.addonMenuItems[addonName] = true
    end

    -- If we're currently viewing this category, update it
    if BustedGUI.currentView == addonName then
        -- If it didn't use to have any errors, display this one and
        -- update the view for it.
        if BustedGUI.currentError == 0 then
            BustedGUI.currentError = 1
            BustedGUI.UpdateErrorView()
        else
            -- Since this might have added to our options for selecting an error,
            -- update whether the next/prev buttons are disabled anyways.
            BustedGUI.UpdateNextPrevButtonStatus()
        end
    end

    -- Update the mini GUI's error count
    LabelSetText("DebugWindowMiniGUIErrorText", towstring(Busted.errorCount)..L" Errors")

    -- Finally, update the mini GUI to flash and turn red to alert the user
    -- if it's not already doing so.
    if not BustedGUI.alertActive then
        BustedGUI.alertActive = true
        LabelSetTextColor("DebugWindowMiniGUIErrorText", 255, 0, 0)
        WindowStartAlphaAnimation("DebugWindowMiniGUIErrorText",
            Window.AnimationType.LOOP, -- startalpha -> endalpha -> startalpha -> endalpha et cetera
            1.0, -- starting alpha
            0.5, -- ending alpha
            1, -- total duration of each cycle
            true, -- set starting alpha immediately as opposed to after delay
            0, -- don't delay before starting animation
            0) -- loop indefinitely (1+ would specific a finite number of loops)
    end

end

function BustedGUI.UpdateErrorView()

    -- Don't try to call this after the interface is shutting down (causes CTD)
    if not DoesWindowExist("BustedGUIErrorText") then return end
    if not DoesWindowExist("BustedGUIErrorMessage") then return end
    if not DoesWindowExist("BustedGUITimeText") then return end
    if not DoesWindowExist("BustedGUIRepeatText") then return end
    if not DoesWindowExist("BustedGUI") then return end

    -- If the current error is 0, it means we shouldn't be displaying anything
    if BustedGUI.currentError == 0 then
        LabelSetText("BustedGUIErrorText", L"None")
        TextEditBoxSetText("BustedGUIErrorMessage", L"")
        LabelSetText("BustedGUITimeText", L"No errors for selection")
        LabelSetText("BustedGUIRepeatText", L"")
        BustedGUI.UpdateNextPrevButtonStatus()
        return
    end

    -- Otherwise, load up the current error
    local errorTable = Busted.errorList[BustedGUI.currentView]
    local errorEntry = errorTable[BustedGUI.currentError]

    -- Update GUI elements to reflect this error
    LabelSetText("BustedGUIErrorText", towstring(BustedGUI.currentError)..L"/"..towstring(#errorTable))
    LabelSetText("BustedGUITimeText", L"Occurred at "..errorEntry.timeStamp)
    LabelSetText("BustedGUIRepeatText", L"Repeated "..towstring(errorEntry.repeatCount)..L" time(s)")
    TextEditBoxSetText("BustedGUIErrorMessage", errorEntry.errorText)

    -- Enable/disable the next/previous error buttons as appropriate
    BustedGUI.UpdateNextPrevButtonStatus()

    -- Finally, focus the edit box (if visible)
    if WindowGetShowing("BustedGUI") then
        WindowAssignFocus("BustedGUIErrorMessage", true)
    end

end



function BustedGUI.SelectAddonView()

    -- Grab the table for the selected item
    local selectedAddon = ComboBoxGetSelectedText("BustedGUIAddonSelect")
    local errorTable = Busted.errorList[selectedAddon]

    -- If there isn't a valid error list for this addon, ignore the request (this shouldn't happen)
    if not errorTable then return end

    -- If the selected addon is different from the current view,
    -- change the view to it and reset the error number to the beginning
    if selectedAddon ~= BustedGUI.currentView then
        BustedGUI.currentView = selectedAddon

        -- If there aren't any errors logged for this addon, don't try
        -- to set the current error to anything other than 0
        if #errorTable == 0 then
            BustedGUI.currentError = 0
        else
            -- There have been errors recorded for this addon, so
            -- set our current position to the first error.
            BustedGUI.currentError = 1
        end

        -- Update the view to reflect our changes.
        BustedGUI.UpdateErrorView()
    end

end

function BustedGUI.SelectNextError()

    -- Load up the current error list
    local errorTable = Busted.errorList[BustedGUI.currentView]

    -- Are we already at the end? If so don't do anything.
    if BustedGUI.currentError >= #errorTable then return end

    -- Otherwise, increment the current error by one and update.
    BustedGUI.currentError = BustedGUI.currentError + 1
    BustedGUI.UpdateErrorView()

end

function BustedGUI.SelectPrevError()

    -- Are we already at the beginning? If so, don't do anything.
    if BustedGUI.currentError <= 1 then return end

    -- Otherwise, decrement the current error by one and update.
    BustedGUI.currentError = BustedGUI.currentError - 1
    BustedGUI.UpdateErrorView()

end

function BustedGUI.ToggleMainWindow()
    if not WindowGetShowing("BustedGUI") then
      WindowSetShowing("BustedGUI", true)
    -- Toggle the status of the main Busted window, and also clear any alert
    BustedGUI.ClearAlertFlash()
    Busted.Show=true;
  else
      WindowSetShowing("BustedGUI", false)
      BustedGUI.ClearAlertFlash()
      Busted.Show=false;
    end
end

function BustedGUI.ClearAlertFlash()

    -- Clear the alert state and mark the most recent error count as acknowledged
    BustedGUI.alertActive = false

    -- Stop any flashing going on, and turn the text green
    WindowStopAlphaAnimation("DebugWindowMiniGUIErrorText")
    WindowSetShowing("DebugWindowMiniGUIErrorText", true)
    WindowSetAlpha("DebugWindowMiniGUIErrorText", 1.0)
    LabelSetTextColor("DebugWindowMiniGUIErrorText", 255, 204,102)

end

function Busted.Initialize()

    -- Grab the event for the ui log being updated and register our handler for it.
    local uiLogEventId = TextLogGetUpdateEventId("UiLog")
    --CreateWindow("BustedProxy", false)
    WindowRegisterEventHandler("BustedProxy", uiLogEventId, "Busted.ProcessUiLogUpdateProxy")
end

function BustedGUI.Initialize()

    -- Create the GUI at the end of the initialization, because we don't want
    -- the previous stuff to fail just because the GUI got borked. Starts hidden.
    CreateWindow("BustedGUI", false)
    LabelSetText("BustedGUIAddonText", L"Addon:")

    -- And the mini GUI too. This starts showing.
  --  CreateWindow("DebugWindowMiniGUI", true)
    LabelSetText("DebugWindowMiniGUIErrorText", L"No errors")
    -- Register the mini GUI with the Layout Editor so it can be moved around
    -- or hidden (but don't allow 1-dimensional stretching, only scaling)
  --  LayoutEditor.RegisterWindow("DebugWindowMiniGUI", L"Busted", L"Busted Mini Alert", false, false, true, nil)

    -- Make sure the <Non-addon specific> entry is always first in the dropdown
    ComboBoxAddMenuItem("BustedGUIAddonSelect", L"<Non-addon specific>")

    -- Then add the others
    for k,_ in pairs(Busted.errorList) do
        if k ~= L"<Non-addon specific>" then
            ComboBoxAddMenuItem("BustedGUIAddonSelect", k)
            BustedGUI.addonMenuItems[k] = true
        end
    end

    -- Default to <Non-addon specific> selected
    ComboBoxSetSelectedMenuItem("BustedGUIAddonSelect", 1)

    -- Update the current view
    BustedGUI.UpdateErrorView()
    if Busted.Show then
      if WindowGetShowing("DebugWindow") then
        BustedGUI.ToggleMainWindow()
      end
    end

bustedloaded=true;


LabelSetTextColor("BustedGUITimeText", 255, 204,102)
LabelSetTextColor("BustedGUIAddonText", 255, 204,102)
LabelSetTextColor("BustedGUIRepeatText", 255, 204,102)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
