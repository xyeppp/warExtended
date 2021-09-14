warExtendedCursor = warExtended.Register("warExtended Curs")
local Kursor = warExtendedCursor
local MOUSEOVER_TARGET = "mouseovertarget"


Kursor.Settings = {

  Ping = {
    Message = "",
    Channel = ""
  },

  isEnemyEnabled = "",
  EnemyMarkNumber = ""
}


local function getPingMessage()
  local message = Kursor.Settings.Ping.Message
  local channel = Kursor.Settings.Ping.Channel
  return message, channel
end


local function setEnemyTargetCache()
  if not Enemy.latestTarget then
    Enemy.latestTarget={}
  end

  Enemy.latestTarget.id=TargetInfo:UnitEntityId(MOUSEOVER_TARGET)
  Enemy.latestTarget.name=TargetInfo:UnitName(MOUSEOVER_TARGET)
  Enemy.latestTarget.isNpc=false;
  Enemy.latestTarget.isFriendly=TargetInfo:UnitIsFriendly(MOUSEOVER_TARGET)
  Enemy.latestTarget.career=TargetInfo:UnitCareer(MOUSEOVER_TARGET)
end


local flagActions = {

  CursorRButtonUp = {

    isCtrlShiftPressed = function ()
      local _, _, isMouseoverTarget = Kursor:GetTargetNames()
      if isMouseoverTarget then
        Kursor:Send(getPingMessage())
      end
    end,

    isCtrlAltPressed = function()
      local isEnemyEnabled = Kursor.Settings.isEnemyEnabled
      local _, _, isMouseoverTarget = Kursor:GetTargetNames()

      if isMouseoverTarget and isEnemyEnabled then
        local enemyMarkNumber = Kursor.Settings.EnemyMarkNumber
        setEnemyTargetCache()
        Enemy.MarksToggle(enemyMarkNumber)
      end

    end,

    isCtrlAltShiftPressed = function()
      local _, _, isMouseoverTarget = Kursor:GetTargetNames()
      if isMouseoverTarget then
        PlayerMenuWindow.ShowMenu(isMouseoverTarget, TargetInfo:UnitEntityId( MOUSEOVER_TARGET ))
      end
    end
  },

}


local function kursorOnRButtonDown(flags)
  local isRootWindow = SystemData.MouseOverWindow.name=="Root"

  if isRootWindow then
    Kursor:GetFunctionFromFlag(flags, "CursorRButtonUp")
    return
  end
end


local function setPingTextAndChannel(pingText, pingChannel)

  if not pingText or not pingChannel then
    Kursor:Print("Parameters: pingText#pingChannel")
    return
  end

  pingChannel = Kursor:FormatChannel(pingChannel)
  Kursor.Settings.Ping.Message = pingText
  Kursor.Settings.Ping.Channel = pingChannel
  Kursor:Print("Cursor ping set to: "..pingText.." Channel: "..pingChannel)
end



local function setEnemyMark(enemyMarkNumber)
  local isNumber = enemyMarkNumber:match("%d")
  local isNil = enemyMarkNumber == ""

  if not isNumber or isNil then
    Kursor:Print("Parameters: enemyMarkNumber")
    return
  end

  enemyMarkNumber = tonumber(enemyMarkNumber)
  Kursor:Print("Cursor enemy mark set to: "..enemyMarkNumber)
  Kursor.Settings.EnemyMarkNumber = enemyMarkNumber
end


local slashCommands = {
  cping = {

    func = function (pingText, pingChannel)
      setPingTextAndChannel(pingText, pingChannel)
    end,
    desc = "Set ping message & channel: pingText#pingChannel"
  },

  cmark = {
    func = function (enemyMarkNumber)
      setEnemyMark(enemyMarkNumber)
    end,
    desc = "Set enemy mark number to use: enemyMarkNumber"
  }
}

local function getEnemyAddonEnabledInfo()
  Kursor.Settings.isEnemyEnabled = Kursor:IsAddonEnabled("Enemy")
end

function Kursor.OnInitialize()
  getEnemyAddonEnabledInfo()
  Kursor:RegisterFlags(flagActions)
  Kursor:RegisterSlash(slashCommands, "warext")
  Kursor:Hook(Cursor.OnRButtonDownProcessed, kursorOnRButtonDown)
end
