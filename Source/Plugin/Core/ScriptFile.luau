local CoreGui = game:GetService("CoreGui")
local ScriptEditorService = game:GetService("ScriptEditorService")
local GetPlugin = require("../../Lib/GetPlugin")
local Arguments = require("./Arguments")
local DefaultScript = require("./DefaultScript")
local PluginStorage = require("./PluginStorage")

local ScriptFile = {}

local plugin = GetPlugin

local scriptFolder = CoreGui:FindFirstChild("CommanderScripts") or Instance.new("Folder")
scriptFolder.Name = "CommanderScripts"
scriptFolder.Parent = CoreGui

function ScriptFile.GetScript(name: string): ModuleScript?
	local found = scriptFolder:FindFirstChild(name)
	assert(not found or found:IsA("ModuleScript"))
	return found
end

function ScriptFile.GetScripts(): {ModuleScript}
	local scripts: {ModuleScript} = {}
	for _, v in scriptFolder:GetChildren() do
		assert(v:IsA("ModuleScript"))
		table.insert(scripts, v)
	end
	return scripts
end

function ScriptFile.AddScript(name: string, scriptData: DefaultScript.ScriptData): ModuleScript
	assert(not ScriptFile.GetScript(name), "Script with name '" .. name .. "' already exists")

	local scriptFile = Instance.new("ModuleScript")
	scriptFile.Name = name
	scriptFile.Source = scriptData.Source

	for k, v in scriptData.Arguments do
		scriptFile:SetAttribute(k, v)
	end

	scriptFile.Parent = scriptFolder

	return scriptFile
end

plugin.Unloading:Connect(function()
	local oldScriptData = PluginStorage.GetScripts()
	local scriptData: {[string]: DefaultScript.ScriptData} = {}

	for _, v in scriptFolder:GetChildren() do
		assert(v:IsA("ModuleScript"))

		local arguments: {[string]: Arguments.ArgumentValue} = {}
		do
			local attributes = v:GetAttributes()
			local ranOnce = false
			for _ in attributes do
				ranOnce = true
				break
			end

			if not ranOnce then
				local data = oldScriptData[v.Name]
				arguments = if data then data.Arguments else {}
			else
				arguments = attributes :: {[string]: Arguments.ArgumentValue}
			end
		end

		scriptData[v.Name] = {
			Source = ScriptEditorService:GetEditorSource(v),
			Arguments = arguments,
		}

		local openScript = ScriptEditorService:FindScriptDocument(v)
		if openScript then
			task.spawn(openScript.CloseAsync, openScript)
		end
		v:Destroy()
	end

	PluginStorage.WriteScripts(scriptData)
end)

for name, scriptData in PluginStorage.GetScripts() do
	ScriptFile.AddScript(name, scriptData)
end

return ScriptFile