local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local Argument = require("./Argument")
local SquareAspectRatio = require("./SquareAspectRatio")

local CHECKBOX_ON_DARK = "rbxasset://studio_svg_textures/Shared/Utility/Dark/Standard/CheckboxOn@3x.png"
local CHECKBOX_OFF_DARK = "rbxasset://studio_svg_textures/Shared/Utility/Dark/Standard/CheckboxOff@3x.png"

local _CHECKBOX_ON_LIGHT = "rbxasset://studio_svg_textures/Shared/Utility/Light/Standard/CheckboxOn@3x.png"
local _CHECKBOX_OFF_LIGHT = "rbxasset://studio_svg_textures/Shared/Utility/Light/Standard/CheckboxOff@3x.png"

local function BooleanArgument(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,

	Name: fluid.Source<string>,
	Value: fluid.Source<boolean>,
})
	local image = function()
		if props.Value() then
			return Content.fromUri(CHECKBOX_ON_DARK)
		end
		return Content.fromUri(CHECKBOX_OFF_DARK)
	end

	return Argument<<boolean>> {
		Name = props.Name,
		Size = props.Size,
		Position = props.Position,
		Value = props.Value,

		Input = fluid.create "ImageButton" {
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(0, TextSize.ArgumentInput),

			BackgroundTransparency = 1,

			ImageContent = image,

			SquareAspectRatio(),

			Activated = function()
				props.Value(not props.Value())
			end
		}
	}
end

return BooleanArgument