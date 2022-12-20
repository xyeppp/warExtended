local warExtendedTerminal = warExtendedTerminal
local warExtended = warExtended

do
    AA_Settings =
    {
        ["outputType"]          = "xml",    -- either "xml" or "singletable" or "multitable"
        ["parentReplacement"]   = true,     -- Whether or not the output string uses parent replacement, not used if outputType == "table"
        ["clipboardCopyOnSet"]  = true,     -- Whether or not to copy the anchor string directly to the clipboard.
        
    }
end

local function GetAnchorAsXMLWideString (anchor, anchoredWindowName, performParentReplacement)
    local relativeTo = anchor.RelativeTo
    
    if (performParentReplacement)
    then
        relativeTo, _ = string.gsub (relativeTo, "^"..WindowGetParent (anchoredWindowName), "$parent")
    end
    
    local anchorString = "    <Anchor point=\""..anchor.Point.."\" relativePoint=\""..anchor.RelativePoint.."\" relativeTo=\""..relativeTo.."\"><BR>        <AbsPoint x=\""..anchor.XOffset.."\" y=\""..anchor.YOffset.."\" /><BR>    </Anchor>"
    return towstring (anchorString)
end

local function GetAnchorAsSingleLineTable (anchor)
    return towstring ("{ Point = \""..anchor.Point.."\", RelativePoint = \""..anchor.RelativePoint.."\", RelativeTo = \""..anchor.RelativeTo.."\", XOffset = "..anchor.XOffset..", YOffset = "..anchor.YOffset.." }")
end

local function GetAnchorAsMultiLineTable (anchor)
    return towstring ("{<BR>    Point           = \""..anchor.Point.."\",<BR>    RelativePoint   = \""..anchor.RelativePoint.."\",<BR>    RelativeTo      = \""..anchor.RelativeTo.."\",<BR>    XOffset         = "..anchor.XOffset..",<BR>    YOffset         = "..anchor.YOffset.."<BR>}")
end

local tiddlywinks =
{
    ["xml"]             = GetAnchorAsXMLWideString,
    ["singletable"]     = GetAnchorAsSingleLineTable,
    ["multitable"]      = GetAnchorAsMultiLineTable
}

--
-- Data
--

local MAIN_WINDOW_LABEL = 1
local MAIN_WINDOW_EDIT  = 2
local REL_WINDOW_LABEL  = 3
local REL_WINDOW_EDIT   = 4
local MAIN_POINT_LABEL  = 5
local MAIN_POINT_COMBO  = 6
local REL_POINT_LABEL   = 7
local REL_POINT_COMBO   = 8
local XOFFS_EDIT        = 10
local YOFFS_EDIT        = 12
local TITLE_BAR_LABEL   = 13
local INTERFACE_LABEL   = 14
local INTERFACE_TEXT    = 15
local MOUSEOVER_LABEL   = 16
local MOUSEOVER_WINDOW  = 17
local MOUSEPOINT_LABEL  = 18
local MOUSEPOINT_TEXT   = 19
local MOUSEOVERWINDOW_LABEL = 20
local MOUSEOVERWINDOW_TEXT = 21
local ANCHOR1           = 22
local ANCHOR2           = 23
local ANCHOR_EDITBOX     = 24
local ANCHOROUT_XML     = 25
local ANCHOROUT_STBL    = 26
local ANCHOROUT_MTBL    = 27
local ANCHOROUT_PREP    = 28
local ANCHOROUT_AUTOCOP = 29
local OUTPUT_RADIO_GROUP = 30
local HIGHLIGHTWINDOW   = 31
local DIMS_WIN = 32
local DIMENSIONSLABEL   = 33
local WINX = 34
local WINY = 35
local WINX_LABEL = 36
local WINY_LABEL = 37



local AnchorNames =
{
    L"left",
    L"bottomleft",
    L"topleft",
    L"right",
    L"bottomright",
    L"topright",
    L"bottom",
    L"top",
    L"center",
    
    ComboSelectionFromName = function (self, name)
        if (name and name ~= "")
        then
            for k, v in ipairs (self)
            do
                if (tostring (v) == name)
                then
                    return k
                end
            end
        end
        
        return 1
    end
}

