local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")
local GetPlugin = require("../../Lib/GetPlugin")

local getArgFunction = "local function GETARG(name) local value = script:GetAttribute(name) if value == nil then error('Unknown argument: ' .. name) end return value end"

-- Alternatively we could parent the created script to the Plugin and use GetPlugin, but then we have to worry about parenting.
local pluginGlobal = "local plugin = script.Plugin.Value"

local scriptHead = getArgFunction .. "\n" .. pluginGlobal .. "\n"

local function Execute(code: string, attributes: {[string]: any}?, name: string): ()
	local recording: string?

	if not RunService:IsRunning() then
		recording = ChangeHistoryService:TryBeginRecording("Execute commander code")
		if not recording then
			return warn("Unable to create undo waypoint, possibly due to another execution already in progress. Execution aborted.")
		end
	end

	local success, result = pcall(function(): any
		local newScript = Instance.new("ModuleScript")
		newScript.Name = name

		local pluginValue = Instance.new("ObjectValue")
		pluginValue.Value = GetPlugin
		pluginValue.Name = "Plugin"
		pluginValue.Parent = newScript

		for name, value in attributes or {} :: {[string] : any} do
			newScript:SetAttribute(name, value)
		end

		local withHead = scriptHead .. code

		local withReturn = withHead .. "\nreturn nil" -- Newline so that any comments on the last line don't mess things up
		newScript.Source = withReturn;
		(require)(newScript)

		return nil
	end)

	if not success then
		warn(result)
	end

	if recording then
		ChangeHistoryService:FinishRecording(recording, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
	end
end

return Execute