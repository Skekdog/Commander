local fluid = require("../../../Packages/fluid")
local getNextColour = require("./getNextColour")

local function TextButton(props: {
	Text: fluid.UsedAs<string>,
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>,
	TextSize: fluid.UsedAs<number>,
})

	return fluid.create "TextButton" {
		Text = props.Text,
		Size = props.Size,
		Position = props.Position,

		Font = Enum.Font.BuilderSans,

		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,

		TextSize = props.TextSize,

		BackgroundColor3 = getNextColour(),

		fluid.create "UICorner" {
			CornerRadius = UDim.new(0, 8),
		},

		fluid.create "UIStroke" {
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}
	}
end

return TextButton