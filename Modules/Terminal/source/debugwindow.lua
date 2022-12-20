
----------------------------------------------------------------
-- Global Variables
----------------------------------------------------------------
local copyWindow="DevPadCopy"
local copyBar="CopyScrollBar"
DebugWindow = {}
DebugWindow.history = {}
DebugWindow.spyfilter = SystemData.Events
RegisteredEvents = {}
DebugWindow.RegisteredFunctionList = {}
DebugWindow.Settings =
{
    logsOn = true,
    useDevErrorHandling = true,
    loadLuaDebugLibrary = false,
    buttonclick=false

}

DebugWindow.Settings.LogFilters = {}
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.SYSTEM ]   = { enabled=true,   color=DefaultColor.MAGENTA }
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.WARNING ]  = { enabled=true,   color=DefaultColor.ORANGE }
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.ERROR ]    = { enabled=true,   color=DefaultColor.RED }
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.DEBUG ]    = { enabled=true,   color=DefaultColor.YELLOW }
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.LOADING ]  = { enabled=false,  color=DefaultColor.LIGHT_GRAY }
DebugWindow.Settings.LogFilters[ SystemData.UiLogFilters.FUNCTION ] = { enabled=false,  color=DefaultColor.GREEN }
DebugWindow.Settings.LogFilters[9] = { enabled=true,  color=DefaultColor.MAGENTA }
DebugWindow.Settings.LogFilters[10] = { enabled=true,  color=DefaultColor.LIGHT_BLUE }
DebugWindow.Settings.LogFilters[11] = { enabled=true,  color=DefaultColor.GOLD }

DebugWindow.currentMouseoverWindow = nil




-- For Internal Builds, Default the Settings to the current log states in the pregame
-- if the log is currently enabled.
if( IsInternalBuild() and (InterfaceCore.inGame == false) and TextLogGetEnabled( "UiLog" ) )
then
    DebugWindow.Settings.logsOn = true
    DebugWindow.Settings.useDevErrorHandling = GetUseLuaErrorHandling()
    DebugWindow.Settings.loadLuaDebugLibrary = GetLoadLuaDebugLibrary()

    -- Filters
    for filterType, filterData in pairs( DebugWindow.Settings.LogFilters )
    do
       filterData.enabled = TextLogGetFilterEnabled( "UiLog", filterType)
    end

end

local function HandlePregameInit()

    if( IsInternalBuild() and (InterfaceCore.inGame == false) )
    then

        -- If the Logs are enabled in the pregame, show the window
        if( DebugWindow.Settings.logsOn )
        then
            WindowSetShowing( "DebugWindow", true )
        end
    end
end

----------------------------------------------------------------
-- DebugWindow Functions
----------------------------------------------------------------

local function UpdateLoggingButton ()

    if ( DebugWindow.Settings.logsOn == true) then
        ButtonSetText("DebugWindowToggleLogging", L"Logs (On)")
    else
        ButtonSetText("DebugWindowToggleLogging", L"Logs (Off)")
    end

end


