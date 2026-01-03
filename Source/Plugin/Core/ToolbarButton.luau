local ScriptEditorService = game:GetService("ScriptEditorService")
local Toolbar = require("../Toolbar")
local Execute = require("./Execute")

local ToolbarButton = {}

export type Parameters = {
	Icon: string?,
	Tooltip: string?,
}

local toolbar = Toolbar.Toolbar

local buttons: {[string]: PluginToolbarButton?} = {}

function ToolbarButton.Add(scriptFile: ModuleScript, parameters: Parameters): ()
	assert(not buttons[scriptFile.Name], "Toolbar button already exists: " .. scriptFile.Name)

	local button = toolbar:CreateButton("CommanderScript" .. scriptFile.Name, parameters.Tooltip or "", parameters.Icon or "", scriptFile.Name)
	button.ClickableWhenViewportHidden = true

	button.Click:Connect(function()
		Execute(ScriptEditorService:GetEditorSource(scriptFile), scriptFile:GetAttributes(), scriptFile.Name)
	end)

	buttons[scriptFile.Name] = button
end

function ToolbarButton.Remove(scriptName: string): ()
	local button = buttons[scriptName]
	assert(button, "Attempt to remove non-existant toolbar button: " .. scriptName)

	-- Roblox bug, but destroying the button doesn't remove it :frowning:
	button:Destroy()

	buttons[scriptName] = nil
end

function ToolbarButton.GetButton(scriptName: string): PluginToolbarButton?
	return buttons[scriptName]
end

function ToolbarButton.UpdateIcon(scriptName: string, icon: string): ()
	local button = buttons[scriptName]
	assert(button, "Attempt to edit non-existant toolbar button: " .. scriptName)

	button.Icon = icon
end

return ToolbarButton