local GetPlugin = require("../Lib/GetPlugin")
local fluid = require("../Packages/fluid")
local LayoutFrame = require("./UI/Components/LayoutFrame")
local TextButton = require("./UI/Components/TextButton")
local TextSize = require("./UI/TextSize")

local plugin = GetPlugin

local module = {}

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

fluid.root(function()
	fluid.create "Frame" {
		Size = UDim2.fromScale(0.5, 1),
		BackgroundTransparency = 1,

		Parent = widget,

		LayoutFrame {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(),

			Padding = 10,

			fluid.create "UIListLayout" {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, 6)
			},

			TextButton {
				Text = "hi there hello",
				Position = UDim2.new(),
				Size = UDim2.fromScale(0.8, 0),

				TextSize = TextSize.Body,
			},
		}
	}
end)

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module