local AnchorIdToAnchorControlMapping =
{
    ANCHOR1,
    ANCHOR2
}

local tooltips = -- this is very close to overwriting the more useful table called Tooltips, don't do that :)
{
    [MAIN_WINDOW_EDIT]  = L"The window whose anchors you wish to modify.<BR><BR>Shift + click to auto-populate the anchor dialogs with the anchors of the next-clicked window.<BR><BR>Shift + right click to clear this edit box.",
    [REL_WINDOW_EDIT]   = L"The main window will be anchored to this window.<BR><BR>Shift + click to auto-populate the edit box with the name of the next-clicked window.<BR><BR>Shift + right click to clear this edit box.",
    [XOFFS_EDIT]        = L"Horizontal offset, in unscaled coordinates.<BR><BR>Roll the mouse wheel for fine adjustments, or shift + mouse wheel for coarse adjustments",
    [YOFFS_EDIT]        = L"Vertical offset, in unscaled coordinates.<BR><BR>Roll the mouse wheel for fine adjustments, or shift + mouse wheel for coarse adjustments",
    [ANCHOR1]           = L"Anchor 1",
    [ANCHOR2]           = L"Anchor 2",
    [ANCHOROUT_XML]     = L"Anchor as XML",
    [ANCHOROUT_STBL]    = L"Anchor as single-line Lua table",
    [ANCHOROUT_MTBL]    = L"Anchor as multi-line Lua table",
    [ANCHOROUT_PREP]    = L"Replace parent name with $parent",
    [ANCHOROUT_AUTOCOP] = L"Auto-copy anchor string to clipboard",
    [HIGHLIGHTWINDOW]   = L"Highlight the specified window.",
    [WINX]        = L"Horizontal dimensions, in unscaled coordinates.<BR><BR>Roll the mouse wheel for fine adjustments, or shift + mouse wheel for coarse adjustments",
    [WINY]        = L"Vertical dimensions, in unscaled coordinates.<BR><BR>Roll the mouse wheel for fine adjustments, or shift + mouse wheel for coarse adjustments",
}

--
-- Specialized EditBoxes (for text and numbers)
--

