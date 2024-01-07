local WINDOW_NAME = "TerminalDevPad"
local select = select
local INDENT = "     "

local ADD_STRING = L"Add New Project"
local ADD_DEFAULT_TEXT = L"Please enter the name of your new project."
local SAVE_AS_STRING = L"Save As..."
local SAVE_AS_DEFAULT_TEXT = L"Please enter the new name of your current project."
local PROJECT_EXIST =  L"This project already exists!"
local OKAY_STRING =  L"Okay"

local WINDOW                 = Frame:Subclass(WINDOW_NAME)
local MANAGE_WINDOW          = Frame:Subclass(WINDOW_NAME.."Manager")
local CODE_FRAME			 = Frame:Subclass(WINDOW_NAME.."Output")
local RESIZE_BUTTON          = ButtonFrame:Subclass(WINDOW_NAME.."ResizeButton")
local MANAGER_LIST           = ListBox:Subclass()
local FILE_BUTTON            = ButtonFrame:Subclass()
local EXECUTE_BUTTON         = ButtonFrame:Subclass()
local CODE_EDITOR            = TextEditBox:Subclass()

local TITLEBAR              = 1
local OUTPUT = 2
local LINE_COUNT_LABEL = 3
local LINE_COUNT = 4
local PROJECT_NAME_LABEL = 5
local PROJECT_NAME = 6
local EXECUTE_BTN = 7
local CODE_EDIT = 8
local FILE_BTN = 9
local RESIZE_BTN = 10
local MNG_LIST = 11
local MNG_WINDOW = 12
local RENAME_BUTTON = 13

function MANAGE_WINDOW:Create(windowName)
    local frame = self:CreateFromTemplate(windowName)
    if frame then
        frame.m_Windows = {
            [TITLEBAR] = Label:CreateFrameForExistingWindow(windowName .. "TitleBarLabel"),
           -- [TITLEBAR] = Label:CreateFrameForExistingWindow(windowName .. "TitleBarLabel"),
          --  [TITLEBAR] = Label:CreateFrameForExistingWindow(windowName .. "TitleBarLabel"),
          --  [TITLEBAR] = Label:CreateFrameForExistingWindow(windowName .. "TitleBarLabel"),

        }
    end

    local win = frame.m_Windows
    win[TITLEBAR]:SetText(L"Manage Projects")

    return frame
end

function RESIZE_BUTTON:OnResizeBegin()
    self:GetParent():BeginResize("topleft", 400, 500, nil)
end

function CODE_EDITOR:OnTextChanged(text)
    self:GetParent():SetLineCount(self:GetLineCount(text))
    TerminalDevPad:GetSavedSettings().currentCode = text
end

function CODE_EDITOR:OnKeyTab()
    self:InsertText(INDENT)
end

function CODE_EDITOR:GetLineCount(text)
    text = text or self:TextAsWideString()
    return select(2, wstring.gsub(text, L"\r", L""))+1
end

function EXECUTE_BUTTON:OnLButtonUp()
    self:GetParent():Execute()
end

--TODO:Change to projectList on start of file
local fileManager = warExtendedSet:New(TerminalDevPad:GetSavedProjects())

function CODE_FRAME:Create(windowName)
    local frame = self:CreateFrameForExistingWindow(windowName)

    if frame then
        frame.m_Windows = {
            [LINE_COUNT] = Label:CreateFrameForExistingWindow(frame:GetName().."LineCount"),
            [PROJECT_NAME_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."ProjectNameLabel"),
            [PROJECT_NAME] = Label:CreateFrameForExistingWindow(frame:GetName().."ProjectName"),
            [LINE_COUNT_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."LineCountLabel"),
            [EXECUTE_BTN] = EXECUTE_BUTTON:CreateFrameForExistingWindow(frame:GetName().."ExecuteButton"),
            [CODE_EDIT] = CODE_EDITOR:CreateFrameForExistingWindow(frame:GetName().."Code"),
            [FILE_BTN] = FILE_BUTTON:CreateFrameForExistingWindow(frame:GetName().."FileButton"),
        }

        frame.currentFile = nil
    end

    local win = frame.m_Windows

    win[LINE_COUNT_LABEL]:SetText(L"Line Count:")
    win[PROJECT_NAME_LABEL]:SetText(L"Project Name:")
    win[EXECUTE_BTN]:SetText(L"Execute")
    win[FILE_BTN]:SetText(L"File")
    win[CODE_EDIT]:SetText(L"")

    local currentProject = TerminalDevPad:GetCurrentProject()

    if TerminalDevPad:GetCurrentProject() ~= L"Unnamed" then
        fileManager:load(currentProject)
        --self:LoadProject(currentProject)
    end

    return frame