-- OnInitialize Handler
function DebugWindow.Initialize()



    -- Setup the Log
    DebugWindow.UpdateLog()
    DebugWindow.SpyCheck()
    Mesh.MeshCheck()




    -- Init the Settings
    for filterName, filterType in pairs( SystemData.UiLogFilters )
    do
        if( DebugWindow.Settings.LogFilters[filterType] == nil )
        then
            DebugWindow.Settings.LogFilters[filterType] = { enabled=true, color=DefaultColors.WHITE }
        end

    end


    LabelSetText("DebugWindowMouseOverLabel", L"Mouseover Window:" )

    LabelSetText("DebugWindowMousePointLabel", L"Mouseover X,Y: " )
    LabelSetText("DebugWindowMousePointText", L"" )
    LabelSetTextColor("DebugWindowMouseOverText", 255, 255, 0 )
        LabelSetTextColor("DebugWindowMousePointText", 255, 255, 0 )

    LogDisplaySetShowTimestamp( "DebugWindowText", false )
    LogDisplaySetShowLogName( "DebugWindowText", false )
    LogDisplaySetShowFilterName( "DebugWindowText", true )

    -- Add the Lua Log
    DebugWindow.AddUiLog()
    ButtonSetText("DebugWindowReloadUi", L"Reload UI")
    ButtonSetText("DebugWindowClose", L"Close")




    -- Options
    ButtonSetText( "DebugWindowToggleOptions", L"Options")

    --DevPad
    ButtonSetText( "DebugWindowToggleDevPad", L"DevPad")

    --Copy
    ButtonSetText( "DebugWindowToggleCopy", L"Copy")

    --Object
    ButtonSetText("DebugWindowToggleObject", L"Inspect")

    CreateWindow( "DebugWindowOptions", false )
    CreateWindow( "DevPadWindow", false )


    LabelSetText( "DebugWindowOptionsFiltersTitle", L"Logging Filters:" )
    LabelSetText( "DebugWindowOptionsFilterType1Label", L"Ui System Messages" )
    LabelSetText( "DebugWindowOptionsFilterType2Label", L"Warning Messages" )
    LabelSetText( "DebugWindowOptionsFilterType3Label", L"Error Messages" )
    LabelSetText( "DebugWindowOptionsFilterType4Label", L"Debug Messages" )
    LabelSetText( "DebugWindowOptionsFilterType5Label", L"Function Calls Messages" )
    LabelSetText( "DebugWindowOptionsFilterType6Label", L"File Loading Messages" )
    LabelSetText( "DebugWindowOptionsFilterType9Label", L"Input Messages" )
    LabelSetText( "DebugWindowOptionsFilterType10Label", L"Output Messages" )
    LabelSetText( "DebugWindowOptionsFilterType11Label", L"Event Messages" )
    ButtonSetText("DebugWindowOptionsClose", L"Close")

    -- Options
    for filterType, filterData in pairs( DebugWindow.Settings.LogFilters )
    do
        local buttonName = "DebugWindowOptionsFilterType"..filterType.."Button"
        ButtonSetStayDownFlag( buttonName, true )

        LogDisplaySetFilterState( "DebugWindowText", "UiLog", filterType, filterData.enabled )
        ButtonSetPressedFlag( buttonName, filterData.enabled )
        WindowSetId( buttonName, filterType )


        -- When UI Log filters are off, disable logging of that filter type entirely.
        TextLogSetFilterEnabled( "UiLog", filterType, filterData.enabled  )
    end

    LabelSetText(  "DebugWindowOptionsErrorHandlingTitle", L"Generate lua-errors from:" )
    LabelSetText(  "DebugWindowOptionsErrorOption1Label", L"Lua calls to ERROR()" )
    LabelSetText(  "DebugWindowOptionsErrorOption2Label", L"Errors in lua calls to C" )

    for index = 1, 2
    do
        ButtonSetStayDownFlag( "DebugWindowOptionsErrorOption"..index.."Button", true )
    end
    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption1Button", DebugWindow.Settings.useDevErrorHandling  )
    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption2Button", GetUseLuaErrorHandling() )

    LabelSetText(  "DebugWindowOptionsLuaDebugLibraryLabel", L"Load Lua Debug Library" )
    ButtonSetPressedFlag( "DebugWindowOptionsLuaDebugLibraryButton", GetLoadLuaDebugLibrary() )

    ButtonSetText( "DebugWindowOptionsClearLogText", L"Clear Log" )
    WindowSetShowing("DebugWindowOptionsFilterType10", false)
    WindowSetShowing("EA_LabelCheckButtonSmallCopy", false)

    WindowSetShowing("DebugWindowOptions", false )
    WindowSetShowing(copyBar, false)
    WindowSetShowing(copyWindow,false)

    HandlePregameInit()
    TextEditBoxSetHistory("DebugWindowTextBox", DebugWindow.history )
    if( DebugWindow.history ) then
        TextEditBoxSetHistory("DebugWindowTextBox", DebugWindow.history )
      end
      abfind=DebugWindow.AbilityFind
      desc = "desc"
      mesh=Mesh.Toggle
      changefont=SetNamesAndTitlesFont


end


function DebugWindow.OnShown()
  if not bustedloaded then return else
  if Busted.Show then
  BustedGUI.ToggleMainWindow()
end
end
end


-- OnShutdown Handler
function DebugWindow.Shutdown()
  DebugWindow.history = TextEditBoxGetHistory("DebugWindowTextBox")
end


-- OnUpdate Handler
function DebugWindow.Update( timePassed )

    if (DebugWindow.lastMouseX ~= SystemData.MousePosition.x or DebugWindow.lastMouseY ~= SystemData.MousePosition.x) then
        local mousePoint = L""..SystemData.MousePosition.x..L", "..SystemData.MousePosition.y;
        LabelSetText ("DebugWindowMousePointText", mousePoint);

        DebugWindow.lastMouseX = SystemData.MousePosition.x;
        DebugWindow.lastMouseY = SystemData.MousePosition.y;
    end



    -- Update the MouseoverWindow
    if( DebugWindow.lastMouseOverWindow ~= SystemData.MouseOverWindow.name ) then
        LabelSetText( "DebugWindowMouseOverText", StringToWString(SystemData.MouseOverWindow.name) )
        DebugWindow.lastMouseOverWindow = SystemData.MouseOverWindow.name
    end


end


