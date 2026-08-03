local GetPlugin = require("../Lib/GetPlugin")

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



function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module