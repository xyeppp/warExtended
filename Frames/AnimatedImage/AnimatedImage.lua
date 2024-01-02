local AnimatedImage = AnimatedImage
local AnimatedImageSetPlaySpeed = AnimatedImageSetPlaySpeed

function AnimatedImage:SetPlaySpeed(playSpeed)
    AnimatedImageSetPlaySpeed(self:GetName(), playSpeed)
end