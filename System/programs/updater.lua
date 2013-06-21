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
	local fh = http.get(url)
	if fh then
		local update = A.json:decode(fh.readAll())
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
	-- Running devel version?
	if devel then
		local base = "https://raw.github.com/Sxw1212/Quartz/devel"
		local url = "https://raw.github.com/Sxw1212/Quartz/devel/System/resources/json/updater.json"
	else
		local base = "https://raw.github.com/Sxw1212/Quartz/master"
		local url = "https://raw.github.com/Sxw1212/Quartz/master/System/resources/json/updater.json"
	end
	local fh = http.get(url)
	if fh then
		local update = A.json:decode(fh.readAll())
		for k,v in pairs(update.files) do
			local new = http.get(base .. v)
			if new then
				A.file.write(v, new.readAll())
				A.scratch:log("Updated " .. v)
			else
				A.scratch:log("Update failed at " .. v)
				error("Update failed!")
			end
		end
	end
end