-- Setup enviroment
A.updater = {}

-- Updater return format : (up to date) (error) (err message)
A.updater.check = function(devel)
	-- Check for http
	if not http then
		return false, true, "HTTP required"
	end
	-- Running devel version?
	local url
	if devel then
		url = "https://raw.github.com/Sxw1212/Quartz/devel/System/resources/json/updater.json"
	else
		url = "https://raw.github.com/Sxw1212/Quartz/master/System/resources/json/updater.json"
	end
	A.scratch:log("Grabbing updater.json")
	local fh = http.get(url)
	if fh then
		A.scratch:log("Sucess!")
		local update = A.json.decode(fh.readAll())
		A.scratch:log("Checking for updates")
		local current = A.data.open("/System/resources/json/updater.json", { version = "0" })
		if update.version == current.version then
			return true, false
		else
			return false, false
		end
	else
		return false, true, "Unable to get updater status"
	end
end

A.updater.update = function(devel)
	A.draw.clear()
	A.scratch:log("Updating system")
	A.draw.print("Updating system")
	-- Running devel version?
	local base
	local url
	if devel then
		base = "https://raw.github.com/Sxw1212/Quartz/devel"
		url = "https://raw.github.com/Sxw1212/Quartz/devel/System/resources/json/updater.json"
	else
		base = "https://raw.github.com/Sxw1212/Quartz/master"
		url = "https://raw.github.com/Sxw1212/Quartz/master/System/resources/json/updater.json"
	end
	local fh = http.get(url)
	if fh then
		local update = A.json.decode(fh.readAll())
		for k,v in pairs(update.files) do
			local new = http.get(base .. v)
			if new then
				A.file.write(v, new.readAll())
				A.scratch:log("Updated " .. v)
				A.draw.print("Updated " .. v)
			else
				A.scratch:log("Update failed at " .. v)
				error("Update failed!")
			end
		end
	end
end