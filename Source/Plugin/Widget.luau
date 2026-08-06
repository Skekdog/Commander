local GetPlugin = require("../Lib/GetPlugin")
local fluid = require("../Packages/fluid")
local ScriptFile = require("./Core/ScriptFile")
local ArgumentList = require("./UI/Components/ArgumentList")
local LayoutFrame = require("./UI/Components/LayoutFrame")
local ListLayout = require("./UI/Components/ListLayout")
local ScriptActions = require("./UI/Components/ScriptActions")
local ScriptList = require("./UI/Components/ScriptList")

local plugin = GetPlugin

_G.__DEV__ = true

local widget = plugin:CreateDockWidgetPluginGuiAsync("Commander", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	600,
	350,
	250,
	150
	)
)

widget.Name = "Commander"
widget.Title = "Commander"
widget.ResetOnSpawn = false
widget.Enabled = false

local module = {}

local function commander(props: {
	Scripts: () -> {ModuleScript},
})
	local activeScript = fluid.source(props.Scripts()[1])

	return fluid.create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		ScriptList {
			Size = UDim2.fromScale(0.5, 1),
			Scripts = props.Scripts,
		},

		LayoutFrame {
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(0.5, 1),

			ListLayout {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			},

			ScriptActions {
				ActiveScript = activeScript,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				fluid.create "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Shrink,
				},
			},

			ArgumentList {
				Arguments = {
					{
						Default = "hi",
						Name = "str",
					},
					{
						Default = 1,
						Name = "num",
					},
					{
						Default = true,
						Name = "bool",
					},
				},
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				fluid.create "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
				},
			}
		},
	}
end

local function app()
	local scripts = ScriptFile.Scripts

	return commander {
		Scripts = scripts,
	}
end

fluid.root(function()
	app().Parent = widget
end)

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module