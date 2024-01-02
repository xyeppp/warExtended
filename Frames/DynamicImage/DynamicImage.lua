local DynamicImage = DynamicImage
local DynamicImageSetTextureScale = DynamicImageSetTextureScale

function DynamicImage:SetTextureScale(scale)
  DynamicImageSetTextureScale(self:GetName(), scale)
end