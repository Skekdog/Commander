local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local function executeEditMode(code: string): ()
	local exec, err = loadstring(code)
	if not exec then
		error(err or "Unknown error occured")
	end
	return exec()
end

local function executePlayMode(code: string): ()
	local folder = ServerScriptService:FindFirstChild("CommanderExecutionScripts")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "CommanderExecutionScripts"
		folder.Parent = ServerScriptService
	end

	local executionScript = Instance.new("Script")
	executionScript.Source = code
	executionScript.RunContext = if RunService:IsServer() then Enum.RunContext.Server else Enum.RunContext.Client
	executionScript.Name = "CommanderExecutionScript"
	executionScript.Parent = folder
end

local function Execute(code: string): ()
	local recording: string?

	if not RunService:IsRunning() then
		recording = ChangeHistoryService:TryBeginRecording("Execute commander code")
		if not recording then
			return warn("Unable to create undo waypoint, possibly due to another execution already in progress. Execution aborted.")
		end
	end

	local success, result = pcall(function(): any
		if RunService:IsRunning() then
			return executePlayMode(code)
		end
		return executeEditMode(code)
	end)

	if not success then
		if result == "loadstring() is not available" then
			if RunService:IsClient() then
				warn("Commander does not support client-side execution.")
			else
				warn("Commander requires ServerScriptService.LoadStringEnabled when running on the server.")
			end
			return
		end
		warn(result)
	end

	if recording then
		ChangeHistoryService:FinishRecording(recording, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
	end
end

return Execute