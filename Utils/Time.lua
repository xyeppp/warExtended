local warExtended = warExtended

local GetGameTime = GetGameTime
local GetTodaysDate = GetTodaysDate
local GetComputerTime = GetComputerTime
local mfloor = math.floor
local wsformat = wstring.format

function warExtended:GetGameTime()
  return GetGameTime()
end

function warExtended:GetTimeFromSeconds (t)
  
  if (not t) then return 0, 0, 0 end
  
  t = mfloor (t + 0.5)
  
  local d = mfloor (t / 86400.0)
  t = t - (d * 86400)
  local h = mfloor (t / 3600.0)
  t = t - (h * 3600)
  local m = mfloor (t / 60.0)
  t = t - (m * 60)
  local s = mfloor (t + 0.5)
  
  return d, h, m, s
end


function warExtended:GetCurrentDateInSeconds ()
  local d = GetTodaysDate ()
  return (d.todaysDay + (d.todaysMonth + d.todaysYear * 12) * 31) * 86400
end


function warExtended:GetCurrentDateInSecondsWithTime ()
  return self:GetCurrentDateInSeconds () + GetComputerTime ()
end


function warExtended:GetCurrentDateTime ()
  
  local t = GetComputerTime ()
  local d = GetTodaysDate ()
  local _d, h, m, s = self:GetTimeFromSeconds (t)
  local ts = t + (d.todaysDay + (d.todaysMonth + d.todaysYear * 12) * 31) * 86400
  
  return
  {
    year = d.todaysYear,
    month = d.todaysMonth,
    day = d.todaysDay,
    hours = h,
    minutes = m,
    seconds = s,
    totalSeconds = ts
  }
end


function warExtended:DateTimeToString (dt)
  
  local res = wsformat (L"%02d.%02d.%04d %02d:%02d:%02d",
          dt.day,
          dt.month,
          dt.year,
          dt.hours,
          dt.minutes,
          dt.seconds
  )
  
  return res
end
