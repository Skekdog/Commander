
local module = {}

local scripts: {[string]: Script?} = {}

module.ActiveScript = nil :: Script?

function module.GetScript(name: string): Script
	return scripts[name] or error("Script not found: " .. name)
end

function module.GetScripts(): {[string]: Script}
	return scripts :: {[string]: Script}
end

function module.RemoveScript(name: string): ()
	local scriptFile = scripts[name]
	assert(scriptFile, "Script not found: " .. name)
	scripts[name] = nil
	scriptFile:Destroy()
end

function module.AddScript(name: string, source: string): Script
	assert(not scripts[name], "Script already exists: " .. name)
	local scriptFile = Instance.new("Script")
	scriptFile.Source = source
	scriptFile.Enabled = false
	scriptFile.Name = name
	scriptFile.Parent = script
	scriptFile.Enabled = true -- if the script is enabled when parenting, it will run. after parenting it will not, and enabling it means the tab doesn't say [Disabled]
	scripts[name] = scriptFile
	return scriptFile
end

return module