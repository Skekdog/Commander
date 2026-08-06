local fluid = require("../../../Packages/fluid")
local ExecuteScript = require("../../Core/ExecuteScript")
local OpenScript = require("../../Core/OpenScript")
local TextSize = require("../TextSize")
local LayoutFrame = require("./LayoutFrame")
local ListLayout = require("./ListLayout")
local Padding = require("./Padding")
local ScriptActionTextButton = require("./ScriptActionTextButton")
local TextBox = require("./TextBox")

local function focusLost(activeScript: fluid.Source<ModuleScript>)
	return fluid.action(function(instance)
		assert(instance:IsA("TextBox"))

		local conn = instance.FocusLost:Connect(function()
			local text = instance.Text
			activeScript().Name = text
		end)

		fluid.cleanup(conn)
	end)
end

local function ScriptActions(props: {
	Position: fluid.UsedAs<UDim2>?,
	Size: fluid.UsedAs<UDim2>,
	AutomaticSize: fluid.UsedAs<Enum.AutomaticSize>?,

	ActiveScript: fluid.Source<ModuleScript>,

	[number]: Instance,
})
	local name = function()
		return props.ActiveScript().Name
	end

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
			Text = name,

			focusLost(props.ActiveScript, name)
		},

		ScriptActionTextButton {
			Text = "Open",
			Activated = function()
				OpenScript(props.ActiveScript())
			end,
		},

		ScriptActionTextButton {
			Text = "Add to Toolbar",
			Activated = function() end,
		},

		ScriptActionTextButton {
			Text = "Execute!",
			Activated = function()
				ExecuteScript(props.ActiveScript())
			end,
		},

		table.unpack(props),
	}
end

return ScriptActions