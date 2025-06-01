local BaseGui = require("./BaseGui")

export type BaseTextParams = {
	BaseGui: BaseGui.BaseGuiParams?,

	Text: string?,

	TextScaled: boolean?,
	FontSize: number?,

	Italics: boolean?,

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
	label.TextSize = if params.FontSize then params.FontSize else 14

	label.TextColor3 = if params.Colour then params.Colour else Color3.new(0, 0, 0)

	local font = Font.fromEnum(Enum.Font.BuilderSans)
	font.Style = if params.Italics then Enum.FontStyle.Italic else Enum.FontStyle.Normal

	label.FontFace = font

	return label
end

return BaseText