function DebugWindow.Hide()
    WindowSetShowing("DebugWindow", false )
    WindowSetShowing("DebugWindowOptions", false )
    if WindowGetShowing("BustedGUI") then
      WindowSetShowing("BustedGUI", false )
    end

end

function DebugWindow.ToggleLogging()

    DebugWindow.Settings.logsOn = not DebugWindow.Settings.logsOn

    if( DebugWindow.Settings.logsOn ) then
        DebugWindow.OnShowFocus()
        CHAT_DEBUG( L" UI Logging: ON" )
    else
        DebugWindow.OnShowFocus()
        CHAT_DEBUG( L" UI Logging: OFF" )
    end

    DebugWindow.UpdateLog()
  end


function DebugWindow.UpdateLog()

    TextLogSetIncrementalSaving( "UiLog", DebugWindow.Settings.logsOn, L"logs/uilog.log");
    TextLogSetEnabled( "UiLog", DebugWindow.Settings.logsOn )

    UpdateLoggingButton()

end

function DebugWindow.OnResizeBegin()
  WindowUtils.BeginResize( "DebugWindow", "topleft", 300, 200, nil)
end



--- Options Window

function DebugWindow.ToggleOptions()
    local showing = WindowGetShowing( "DebugWindowOptions" )
    WindowSetShowing("DebugWindowOptions", showing == false )
end

function DebugWindow.HideOptions()
    WindowSetShowing("DebugWindowOptions", false )
end

function DebugWindow.ClearTextLog()
    --DEBUG(L"Entered Clear text Log")

    -- Clear the UI log
    TextLogClear("UiLog")

    -- Options
    for filterType, filterData in pairs( DebugWindow.Settings.LogFilters )
    do
        LogDisplaySetFilterState( "DebugWindowText", "UiLog", filterType, filterData.enabled )

        -- When UI Log filters are off, disable logging of that filter type entirely.
        TextLogSetFilterEnabled( "UiLog", filterType, filterData.enabled  )
    end


    for index = 1, 2
    do
        ButtonSetStayDownFlag( "DebugWindowOptionsErrorOption"..index.."Button", true )
    end

    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption1Button", DebugWindow.Settings.useDevErrorHandling  )
    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption2Button", GetUseLuaErrorHandling() )
    ButtonSetPressedFlag( "DebugWindowOptionsLuaDebugLibraryButton", GetLoadLuaDebugLibrary() )

end

function DebugWindow.AddUiLog()
    LogDisplayAddLog("DebugWindowText", "UiLog", true)

        -- Options
    for filterType, filterData in pairs( DebugWindow.Settings.LogFilters )
    do
        LogDisplaySetFilterColor( "DebugWindowText", "UiLog", filterType, filterData.color.r, filterData.color.g, filterData.color.b )
    end

    UpdateLoggingButton()

end

function DebugWindow.UpdateDisplayFilter()

    local filterId = WindowGetId(SystemData.ActiveWindow.name)

    local enabled = not DebugWindow.Settings.LogFilters[filterId].enabled
    DebugWindow.Settings.LogFilters[filterId].enabled = enabled

    ButtonSetPressedFlag( "DebugWindowOptionsFilterType"..filterId.."Button", enabled )
    LogDisplaySetFilterState( "DebugWindowText", "UiLog", filterId, enabled )


    -- When UI Log filters are off, disable logging of that filter type entirely.
    TextLogSetFilterEnabled( "UiLog", filterId, enabled )

end

function DebugWindow.UpdateLuaErrorHandling()

    DebugWindow.Settings.useDevErrorHandling = not DebugWindow.Settings.useDevErrorHandling ;
    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption1Button", DebugWindow.Settings.useDevErrorHandling  )
end

function DebugWindow.UpdateCodeErrorHandling()
    local enabled = GetUseLuaErrorHandling()
    enabled = not enabled

    SetUseLuaErrorHandling( enabled )
    ButtonSetPressedFlag( "DebugWindowOptionsErrorOption2Button", enabled )
end

function DebugWindow.UpdateLoadLuaDebugLibrary()
    local enabled = GetLoadLuaDebugLibrary()
    enabled = not enabled

    SetLoadLuaDebugLibrary( enabled )
    ButtonSetPressedFlag( "DebugWindowOptionsLuaDebugLibraryButton", enabled )
end



-----------------CHAT HISTORY-----------------
function DebugWindow.AddInputHistory()
  table.insert(DebugWindow.history, text)
end


------------SCROLL TO BOTTOM----------------------
function DebugWindow.ScrollToBottom ()
    LogDisplayScrollToBottom ("DebugWindowText")
    WindowAssignFocus("DebugWindowTextBox", true)
end


function DebugWindow.ScJoin()
  pp("Attempting to join a scenario.")
  BroadcastEvent( SystemData.Events.SCENARIO_INSTANCE_JOIN_NOW )
