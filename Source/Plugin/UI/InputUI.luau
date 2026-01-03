local AddAspectRatio = require("./AddEffects/AddAspectRatio")
local AddListLayout = require("./AddEffects/AddListLayout")
local BackgroundFrame = require("./BackgroundFrame")
local BaseGui = require("./BaseGui")
local BaseText = require("./BaseText")
local Style = require("./Style")

local InputUI = {}

export type ArgumentFrame = {
	Value: ImageButton | TextBox,
	Label: TextLabel,
} & Frame

export type PossibleInputs = string | number | boolean

local CHECKBOX_ON_DARK = "rbxasset://studio_svg_textures/Shared/Utility/Dark/Standard/CheckboxOn@3x.png"
local CHECKBOX_OFF_DARK = "rbxasset://studio_svg_textures/Shared/Utility/Dark/Standard/CheckboxOff@3x.png"

local CHECKBOX_ON_LIGHT = "rbxasset://studio_svg_textures/Shared/Utility/Light/Standard/CheckboxOn@3x.png"
local CHECKBOX_OFF_LIGHT = "rbxasset://studio_svg_textures/Shared/Utility/Light/Standard/CheckboxOff@3x.png"

local textBoxArgument = BackgroundFrame({
	Transparency = 1,
	Size = UDim2.fromScale(1, 0.125),

	NoStroke = true,

	Name = "TextBoxArgument",
}) :: ArgumentFrame

AddListLayout(textBoxArgument, {
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
	Padding = UDim.new(0, 4),
})

do
	local value = BaseText(Instance.new("TextBox"), {
		BaseGui = {
			Size = UDim2.new(0, 40, 1, 0),

			PaddingParams = {
				Left = UDim.new(0, 2),
				Right = UDim.new(0, 2),
				Top = UDim.new(0, 2),
				Bottom = UDim.new(0, 2),
			},

			LayoutOrder = 1,

			Name = "Value",
			Parent = textBoxArgument,
		},
		Text = "text",
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local label = BaseText(Instance.new("TextLabel"), {
		BaseGui = {
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,

			NoStroke = true,

			Name = "Label",
			Parent = textBoxArgument,
		},
		Text = "Text: ",
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Shrink
	flex.Parent = label

	flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Grow
	flex.Parent = value
end

local booleanArgument = textBoxArgument:Clone()

local function getCheckboxImage(enabled: boolean, isDark: boolean): string
	if enabled then
		if isDark then
			return CHECKBOX_ON_DARK
		else
			return CHECKBOX_ON_LIGHT
		end
	else
		if isDark then
			return CHECKBOX_OFF_DARK
		else
			return CHECKBOX_OFF_LIGHT
		end
	end
end

do
	booleanArgument.Name = "BooleanArgument"
	booleanArgument.Value:Destroy()

	Style(booleanArgument)
	Style(booleanArgument.Label)

	local value = BaseGui(Instance.new("ImageButton"), {
		Name = "Value",
		Parent = booleanArgument,

		Size = UDim2.new(0, 40, 1, 0),

		Transparency = 1,

		CornerRadius = UDim.new(0, 0),
		NoStroke = true,
	})

	value.Image = CHECKBOX_ON_DARK

	AddAspectRatio(value, {
		Type = Enum.AspectType.ScaleWithParentSize,
	})
end

function InputUI.CreateInput<T>(name: string, value: T?, default: T & PossibleInputs, onInput: (input: T) -> (), onInvalid: (reason: "InvalidNumber") -> ()): ArgumentFrame
	local argumentFrame: ArgumentFrame
	if typeof(default) == "boolean" then
		argumentFrame = booleanArgument:Clone()
	else
		argumentFrame = textBoxArgument:Clone()
	end

	assert(typeof(value) == "string" or typeof(value) == "number" or typeof(value) == "boolean" or value == nil, "Invalid argument type")

	if value == nil then
		value = default
	end

	local valueObject: ImageButton | TextBox = argumentFrame.Value
	local label = argumentFrame.Label :: TextLabel

	label.Text = name:gsub("_", " ") .. ": "

	local function setBooleanValue(): ()
		assert(valueObject:IsA("ImageButton") and typeof(value) == "boolean")
		local theme = settings().Studio.Theme
		local isDark = theme.Name == "Dark"
		valueObject.Image = getCheckboxImage(value, isDark)
		onInput(value)
	end

	local function setTextValue(): ()
		assert(valueObject:IsA("TextBox") and (typeof(value) == "string" or typeof(value) == "number"))
		valueObject.Text = tostring(value)
		onInput(value)
	end

	Style(valueObject, if valueObject:IsA("ImageButton") then {
		Image = function(theme)
			local enabled = valueObject.Image == CHECKBOX_ON_DARK or valueObject.Image == CHECKBOX_ON_LIGHT
			local isDark = theme.Name == "Dark"
			return getCheckboxImage(enabled, isDark)
		end
	} else nil)

	Style(label)

	if typeof(default) == "boolean" then
		assert(valueObject:IsA("ImageButton") and typeof(value) == "boolean")
		setBooleanValue()

		valueObject.Activated:Connect(function()
			value = (not value) :: any
			setBooleanValue()
		end)
	else
		assert(valueObject:IsA("TextBox"))
		valueObject.PlaceholderText = if typeof(default) == "number" then "Enter a number" else "Enter a string"
		setTextValue()

		if typeof(default) == "number" then
			local box = valueObject :: TextBox -- type narrowing fails here, don't know why
			onInput(tonumber(box.Text) or error("Invalid number") :: any)

			local lastSaneValue = box.Text

			box.FocusLost:Connect(function()
				if not tonumber(box.Text) then
					box.Text = lastSaneValue
					onInvalid("InvalidNumber")
				else
					lastSaneValue = box.Text
					onInput(box.Text :: any)
				end
			end)
		elseif typeof(default) == "string" then
			local box = valueObject :: TextBox
			onInput(box.Text :: any)

			box.FocusLost:Connect(function()
				onInput(box.Text :: any)
			end)
		end
	end

	argumentFrame.Name = name .. "_ArgumentFrame"

	return argumentFrame
end

return InputUI