
export type ScriptFile = {
	Name: string,
	Source: string,
	IsSaved: boolean,
	ScriptInstance: Script?,
}

local module = {}

local defaultScript: ScriptFile = {
	Name = "Untitled Script",
	Source = 'print("Hello, World!")',
	IsSaved = false,
}

module.DEFAULT_SCRIPT = defaultScript

local scripts: {[string]: ScriptFile?} = {["Untitled Script"] = module.DEFAULT_SCRIPT}

module.ActiveScript = module.DEFAULT_SCRIPT :: ScriptFile

function module.GetScript(name: string): ScriptFile?
	return scripts[name]
end

function module.GetScripts(): {[string]: ScriptFile}
	return scripts :: {[string]: ScriptFile}
end

function module.AddScript(name: string, source: string): ()
	scripts[name] = {
		Name = name,
		Source = source,
		IsSaved = true,
		ScriptInstance = nil :: Script?,
	}
end

function module.UpdateScript(name: string, source: string): ()
	(scripts[name] or error("Script not found")).Source = source
end

function module.DeleteScript(name: string): ()
	scripts[name] = nil
end

return module