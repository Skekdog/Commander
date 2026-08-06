local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local Argument = require("./Argument")
local TextBox = require("./TextBox")

local function NumberArgument(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,

	Name: fluid.Source<string>,
	Value: fluid.Source<number>,
})
	local text = function()
		return tostring(props.Value())
	end
	return Argument<<number>> {
		Name = props.Name,
		Size = props.Size,
		Position = props.Position,
		Value = props.Value,

		Input = TextBox {
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.Y,

			Text = text,
			PlaceholderText = "Enter a number",
			TextSize = TextSize.ArgumentInput,
			TextXAlignment = Enum.TextXAlignment.Right,

			fluid.create "UIFlexItem" {
				FlexMode = Enum.UIFlexMode.Fill,
			},

			FocusLost = function()

			end,
		},
	}
end

return NumberArgument