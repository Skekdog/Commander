local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")

local getArgFunction = "local function GETARG(name) local value = script:GetAttribute(name) if value == nil then error('Unknown argument: ' .. name) end return value end "

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

		for name, value in attributes or {} :: {[string] : any} do
			newScript:SetAttribute(name, value)
		end

		local withGetArgFunction = getArgFunction .. code

		local withReturn = withGetArgFunction .. "\nreturn nil" -- Newline so that any comments on the last line don't mess things up
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