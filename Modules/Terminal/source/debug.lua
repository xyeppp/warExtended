----------------------------------------------------------------
-- Debugging Assistance Variables
----------------------------------------------------------------
local dump=false;

TextLogAddFilterType ("UiLog", 11, L"[Event]:")

--------------------------------------
function CHAT_DEBUG( text )
    TextLogAddEntry( "Chat", 100, text )
end

function DEBUG( text )
    LogLuaMessage( "Lua", SystemData.UiLogFilters.DEBUG, text )
end

--------- PRINTING TO TERMINAL
function PRINT( text )
  if not dump then
    TextLogAddEntry( "UiLog", 10, text )
  elseif dump then
    TextLogAddEntry( DevPad_Settings.Logdump, 1, (text))
  end
end
--------------------------------
---------- inp() HANDLE---- ----
function INPUT( text )
  TextLogAddEntry( "UiLog", 9, text )
end

--------------------- eve() handle--------------------
function EVENT( text )
 TextLogAddSingleByteEntry( "UiLog", 11, text )
end
------------------------------------------------


--------------------------

function ERROR( text )
    if( DebugWindow.Settings.useDevErrorHandling == true ) then
        local strTxt = WStringToString( text )
        error(strTxt, 3)
    else
        LogLuaMessage( "Lua", SystemData.UiLogFilters.ERROR, text )
    end
end

function ERROR_TRACE( text )
    SHOW_STACK_TRACE( 3 )
    ERROR( text )
end

function DUMP_TABLE (t, indent, tableHistory)

    DUMP_TABLE_TO( t, DEBUG, indent, tableHistory )

end

------------------ TABLE DUMP TO PRINT
function PRINT_TABLE (t, indent, tableHistory)
   PRINT_TABLE_TO (t, PRINT, indent, tableHistory)
end
----------------------------------------------

-- Outputs the table contents to a function that takes a string as a parameter.
--   calls this function once per line.
function DUMP_TABLE_TO( t, printFunction, indent, tableHistory )

    if ( printFunction == nil)
    then
        DEBUG(L" Error in: DUMP_TABLE_TO(table, printFunctions), function for output is nil")
        return
    end

    if (t == nil)
    then
        -- Don't ERROR out on this, it stops your script execution...not so desirable for debugging.
        printFunction (L" Error in: DUMP_TABLE_TO(table), table param is nil")
        return;
    end

    if (type (t) ~= "table")
    then
        -- Don't ERROR out on this, it stops your script execution...not so desirable for debugging.
        printFunction (L" Error in: DUMP_TABLE_TO(table), table param is not a table, type="..towstring(type(t)))
        return;
    end

    tableHistory = tableHistory or {}

    if (indent == nil or (type (indent) ~= "wstring"))
    then
        indent = L"";
    end

    for k, v in pairs (t)
    do
        local valueType = towstring (type (v))
        local keyName   = towstring (tostring (k))
        local value     = towstring (tostring (v))

        printFunction (indent..L"("..valueType..L") "..keyName..L" = "..value)

        if type (v) == "table"
        then
            if (tableHistory[v] == nil)
            then
                tableHistory[v] = true
                DUMP_TABLE_TO (v, printFunction, indent..L"   ", tableHistory)
            else
                printFunction (indent..L"Preventing cycle on table ["..value..L"]")
            end
        end
    end

    printFunction (indent..L"end")

