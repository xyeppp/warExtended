local function EnemyChanger()
  if not Enemy.latestTarget then
	Enemy.latestTarget={}
  end
  Enemy.latestTarget.id=TargetInfo:UnitEntityId("mouseovertarget")
  Enemy.latestTarget.name=TargetInfo:UnitName("mouseovertarget")
  Enemy.latestTarget.isNpc=false;
  Enemy.latestTarget.isFriendly=TargetInfo:UnitIsFriendly("mouseovertarget")
  Enemy.latestTarget.career=TargetInfo:UnitCareer("mouseovertarget")
end

function QuickNameActionsRessurected.newCursorOnRButtonDownProcessed(flags)
  if SystemData.MouseOverWindow.name=="Root" then
    if( flags == SystemData.ButtonFlags.CONTROL) then
      if TargetInfo:UnitName("mouseovertarget") ~= L"" then
        TargetInfo:UpdateFromClient()
        ChatMacro(QuickNameActionsRessurected.Settings.PingMessage, QuickNameActionsRessurected.Settings.PingChannel)
      end
    elseif flags == SystemData.ButtonFlags.ALT then
      if enemyMod then
        if TargetInfo:UnitName("mouseovertarget") ~= L"" then
          EnemyChanger()
          --  oldCursorOnRButtonDownProcessed()
          Enemy.MarksToggle(QuickNameActionsRessurected.Settings.MarkToggle)
        end
      end
    elseif flags== SystemData.ButtonFlags.SHIFT then
      p("shift")
      local target=TargetInfo:UnitName("mouseovertarget")
      if TargetInfo:UnitName("mouseovertarget") ~= L"" and TargetInfo:UnitIsNPC("mouseovertarget") == false then
        PlayerMenuWindow.ShowMenu(target)

      end
    end
  end
  oldCursorOnRButtonDownProcessed()
end

function QuickNameActionsRessurected.SetPing(input)
  input=towstring(input)
  local regex = wstring.match(towstring(input), L"\^\%s")
  local qnaSplit = StringSplit(tostring(input), "#")
  local input = towstring(qnaSplit[1])
  local messageNumber = towstring(qnaSplit[2])

  if input == L"" or input == nil or regex or not qnaSplit[2] then
    EA_ChatWindow.Print(link..L"Current ping message is: "..towstring(QuickNameActionsRessurected.Settings.PingMessage))
    EA_ChatWindow.Print(link..L"/qnahelp for all available message $functions")
    EA_ChatWindow.Print(link..L"Example usage: /qnaping Target Info: $mt $mlvl $mhp $mcr#channel")
  else
    QuickNameActionsRessurected.Settings.PingMessage=qnaSplit[1]
    QuickNameActionsRessurected.Settings.PingChannel=qnaSplit[2]
    EA_ChatWindow.Print(link..L"Ping message set to: "..towstring(QuickNameActionsRessurected.Settings.PingMessage))
    EA_ChatWindow.Print(link..L"Ping channel set to: "..towstring(QuickNameActionsRessurected.Settings.PingChannel))
    --  end
  end
end

function QuickNameActionsRessurected.SetMark(input)
  input=towstring(input)
  local regex = wstring.match(towstring(input), L"\^\%s")
  local number = wstring.match(towstring(input), L"(%d+)")

  if input == L"" or input == nil or regex or not number then
    EA_ChatWindow.Print(link..L"Current mark used: "..towstring(QuickNameActionsRessurected.Settings.MarkToggle))
    EA_ChatWindow.Print(link..L"/qnamark number to set a new marker.")
  else
    QuickNameActionsRessurected.Settings.MarkToggle=tonumber(input)
    EA_ChatWindow.Print(link..L"Mark used set to: "..towstring(QuickNameActionsRessurected.Settings.MarkToggle))
  end
end