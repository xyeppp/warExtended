TextLog = {}

function TextLog:Subclass(name)
  local derivedObject = setmetatable ({}, self)
  
  derivedObject.__index       = derivedObject
  derivedObject.m_Name = name
  
  return derivedObject
end

function TextLog:GetName()
  return self.m_Name
end

function TextLog:Create()
  TextLogCreate(self:GetName())
end

function TextLog:Destroy()
 TextLogDestroy(self:GetName())
end

function TextLog:AddFilterType(filterId, filterText)
  TextLogAddFilterType( self:GetName(), filterId, filterText )
end

function TextLog:AddEntry(filterId, entry)
  TextLogAddEntry(self:GetName(), filterId, entry)
end

function TextLog:AddSingleByteEntry(filterId, entry)
  TextLogAddSingleByteEntry(self:GetName(), filterId, entry )
end

function TextLog:SetIncrementalSaving(flag, fileName)
  --TextLogSetIncrementalSaving( self:GetName(), flag, L"logs/"..warExtended:toWString(fileName)raidlog1.txt" )
end

function TextLog:GetIncrementalSaving()
--local logFileOn = TextLogGetIncrementalSaving( self:GetName())
end

function TextLog:Clear()
  TextLogClear(self:GetName())
end

function TextLog:Save(path)
--TextLogSaveLog( self:GetName(), "logs/SomeDungon_July5th.txt" )
end

function TextLog:LoadFromFile(path)
--TextLogLoadFromFile( self:GetName(), "logs/SomeDungon_July5th.txt" )
end

function TextLog:SetEnabled(flag)
  TextLogSetEnabled(self:GetName(), flag)
end

function TextLog:GetEnabled()
  return TextLogGetEnabled(self:GetName())
end

function TextLog:GetNumEntries()
  return TextLogGetNumEntries(self:GetName())
end

function TextLog:GetEntry(entry)
  return TextLogGetEntry(self:GetName(), entry)
end

function TextLog:GetUpdateEventId()
  return TextLogGetUpdateEventId(self:GetName())
end

