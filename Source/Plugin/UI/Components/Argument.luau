local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local ListLayout = require("./ListLayout")
local TextLabel = require("./TextLabel")
local getNextColour = require("./getNextColour")

local function Argument<T>(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,

	Name: fluid.Source<string>,

	Input: GuiObject,
})
	return fluid.create "Frame" {
		Size = props.Size,
		Position = props.Position,

		BackgroundColor3 = getNextColour(),

		AutomaticSize = Enum.AutomaticSize.Y,

		ListLayout {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,

			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
		},

		TextLabel {
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.XY,

			Text = props.Name,
			TextSize = TextSize.ArgumentInput,
		},

		props.Input,
	}
end

return Argument