end

function DebugWindow.ScGroup()
  if not WindowGetShowing("ScenarioGroupWindow") then
    pp("Displaying Scenario Groups Window.")
    WindowSetShowing("ScenarioGroupWindow", true)
  else
      pp("Hiding Scenario Groups Window.")
      WindowSetShowing("ScenarioGroupWindow", false)
  end
end

function DebugWindow.GuildID()
  pp("Your Guild ID is: "..tostring(GameData.Guild.m_GuildID))
end


function DebugWindow.CombatLog()
  local logOn = TextLogGetEnabled( "Combat")
  if logOn then
  pp("Disabling Combat log.")
  TextLogSetEnabled( "Combat", false)
  else
  pp("Enabling Combat log.")
  TextLogSetEnabled( "Combat", true)
  end
end



---------------------MAIN CHAT SEND-----------------
function DebugWindow.TextSend()
  text = towstring(TextEditBoxGetText(SystemData.ActiveWindow.name))
    if text == L"" then
      DebugWindow.TextSender()
    elseif text == L"h" then
      DebugWindow.TextSender()
      DebugWindow.help()
    elseif text == L"r" then
      InterfaceCore.ReloadUI()
    elseif text == L"f" then
      DebugWindow.TextSender()
      functionlist()
    elseif text == L"e" then
      DebugWindow.TextSender()
      DebugWindow.EventList()
    elseif text == L"s" then
      DebugWindow.TextSender()
      DebugWindow.Spy()
    elseif text == L"areainfo" then
      DebugWindow.TextSender()
      DebugWindow.GetAreaInfo()
    elseif text==L"abfind" then
      DebugWindow.TextSender()
      DebugWindow.AbilityFind()
    elseif text==L"mesh" then
      DebugWindow.TextSender()
      Mesh.Toggle()
    elseif text==L"scjoin" then
      DebugWindow.TextSender()
      DebugWindow.ScJoin()
    elseif text==L"scgroup" then
      DebugWindow.TextSender()
      DebugWindow.ScGroup()
    elseif text==L"guildid" then
      DebugWindow.TextSender()
      DebugWindow.GuildID()
    elseif text==L"keepid" then
      DebugWindow.TextSender()
      DebugWindow.KeepList()
    elseif text==L"fontlist" then
      DebugWindow.TextSender()
      DebugWindow.FontList()
    elseif text==L"changefont" then
      DebugWindow.TextSender()
      pp("Usage: changefont(\"font1\", \"font2\")\nChanges the name & title font respectively. (fontlist to print available fonts)")
    elseif text==L"clog" then
      DebugWindow.TextSender()
      DebugWindow.CombatLog()
    elseif text ~= nil then
      DebugWindow.TextSender()
      DebugWindow.ScriptSender()
  end
end

-------------AUTOSEND----------------
function DebugWindow.AutoSender()
  local text = towstring(TextEditBoxGetText("DebugWindowTextBox"))
  if text == L"ff" then
    DebugWindow.TextSender()
    DebugWindow.RegisteredList()
  elseif text == L"ror" then
    DebugWindow.TextSender()
    DebugWindow.ror()
  elseif text == L"ss" then
    DebugWindow.TextSender()
    DebugWindow.SpyStop()
  elseif text == L"spylist" then
    DebugWindow.TextSender()
    DebugWindow.SpyList()
  elseif text == L"devpad" then
    DebugWindow.TextSender()
    DevPadWindow.Toggle()
end
end



---------------------------------------------------------------------
----------------EVENT SPY--------------------


  function DebugWindow.OnShowFocus()
    local  visible = WindowGetShowing("DebugWindow") == true
    local  codevis=WindowGetShowing("DevPadWindowDevPadCode")==true
        if codevis==true and  visible==false then
          WindowAssignFocus("DevPadWindowDevPadCode", true)
        elseif visible==true then
        WindowAssignFocus( "DebugWindowTextBox", true ) end
      end

-----------REGISTER MAIN FUNCTION---------------
function DebugWindow.EventRegister()
  for k,v in pairs(DebugWindow.spyfilter) do
    _G["EventDebug_" .. k] = function(...)
      eve(k .. ": " .. DebugWindow.tableConcat({...}, ", ")) end
    end
end


-----------REGISTER EVENT SPY---------------
  function DebugWindow.RegisterHandleSpy()
        DebugWindow.EventRegister()
        if next(RegisteredEvents) == nil then
            for k,v in pairs(DebugWindow.spyfilter) do
              if k ~= "UPDATE_PROCESSED"  and k ~="PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
                RegisteredEvents[k]=v end
              end
            end
          end
--------------------CLEAR TABLE ON UNREGISTER--------------------

