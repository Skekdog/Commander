local BaseGui = require("./BaseGui")

export type ScrollFrameParams = {
	BaseGui: BaseGui.BaseGuiParams?,

	AutomaticCanvasSize: Enum.AutomaticSize?,

	ScrollbarThickness: number?,

	ScrollingDirection: Enum.ScrollingDirection?,

	VerticalScrollBarInset: Enum.ScrollBarInset?,
	HorizontalScrollBarInset: Enum.ScrollBarInset?,

	[any]: never,
}

local function ScrollFrame(params: ScrollFrameParams): ScrollingFrame
	local frame = Instance.new("ScrollingFrame")
	BaseGui(frame, params.BaseGui)

	frame.CanvasSize = UDim2.fromScale(0, 0)
	frame.AutomaticCanvasSize = params.AutomaticCanvasSize or Enum.AutomaticSize.Y
	frame.ScrollBarThickness = params.ScrollbarThickness or 4
	frame.ScrollingDirection = params.ScrollingDirection or Enum.ScrollingDirection.Y
	frame.VerticalScrollBarInset = params.VerticalScrollBarInset or Enum.ScrollBarInset.Always
	frame.HorizontalScrollBarInset = params.HorizontalScrollBarInset or Enum.ScrollBarInset.Always

	frame.ScrollBarImageColor3 = Color3.new(0, 0, 0)

	return frame
end

return ScrollFrame