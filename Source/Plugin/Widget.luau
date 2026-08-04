local GetPlugin = require("../Lib/GetPlugin")
local fluid = require("../Packages/fluid")
local ScriptFile = require("./Core/ScriptFile")
local LayoutFrame = require("./UI/Components/LayoutFrame")
local ScriptEntry = require("./UI/Components/ScriptEntry")

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
	return fluid.create "Frame" {
		Size = UDim2.fromScale(0.5, 1),
		BackgroundTransparency = 1,

		Parent = widget,

		LayoutFrame {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(),

			Padding = 4,

			fluid.create "UIListLayout" {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 6)
			},

			fluid.for_keys(props.Scripts, function(instance, i)
				return ScriptEntry {
					Script = instance(),
					Activated = function()
						print(i)
					end,
				}
			end) :: any,
		}
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