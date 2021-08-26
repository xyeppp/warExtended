local function getGroupType()
  if (IsWarBandActive()) then
    return 3
  end
  if (GetNumGroupmates() > 0) then
    return 2
  end
  return 1
end



