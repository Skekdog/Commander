local BaseGui = require("./BaseGui")

export type BaseTextParams = {
	BaseGui: BaseGui.BaseGuiParams?,

	Text: string?,

	TextScaled: boolean?,
	FontSize: number?,

	Font: Font?,
	Italics: boolean?,

	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,

	TextWrapped: boolean?,

	Colour: Color3?,

	[any]: never,
}

local function BaseText<T>(gui: T & (TextLabel | TextButton | TextBox), params: BaseTextParams?): T
	params = params or {}
	assert(params)

	local label = gui :: T & TextLabel
	BaseGui(gui, params.BaseGui)

	label.Text = params.Text or ""
	label.TextScaled = if params.TextScaled ~= nil then params.TextScaled else true
	label.TextSize = params.FontSize or 14

	label.TextWrapped = if params.TextWrapped ~= nil then params.TextWrapped else true

	label.TextXAlignment = params.TextXAlignment or Enum.TextXAlignment.Center
	label.TextYAlignment = params.TextYAlignment or Enum.TextYAlignment.Center

	label.TextColor3 = if params.Colour then params.Colour else Color3.new(0, 0, 0)

	local font = params.Font or Font.fromEnum(Enum.Font.BuilderSans)
	font.Style = if params.Italics then Enum.FontStyle.Italic else Enum.FontStyle.Normal

	label.FontFace = font

	return label
end

return BaseText