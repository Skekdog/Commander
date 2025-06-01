local ChangeHistoryService = game:GetService("ChangeHistoryService")

local function Execute(code: string): ()
	local recording: string?
	
	recording = ChangeHistoryService:TryBeginRecording("Execute commander code")
	if not recording then
		return warn("Unable to create undo waypoint, possibly due to another execution already in progress. Execution aborted.")
	end

	local success, result = pcall(function(): (any, any)
		local exec, err = loadstring(code)
		if not exec then
			return error(err or "Unknown error occured")
		end
		return exec()
	end)

	if not success then
		warn(result)
	end

	if recording then
		ChangeHistoryService:FinishRecording(recording, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
	end
end

return Execute