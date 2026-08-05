local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")

local function ScriptActionImageButton(props: {
	Content: Content,
})
	return fluid.create "ImageButton" {
		ImageContent = props.Content,
		BackgroundTransparency = 1,

		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(0, TextSize.Body),

		fluid.create "UIAspectRatioConstraint" {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}
	}
end

return ScriptActionImageButton