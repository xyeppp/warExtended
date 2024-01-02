CircleImage       = Frame:Subclass()
local CircleImage = CircleImage
local CircleImageSetTextureSlice = CircleImageSetTextureSlice
local CircleImageSetRotation = CircleImageSetRotation
local CircleImageSetTextureScale = CircleImageSetTextureScale
local CircleImageSetFillParams = CircleImageSetFillParams
local CircleImageSetTexture = CircleImageSetTexture


function CircleImage:SetTextureSlice (sliceName, forceOverride)
  if ((sliceName ~= self.m_SliceName) or (forceOverride == Frame.FORCE_OVERRIDE))
  then
	CircleImageSetTextureSlice(self:GetName(), sliceName)
	self.m_SliceName = sliceName
  end
end

function CircleImage:SetRotation(rotationAngle)
  rotationAngle = rotationAngle or 0
  
  CircleImageSetRotation(self:GetName(), rotationAngle)
end

function CircleImage:SetScale(scale)
  scale = scale or 1
  
  CircleImageSetTextureScale(self:GetName(), scale)
end

function CircleImage:SetFill (startAngle, fillAngle)
  startAngle = startAngle or 0
  fillAngle  = fillAngle or 0
  
  CircleImageSetFillParams(self:GetName(), startAngle, fillAngle)
end

function CircleImage:SetTexture (textureName, textureX, textureY)
  textureX = textureX or 0
  textureY = textureY or 0
  
  CircleImageSetTexture(self:GetName(), textureName, textureX, textureY)
end

function CircleImage:SetExtents(maxY, minY, maxX, minX, width, height)
  self.extents = {
	maxY = maxY,
	minY = minY,
	maxX = maxX,
	minX = minX,
	width = width,
	height = height
  }
end

-- SetExtents needs be called before this function can be used.
-- Show the appropriate amount of the texture based on some fill percent from 0 to 1.0.
function CircleImage:FillBasedOnPercent(fillPercent, textureName)
  if (fillPercent and textureName and self.extents)
  then
	local height = math.floor((fillPercent * self.extents.height) + 0.5)
	local texY   = self.extents.maxY - height
	
	self:SetDimensions(self.extents.width, height)
	self:SetTexture(textureName, self.extents.minX, texY)
  end
end
