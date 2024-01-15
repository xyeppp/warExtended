TextLog = {}

function TextLog:Subclass(name)
  local derivedObject = setmetatable ({}, { __index = self })
  derivedObject.m_Name = name
  return derivedObject
end

function TextLog:GetName()
  return self.m_Name
end

function TextLog:Create(entryLimit)
  TextLogCreate(self:GetName(), entryLimit or 65535)
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

function TextLog:SetIncrementalSaving(isIncrementalSaving, logName)
  TextLogSetIncrementalSaving( self:GetName(), isIncrementalSaving, L"logs/"..logName..L".log" )
end

function TextLog:GetIncrementalSaving()
 return TextLogGetIncrementalSaving(self:GetName())
end

function TextLog:Clear()
  TextLogClear(self:GetName())
end

function TextLog:Save(logName)
 TextLogSaveLog( self:GetName(), L"logs/"..logName..L".log" )
end

function TextLog:LoadFromFile(logName)
  self:Clear()
 TextLogLoadFromFile( self:GetName(), L"logs/"..logName..L".log" )
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

function TextLog:GetLastEntry()
  return self:GetEntry(self:GetNumEntries() -1)
end

function TextLog:GetEntriesAsString()
  local entries = {}

  for i = 0, self:GetNumEntries() - 1 do
    local _, _, text = self:GetEntry(i)
    entries[#entries+1] = warExtended:toString(text)
  end

  return table.concat(entries, "\n")
end

function TextLog:GetEntriesTable()
  local entries = {}
  for i = 0, self:GetNumEntries() - 1 do
    local timestamp, filterId, text = self:GetEntry(i)
    entries[#entries+1] = {timestamp, filterId, text}
  end
  return entries
end

function TextLog:GetUpdateEventId()
  return TextLogGetUpdateEventId(self:GetName())
end

