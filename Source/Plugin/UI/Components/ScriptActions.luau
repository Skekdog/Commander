local fluid = require("../../../Packages/fluid")
local TextSize = require("../TextSize")
local LayoutFrame = require("./LayoutFrame")
local ListLayout = require("./ListLayout")
local Padding = require("./Padding")
local ScriptActionTextButton = require("./ScriptActionTextButton")
local TextBox = require("./TextBox")

local function ScriptActions(props: {
	Position: fluid.UsedAs<UDim2>?,
	Size: fluid.UsedAs<UDim2>,
	AutomaticSize: fluid.UsedAs<Enum.AutomaticSize>?,

	ActiveScript: fluid.Source<ModuleScript>,

	[number]: Instance,
})
	local scriptName = fluid.source(props.ActiveScript().Name)
	fluid.effect(function()
		scriptName(props.ActiveScript().Name)
	end)

	return LayoutFrame {
		AutomaticSize = props.AutomaticSize,
		Position = props.Position,
		Size = props.Size,

		Padding(6),

		ListLayout {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 6),
		},

		TextBox {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = TextSize.MainButton,

			PlaceholderText = "Script Name",
			Text = scriptName,
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

		table.unpack(props),
	}
end

return ScriptActions