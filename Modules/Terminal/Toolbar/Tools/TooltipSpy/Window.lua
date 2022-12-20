local warExtended = warExtended

local WINDOW_NAME = "TerminalTooltipSpy"
local ICON_FRAME = 1
local NAME_COLUMN = 2
local NAME_LABEL = 3
local ID_COLUMN = 4
local ID_LABEL = 5
local ICON_COLUMN = 6
local ICON_LABEL = 7
local OUTPUT_TEXT = 8
local TITLEBAR = 9
local TABGROUP = 10


    local TerminalTooltipSpy = TerminalTooltipSpy
    local WINDOW = Frame:Subclass(WINDOW_NAME)
    local OBJECT_OUTPUT = Frame:CreateFrameForExistingWindow(WINDOW_NAME.."ObjectOutput")
    local BUTTON_OUTPUT = Frame:CreateFrameForExistingWindow(WINDOW_NAME.."ActionButtonOutput")
   
    function WINDOW:Create()
      self:CreateFromTemplate(WINDOW_NAME)
      
      self.m_Windows = {}
      
      self.m_Windows[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME.."TitleBarLabel")
      
      self.m_Windows[TABGROUP] = TabGroup:Create(WINDOW_NAME.."BottomTabs", TerminalTooltipSpy:GetSavedSettings())
      
      self.m_Windows[TABGROUP] = {
        [OBJECT_OUTPUT] = self.m_Windows[TABGROUP]:AddExistingTab (WINDOW_NAME.."BottomTabsObject", WINDOW_NAME.."ObjectOutput", "Object", "Object Data"),
        [BUTTON_OUTPUT] = self.m_Windows[TABGROUP]:AddExistingTab (WINDOW_NAME.."BottomTabsActionButton", WINDOW_NAME.."ActionButtonOutput", "Action Button", "Action Button Data"),
      }
      
      
      self.m_Windows[OBJECT_OUTPUT] = {
        [ICON_FRAME] = CircleImage:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."Circle"),
        [NAME_COLUMN] = Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."NameColumn"),
        [NAME_LABEL] = Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."NameElement"),
        [ID_COLUMN] = Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."IdColumn"),
        [ID_LABEL] = Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."IdElement"),
        [ICON_COLUMN] =Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."IconColumn"),
        [ICON_LABEL] =Label:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."IconElement"),
        [OUTPUT_TEXT] = TextEditBox:CreateFrameForExistingWindow(OBJECT_OUTPUT:GetName().."Text"),
      }
      
      self.m_Windows[BUTTON_OUTPUT] = {
        [ICON_FRAME] = CircleImage:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."Circle"),
        [NAME_COLUMN] = Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."NameColumn"),
        [NAME_LABEL] = Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."NameElement"),
        [ID_COLUMN] = Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."IdColumn"),
        [ID_LABEL] = Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."IdElement"),
        [ICON_COLUMN] =Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."IconColumn"),
        [ICON_LABEL] =Label:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."IconElement"),
        [OUTPUT_TEXT] = TextEditBox:CreateFrameForExistingWindow(BUTTON_OUTPUT:GetName().."Text"),
      }
      
  
      local win = self.m_Windows
  
      win[TITLEBAR]:SetText(L"Tooltip Spy")
      
      if win[OBJECT_OUTPUT][OUTPUT_TEXT]:TextAsWideString()==L"" then
        win[OBJECT_OUTPUT][ICON_FRAME]:Show(false)
        win[OBJECT_OUTPUT][OUTPUT_TEXT]:SetTextCache("Hover over an item/target/ability to see more information.")
      end
      
      if win[BUTTON_OUTPUT][OUTPUT_TEXT]:TextAsWideString()==L"" then
        win[BUTTON_OUTPUT][ICON_FRAME]:Show(false)
        win[BUTTON_OUTPUT][OUTPUT_TEXT]:SetTextCache("Hover over an action bar button to see more information.")
      end
    end
    
    function WINDOW:SetOutput(winOutput, data)
      local win = WINDOW.m_Windows[winOutput]
      local tab = WINDOW.m_Windows[TABGROUP][winOutput]
      
      if not tab:IsPressed() then
        tab:Flash()
      end
      
      if not win[ICON_FRAME]:IsShowing() then
        win[ICON_FRAME]:Show(true)
      end
      
      if win[NAME_COLUMN]:TextAsWideString()==L"" and win[ID_COLUMN]:TextAsWideString()==L"" and win[ICON_COLUMN]:TextAsWideString()==L"" then
        win[NAME_COLUMN]:SetText(L"Name")
        win[ID_COLUMN]:SetText(L"Id")
        win[ICON_COLUMN]:SetText(L"Icon")
      end
      
      local nameLabel = data.name or data.m_Name
      local idLabel = data.id or data.m_Id or data.entityid or warExtended:GetMacroSlotFromName(data.name)
      local iconLabel = data.iconNum or data.m_IconNum or warExtended:GetCareerIcon(data.career)
  
      win[NAME_LABEL]:SetText(nameLabel)
      win[ID_LABEL]:SetText(idLabel)
      win[ICON_LABEL]:SetText(iconLabel)
  
      local texture, x, y = GetIconData (iconLabel)
      
      if data.entityid then
        win[ICON_FRAME]:SetTexture(texture, 48, -47)
        win[ICON_FRAME]:SetScale(1.74)
      else
        local winX, winY = win[ICON_FRAME]:GetDimensions()
        win[ICON_FRAME]:SetTexture(texture, x + winX/2, y + winY/2)
        win[ICON_FRAME]:SetScale(1)
      end
      
      local outputText = objToString(data)
      win[OUTPUT_TEXT]:SetTextCache(outputText)
    end
    
    function TerminalTooltipSpy:SetObjectData(data)
      WINDOW:SetOutput(OBJECT_OUTPUT, data)
    end
    
    function TerminalTooltipSpy:SetActionButtonData(data)
      WINDOW:SetOutput(BUTTON_OUTPUT, data)
    end
    
    function TerminalTooltipSpy.OnResizeBegin()
      warExtended:OnResizeWindow(400, 500)
    end
    
    WINDOW:Create()
