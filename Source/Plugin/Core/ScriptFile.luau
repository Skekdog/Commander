local CoreGui = game:GetService("CoreGui")
local ScriptEditorService = game:GetService("ScriptEditorService")
local GetPlugin = require("../../Lib/GetPlugin")
local Arguments = require("./Arguments")
local DefaultScript = require("./DefaultScript")
local PluginStorage = require("./PluginStorage")
local ToolbarButton = require("./ToolbarButton")
local fluid = require("../../Packages/fluid")

local ScriptFile = {}

local plugin = GetPlugin

local scriptFolder = Instance.new("Folder")
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

ScriptFile.Scripts = fluid.source(ScriptFile.GetScripts())

function ScriptFile.Delete(scriptFile: ModuleScript): ()
	scriptFile:Destroy()

	local index = table.find(ScriptFile.Scripts(), scriptFile)
	if index then
		table.remove(ScriptFile.Scripts(), index)
		ScriptFile.Scripts(ScriptFile.Scripts())
	end

	local button = ToolbarButton.Get(scriptFile.Name)
	if button then
		ToolbarButton.Remove(scriptFile.Name)
	end
end

function ScriptFile.AddScript(name: string, scriptData: DefaultScript.ScriptData): ModuleScript
	assert(not ScriptFile.GetScript(name), "Script with name '" .. name .. "' already exists")

	local scriptFile = Instance.new("ModuleScript")
	scriptFile.Name = name
	scriptFile.Source = scriptData.Source

	for k, v in scriptData.Arguments do
		scriptFile:SetAttribute(k, v)
	end

	if scriptData.ToolbarButton then
		ToolbarButton.Add(scriptFile, scriptData.ToolbarButton)
	end

	table.insert(ScriptFile.Scripts(), scriptFile)
	ScriptFile.Scripts(ScriptFile.Scripts())

	for i = 1, 10 do
		local c = scriptFile:Clone()
		c.Name = name .. i
		c.Parent = scriptFolder

		table.insert(ScriptFile.Scripts(), c)
		ScriptFile.Scripts(ScriptFile.Scripts())
	end
	scriptFile.Parent = scriptFolder

	return scriptFile
end

-- plugin.Unloading:Connect(function()
-- 	local oldScriptData = PluginStorage.GetScripts()
-- 	local scriptData: {[string]: DefaultScript.ScriptData} = {}

-- 	for _, v in scriptFolder:GetChildren() do
-- 		assert(v:IsA("ModuleScript"))

-- 		local arguments: {[string]: Arguments.ArgumentValue} = {}
-- 		do
-- 			local attributes = v:GetAttributes()
-- 			local ranOnce = false
-- 			for _ in attributes do
-- 				ranOnce = true
-- 				break
-- 			end

-- 			if not ranOnce then
-- 				local data = oldScriptData[v.Name]
-- 				arguments = if data then data.Arguments else {}
-- 			else
-- 				arguments = attributes :: {[string]: Arguments.ArgumentValue}
-- 			end
-- 		end

-- 		local toolbarButton = ToolbarButton.Get(v.Name)

-- 		scriptData[v.Name] = {
-- 			Source = ScriptEditorService:GetEditorSource(v),
-- 			Arguments = arguments,
-- 			ToolbarButton = if toolbarButton then toolbarButton.Parameters else nil,
-- 		}

-- 		local openScript = ScriptEditorService:FindScriptDocument(v)
-- 		if openScript then
-- 			openScript:CloseAsync()
-- 		end
-- 	end

-- 	PluginStorage.WriteScripts(scriptData)
-- 	scriptFolder:Destroy()
-- end)

for name, scriptData in PluginStorage.GetScripts() do
	ScriptFile.AddScript(name, scriptData)
end

return ScriptFile