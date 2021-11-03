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

local function setPlayerMenuWindowData(targetName)
  local targetId = TargetInfo:UnitEntityId(MOUSEOVER_TARGET)
  PlayerMenuWindow.curPlayer.name = targetName
  PlayerMenuWindow.curPlayer.objNum = targetId
end

local function isPlayerName(targetName)
  local playerName = GameData.Player.name
  local isPlayerName = playerName == targetName
  return isPlayerName
end

local function isAllyTarget(targetType)
  local allyTargetType = SystemData.TargetObjectType.ALLY_PLAYER
  local isAllyTarget = allyTargetType == targetType
  return isAllyTarget
end

local function showPlayerMenu(targetName)
   local targetType = TargetInfo:UnitType (MOUSEOVER_TARGET);
   local targetId = TargetInfo:UnitEntityId(MOUSEOVER_TARGET)

  if not isPlayerName(targetName) and isAllyTarget(targetType) then
      PlayerMenuWindow.ShowMenu(targetName, targetId)
    end
end

local flagActions = {

  CursorRButtonDown = {


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
      local _, _, mouseoverTarget = Kursor:GetTargetNames()
       if mouseoverTarget then
         showPlayerMenu(mouseoverTarget)
       end
    end
  },

}


local function kursorOnRButtonDown(flags)
  local isRootWindow = SystemData.MouseOverWindow.name=="Root"

  if isRootWindow then
    Kursor:GetFunctionFromFlag(flags, "CursorRButtonDown")
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

local function getEnemyAddonEnabledInfo()
  Kursor.Settings.isEnemyEnabled = Kursor:IsAddonEnabled("Enemy")
end


function Kursor.newPlayerMenuWindowOnRButtonDownProcessed(flags)
  local flagName = Kursor:GetFlagName(flags)

  if flagName == "isCtrlAltShiftPressed" then
    return
  end

  oldPlayerMenuWindowOnRButtonDownProcessed()
end


local function setPlayerMenuWindowHook()
  oldPlayerMenuWindowOnRButtonDownProcessed = PlayerMenuWindow.OnRButtonDownProcessed
  PlayerMenuWindow.OnRButtonDownProcessed = Kursor.newPlayerMenuWindowOnRButtonDownProcessed
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

function Kursor.OnInitialize()
  getEnemyAddonEnabledInfo()
  setPlayerMenuWindowHook()
  Kursor:RegisterFlags(flagActions)
  Kursor:RegisterSlash(slashCommands, "warext")
  Kursor:Hook(Cursor.OnRButtonDownProcessed, kursorOnRButtonDown, true)
end
