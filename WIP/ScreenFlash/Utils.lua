local ScreenFlash = warExtendedScreenFlash

local threshold = {
	selfPrint = function (...)
	  p(...)
	end
}

local thresholds = {

}

function ScreenFlash.RegisterThresholds(...)
  local thresholdTable = {}
  for i = 1, select('#', ...) do
	p(i)
	p(...)
	p(unpack(...))
	--threshold:selfPrint(unpack(...))
  end

end

