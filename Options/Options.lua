local warExtended = warExtended

warExtended.data = nil           -- data we receive from C



warExtended.OptionsListBoxData = {
  }

local configurationWindow = {
}

function warExtended.InitializeOptions()
  p("initializing opt")
end

function warExtended.OptionsOnInitialize()
  p('window shown')
end

function warExtended.OptionsOnShutdown()
  p("window disabled")
end
