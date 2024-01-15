warExtendedDefaultRenownTraining = Frame:Subclass("warExtendedDefaultRenownTraining")

function warExtendedDefaultRenownTraining:Create(windowName, parentName)
    local frame
end

function warExtendedDefaultRenownTraining:OnInitialize()
    p("initializing the frame")
end

function warExtendedDefaultRenownTraining:GetLinkedAdvances()
    return self.m_linkedAdvances
end