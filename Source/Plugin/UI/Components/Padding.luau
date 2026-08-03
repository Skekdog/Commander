local fluid = require("../../../Packages/fluid")

type PaddingBaseValue = UDim | number
export type PaddingProperty = PaddingBaseValue | {
	[PaddingSide]: PaddingBaseValue?,
}

type PaddingSide = "Left" | "Right" | "Top" | "Bottom"

local function getPaddingSide(side: PaddingSide, padding: PaddingProperty): UDim
	return
		if typeof(padding) == "table" then
			getPaddingSide(side, padding[side] or UDim.new())
		elseif typeof(padding) == "UDim" then
			padding
		else
			UDim.new(0, padding)
end

local function Padding(padding: PaddingProperty)
	return fluid.create "UIPadding" {
		PaddingLeft = getPaddingSide("Left", padding),
		PaddingRight = getPaddingSide("Right", padding),
		PaddingTop = getPaddingSide("Top", padding),
		PaddingBottom = getPaddingSide("Bottom", padding),
	}
end

return Padding