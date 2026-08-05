local fluid = require("../../../Packages/fluid")
local Execute = require("../../Core/Execute")
local TextSize = require("../TextSize")
local LayoutFrame = require("./LayoutFrame")
local Padding = require("./Padding")
local ScriptActionTextButton = require("./ScriptActionTextButton")

local function ScriptActions(props: {
	Position: fluid.UsedAs<UDim2>?,
	Size: fluid.UsedAs<UDim2>,
	ActiveScript: fluid.Source<ModuleScript>,
})
	local scriptName = fluid.source(props.ActiveScript().Name)
	fluid.effect(function()
		scriptName(props.ActiveScript().Name)
	end)

	return LayoutFrame {
		Position = props.Position,
		Size = props.Size,

		Padding(6),

		fluid.create "UIListLayout" {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 6),
		},

		fluid.create "TextBox" {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = TextSize.Body,
			Font = Enum.Font.BuilderSans,

			PlaceholderText = "Script Name",
			Text = scriptName,

			fluid.create "UICorner" {
				CornerRadius = UDim.new(0, 8),
			},

			fluid.create "UIStroke" {
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			},
		},

		ScriptActionTextButton {
			Text = "Open",
			Activated = function() end,
		},

		ScriptActionTextButton {
			Text = "Add to Toolbar",
			Activated = function() end,
		},

		ScriptActionTextButton {
			Text = "Execute!",
			Activated = function() end,
		},
	}
end

return ScriptActions