end
---------------- DUMP TABLE COPY TO PRINT
function PRINT_TABLE_TO( t, printFunction, indent, tableHistory )

    if ( printFunction == nil)
    then
        PRINT(L" Error in: PRINT_TABLE_TO(table, printFunctions), function for output is nil")
        return
    end

    if (t == nil)
    then
        -- Don't ERROR out on this, it stops your script execution...not so desirable for debugging.
        printFunction (L" Error in: PRINT_TABLE_TO(table), table param is nil")
        return;
    end

    if (type (t) ~= "table")
    then
        -- Don't ERROR out on this, it stops your script execution...not so desirable for debugging.
        printFunction (L" Error in: PRINT_TABLE_TO(table), table param is not a table, type="..towstring(type(t)))
        return;
    end

    tableHistory = tableHistory or {}

    if (indent == nil or (type (indent) ~= "wstring"))
    then
        indent = L"";
    end

    for k, v in pairs (t)
    do
        local valueType = towstring (type (v))
        local keyName   = towstring (tostring (k))
        local value     = towstring (tostring (v))

        printFunction (indent..L"("..valueType..L") "..keyName..L" = "..value)

        if type (v) == "table"
        then
            if (tableHistory[v] == nil)
            then
                tableHistory[v] = true
                PRINT_TABLE_TO(v, printFunction, indent..L"   ", tableHistory)
            else
                printFunction(indent..L"Preventing cycle on table ["..value..L"]")
            end
        end
    end

    printFunction (indent..L"end")

end
--------------------------------------------------------------------------

-- alias ftw!
dt = DUMP_TABLE;
pt = PRINT_TABLE;
inp = INPUT;
-- do you ever get sick of typing DEBUG (L""...), I know I do...
function d (...)
    for msgIndex, message in ipairs (arg)
    do
        if (message == nil)
        then
            DEBUG (L"Please don't pass nil as an argument to the debug log.")
        else
            local messageType = type (message)

            if (messageType == "number")
            then
                DEBUG (L""..message)
            elseif (messageType == "string")
            then
                DEBUG (towstring (message))
            elseif (messageType == "table")
            then
                dt (message)
            elseif (messageType == "boolean")
            then
                DEBUG (towstring (booltostring (message)))
            else
                DEBUG (message)
            end
        end
    end
end
---------------------------- PRINT MESSAGES TO TERMINAL--------------
function pp (...)
    for msgIndex, message in ipairs (arg)
    do
        if (message == nil)
        then
            PRINT (L"Please don't pass nil as an argument into the terminal.")
        else
            local messageType = type (message)

            if (messageType == "number")
            then
                PRINT (L""..message)
            elseif (messageType == "string")
            then
                PRINT (towstring (message))
            elseif (messageType == "table")
            then
                pt (message)
            elseif (messageType == "boolean")
            then
                PRINT (towstring (booltostring (message)))
            else
                PRINT (message)
            end
        end
    end
end
--------------------------------------------------------------------------
function booltostring (bool)
    if (bool == nil)
    then
        return "nil"
    end

    if (bool == true)
    then
        return "true"
    end

    return "false"
end



---------------- PRETTY PRINT FUNCTIONS ---------------------------------



local function print(text)
    pp(text)
end

local function mysort(alpha, bravo)
    if type(alpha) ~= type(bravo) then
        return type(alpha) < type(bravo)
    end
    if alpha == bravo then
        return false
    end
    if type(alpha) == "string" or type(alpha) == "wstring" then
        return alpha:lower() < bravo:lower()
    end
    if type(alpha) == "number" then
        return alpha < bravo
    end
    return false
end

