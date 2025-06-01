local Style = require("../Style")

local function AddStroke<T>(instance: T & Instance, thickness: number?): T
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = thickness or 2
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = instance

	Style(uiStroke, if instance:IsA("GuiButton") then {Color = {Color = Enum.StudioStyleGuideColor.ButtonBorder}} else nil)

	return instance
end

return AddStroke