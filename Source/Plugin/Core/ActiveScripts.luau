local CoreGui = game:GetService("CoreGui")

local module = {}

local scripts: {[string]: ModuleScript?} = {}

module.ScriptFolder = CoreGui:FindFirstChild("CommanderScripts") or Instance.new("Folder")
module.ScriptFolder.Name = "CommanderScripts"
module.ScriptFolder.Parent = CoreGui

module.ActiveScript = nil :: ModuleScript?

function module.GetScript(name: string): ModuleScript
	return scripts[name] or error("Script not found: " .. name)
end

function module.GetScripts(): {[string]: ModuleScript}
	return scripts :: {[string]: ModuleScript}
end

function module.RemoveScript(name: string): ()
	local scriptFile = scripts[name]
	assert(scriptFile, "Script not found: " .. name)
	scripts[name] = nil
	scriptFile:Destroy()
end

function module.RenameScript(scriptFile: ModuleScript, newName: string): ()
	assert(not scripts[newName], "Script already exists: " .. newName)
	scripts[scriptFile.Name] = nil
	scriptFile.Name = newName
	scripts[newName] = scriptFile
end

function module.AddScript(name: string, source: string): ModuleScript
	assert(not scripts[name], "Script already exists: " .. name)
	local scriptFile = Instance.new("ModuleScript")
	scriptFile.Source = source
	scriptFile.Name = name
	scriptFile.Parent = module.ScriptFolder
	scripts[name] = scriptFile
	return scriptFile
end

return module