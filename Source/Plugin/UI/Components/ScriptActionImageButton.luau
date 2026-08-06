local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local SquareAspectRatio = require("./SquareAspectRatio")

local function ScriptActionImageButton(props: {
	Content: Content,
	Activated: (...unknown) -> (),
})
	return fluid.create "ImageButton" {
		ImageContent = props.Content,
		BackgroundTransparency = 1,

		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(0, TextSize.MainButton),

		SquareAspectRatio(),

		Activated = props.Activated,
	}
end

return ScriptActionImageButton