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
local buttonsThatHaveBeenRemovedButStillNeedToBeTrackedBecauseOfARobloxBug: {[string]: PluginToolbarButton?} = {}

-- todo: this function also acts as an update function, but only for the icon, until roblox fixes button removal
function ToolbarButton.Add(scriptFile: ModuleScript, parameters: Parameters): ()
	local button = buttonsThatHaveBeenRemovedButStillNeedToBeTrackedBecauseOfARobloxBug[scriptFile.Name]
		or
		toolbar:CreateButton("CommanderScript" .. scriptFile.Name, parameters.Tooltip or "", parameters.Icon or "", scriptFile.Name)

	if parameters.Icon or parameters.Icon == "" then
		button.Icon = parameters.Icon
	end

	button.ClickableWhenViewportHidden = true

	button.Click:Connect(function()
		Execute(ScriptEditorService:GetEditorSource(scriptFile), scriptFile:GetAttributes(), scriptFile.Name)
	end)

	buttons[scriptFile.Name] = button
	buttonsThatHaveBeenRemovedButStillNeedToBeTrackedBecauseOfARobloxBug[scriptFile.Name] = button
end

function ToolbarButton.Remove(scriptName: string): ()
	local button = buttons[scriptName]
	assert(button, "Attempt to remove non-existant toolbar button: " .. scriptName)

	-- todo Roblox bug, but destroying the button doesn't remove it :frowning:
	-- button:Destroy()

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