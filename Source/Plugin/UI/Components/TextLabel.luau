local fluid = require("../../../Packages/fluid")
local getNextColour = require("./getNextColour")

local function TextLabel(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,
	AutomaticSize: fluid.UsedAs<Enum.AutomaticSize>?,

	Text: fluid.UsedAs<string>,
	TextSize: fluid.UsedAs<number>,
})
	return fluid.create "TextLabel" {
		Size = props.Size,
		Position = props.Position,
		AutomaticSize = props.AutomaticSize,

		Font = Enum.Font.BuilderSans,

		BackgroundColor3 = getNextColour(),

		Text = props.Text,
		TextSize = props.TextSize,
	}
end

return TextLabel