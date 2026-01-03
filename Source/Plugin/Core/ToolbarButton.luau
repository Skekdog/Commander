local ScriptEditorService = game:GetService("ScriptEditorService")
local Toolbar = require("../Toolbar")
local Execute = require("./Execute")

local ToolbarButton = {}

export type Parameters = {
	Icon: string?,
	Tooltip: string?,
}

export type Button = {
	PluginButton: PluginToolbarButton,
	Parameters: Parameters,
	ClickConnection: RBXScriptConnection?,
}

local toolbar = Toolbar.Toolbar

local buttons: {[string]: Button?} = {}
local buttonsForRobloxBug: {[string]: Button?} = {}

-- todo: this function also acts as an update function, but only for the icon, until roblox fixes button removal
function ToolbarButton.Add(scriptFile: ModuleScript, parameters: Parameters): ()
	local button = buttonsForRobloxBug[scriptFile.Name] or {
		PluginButton = toolbar:CreateButton("CommanderScript" .. scriptFile.Name, parameters.Tooltip or "", parameters.Icon or "", scriptFile.Name),
		Parameters = parameters,
	} :: Button

	if parameters.Icon or parameters.Icon == "" then
		button.PluginButton.Icon = parameters.Icon
	end

	button.PluginButton.ClickableWhenViewportHidden = true

	if button.ClickConnection then
		button.ClickConnection:Disconnect()
	end

	button.ClickConnection = button.PluginButton.Click:Connect(function()
		Execute(ScriptEditorService:GetEditorSource(scriptFile), scriptFile:GetAttributes(), scriptFile.Name)
	end)

	buttons[scriptFile.Name] = button
	buttonsForRobloxBug[scriptFile.Name] = button
end

function ToolbarButton.Remove(scriptName: string): ()
	local button = buttons[scriptName]
	assert(button, "Attempt to remove non-existant toolbar button: " .. scriptName)

	-- todo Roblox bug, but destroying the button doesn't remove it :frowning:
	-- button:Destroy()

	buttons[scriptName] = nil
end

function ToolbarButton.Get(scriptName: string): Button?
	return buttons[scriptName]
end

function ToolbarButton.UpdateIcon(scriptName: string, icon: string): ()
	local button = buttons[scriptName]
	assert(button, "Attempt to edit non-existant toolbar button: " .. scriptName)

	button.PluginButton.Icon = icon
end

return ToolbarButton