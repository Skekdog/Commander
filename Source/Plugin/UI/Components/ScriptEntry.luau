local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local ListLayout = require("./ListLayout")
local Padding = require("./Padding")
local ScriptActionImageButton = require("./ScriptActionImageButton")
local TextButton = require("./TextButton")

local function ScriptEntry(props: {
	Script: Instance,
	Activated: (...unknown) -> (),
})
	local scriptName = fluid.source(props.Script.Name)
	props.Script:GetPropertyChangedSignal("Name"):Connect(function()
		scriptName(props.Script.Name)
	end)

	return TextButton {
		Text = "",
		Size = UDim2.fromScale(1, 0),
		TextSize = TextSize.MainButton,

		StrokePosition = Enum.BorderStrokePosition.Inner,

		Activated = props.Activated,

		ListLayout {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
		},

		fluid.create "TextLabel" {
			BackgroundTransparency = 1,

			Text = scriptName,
			TextSize = TextSize.MainButton,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,

			Font = Enum.Font.BuilderSans,

			AutomaticSize = Enum.AutomaticSize.Y,

			fluid.create "UIFlexItem" {
				FlexMode = Enum.UIFlexMode.Fill,
			},
		},

		ScriptActionImageButton {
			Content = Content.fromAssetId(8517323790),
		},

		ScriptActionImageButton {
			Content = Content.fromAssetId(15911231575),
		},

		ScriptActionImageButton {
			Content = Content.fromAssetId(11768918600),
		},

		Padding(4),
	}
end

return ScriptEntry