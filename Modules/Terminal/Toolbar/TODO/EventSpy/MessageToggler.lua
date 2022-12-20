----------------------------------------------------------------------------
--
--  You know what I hate?  I hate typing *net toggle f_blah_blah_blah.
--  I probably type that about 700 times every day.
--  Well, balls to that!  "BALLS TO THAT," I SAY!!!!
--
----------------------------------------------------------------------------

-- The head honcho....
MessageToggler = 
{
    m_data = FuncXMLMessageData,
}

-- Default Saved Variable for message sets, contains the information to create them and populate the buttons
MessageSets = {}

-- Colors for the different labels depending on their pressed state (true = pressed, false = not pressed)
local PRESSED = true
local UNPRESSED = false

MessageColors =
{
    [PRESSED]   = { r = 30, g = 200, b = 12 },
    [UNPRESSED] = { r = 32, g = 175, b = 230 },
}

-- The window that will be created over and over again (to display helpful
ToggleRow = Frame:Subclass ("MessageToggleEntry")

function ToggleRow:Create (windowName, parentName, messageIndex, messageData)
    local messageRow = self:CreateFromTemplate (windowName, parentName)
    
    if (messageRow)
    then
        messageRow:Show (true)
        
        local color = MessageColors[UNPRESSED]

        messageRow.m_messageIndex   = messageIndex
        messageRow.m_isChecked      = false        
        messageRow.m_CheckBox       = ButtonFrame:CreateFrameForExistingWindow (windowName.."ButtonButton")
        messageRow.m_Label          = Label:CreateFrameForExistingWindow (windowName.."ButtonLabel")
        
        messageRow.m_CheckBox:SetCheckButtonFlag (true)
        messageRow.m_Label:SetTextColor (color)
        messageRow.m_Label:SetText (messageData.name)
        messageRow.m_Label:SetFont ("font_chat_text", 20)

        -- Slight hack...Add the button window to the frame manager...
        -- This is to lubricate and ease the passage of those horrible mouse clicks...
        FrameManager:Add (windowName.."Button", messageRow)
    end
    
    return messageRow
end

local TURN_LOGGING_ON   = true
local TURN_LOGGING_OFF  = false

function ToggleRow:DoNetCommand (loggingOptions, additionalOptions)
    local commandParam = L"off"
    
    additionalOptions = additionalOptions or L""
    
    if (loggingOptions == TURN_LOGGING_ON) then commandParam = L"on" end
    
    SystemData.UserInput.ChatText = L"*net "..commandParam..L" "..MessageToggler:GetMessageName (self.m_messageIndex)..L" "..additionalOptions
    BroadcastEvent( SystemData.Events.SEND_CHAT_TEXT )    
end

function ToggleRow:Toggle ()    
    local logMessage = not self.m_CheckBox:IsPressed ()
    
    self.m_CheckBox:SetPressedFlag (logMessage)
    self.m_Label:SetTextColor (MessageColors[logMessage])
    self:DoNetCommand (logMessage)
end

function ToggleRow:IsPressed ()
    return self.m_CheckBox:IsPressed ()
end

function ToggleRow:GetMessageName ()
    assert (self.m_Label)
    return self.m_Label:TextAsWideString ()
end

--[[
    The buttons that let you make message sets...
--]]

-- Misusing the hell out of the Frame object here...but that's ok.
MessageSetData = Frame:Subclass ()

function MessageSetData:Create (setName, messageRows)
    local messageSet = self:Subclass () -- This is the misuse, just calling Subclass to create a new table with a metatable.

    if (messageSet)
    then
        messageSet.m_SetName        = setName
        messageSet.m_MessageRows    = messageRows
    end
    
    return messageSet
end

function MessageSetData:Toggle ()
    for k, v in pairs (self.m_MessageRows)
    do
        v:Toggle ()
    end
end

function MessageSetData:GetMessageNamesInSingleString ()
    local messageNames  = L""
    local isFirst       = true
    
    for k, v in pairs (self.m_MessageRows)
    do
        if (isFirst)
        then
            messageNames = v:GetMessageName ()
            isFirst = false
        else
            messageNames = messageNames..L"<BR>"..v:GetMessageName ()
        end
    end    
    
    return messageNames
end

MessageSetButton = ButtonFrame:Subclass ("MessageSetButton")

function MessageSetButton:Create (windowName, parentName, anchor, setName, messageRows)
    local messageButton = self:CreateFromTemplate (windowName, parentName)
    
    if (messageButton)
    then
        if (anchor)
        then
            messageButton:SetAnchor (anchor)
        end
        
        if (setName and messageRows)
        then
            messageButton.m_SetData = MessageSetData:Create (setName, messageRows)
            messageButton:SetText (setName)
        else
            messageButton:SetText (L"New Set")
        end
        
        messageButton:Show (true)
    end
    
    return messageButton
end

function MessageSetButton:OnLButtonUp (flags, mouseX, mouseY)
    if (self.m_SetData)
    then
        self.m_SetData:Toggle ()
    else
        MessageToggler:CreateMessageSet ()
    end     
end

function MessageSetButton:OnMouseOver (flags, mouseX, mouseY)
    Tooltips.CreateTextOnlyTooltip(SystemData.ActiveWindow.name)
    
    if (self.m_SetData)
    then
        Tooltips.SetTooltipText (1, 1, self.m_SetData:GetMessageNamesInSingleString ())
    else
        Tooltips.SetTooltipText (1, 1, L"Click me to create a new message set based on the messages that are currently netlogged")
    end 
    
    Tooltips.Finalize()
    Tooltips.AnchorTooltip ()
end

MessageSetManager = {}

--[[
    The code behind the toggler...
--]]

function MessageToggler.ToggleMessage ()    
    local messageRow = FrameManager:GetMouseOverWindow ()
    
    if (messageRow)
    then        
        messageRow:Toggle ()
    end
end

local function SetMessageDescriptionLabel (description, origin)
    if (origin ~= nil)
    then
        LabelSetText ("MessageTogglerMessageDescriptionText", L"Origin: "..origin..L"<BR>"..description)
    else
        LabelSetText ("MessageTogglerMessageDescriptionText", description)
    end
end

function MessageToggler.ShowMessageDescription ()
    local messageRow = FrameManager:GetMouseOverWindow ()
    
    if (messageRow)
    then
        local description   = MessageToggler:GetMessageDescription (messageRow.m_messageIndex)
        local origin        = MessageToggler:GetMessageOrigin (messageRow.m_messageIndex)
        
        SetMessageDescriptionLabel (description, origin)
    end
end

function MessageToggler.ClearMessageDescription ()
    SetMessageDescriptionLabel (L"")
end

--
-- All the event handlers for MessageToggler
--

function MessageToggler.Initialize ()
    CreateWindow ("MessageToggler", false)
    LabelSetText ("MessageTogglerTitleBarText", L"Network Messages")
    LabelSetText ("MessageTogglerMessageDescriptionTitleBarText", L"Details")
    MessageToggler:CreateMessages ()
    MessageToggler:CreateSets ()
        
    DevBar:RegisterMod (L"Message Toggler", L"Hides and shows the various network traffic for the game.", MessageToggler.ToggleMainWindow, 10901)
end


function MessageToggler.Shutdown ()
    DestroyWindow ("MessageToggler")
end

function MessageToggler.ToggleMainWindow ()
    WindowSetShowing ("MessageToggler", not WindowGetShowing ("MessageToggler"))
end

function MessageToggler.Hide ()
    WindowSetShowing ("MessageToggler", false)
end

--
-- Utility functions for MessageToggler
--

function MessageToggler:CreateSingleMessage (rowID, messageIndex, messageData)
    local messageRow = ToggleRow:Create ("Message"..rowID, "MessageTogglerScrollWindowStuff", messageIndex, messageData)

    if (messageRow ~= nil)
    then
        messageRow:DoNetCommand (TURN_LOGGING_OFF, L"suppress")

        if (rowID == 1)
        then
            messageRow:SetAnchor ({Point = "topleft", RelativePoint = "topleft", RelativeTo = "MessageTogglerScrollWindowStuff", XOffset = 15, YOffset = 10})
        else
            messageRow:SetAnchor ({Point = "bottomleft", RelativePoint = "topleft", RelativeTo = "Message"..(rowID - 1), XOffset = 0, YOffset = 2})
        end

        rowID = rowID + 1
    end
    
    return rowID
end

function MessageToggler:CreateMessages ()
    table.sort( self.m_data, DataUtils.AlphabetizeByNames )
    
    local rowID = 1
    
    for messageIndex, messageData in ipairs (self.m_data) 
    do
        rowID = self:CreateSingleMessage (rowID, messageIndex, messageData)
    end
    
    self.m_MessageCount = rowID
    
    -- hmmm...create another row at the end as a spacer?
    -- yeah, it works...silly scroll window not wanting to scroll to its last item.  something must be up with the way I am initializing it
    rowID = self:CreateSingleMessage (rowID, 1, { name = L"Not a message", origin = L"Man, that band rocks", description = L"Please don't toggle this" })
    
    -- Dynamically change the height of the scroll window so that all the messages can be seen, 
    -- without just hardcoding a gargantuan value...
    
    -- if this exists, there were probably some rows created...
    local oneRowFrame = FrameManager:Get ("Message1")
    if (oneRowFrame)
    then
        local oneRowWidth, oneRowHeight = oneRowFrame:GetDimensions ()
        local scrollWindowWidth, scrollWindowHeight = WindowGetDimensions ("MessageTogglerScrollWindowStuff")
        
        WindowSetDimensions ("MessageTogglerScrollWindowStuff", scrollWindowWidth, oneRowHeight * rowID)
    end
end

function MessageToggler:CreateSets ()
    local anchor = { Point = "bottom", RelativePoint = "top", RelativeTo = "MessageTogglerMessageDescriptionText", XOffset = 0, YOffset = -30 }

    MessageSetButton:Create ("CreateNewMessageSet", "MessageToggler", anchor)
end

function MessageToggler:GetMessageName (index)
    return (self.m_data[index].name)
end

function MessageToggler:GetMessageDescription (index)
    return (self.m_data[index].description)
end

function MessageToggler:GetMessageOrigin (index)
    return (self.m_data[index].origin)
end

function MessageToggler:CreateMessageSet ()
    -- d ("Surprise!")
end