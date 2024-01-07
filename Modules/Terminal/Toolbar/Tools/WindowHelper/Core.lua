local warExtendedTerminal = warExtendedTerminal

local settings = {
  ["outputType"]          = "xml",    -- either "xml" or "singletable" or "multitable"
  ["parentReplacement"]   = true,     -- Whether or not the output string uses parent replacement, not used if outputType == "table"
}

local function GetAnchorAsXMLWideString (anchor, anchoredWindowName, performParentReplacement)
  local relativeTo = anchor.RelativeTo
  
  if (performParentReplacement)
  then
    relativeTo, _ = string.gsub (relativeTo, "^"..WindowGetParent (anchoredWindowName), "$parent")
  end
  
  local anchorString = "    <Anchor point=\""..anchor.Point.."\" relativePoint=\""..anchor.RelativePoint.."\" relativeTo=\""..relativeTo.."\"><BR>        <AbsPoint x=\""..anchor.XOffset.."\" y=\""..anchor.YOffset.."\" /><BR>    </Anchor>"
  return towstring (anchorString)
end

local function GetAnchorAsSingleLineTable (anchor)
  return towstring ("{ Point = \""..anchor.Point.."\", RelativePoint = \""..anchor.RelativePoint.."\", RelativeTo = \""..anchor.RelativeTo.."\", XOffset = "..anchor.XOffset..", YOffset = "..anchor.YOffset.." }")
end

local function GetAnchorAsMultiLineTable (anchor)
  return towstring ("{<BR>    Point           = \""..anchor.Point.."\",<BR>    RelativePoint   = \""..anchor.RelativePoint.."\",<BR>    RelativeTo      = \""..anchor.RelativeTo.."\",<BR>    XOffset         = "..anchor.XOffset..",<BR>    YOffset         = "..anchor.YOffset.."<BR>}")
end

local anchorFunctions =
{
  ["xml"]             = GetAnchorAsXMLWideString,
  ["singletable"]     = GetAnchorAsSingleLineTable,
  ["multitable"]      = GetAnchorAsMultiLineTable
}

local TerminalToolbar  = TerminalToolbar
local WINDOW_NAME      = "Yaaar"
local TOOL_NAME        = L"Window Helper"
local TOOL_DESCRIPTION = L"Set up window anchors."
local TOOL_ICON        = 70000

TerminalWindowHelper     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, settings)

--[[unction warExtendedTerminal.WindowHelperOnInitialize()
  warExtendedTerminal:RegisterToolbarItem(L"Window Helper", L"Displays all the area IDs, area names, and influence IDs that the player is in", "Yaaar", 70000, settings)
end]]

