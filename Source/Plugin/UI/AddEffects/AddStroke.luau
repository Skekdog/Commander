
local function AddStroke<T>(instance: T & Instance, thickness: number?): T
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = thickness or 2
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = instance
	return instance
end

return AddStroke