
local count = 0

-- this exists to better visualise debug ui, nothing else

local function getNextColour(): Color3
	count = (count + 2) % 128
	return BrickColor.palette(count).Color
end

return getNextColour