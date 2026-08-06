local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local SquareAspectRatio = require("./SquareAspectRatio")

local function ScriptActionImageButton(props: {
	Content: Content,
})
	return fluid.create "ImageButton" {
		ImageContent = props.Content,
		BackgroundTransparency = 1,

		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(0, TextSize.MainButton),

		SquareAspectRatio(),
	}
end

return ScriptActionImageButton