end

function CODE_FRAME:SetCode(projectName, code)
    local frame = GetFrame(WINDOW_NAME.."Output")
    local editor = frame.m_Windows[CODE_EDIT]
    local name = frame.m_Windows[PROJECT_NAME]

    name:SetText(projectName)
    editor:SetText(code)
end

function CODE_FRAME:SetLineCount(lineCount)
    local win = self.m_Windows
    win[LINE_COUNT]:SetText(lineCount)
end

fileManager.addString = L"Add New Project"
fileManager.addDefaultText = L"Please enter the name of your new project."
fileManager.saveAsString = L"Save As..."
fileManager.saveAsDefaultText = L"Please enter the new name of your current project."
fileManager.projectExistString = L"This project already exists!"
fileManager.okayString = L"Okay"
fileManager.currentFile = nil

function fileManager:addNew(e)
    self:Add(e)
    TerminalDevPad:GetSavedSettings().savedProjects[e] = L""
    self:load(e)
end

function fileManager:saveAs(e)
    self:Add(e)
    TerminalDevPad:GetSavedSettings().savedProjects[e] = TerminalDevPad:GetCurrentCode()
    self:load(e)
end

function fileManager:save(e)
    p(self)
    if self:Has(e) then
        TerminalDevPad:GetSavedSettings().savedProjects[e] = TerminalDevPad:GetCurrentCode()
    end
end

function fileManager:rename(e)
    if self:Has(fileManager.currentFile) then
       -- local copy = TerminalDevPad:GetSavedSettings().savedProjects[fileManager.currentFile]
        self:remove(fileManager.currentFile)
        self:saveAs(e)
    end
end

function fileManager:remove(e)
    self:Remove(e)
    TerminalDevPad:GetSavedSettings().savedProjects[e] = nil
end

function fileManager:load(e)
    if self:Has(e) then
        self.currentFile = e
        TerminalDevPad:GetSavedSettings().currentProject = e
        CODE_FRAME:SetCode(e, TerminalDevPad:GetSavedSettings().savedProjects[e])
    end
end

function fileManager.execute()
    p(FrameManager:GetActiveWindow())
    local windowName = SystemData.ActiveWindow.name
    local projectName = ButtonGetText( windowName )
    local frame = GetFrame(WINDOW_NAME.."Output")
    frame:Execute(TerminalDevPad:GetProjectCode(projectName))

  --  DevPad.TestPrint()
end

function fileManager.addProject(projectName)
    if fileManager:Has(projectName) then
        DialogManager.MakeOneButtonDialog( fileManager.projectExistString, fileManager.okayString, CODE_FRAME.AddNewProject, nil, 5 )
    else
        fileManager:addNew(projectName)
    end
end

function fileManager.currentProjectSave()
    p(fileManager.currentFile)
    fileManager:save(fileManager.currentFile)
end

function fileManager.currentProjectSaveAs(projectName)
    fileManager:saveAs(projectName)
end

function CODE_FRAME.AddNewProject()
    DialogManager.MakeTextEntryDialog( fileManager.addString, fileManager.addDefaultText, L"", fileManager.addProject, nil )
    p("adding")
end

function CODE_FRAME.SaveAs()
   -- DialogManager.MakeTextEntryDialog( fileManager.saveAsString, fileManager.saveAsDefaultText, L"", fileManager.addProject, nil )
   -- p("adding")
end

function CODE_FRAME:Clear()
    local frame = GetFrame(WINDOW_NAME.."Output").m_Windows[CODE_EDIT]
    frame:SetText(L"")
