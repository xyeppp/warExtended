warExtendedDefaultSets = Frame:Subclass("warExtendedDefaultSets")

local warExtendedDefaultSets = warExtendedDefaultSets
--local warExtendedSet = warExtendedSet
local GetFrame = GetFrame
local trem = table.remove

local LABEL = 1
local ADD_BUTTON = 2
local REMOVE_BUTTON = 3
local SET_COMBO = 4

function warExtendedDefaultSets:Create(windowName, callbackObject, callbackFrame, label)
    local frame = GetFrame(windowName) or self:CreateFrameForExistingWindow(windowName)
    if frame then
        frame.m_initialized = false;
        frame.m_callbackObject = callbackObject
        frame.m_Windows = {
            [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."Label"),
            [ADD_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."Add"),
            [REMOVE_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."Remove"),
            [SET_COMBO] = ComboBox:CreateFrameForExistingWindow(frame:GetName().."ComboBox"),
        }

        local win = frame.m_Windows

        if not frame.m_callbackObject.Sets then
            local sets = warExtendedSet:New()

            frame.m_callbackObject.selectedSet = 1
            frame.m_callbackObject.Sets = sets
        else
            warExtendedSet:Wrap(frame.m_callbackObject.Sets)

            for idx,v in ipairs(frame.m_callbackObject.Sets) do
               warExtendedSet:Wrap(frame.m_callbackObject.Sets[idx])
                win[SET_COMBO]:AddMenuItem(L"Set ".. idx)
            end

        end

        win[ADD_BUTTON]:SetText(L"Add")
        win[REMOVE_BUTTON]:SetText(L"Remove")
        win[LABEL]:SetText(label)

        win[ADD_BUTTON].OnLButtonUp = function(self, ...)
            local setContents = callbackFrame:OnAddSet()

            if setContents then
                frame:AddSet(setContents)
            end
        end

        win[REMOVE_BUTTON].OnLButtonUp = function(self, ...)
            if self:IsDisabled() then
             return
            end

            if callbackFrame.OnRemoveSet then
                if callbackFrame:OnRemoveSet() then
                    frame:RemoveSet()
                    return
                end
            end

            frame:RemoveSet()

            end

        win[SET_COMBO].OnSelChanged = function(self, curSelection)
            if curSelection == 0 then
                curSelection = 1
            end

            frame.m_callbackObject.selectedSet = curSelection
            win[REMOVE_BUTTON]:SetDisabled(curSelection == 1)

            if frame.m_initialized then
                callbackFrame:OnSetChanged(curSelection, frame:GetSet(curSelection))
            end
        end

        frame:SetSelectedSet(frame.m_callbackObject.selectedSet or 1)
        win[REMOVE_BUTTON]:SetDisabled(frame.m_callbackObject.selectedSet == 1)

        frame.m_initialized = true;
        return frame
    end
end

function warExtendedDefaultSets:AddSet(setContents)
    local win = self.m_Windows
    local sets = self.m_callbackObject.Sets

    local newSet = warExtendedSet:New()

    for k,v in ipairs(setContents) do
        newSet:Add(k, v)
    end

    self.m_callbackObject.Sets[sets:Len()+1] = newSet

    win[SET_COMBO]:AddMenuItem(L"Set ".. sets:Len())

end

function warExtendedDefaultSets:RemoveSet()
    local win = self.m_Windows
    local id, name = win[SET_COMBO]:GetSelectedMenuItem()

    trem(self.m_callbackObject.Sets, id)
    win[SET_COMBO]:ClearMenuItems()

    for idx,v in ipairs(self.m_callbackObject.Sets) do
        win[SET_COMBO]:AddMenuItem(L"Set ".. idx)
    end

    self:SetSelectedSet(1)
end

function warExtendedDefaultSets:IsSetSelected(setIdx)
    local id, _ = self:GetSelectedSet()
    return id == setIdx
end

function warExtendedDefaultSets:GetSelectedSet()
    local win = self.m_Windows

    return win[SET_COMBO]:GetSelectedMenuItem()
end

function warExtendedDefaultSets:SetSelectedSet(setIdx)
    local win = self.m_Windows
    win[SET_COMBO]:SetSelectedMenuItem(setIdx)
    win[SET_COMBO]:OnSelChanged(setIdx)

end

function warExtendedDefaultSets:GetSet(setIdx)
    local sets = self.m_callbackObject.Sets
    return sets:Get(setIdx)
end

function warExtendedDefaultSets:HasSet(setIdx)
    local sets = self.m_callbackObject.Sets
    return sets:Has(setIdx)
end

function warExtendedDefaultSets:GetSets()
    return self.m_callbackObject.Sets
end

function warExtendedDefaultSets:GetSetAmount()
    local sets = self.m_callbackObject.Sets
    return sets:Len()
end

