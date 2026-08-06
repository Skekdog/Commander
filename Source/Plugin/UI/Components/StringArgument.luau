local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local Argument = require("./Argument")
local TextBox = require("./TextBox")

local function focusLost(callback: fluid.Source<string>)
	return fluid.action(function(instance)
		assert(instance:IsA("TextBox"))

		instance.FocusLost:Connect(function()
			callback(instance.Text)
		end)
	end)
end

local function StringArgument(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,

	Name: fluid.Source<string>,
	Value: fluid.Source<string>,
})
	return Argument<<string>> {
		Name = props.Name,
		Size = props.Size,
		Position = props.Position,
		Value = props.Value,

		Input = TextBox {
			Size = UDim2.new(),
			AutomaticSize = Enum.AutomaticSize.Y,

			Text = props.Value,
			PlaceholderText = "Enter a string",
			TextSize = TextSize.ArgumentInput,
			TextXAlignment = Enum.TextXAlignment.Right,

			fluid.create "UIFlexItem" {
				FlexMode = Enum.UIFlexMode.Fill,
			},

			focusLost(props.Value)
		},
	}
end

return StringArgument