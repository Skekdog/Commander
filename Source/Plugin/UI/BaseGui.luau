local AddCorners = require("./AddEffects/AddCorners")
local AddPadding = require("./AddEffects/AddPadding")

export type BaseGuiParams = {
	PaddingParams: AddPadding.PaddingParams?,
	CornerRadius: UDim?,
	Transparency: number?,

	Size: UDim2?,
	Position: UDim2?,

	Visible: boolean?,

	Name: string?,
	Parent: Instance?,

	[any]: never,
}

local function BaseGui<T>(gui: T & GuiObject, params: BaseGuiParams?): T
	params = params or {}
	assert(params)

	gui.BackgroundColor3 = Color3.new(1, 1, 1)
	gui.BackgroundTransparency = params.Transparency or 0

	if params.PaddingParams then
		AddPadding(gui, params.PaddingParams)
	end

	gui.Size = params.Size or UDim2.fromScale(0.5, 0.5)
	gui.Position = params.Position or UDim2.fromScale(0, 0)

	gui.Visible = if params.Visible == nil then true else params.Visible

	AddCorners(gui, params.CornerRadius or UDim.new(0, 8))

	if params.Name then
		gui.Name = params.Name
	end

	if params.Parent then
		gui.Parent = params.Parent
	end

	return gui
end

return BaseGui