function DebugWindow.TableClear()
for k in pairs (RegisteredEvents) do
  RegisteredEvents[k] = nil
end
end

---------CHECK IF SPYING ON RELUI----------
function DebugWindow.SpyCheck()
if RegisteredEvents == nil then return end
if next(RegisteredEvents) ~= nil then
  for k,v in pairs(RegisteredEvents) do
      _G["EventDebug_" .. k] = function(...)
      eve(k .. ": " .. DebugWindow.tableConcat({...}, ", ")) end
    end
    end
        for k,v in pairs(RegisteredEvents) do
          RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
        end
end

-----------007 SPY -----------------
function DebugWindow.Spy()
  if next(RegisteredEvents) ~= nil then
    pp("You are already spying.") return
  end
    DebugWindow.RegisterHandleSpy()
    for k,v in pairs(DebugWindow.spyfilter) do
      if k ~= "UPDATE_PROCESSED"  and k ~="PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
        RegisteredEvents[k]=v end end
            for k,v in pairs(RegisteredEvents) do
              RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
            end
        pp(L"Starting Event Spy")
end

----------------007 SPYSTOP------------------
function DebugWindow.SpyStop()

    if next(RegisteredEvents) == nil then
            pp("You are not spying anything.")
      elseif RegisteredEvents ~= nil then
        for k,v in pairs(RegisteredEvents) do
              UnregisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
        end
        DebugWindow.TableClear()
        pp(L"Stopping Event Spy")
    end
end

----------ADD TO SPY-------
function spyadd(text)
local wasFound=false;

    for k,v in pairs(DebugWindow.spyfilter) do
        if string.find(k, text) then
          wasFound=true;
          if RegisteredEvents[k]==nil then
            RegisteredEvents[k]=v
            DebugWindow.RegisterHandleSpy()
            pp("Adding "..k.." to Event Spy.")
            RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
        elseif RegisteredEvents[k] ~=nil then
          pp("Already spying on "..k..".")
            end
          end
        end
        if not wasFound then
          pp("No matching events found.")
        end
end

----------REMOVE FROM EVENT SPY
function spyrem(text)
  for k,v in pairs (DebugWindow.spyfilter) do
    if string.find(k,text) then
      if RegisteredEvents[k] ==nil then pp("You are not spying on "..k.." currently.")
      end
    end
end
    for k,v in pairs(RegisteredEvents) do
        if string.find(k, text) then
          if RegisteredEvents[k]~=nil then
            pp("Removing "..k.." from Event Spy.")
            UnregisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
            RegisteredEvents[k]=nil
            end
          end
        end
end
-----LIST OF EVENTS SPIED UPON
function DebugWindow.SpyList()
if next(RegisteredEvents)==nil then
  pp("You are not spying anything.")
elseif next(RegisteredEvents) ~= nil then
  pp("Currently spying on:")
  p(RegisteredEvents)
end
end

---------------------------------
------EVENT LIST---------
function DebugWindow.EventList()
          p(SystemData.Events)
        end


-----------------------
-------------REGISTER ALL FUNCTIONS------------
function DebugWindow.RegisterFunctions()
  for k in pairs (DebugWindow.RegisteredFunctionList) do
      DebugWindow.RegisteredFunctionList[k] = nil
      end
        for i,v in pairs(_G) do
        if type(v) == "function" then
          DebugWindow.RegisteredFunctionList[i]=v
          end
         end
         table.sort(DebugWindow.RegisteredFunctionList)
    end

---------------------------------------------------------------------
------------- PRINT ALL REGISTERED FUINCTIONS---------------------

      function DebugWindow.RegisteredList()
        DebugWindow.RegisterFunctions()
          p(DebugWindow.RegisteredFunctionList)
      end

------------------------------SEND FROM TERMINAL-------------

function DebugWindow.ScriptSender(...)
  local emptytext=false;
  if text==nil or text==L" " or text==L"  " or text==L"    " then
     emptytext=true;
    else
      emptytext=false;
    end
    if not emptytext then
SendChatText(L"/script "..towstring(text), L"")
  end
end

function DebugWindow.TextSender()
  local text = towstring(TextEditBoxGetText("DebugWindowTextBox"))
  inp(text)
  DebugWindow.AddInputHistory()
  DebugWindow.ScrollToBottom ()
  TextEditBoxSetText(SystemData.ActiveWindow.name,L"")
end



