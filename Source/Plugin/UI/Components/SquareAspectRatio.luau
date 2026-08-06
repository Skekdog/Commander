local fluid = require("../../../Packages/fluid")

local function SquareAspectRatio()
	return fluid.create "UIAspectRatioConstraint" {
		AspectRatio = 1,
		AspectType = Enum.AspectType.ScaleWithParentSize,
		DominantAxis = Enum.DominantAxis.Height,
	}
end

return SquareAspectRatio