local recursions = {}
local function better_toString(data, depth)
    if type(data) == "string" then
        return ("%q"):format(data)
    elseif type(data) == "wstring" then
        return ("L%q"):format(WStringToString(data))
    elseif type(data) ~= "table" then
        return ("%s"):format(tostring(data))
    else
        if recursions[data] then
            return "{<recursive table>}"
        end
        recursions[data] = true
        if next(data) == nil then
            return "{}"
        elseif next(data, next(data)) == nil then
            return "{ [" .. better_toString(next(data), depth) .. "] = " .. better_toString(select(2, next(data)), depth) .. " }"
        else
            local t = {}
            t[#t+1] = "{\n"
            local keys = {}
            for k in pairs(data) do
                keys[#keys+1] = k
            end
            table.sort(keys, mysort)
            for _, k in ipairs(keys) do
                local v = data[k]
                for i = 1, depth do
                    t[#t+1] = "    "
                end
                t[#t+1] = "["
                t[#t+1] = better_toString(k, depth+1)
                t[#t+1] = "] = "
                t[#t+1] = better_toString(v, depth+1)
                t[#t+1] = ",\n"
            end

            for i = 1, depth do
                t[#t+1] = "    "
            end
            t[#t+1] = "}"
            return table.concat(t)
        end
    end
end


-------------------------------------------------------------------


-----------------PRETTY PRINT----------------------------
function p(...)
  local text = (...)
    local n = select('#', ...)
    local t = {}
    for i = 1, n do
        if i > 1 then
            t[#t+1] = ", "
        end
        t[#t+1] = better_toString((select(i, ...)), 0)
    end
    for k in pairs(recursions) do
        recursions[k] = nil
    end
      if (text == nil) then
        pp("nil")
      elseif (text ~= nil) then
        print(table.concat(t))
        return p
  end
end


--------------------event print----------------------------------------

function eve(...)
  local text = (...)
    local n = select('#', ...)
    local t = {}
    for i = 1, n do
        if i > 1 then
            t[#t+1] = ", "
        end
        t[#t+1] = better_toString((select(i, ...)), 0)
    end
    for k in pairs(recursions) do
        recursions[k] = nil
    end
          EVENT(DebugWindow.tableConcat(t))
end




function SIMPLE_STACK_TRACE ()
    if (debug and debug.traceback)
    then
        DEBUG (towstring (debug.traceback ()));
    else
        DEBUG (L"ERROR: Attempting to display stack trace without loading the debug library.")
    end
end

function SHOW_STACK_TRACE( startLevel )

    if( debug == nil ) then
        return
    end

    if( debug.getinfo == nil ) then
        DEBUG( L" SHOW_STACK_TRACE - Lua Debug Library is not loaded. ")
        return
    end

    local traceLines = {}
    local numLines = 0

    -- Determine the stack trace lines
    local level = 2 -- Skip Level 1 because we dont' want to display the SHOW_STACK_TRACE() funcion call
    if( startLevel ~= nil ) then
        level = startLevel
    end
    while true do
        local info = debug.getinfo(level, "Sln")
        if not info then break end

        local text = L""

        -- Exposed C Functions
        if info.what == "C" then
            local name = info.name;
            if( name == nil ) then
                name =  "NAME_NOT_FOUND"
            end
            text = L""..StringToWString(name)..L": C-Function"

        -- Lua Function
        elseif  info.what == "Lua" then
            local name = info.name;
            if( name == nil ) then
                name =  "NAME_NOT_FOUND"
            end
            local strText = string.format("%s(...) - %s:%d", name, info.short_src, info.currentline)
            text = StringToWString( strText )

        -- Main lua chunk ( On Loading the file )
        else
            local name = info.name;
            if( name == nil ) then
                name =  "NAME_NOT_FOUND"
            end
            local strText = string.format("Loading File %s:%d", name, info.short_src, info.currentline)
            text = StringToWString( strText )

        end

        numLines = numLines + 1
        traceLines[numLines] = text

        level = level + 1
    end

    -- Print the formatted stack trace to debug.

    DEBUG( L" ------- ")
    for index = 1, numLines do
        local line = numLines - index
        DEBUG(L""..line..L" - "..traceLines[index] )
    end
    DEBUG( L" ------- ")
end

function TRACE (event, line)
    local info = debug.getinfo(2)
    if info.short_src ~= nil then
        local string = towstring( string.format( "[%s]:%d", info.short_src, info.currentline ) )
        LogLuaMessage( "Lua", SystemData.UiLogFilters.FUNCTION, string )
    end
end

function START_FUNCTION(event, line)
    local info = debug.getinfo(2)
    local s = info.short_src
    if info.name ~=nil then
        local string = towstring("Entering function: "..s.."."..info.name)
        LogLuaMessage( "Lua", SystemData.UiLogFilters.FUNCTION, string )
    else
    if s ~= nil then
        local string = towstring("Entering unknown function: "..s)
        LogLuaMessage( "Lua", SystemData.UiLogFilters.FUNCTION, string )
    end
  end
end

function END_FUNCTION(event, line)
    local info = debug.getinfo(2)
    local s = info.short_src
    if info.name ~=nil then
        local string = towstring("Exiting function: "..s.."."..info.name)
        LogLuaMessage( "Lua", SystemData.UiLogFilters.FUNCTION, string )
    else
        if s ~= nil then
            local string = towstring("Exiting unknown function: "..s)
            LogLuaMessage( "Lua", SystemData.UiLogFilters.FUNCTION, string )
        end
    end
end

function ENABLE_TRACE( value )
    if ( value == 0 ) then
        debug.sethook(TRACE, "")
        debug.sethook(END_FUNCTION, "")
        debug.sethook(START_FUNCTION, "")
    else
        debug.sethook(TRACE, "l")
        debug.sethook(END_FUNCTION, "r")
        debug.sethook(START_FUNCTION, "c")
    end
end




---------------------------------------------------------------------
----------------------window highglihter-----------------

function hw(text)
  local showing = WindowGetShowing(HelpTips.FOCUS_WINDOW_NAME)
  if string.match ("", text) and showing == true then
      WindowSetShowing( HelpTips.FOCUS_WINDOW_NAME, false )
      pp("Stopping window highlight.")
    elseif string.match ("", text) and showing == false then
      WindowSetShowing( HelpTips.FOCUS_WINDOW_NAME, false )
      pp("Window name cannot be empty!")
    elseif (showing == true and text == nil) then
        WindowSetShowing( HelpTips.FOCUS_WINDOW_NAME, false )
        pp(L"Stopping window highlight.")
    elseif text == nil then
        pp(L"You must specify a window to highlight! (Use quotation marks)")
    else
        if (WindowGetShowing((text)) == true) then
          HelpTips.SetFocusOnWindow((text))
          pp(L"Highlighting window "..towstring(text))
    else
          WindowSetShowing( HelpTips.FOCUS_WINDOW_NAME, false )
        end
    end
end


--------------------------------LOGDUMP------------------------------------
function logdump(name, ...)
 local testing=false;
      if name==nil or (...)==nil then testing=true;
        else testing=false
      end
      if testing then pp("Usage: logdump(\"logname\", arguments)")
     else
	      dump=true;
        DevPad_Settings.Logdump=name
  	    TextLogCreate(tostring(name),50000)
	      TextLogSetIncrementalSaving(name, true, StringToWString("logs/"..name..".log"))
		    p(...)
			  dump=false;
        pp("\""..name.."\" saved to logs/"..name..".log")
      end
		end





---------------------------------------------------------------------
--------------BASIC GAME FUNCTION LIST-----------------------

local registeredfunctionlist = {}
   for i,v in pairs(_G) do
        if type(v) == "function" then
            registeredfunctionlist[i]=v
         end
           table.sort(registeredfunctionlist)
end

---------------------------------------------------------------------
----------------PRINT FUNCTIONS TO WINDOW ------------------------
function functionlist()
        p(registeredfunctionlist)
        end

---------------------------------------------------------------------




-- Hook assert so that it "compiles" to nothing when the debug library isn't loaded.
-- And when the debug library is loaded, assert will also display a simple stack trace.
if (GetLoadLuaDebugLibrary ())
then
    luaAssert = assert
    if condition == nil then condition = false end
    function assert (condition)
        if (not condition)
        then
            SIMPLE_STACK_TRACE ()
            luaAssert (condition)
        end
    end
else
    function assert () end
end


--ENABLE_TRACE( 1 )