-----------------------ON ESC BEHAVIOR TEXTBOX---------------------------------------
function DebugWindow.TextClear()
    local devpad=WindowGetShowing("DevPadWindow")==true
    local scrollcondition = LogDisplayIsScrolledToBottom ("DebugWindowText") == true
    local text = TextEditBoxGetText("DebugWindowTextBox")
    local texting=true;
    if (text == L"" and scrollcondition == true) then
        texting=false;
          if devpad==true then
            WindowAssignFocus("DevPadWindowDevPadCode", true)
          else
  	        DebugWindow.Hide()
          end
    end
      if texting then
          DebugWindow.ScrollToBottom ()
            if scrollcondition==true then
              TextEditBoxSetText(SystemData.ActiveWindow.name,L"")
            end
      end
  end
---------------------------------------------------------------------
---------on esc window behavior------------------------------
function DebugWindow.OnKeyEscape()
  if WindowGetShowing("DebugWindow") then
      WindowAssignFocus( "DebugWindowTextBox", true)
      DebugWindow.ScrollToBottom ()
    end
end
------------------------

---copy window
--get entries & filtername
function DebugWindow.GetEntries()
  entry={}
    local numEntries =TextLogGetNumEntries( "UiLog")
    for i=0, numEntries - 1 do
        local timestamp,filterId,text = TextLogGetEntry( "UiLog", i)
        if filterId==3 then
          filterId=L"[Error]: "
        elseif filterId==2 then
          filterId=L"[Warning]: "
        elseif filterId==4 then
          filterId=L"[Debug]: "
        elseif filterId==11 then
          filterId=L"[Event]: "
        elseif filterId==5 then
          filterId=L"[Function]: "
        end
        if filterId==9 or filterId==10 then
        table.insert(entry, text)
        else
        table.insert(entry, filterId..text)
        end
    end
   copyText = entry[1]
     for i = 2, #entry  do
        copyText = copyText..L"\n"..entry[i]
    end
    TextEditBoxSetTextColor("DevPadCopyLog",223,185,53)
    TextEditBoxSetText("DevPadCopyLog", copyText)
end

---prevent overwriting copy text
function DebugWindow.PreventType()
TextEditBoxSetText("DevPadCopyLog", copyText) return
end
--press tab to show copylog
function DebugWindow.OnKeyTab()
	 DebugWindow.CopyToggle()
 end
--show behavior
function DebugWindow.OnShowCopy()
  DebugWindow.GetEntries()
  WindowSetShowing("DevPadCopy", true)
  WindowSetShowing("DebugWindowText", false)
  ButtonSetText("DebugWindowToggleCopy", L"Terminal")
end
--hide behavior
function DebugWindow.OnHideCopy()
TextEditBoxSetText("DevPadCopyLog", L"")
WindowSetShowing("DevPadCopy", false)
WindowAssignFocus("DevPadCopyLog", false)
WindowSetShowing("DebugWindowText", true)
local showing=WindowGetShowing("DebugWindowTextBox")==true
if showing then
  WindowAssignFocus("DebugWindowTextBox", true)
end
ButtonSetText("DebugWindowToggleCopy", L"Copy")
entry=nil
end
---show/hide window toggle
function DebugWindow.CopyToggle()
  local showing = WindowGetShowing( "DevPadCopy" )
  if not showing then
    DebugWindow.OnShowCopy()
    WindowAssignFocus("DevPadCopyLog", true)
  else
    DebugWindow.OnHideCopy()
  end
end
------------------------

---------abfind

function DebugWindow.AbilityFind (regex, desc)
  local toomany=false;
  if regex=="" or regex==nil then pp("Usage: abfind(\"name\", desc)\ndesc is optional")
  else
	regex =tostring (regex)
	local max = 80
	local found = 0

	for id = 1, 100000
	do
		local ability_name = tostring (DebugWindow.FixStr(GetAbilityName (id)))

		if (ability_name:lower ():match (regex)) then
			found = found + 1

			if (found >= max)
			then
        toomany=true;
        pp(tostring(found).." abilities found")
				pp("Maximum number of results reached")
        --toomany=false;
				break
			end

			local str = "["..tostring (id).."] "..ability_name
			if (desc)=="desc"
			then
				local desc = tostring(GetAbilityDesc (id, 40))
				if (desc:len() > 1)
				then
					str = str.."\n ("..desc..")"
				end
			end


				pp(str)
		end

	end
  if not toomany then
	pp(tostring(found).." abilities found")
  end
  end
end


function DebugWindow.FixStr (str)

	if (str == nil) then return nil end

	local str = str
	local pos = str:find (L"^", 1, true)
	if (pos) then str = str:sub (1, pos - 1) end

	return str
end

function DebugWindow.GetAreaInfo()
  local AreaData = GetAreaData()
    if( AreaData ~= nil ) then

        for key, value in ipairs( AreaData ) do

            -- These should match the data that was retrived from war_interface::LuaGetAreaData

          --  AreaSpy.AreaListData[key] = {}

            local areaName        = tostring(value.areaName)

            local areaNumber    = value.areaNumber

            local areaID        = value.areaID

            local influenceID    = value.influenceID



            local tempText = ("Area: "..areaName.."\nNumber: "..areaNumber.."\nID: "..areaID.."\nInfluence ID: "..influenceID)


     pp(tempText)
