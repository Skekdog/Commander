
local count = 0

-- this exists to better visualise debug ui, nothing else

local function getNextColour(): Color3
	count += 1
	return BrickColor.new(count).Color
end

return getNextColour