local function das123()
    do
        YaaarEditBox = TextEditBox:Subclass ()
        YaaarNumberEditBox = YaaarEditBox:Subclass ()
        Yaaar = Frame:Subclass ("YaaarTemplate")
        YaaarSingleAnchor = Frame:Subclass ("AA_SingleAnchor")
        YaaarDimensions = Frame:Subclass ("AA_Dimensions")
        
        function YaaarEditBox:Create (windowName, anchorEditor, tooltip, modifiedId)
            local frame = self:CreateFrameForExistingWindow (windowName)
            
            if (frame)
            then
                frame.m_AnchorEditor    = anchorEditor
                frame.m_Tooltip         = tooltip
                frame.m_ModifiedId      = modifiedId
            end
            
            return frame
        end
        
        function YaaarEditBox:OnMouseOver (flags, x, y)
            Tooltips.CreateTextOnlyTooltip (self:GetName (), self.m_Tooltip)
            Tooltips.Finalize ()
            Tooltips.AnchorTooltip (Tooltips.ANCHOR_WINDOW_VARIABLE)
        end
        
        function YaaarEditBox:OnMouseWheel (x, y, delta, flags)
            -- Does nothing, that's cool...
        end
        
        function YaaarEditBox:AA_GetModifiedId ()
            return self.m_ModifiedId
        end
        
        
        function YaaarNumberEditBox:OnMouseWheel (x, y, delta, flags)
            if (flags == SystemData.ButtonFlags.SHIFT)
            then
                delta = delta * 10
            end
            
            self:SetText (self:TextAsNumber () + delta)
            self.m_AnchorEditor:Apply ()
        end
        
        function YaaarNumberEditBox:Clear ()
            self:SetText (L"0")
        end
        
        
        
        
        --
        -- This object encapsulates a single anchor
        --
        
        function YaaarDimensions:Create(windowName, parentWindow, anchorEditor)
            local dims = self:CreateFromTemplate (windowName, parentWindow)
            if (dims) then
                local win =
                {
                    [DIMENSIONSLABEL   ] = Label:CreateFrameForExistingWindow (windowName.."Label"),
                    [WINX_LABEL   ] = Label:CreateFrameForExistingWindow (windowName.."XLabel"),
                    [WINX  ] = YaaarNumberEditBox:Create (windowName.."XEdit", anchorEditor, tooltips[WINX]),
                    [WINY_LABEL   ] = Label:CreateFrameForExistingWindow (windowName.."YLabel"),
                    [WINY  ] = YaaarNumberEditBox:Create (windowName.."YEdit", anchorEditor, tooltips[WINY]),
                }
        
                win[DIMENSIONSLABEL]:SetText (L"Window Dimensions:")
                win[WINX_LABEL]:SetText (L"X: ")
                win[WINY_LABEL]:SetText (L"Y:")
                
                win[WINX]:Clear ()
                win[WINY]:Clear ()
    
                dims.m_Windows    = win
                dims.m_Dims = {}
                
                dims:Show (true)
            end
    
            return dims
        end
        
        function YaaarDimensions:GetDimensions()
            local win = self.m_Windows
    
            self.m_Dims.X = win[WINX]:TextAsString ()
            
            if (self.m_Dims.X ~= "")
            then
                self.m_Dims.X = win[WINX]:TextAsNumber ()
                self.m_Dims.Y = win[WINY]:TextAsNumber ()
        
                return self.m_Dims.X, self.m_Dims.Y
            end
    
            return nil
        end
    
        function YaaarDimensions:UpdateDims(winX, winY)
            local win = self.m_Windows
            win[WINX]:SetText(winX)
            win[WINY]:SetText(winY)
        end
        
        
        function YaaarSingleAnchor:Create (windowName, parentWindow, anchorEditor, anchorId)
            local anchor = self:CreateFromTemplate (windowName, parentWindow)
            
            if (anchor)
            then
                local win =
                {
                    [REL_WINDOW_LABEL   ] = Label:CreateFrameForExistingWindow (windowName.."RelativeWindowLabel"),
                    [REL_WINDOW_EDIT    ] = YaaarEditBox:Create (windowName.."RelativeWindowEdit", anchorEditor, tooltips[REL_WINDOW_EDIT], REL_WINDOW_EDIT),
                    [MAIN_POINT_LABEL   ] = Label:CreateFrameForExistingWindow (windowName.."PointLabel"),
                    [MAIN_POINT_COMBO   ] = ComboBox:CreateFrameForExistingWindow (windowName.."PointCombo"),
                    [REL_POINT_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."RelativePointLabel"),
                    [REL_POINT_COMBO    ] = ComboBox:CreateFrameForExistingWindow (windowName.."RelativePointCombo"),
                    [XOFFS_EDIT         ] = YaaarNumberEditBox:Create (windowName.."XOffs", anchorEditor, tooltips[XOFFS_EDIT]),
                    [YOFFS_EDIT         ] = YaaarNumberEditBox:Create (windowName.."YOffs", anchorEditor, tooltips[YOFFS_EDIT]),
                    [HIGHLIGHTWINDOW  ] = SimpleCheckButton:Create (windowName.."HighlightWindow", tooltips[HIGHLIGHTWINDOW], anchorEditor, anchorEditor.HighlightWindowButtonCallback),
                }
                
                win[REL_WINDOW_LABEL]:SetText (tooltips[anchorId])
                win[MAIN_POINT_LABEL]:SetText (L"Point:")
                win[REL_POINT_LABEL]:SetText (L"Rel. Point:")
                
                win[MAIN_POINT_COMBO]:AddTable (AnchorNames)
                win[REL_POINT_COMBO]:AddTable (AnchorNames)
                
                win[REL_WINDOW_EDIT]:Clear ()
                win[XOFFS_EDIT]:Clear ()
                win[YOFFS_EDIT]:Clear ()
                
                anchor.m_Windows    = win
                anchor.m_Anchor     = {}
                
                anchor:Show (true)
            end
            
            return anchor
        end
        
        function YaaarSingleAnchor:GetAnchor ()
            local win = self.m_Windows
            
            self.m_Anchor.RelativeTo = win[REL_WINDOW_EDIT]:TextAsString ()
            
            if (self.m_Anchor.RelativeTo ~= "")
            then
                self.m_Anchor.Point         = win[MAIN_POINT_COMBO]:TextAsString ()
                self.m_Anchor.RelativePoint = win[REL_POINT_COMBO]:TextAsString ()
                self.m_Anchor.RelativeTo    = win[REL_WINDOW_EDIT]:TextAsString ()
                self.m_Anchor.XOffset       = win[XOFFS_EDIT]:TextAsNumber ()
                self.m_Anchor.YOffset       = win[YOFFS_EDIT]:TextAsNumber ()
                
                return self.m_Anchor
            end
            
            return nil
        end
    
        function YaaarSingleAnchor:GetAnchorAsWideString (anchoredWindowName)
            local anchor = self:GetAnchor ()
        
            if (anchor == nil)
            then
                return L""
            end
        
            local outputType = AA_Settings["outputType"]
            local parentReplacement = AA_Settings["parentReplacement"] and (outputType == "xml")
            
            return (tiddlywinks[outputType] (anchor, anchoredWindowName, parentReplacement))
        end
    
        function YaaarSingleAnchor:UpdateAnchor (point, relativePoint, relativeTo, xoffs, yoffs)
            local win = self.m_Windows
        
            win[REL_WINDOW_EDIT]:SetText (relativeTo)
            win[MAIN_POINT_COMBO]:SetSelectedMenuItem (AnchorNames:ComboSelectionFromName (point))
            win[REL_POINT_COMBO]:SetSelectedMenuItem (AnchorNames:ComboSelectionFromName (relativePoint))
            win[XOFFS_EDIT]:SetText (xoffs)
            win[YOFFS_EDIT]:SetText (yoffs)
        end
    
        --
        -- The Anchor Editor
        --
    
    
        function Yaaar:Create (windowName)
            local yaaar = self:CreateFromTemplate (windowName)
        
            local radioGroup = RadioGroup:Create (windowName.."OutputType", yaaar, yaaar.RadioGroupCallback)
        
            local win =
            {
                [MAIN_WINDOW_LABEL  ] = Label:CreateFrameForExistingWindow (windowName.."MainWindowLabel"),
                [MAIN_WINDOW_EDIT   ] = YaaarEditBox:Create (windowName.."Main", yaaar, tooltips[MAIN_WINDOW_EDIT], MAIN_WINDOW_EDIT),
                [ANCHOR1            ] = YaaarSingleAnchor:Create (windowName.."Anchor1", windowName, yaaar, ANCHOR1),
                [ANCHOR2            ] = YaaarSingleAnchor:Create (windowName.."Anchor2", windowName, yaaar, ANCHOR2),
                [DIMS_WIN           ] = YaaarDimensions:Create(windowName.."Dimensions", windowName, yaaar, DIMS_WIN),
                [TITLE_BAR_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."TitleBarLabel"),
              --  [INTERFACE_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentInterfaceScaleLabel"),
              --  [INTERFACE_TEXT    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentInterfaceScaleText"),
                [MOUSEOVER_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentMouseOverLabel"),
                [MOUSEOVER_WINDOW    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentMouseOverWindow"),
                [MOUSEPOINT_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentMousePointLabel"),
                [MOUSEPOINT_TEXT    ] = Label:CreateFrameForExistingWindow (windowName.."CurrentMousePointText"),
                [MOUSEOVERWINDOW_LABEL    ] = Label:CreateFrameForExistingWindow (windowName.."WindowMousePointLabel"),
                [MOUSEOVERWINDOW_TEXT    ] = Label:CreateFrameForExistingWindow (windowName.."WindowMousePointText"),
                [ANCHOR_EDITBOX      ] = YaaarEditBox:Create(windowName.."AnchorText", yaaar, tooltips[ANCHOR_EDITBOX], ANCHOR_EDITBOX),
                [OUTPUT_RADIO_GROUP ] = radioGroup,
                [ANCHOROUT_XML      ] = radioGroup:AddExistingButton (windowName.."OutputTypeAnchorAsXML", "xml", tooltips[ANCHOROUT_XML]),
                [ANCHOROUT_STBL     ] = radioGroup:AddExistingButton (windowName.."OutputTypeAnchorAsSingleLineTable", "singletable", tooltips[ANCHOROUT_STBL]),
                [ANCHOROUT_MTBL     ] = radioGroup:AddExistingButton (windowName.."OutputTypeAnchorAsMultiLineTable", "multitable", tooltips[ANCHOROUT_MTBL]),
                [ANCHOROUT_PREP     ] = SimpleCheckButton:Create (windowName.."PerformParentReplacement", tooltips[ANCHOROUT_PREP], yaaar, yaaar.CheckButtonCallback),
                [ANCHOROUT_AUTOCOP  ] = SimpleCheckButton:Create (windowName.."AutoCopyToClipboard", tooltips[ANCHOROUT_AUTOCOP], yaaar, yaaar.CheckButtonCallback),
                [HIGHLIGHTWINDOW  ] = SimpleCheckButton:Create (windowName.."HighlightWindow", tooltips[HIGHLIGHTWINDOW], yaaar, yaaar.HighlightWindowButtonCallback),
            }
        
            win[TITLE_BAR_LABEL]:SetText (L"Window Helper")
            win[MAIN_WINDOW_LABEL]:SetText (L"Main Window:")
            win[MOUSEOVER_LABEL]:SetText (L"Mouseover Window:")
            win[MOUSEPOINT_LABEL]:SetText (L"Mouse Point:")
            win[MOUSEOVERWINDOW_LABEL]:SetText (L"Relative Window Mouse Point:")
        
            win[ANCHOR1]:SetAnchor ({Point = "bottomleft", RelativePoint = "topleft", RelativeTo= win[MAIN_WINDOW_EDIT]:GetName (), XOffset = 0, YOffset = 40})
            win[ANCHOR2]:SetAnchor ({Point = "bottomright", RelativePoint = "topright", RelativeTo= win[MAIN_WINDOW_EDIT]:GetName (), XOffset = 0, YOffset = 40})
            win[DIMS_WIN]:SetAnchor ({Point = "top", RelativePoint = "center", RelativeTo= win[ANCHOR2]:GetName (), XOffset = 0, YOffset = 10})
            win[ANCHOR_EDITBOX]:Clear ()
           -- win[ANCHOR_STRING]:Show (true) -- not showing this window, but it needs to exist for newline behavior to work...
        
            yaaar.m_Windows = win
        
            -- Undesirable dependency....m_Windows needs to be set up before these functions can be called.
            win[OUTPUT_RADIO_GROUP]:UpdatePressedId (win[ANCHOROUT_XML])
            win[ANCHOROUT_PREP]:SetChecked (true)
            win[ANCHOROUT_AUTOCOP]:SetChecked (true)
        
            return yaaar
        end
    
        function Yaaar:RadioGroupCallback (newRadioGroupSelection)
            AA_Settings["outputType"] = newRadioGroupSelection
            self:Apply ()
        end
        
        function Yaaar:HighlightWindowButtonCallback(checkButtonFrame, isChecked)
            local main, anchor, anchorHighlight= warExtended:IsMouseOverWindow("Yaaar", "Anchor", "AnchorHighlight")
            local checkButtonName = checkButtonFrame:GetName ()
            local windows = self.m_Windows
            
            if anchor ~= nil then
            
            else
                warExtendedTerminal.HighlightWindow(windows[MAIN_WINDOW_EDIT]:TextAsString ())
            end
        end
    
        function Yaaar:CheckButtonCallback (checkButtonFrame, isChecked)
            local checkButtonName = checkButtonFrame:GetName ()
        
            if (checkButtonName == self.m_Windows[ANCHOROUT_PREP]:GetName ())
            then
                AA_Settings["parentReplacement"] = isChecked
            elseif (checkButtonName == self.m_Windows[ANCHOROUT_AUTOCOP]:GetName ())
            then
                AA_Settings["clipboardCopyOnSet"] = isChecked
            end
        
            self:Apply ()
        end
    
        function Yaaar:Apply ()
            local controls = self.m_Windows
        
            local windowName = controls[MAIN_WINDOW_EDIT]:TextAsString ()
            local frame = FrameManager:EnsureWindowHasFrame (windowName)
         
            if (frame)
            then
                local anchor1 = controls[ANCHOR1]
                local anchor2 = controls[ANCHOR2]
                local dims = controls[DIMS_WIN]
                
            
                frame:SetAnchor (anchor1:GetAnchor (), anchor2:GetAnchor ())
                frame:SetDimensions(dims:GetDimensions())
            
                local wstringAnchor1    = anchor1:GetAnchorAsWideString (windowName)
                local wstringAnchor2    = anchor2:GetAnchorAsWideString (windowName)
                local wstringFullAnchor = wstringAnchor1..L"<BR>"..wstringAnchor2
            
                if (AA_Settings["outputType"] == "xml")
                then
                    wstringFullAnchor = L"<Anchors><BR>"..wstringFullAnchor..L"<BR></Anchors>"
                end
            
                controls[ANCHOR_EDITBOX]:SetText (wstringFullAnchor)
            end
        end
    
        function Yaaar:SetGrabberWindow (frame)
            if (frame)
            then
                frame:SetTintColor (0, 255, 0)
            elseif (self.m_GrabberFrame)
            then
                self.m_GrabberFrame:SetTintColor (255, 255, 255)
            end
        
            self.m_GrabberFrame = frame
        end
    
        function Yaaar:UpdateGrabberWindow (windowName)
            if (self.m_GrabberFrame)
            then
                self.m_GrabberFrame:SetText (windowName)
            
                if (self.m_GrabberFrame:AA_GetModifiedId () == MAIN_WINDOW_EDIT)
                then
                    local anchorCount = WindowGetAnchorCount (windowName)
                    local winX, winY = WindowGetDimensions(windowName)
                    local anchorId = 1
                
                    while (anchorId <= anchorCount)
                    do
                        local point, relativePoint, relativeTo, xoffs, yoffs = WindowGetAnchor (windowName, anchorId)
                    
                        self.m_Windows[AnchorIdToAnchorControlMapping[anchorId]]:UpdateAnchor (point, relativePoint, relativeTo, xoffs, yoffs)
                    
                        anchorId = anchorId + 1
                    end
                
                    while (anchorId <= 2)
                    do
                        self.m_Windows[AnchorIdToAnchorControlMapping[anchorId]]:UpdateAnchor ("", "", "", 0, 0)
                        anchorId = anchorId + 1
                    end
                    
                    
                    self.m_Windows[DIMS_WIN]:UpdateDims(winX, winY)
                end
            
                self:SetGrabberWindow (nil)
            end
        end
    
    end
    
end

warExtended:AddEventHandler("das123", "CoreInitialized", das123)
--
-- There's a better way to do this...string.format, wstring.format, and/or __tostring (which probably uses string.format)
-- This is the easy way...and this is the first time this has been implemented, so I'm taking the easy way out.
--

-- And of course, the conversion lookup table...

-- Actually checks settings to see what the anchors should look like...does all necessary conversions


AnchorMover = {}

local lastMouseOverWindow = ""
local lastMouseX = ""
local lastMouseY = ""
local lastRelativeMouseX = ""
local lastRelativeMouseY = ""
local interfaceScale = ""

function AnchorMover.Initialize ()
    RegisterEventHandler (SystemData.Events.L_BUTTON_DOWN_PROCESSED,    "AnchorMover.OnLButtonDownProcessed")
    RegisterEventHandler (SystemData.Events.R_BUTTON_DOWN_PROCESSED,    "AnchorMover.OnRButtonDownProcessed")

    interfaceScale = InterfaceCore.GetScale()
    Yaaar:Create ("Yaaar")
end

function AnchorMover.Shutdown ()
    UnregisterEventHandler (SystemData.Events.L_BUTTON_DOWN_PROCESSED,    "AnchorMover.OnLButtonDownProcessed")
    UnregisterEventHandler (SystemData.Events.R_BUTTON_DOWN_PROCESSED,    "AnchorMover.OnRButtonDownProcessed")
    
    AnchorMover.mainWindow:Destroy ()
end

function AnchorMover.Update (timePassed)
    local yaaar = FrameManager:Get ("Yaaar")
    local currentMouseOverWindow = warExtended:GetMouseOverWindow()
    local mouseX, mouseY = warExtended:GetMousePosition()
    local winX, winY = warExtended:WindowGetDimensions(currentMouseOverWindow)
    local winPosX, winPosY = warExtended:GetWindowPosition(currentMouseOverWindow)
    local relativeMouseX, relativeMouseY = math.floor((mouseX - winPosX)/interfaceScale), math.floor((mouseY - winPosY)/interfaceScale)
    
    
    
    if ((yaaar ~= nil) and (lastMouseOverWindow ~= currentMouseOverWindow))
    then
        yaaar.m_Windows[MOUSEOVER_WINDOW]:SetText (warExtendedTerminal:toWString (currentMouseOverWindow))
        lastMouseOverWindow = currentMouseOverWindow
    end
    
    if (lastMouseX ~= mouseX or lastMouseY ~= mouseY) then
        local mousePoint = L"X: " .. mouseX .. L", Y: " .. mouseY;
        yaaar.m_Windows[MOUSEPOINT_TEXT]:SetText (mousePoint)
        lastMouseX, lastMouseY = mouseX, mouseY
    end
    
    if lastRelativeMouseX ~= relativeMouseX or lastRelativeMouseY ~= relativeMouseY then
        local relativePoint = "X: " .. relativeMouseX .. ", Y: " .. relativeMouseY;
    
        if currentMouseOverWindow == "Root" then
            relativePoint = L"X: " .. mouseX .. L", Y: " .. mouseY;
        end
        
        yaaar.m_Windows[MOUSEOVERWINDOW_TEXT]:SetText (warExtendedTerminal:toWString(relativePoint))
        lastRelativeMouseX, lastRelativeMouseY = relativeMouseX, relativeMouseY
    
    end
   
end

function AnchorMover.Apply (flags, x, y)
    if (flags ~= SystemData.ButtonFlags.SHIFT)
    then
        GetFrame ("Yaaar"):Apply ()
    end
end

function AnchorMover.OnLButtonDownProcessed (flags, x, y)
    local frame = GetFrame (SystemData.MouseOverWindow.name)
    local yaaar = GetFrame ("Yaaar")
    
    if (flags == SystemData.ButtonFlags.SHIFT)
    then
        if ((frame ~= nil) and (frame["AA_GetModifiedId"] ~= nil))
        then
            yaaar:SetGrabberWindow (frame)
        end
    else
        yaaar:UpdateGrabberWindow (SystemData.MouseOverWindow.name)
    end
end

function AnchorMover.OnRButtonDownProcessed (flags, x, y)
    if (flags == SystemData.ButtonFlags.SHIFT)
    then
        local frame = GetFrame (SystemData.MouseOverWindow.name)
        
        if ((frame ~= nil) and (frame["AA_GetModifiedId"] ~= nil))
        then
            frame:Clear ()
        end
    end
end

warExtended:AddEventHandler("asdd", "CoreInitialized", AnchorMover.Initialize)