end
end
end


--------------------print help--------------------------
function DebugWindow.help()
 local help = {[[

 ______________________________________
 \_____________________________________/

                           warTerminal v1.2
  _____________________________________
/______________________________________\

Available commands:

p() - Prints to the terminal.

f - Prints a list of all basic game functions.
ff - Prints a list of all currently registered functions.
e - Prints a list of all game events.

r - Reloads UI

clog - Toggles the Combat Log on or off.

logdump("name", objects) - Dumps the contents of specified objects to a .log file.

abfind("name", desc) - Prints a list of matching abilities with their description if specified.
areainfo - Displays information about the current area.

scjoin - Rejoin a SC/City after a crash or when the scenario-pop window disapeared.
scgroup - Displays Scenario Group window.

fontlist - Prints a list of all in-game available fonts.
changefont("font1", "font2") - Changes the name & title font respectively.

guildid - Displays the ID of your Guild.
keepid - Prints a list of keep IDs.

hw"windowName" - Highlights where a specified window is being drawn even if not currently visible.
(Not compatible with NoUselessMods-HelpTips)
mesh(size) - Creates an on-screen grid for easy layout arrangement/measurements.
(16/256 - intervals of 16)

ror - List of RoR server commands

Event Spy
s - Start on-the-fly event spying.
(UPDATE_PROCESSED, RVR_REWARD_POOLS_UPDATED and PLAYER_POSITION_UPDATED are not added by default)
ss - Stop on-the-fly event spying.
spylist - Prints a list of events being spied upon currently.
spyadd"text" - Looks for partial matches and adds an event to Event Spy.
spyrem"text" - Looks for partial matches and removes an event from Event Spy.

Captain Hook
hook(func) - Hooks a function and spies on it's parameters.
unhook(func) - Unhooks a function from spying.
]]
    }

    for k,v in pairs(help) do
           pp(v)
            end
end


----------------------------------------------------------------------------------------------------------print ror functions----------------

function DebugWindow.ror()
  local ror = {[[

AVAILABLE ROR SERVER COMMANDS
===================================
RANKED: Ranked commands.
READYCHECK: Ready check commands.
RESPEC: Respecialization commands.
SPEC: Respecialization commands.
CHANGENAME: Requests a name change, one per account per month
GMLIST: Lists available GMs.
RULES: Sends a condensed list of in-game rules.
ASSIST: Switches to friendly target's target
UNLOCK: Used to fix stuck-in-combat problems preventing you from joining a scenario.
TELLBLOCK: Allows you to block whispers from non-staff players who are outside of your guild.
GETSTATS: Shows your own linear stat bonuses.
STANDARD: Assigns Standard Bearer Titel to the Player.
ROR: Help Files for RoR-specific features.
LANGUAGE: Change the language of data.
TOKFIX: Checks if player have all ToKs and fixes if needed
RVRSTATUS: Displays current status of RvR.
PUG: Displays current PUG scenario.
SURRENDER: Starts surrender vote in scenario.
YES: Vote YES durring scenario surrender vote.
NO: Vote NO durring scenario surrender vote.
SORENABLE: Enables SoR addon.
SORDISABLE: Disables SoR addon.
MMRENABLE: Enables MMR addon.
GUILDINVOLVE: Allows you to involve your guild with RvR campaign.
GUILDCHANGENAME: Change guild name, costs 1000 gold
CLAIMKEEP: Allows you to claim keep for your guild in RvR campaign.
APPRENTICE: Allows you to claim keep for your guild in RvR campaign.
LOCKOUTS: Displays lockouts of player and his party.
BAGBONUS: Displays accumulated bonuses for RvR bags.
ALERT: Sends an alert to the player specified using channel 9(string playerName string message). Used for Addons.
RANKEDSCSTATUS: Shows player count of the ranked solo scenario queue.
UISCSTATUS: Shows player count of the ranked solo scenario queue for the UI.
UISERVER: Sends user interface server settings.
GROUPSCOREBOARDRESET: Reset Group Scoreboard
GROUPCHALLENGE: Challenge another group to a scenario
===================================
  ]]}

  for k,v in pairs(ror) do
         pp(v)
          end
end


