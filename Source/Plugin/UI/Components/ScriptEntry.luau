local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
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

		Activated = props.Activated,

		fluid.create "UIListLayout" {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
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

		Padding(2),
	}
end

return ScriptEntry