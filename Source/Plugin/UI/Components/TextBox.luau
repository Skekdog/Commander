local fluid = require("../../../Packages/fluid")

local function TextBox(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,
	AutomaticSize: fluid.UsedAs<Enum.AutomaticSize>?,

	Text: fluid.UsedAs<string>,
	PlaceholderText: fluid.UsedAs<string>,
	TextSize: fluid.UsedAs<number>,
	TextXAlignment: fluid.UsedAs<Enum.TextXAlignment>?,

	[number]: Instance | fluid.Action,
})
	return fluid.create "TextBox" {
		Size = props.Size,
		Position = props.Position,
		AutomaticSize = props.AutomaticSize,

		Font = Enum.Font.BuilderSans,

		Text = props.Text,
		PlaceholderText = props.PlaceholderText,
		TextSize = props.TextSize,
		TextXAlignment = props.TextXAlignment,

		table.unpack(props),
	}
end

return TextBox