function DebugWindow.KeepList()
  local keeplist ={[[

Dok Karaz - ID: 1
Fangbreaka Swamp - ID: 2
Gnol Baraz - ID: 3
Thickmuck Pit -  ID: 4
Karaz Drengi - ID: 5
Kazad Dammaz - ID: 6
Bloodfist Rock - ID: 7
Karak Karag - ID: 8
Ironskin Skar - ID: 9
Badmoon Hole - ID: 10
Mandred's Hold - ID: 11
Stonetroll Keep - ID: 12
Passwatch Castle - ID: 13
Stoneclaw Castle - ID: 14
Wilhelm's Fist - ID: 15
Morr's Repose - ID: 16
Southern Garrison - ID: 17
Garrison of Skulls - ID: 18
Zimmeron's Hold - ID: 19
Charon's Keep - ID: 20
Cascades of Thunder - ID: 21
Spite's Reach - ID: 22
The Well of Qhaysh - ID: 23
Ghrond's Sacristy - ID: 24
Arbor of Light - ID: 25
Pillars of Remembrance - ID: 26
Covenant of Flame - ID: 27
Drakebreaker's Scourge - ID: 28
Hatred's Way - ID: 29
Wrath's Resolve - ID: 30
  ]]}
  for k,v in pairs(keeplist) do
         pp(v)
          end
end


function DebugWindow.FontList()
  local fontlist={[[

"font_heading_default"
"font_heading_medium"
"font_heading_large"
"font_heading_huge"
"font_heading_medium_noshadow"
"font_heading_large_noshadow"
"font_heading_big_noshadow"
"font_heading_huge_noshadow"
"font_journal_body"
"font_journal_text"
"font_journal_body_large"
"font_journal_text_large"
"font_journal_text_huge"
"font_journal_text_italic"
"font_journal_sub_heading"
"font_journal_heading"
"font_journal_heading_smaller"
"font_journal_small_heading"
"font_default_heading"
"font_default_medium_heading"
"font_default_sub_heading"
"font_default_sub_heading_no_outline"
"font_default_war_heading"
"font_default_text"
"font_default_text_no_outline"
"font_default_text_small"
"font_default_text_large"
"font_default_text_huge"
"font_default_text_giant"
"font_chat_text"
"font_chat_text_no_outline"
"font_chat_text_bold"
"font_clear_default"
"font_clear_tiny"
"font_clear_small"
"font_clear_medium"
"font_clear_large"
"font_clear_small_bold"
"font_clear_medium_bold"
"font_clear_large_bold"
"font_default_text_gigantic"
"font_heading_default_no_shadow"
"font_heading_zone_name_no_shadow"
"font_heading_tiny_no_shadow"
"font_heading_20pt_no_shadow"
"font_heading_22pt_no_shadow"
"font_heading_small_no_shadow"
"font_heading_huge_no_shadow"
"font_heading_rank"
"font_heading_target_mouseover_name"
"font_heading_unitframe_large_name"
"font_heading_unitframe_con"
"font_alert_outline_tiny"
"font_alert_outline_small"
"font_alert_outline_medium"
"font_alert_outline_large"
"font_alert_outline_huge"
"font_alert_outline_giant"
"font_alert_outline_gigantic"
"font_alert_outline_half_tiny"
"font_alert_outline_half_small"
"font_alert_outline_half_medium"
"font_alert_outline_half_large"
"font_alert_outline_half_huge"
"font_alert_outline_half_giant"
"font_alert_outline_half_gigantic"
"font_guild_MP_R_17"
"font_guild_MP_R_19"
"font_guild_MP_R_23"
"font_name_plate_titles_old"
"font_name_plate_names_old"
"font_name_plate_titles"
"font_name_plate_names"
"font_title_window_game_rating_text"
"font_chat_window_game_rating_text"
]]}

  for k,v in pairs(fontlist) do
    pp(v)
  end
end




--------------TABLE CONCAT CHANGES TO PRINT EVENTS CORRECTLY -----------------



do
   local orig_table_concat = table.concat

   -- Define new function "table.concat" which overrides standard one
   function DebugWindow.tableConcat(list, sep, i, j, ...)
      -- Usual parameters are followed by a list of value converters
      local first_conv_idx, converters, t = 4, {sep, i, j, ...}, {}
      local conv_types = {
         ['function'] = function(cnv, val) return cnv(val)        end,
         table        = function(cnv, val) return cnv[val] or val end
      }
      if conv_types[type(sep)]   then first_conv_idx, sep, i, j = 1
      elseif conv_types[type(i)] then first_conv_idx,      i, j = 2
      elseif conv_types[type(j)] then first_conv_idx,         j = 3
      end
      sep, i, j = sep or '', i or 1, j or #list
      for k = i, j do
         local v, idx = list[k], first_conv_idx
         while conv_types[type(converters[idx])] do
            v = conv_types[type(converters[idx])](converters[idx], v)
            idx = idx + 1
         end
         t[k] = tostring(v) -- 'tostring' is always the final converter
      end
      return orig_table_concat(t, sep, i, j)
   end
end
