
        
        SimpleCheckButton = DynamicImage:Subclass ()
        
        function SimpleCheckButton:Create (windowName, labelText, callbackObject, callbackFunction)
            local button = self:CreateFrameForExistingWindow (windowName)
            
            if (button)
            then
                button.m_CheckedImage   = DynamicImage:CreateFrameForExistingWindow (windowName.."Check")
                button.m_Label          = Label:CreateFrameForExistingWindow (windowName.."Label")
                
                button.m_Label:SetText (labelText)
                
                if (callbackObject and callbackFunction)
                then
                    button.m_CallbackObject     = callbackObject
                    button.m_CallbackFunction   = callbackFunction
                end
            end
            
            return button
        end
        
        function SimpleCheckButton:SetChecked (checkedFlag)
            self.m_IsChecked = checkedFlag
            
            if (self.m_CheckedImage)
            then
                self.m_CheckedImage:Show (checkedFlag)
            end
            
            if (self.m_CallbackObject and self.m_CallbackFunction)
            then
                local obj   = self.m_CallbackObject
                local func  = self.m_CallbackFunction
                
                func (obj, self, self:GetChecked ())
            end
        end
        
        function SimpleCheckButton:GetChecked ()
            return self.m_IsChecked or false
        end
        
        function SimpleCheckButton:OnLButtonUp (flags, x, y)
            self:SetChecked (not self:GetChecked ())
        end
    
