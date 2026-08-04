local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local TextButton = require("./TextButton")

local function ScriptEntry(props: {
	Script: Instance,
	Activated: (...unknown) -> (),
})
	local scriptName = fluid.source(props.Script.Name)
	props.Script:GetPropertyChangedSignal("Name"):Connect(function()
		scriptName(props.Script.Name)
	end)

	return TextButton {
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 0),
		Text = scriptName,
		TextSize = TextSize.Body,

		Activated = props.Activated,
	}
end

return ScriptEntry