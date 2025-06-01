local BaseGui = require("./BaseGui")

local function BackgroundFrame(params: BaseGui.BaseGuiParams): Frame
	local frame = Instance.new("Frame")
	BaseGui(frame, params)

	return frame
end

return BackgroundFrame