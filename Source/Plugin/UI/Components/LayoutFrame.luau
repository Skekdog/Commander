local fluid = require("../../../Packages/fluid")
local Padding = require("./Padding")
local getNextColour = require("./getNextColour")

local function LayoutFrame(props: {
	Size: fluid.UsedAs<UDim2>,
	Position: fluid.UsedAs<UDim2>?,

	Padding: Padding.PaddingProperty?,

	[number]: Instance,
}): ScrollingFrame | Frame
	local scrollingFrameProperties: fluid.PropertiesFor<"ScrollingFrame"> = {
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		BackgroundColor3 = getNextColour(),

		ScrollBarThickness = 4,

		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,

		table.unpack(props),
	}

	if props.Padding then
		scrollingFrameProperties.BackgroundTransparency = 1
		scrollingFrameProperties.Size = UDim2.fromScale(1, 1)

		-- This will obviously seem strange, but there's a Roblox bug that makes scrolling frames and padding not go well (especially with list layout)
		return fluid.create "Frame" {
			Size = props.Size,
			Position = props.Position,

			BackgroundColor3 = getNextColour(),

			fluid.create "ScrollingFrame" (scrollingFrameProperties),

			Padding(props.Padding),
		}
	end

	scrollingFrameProperties.Size = props.Size
	scrollingFrameProperties.Position = props.Position

	return fluid.create "ScrollingFrame" (scrollingFrameProperties)
end

return LayoutFrame