local warExtendedSettings = warExtendedSettings

function warExtendedSettings.FixSettings ()
  
  for k, v in pairs (warExtendedSettings.Config)
  do
	if (type (v) == "table")
	then
	  warExtendedSettings.Config[k] = warExtended:clone (v)
	end
  end
  
  warExtended:each (Enemy.Settings, function (t, k, v)
	
	if (
			type (v) == "function"
					or
					(type (k) == "string" and k:sub (1, 1) == "_")
					or
					(type (k) == "wstring" and k:sub (1, 1) == L"_")
					or
					(type (v) == "number" and (v == math.huge or v == -math.huge))
	)
	then
	  t[k] = nil
	end
  end)
end

function warExtendedSettings.ResetSettings ()
  warExtendedSettings.Config = nil
  warExtended:Print ("All settings has been reset")
  InterfaceCore.ReloadUI ()
end