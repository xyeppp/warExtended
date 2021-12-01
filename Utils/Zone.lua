local warExtended = warExtended

if text:find(L"SoR_F") then
  sorZoneId = text:match( L"SoR_F:(%d-):");
  sorUpdateType = L"F";
  sorUpdateTier = L"T4";
else
  sorUpdateTier, sorUpdateType, sorZoneId = text:match( L"SoR_([^%.]-)_([^%.]-):(%d-):" );
end