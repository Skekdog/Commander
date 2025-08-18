local AddCorners = require("./AddEffects/AddCorners")
local AddPadding = require("./AddEffects/AddPadding")
local AddSizeConstraints = require("./AddEffects/AddSizeConstraints")
local AddStroke = require("./AddEffects/AddStroke")
local Style = require("./Style")

export type BaseGuiParams = {
	PaddingParams: AddPadding.PaddingParams?,
	CornerRadius: UDim?,
	Transparency: number?,

	AutomaticSize: Enum.AutomaticSize?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,

	SizeConstraints: {
		Min: Vector2?,
		Max: Vector2?,
	}?,

	LayoutOrder: number?,
	ZIndex: number?,

	Visible: boolean?,

	Name: string?,
	Parent: Instance?,

	Style: Style.Style?,
	NoStyle: boolean?,

	NoStroke: boolean?,

	[any]: never,
}

local function BaseGui<T>(gui: T & GuiObject, params: BaseGuiParams?): T
	params = params or {} :: BaseGuiParams
	assert(params)

	gui.BackgroundColor3 = Color3.new(1, 1, 1)
	gui.BackgroundTransparency = params.Transparency or 0
	gui.BorderSizePixel = 0

	if params.PaddingParams then
		AddPadding(gui, params.PaddingParams)
	end

	gui.Size = params.Size or UDim2.fromScale(0.5, 0.5)
	gui.Position = params.Position or UDim2.fromScale(0, 0)

	gui.AutomaticSize = params.AutomaticSize or Enum.AutomaticSize.None

	if params.AnchorPoint then
		gui.AnchorPoint = params.AnchorPoint
	end

	if params.LayoutOrder then
		gui.LayoutOrder = params.LayoutOrder
	end

	if params.ZIndex then
		gui.ZIndex = params.ZIndex
	end

	gui.Visible = if params.Visible == nil then true else params.Visible

	if not params.CornerRadius then
		AddCorners(gui, UDim.new(0, 8))
	elseif params.CornerRadius.Scale ~= 0 or params.CornerRadius.Offset ~= 0 then
		AddCorners(gui, params.CornerRadius or UDim.new(0, 8))
	end

	if params.SizeConstraints then
		AddSizeConstraints(gui, params.SizeConstraints.Min, params.SizeConstraints.Max)
	end

	if params.Name then
		gui.Name = params.Name
	end

	if params.Parent then
		gui.Parent = params.Parent
	end

	if not params.NoStroke and (not params.Transparency or params.Transparency < 1) then
		AddStroke(gui, 1)
	end

	if not params.NoStyle then
		task.defer(Style, gui, (params.Style or "Default") :: Style.Style)
	end

	return gui
end

return BaseGui