end

function CODE_FRAME.Rename()
  --  DialogManager.MakeTextEntryDialog( fileManager.addString, fileManager.addDefaultText, L"", fileManager.addProject, nil )
end

function CODE_FRAME:Manage()
    WINDOW:ToggleManager()
    p("das")
end

function CODE_FRAME.Delete(projectName)
    fileManager:remove(projectName or TerminalDevPad:GetCurrentProject())
    fileManager:load(L"testqer")
end

function CODE_FRAME:Execute(code)
    local win = self.m_Windows

    local code = code or win[CODE_EDIT]:TextAsWideString()
    if code ~= L"" then
        warExtended:Script(code)
    end

    --DevPad.TestPrint()
end

local contextMenu = {
    {text = L""},
    {text = L"New", callback = CODE_FRAME.AddNewProject, disabled = false },
    {text = L"Clear", callback = CODE_FRAME.Clear, disabled=false},
    {text = L"Rename", callback = CODE_FRAME.Rename, disabled=false},
    {text = L""},
    {text = L"Load", callback = CODE_FRAME.LoadComboBox, disabled=false},
    {text = L"Save", callback = fileManager.currentProjectSave, disabled=false},
    {text = L"Save As", callback = CODE_FRAME.SaveAs, disabled=false},
    {text = L""},
    {text = L"Manage", callback = CODE_FRAME.Manage, disabled=false},
    {text = L"Execute", type="cascading", entryData={

    }, disabled=false},
    {text = L""},
    {text = L"Delete", callback = CODE_FRAME.Delete, disabled=false},
}


local contextMenuAnchor =  {
    ["XOffset"] = -96,
    ["YOffset"] = 318,
    ["Point"] = "bottomright",
    ["RelativePoint"] = "bottomleft",
    ["RelativeTo"] = WINDOW_NAME.."OutputFileButton",
}

function FILE_BUTTON:OnLButtonUp()
    local frame = GetFrame(WINDOW_NAME.."Output")
    local savedProjects = TerminalDevPad:GetSavedSettings().savedProjects
    local currentProject = TerminalDevPad:GetCurrentProject()

    p(currentProject)

    contextMenu[3].disabled = TerminalDevPad:GetCurrentCode() == L""
    contextMenu[4].disabled = currentProject == L"Unnamed"
    contextMenu[6].disabled = next(savedProjects) == nil
    contextMenu[7].disabled = currentProject == L"Unnamed" or TerminalDevPad:GetCurrentCode() == TerminalDevPad:GetProjectCode(currentProject)
    contextMenu[11].disabled = next(savedProjects) == nil
    contextMenu[13].disabled = savedProjects[fileManager.currentFile] == nil

    if next(savedProjects) ~= nil then
        contextMenu[11].entryData = {}
        for projectName,projectCode in pairs(savedProjects) do
            contextMenu[11].entryData[#contextMenu[11].entryData + 1] = {text = projectName, callback = fileManager.execute, disabled=false}
        end

        table.sort(contextMenu[11].entryData, function(a, b) return a.text < b.text  end)
    end

    local currentProject = TerminalDevPad:GetCurrentProject()
    if next(TerminalDevPad:GetSavedSettings().savedProjects) == nil or currentProject == L"Unnamed" then
        warExtended:CreateContextMenu(nil, contextMenu, L"Unnamed", contextMenuAnchor)
    else
        warExtended:CreateContextMenu(nil, contextMenu, currentProject, contextMenuAnchor)
    end
end

function WINDOW:ToggleManager()
    local mngWindow = self.m_Windows[MNG_WINDOW]
    mngWindow:Show(not mngWindow:IsShowing())
end

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)

  self.m_Windows            = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[OUTPUT] = CODE_FRAME:Create(WINDOW_NAME .. "Output"),
    [RESIZE_BTN] = RESIZE_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME.."ResizeButton"),
    [MNG_WINDOW] = MANAGE_WINDOW:Create(WINDOW_NAME.."Manager")
  }

  self.m_Windows[TITLEBAR]:SetText(L"DevPad")
end


WINDOW:Create()
