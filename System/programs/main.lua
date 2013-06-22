A.draw.clear()

local x,y = A.draw.getSize()

function main()

if not fs.exists("/Library/Settings/.done") then
	A.run("/System/programs/installer.lua", {["runTime"] = "main"})
	os.reboot()
end

A.scratch:log("Building GUI")

A.draw.clear()

local screen = A.gui.screen()

local pallet = A.gui.colorscheme()

local shutdown = A.gui.button(x-9, y-2, 8, 1, "Shutdown", pallet, os.shutdown)

local reboot = A.gui.button(3, y-2, 6, 1, "Reboot", pallet, os.reboot)

local user = A.gui.label(2, 2, "Username:", pallet)
local pass = A.gui.label(2, 4, "Password:", pallet)

local username = A.gui.textbox(12, 2, 10, pallet)
local password = A.gui.password(12, 4, 10, pallet)

local login = A.gui.button(2, 6, 5, 1, "Login", pallet, function()
	local user = username:getText()
	local pass = A.hash.sha(password:getText())
	local valid = false
	local admin = false
	for k,v in pairs(data.open("/Library/users.json", nil)) do
		if v[1] == user and v[2] == pass then
			valid = true
			admin = v[3]
		end
	end
	if valid then
		A.run("/rom/programs/shell", {["runTime"] = "login"})
	else
		pallet:apply("error")
		A.draw.clear()
		print("Invalid username/password")
		sleep(1)
	end
end)

screen:add(shutdown)
screen:add(reboot)
screen:add(user)
screen:add(pass)
screen:add(username)
screen:add(password)
screen:add(login)

A.scratch:log("Starting GUI")

screen:listen()
end

local upsettings = A.data.open("/Library/Settings/updater.json", {
	devel = true,
	confirm = true
})

A.run("/System/programs/updater.lua", {["runTime"] = "main"})

local updated, errored, err = A.updater.check(upsettings.devel)

if errored then
	A.scratch:log("Updater failed: " .. err)
	main()
else
	if not updated then
		if upsettings.confirm then

			local screen = A.gui.screen()
			local pallet = A.gui.colorscheme()

			local yes = A.gui.button(2, 3, 3, 1, "Yes", pallet, function()
				A.updater.update(upsettings.devel)
				os.reboot()
			end)

			local no = A.gui.button(x-2, 3, 2, 1, "No", pallet, function()
				A.draw.clear()
				main()
			end)

			local update = A.gui.label(2, 1, "An update is available, would you like to update?")

			screen:add(yes)
			screen:add(no)
			screen:add(update)

			screen:listen()
		else
			print("Updating system...")
			A.updater.update(upsettings.devel)
			os.reboot()
		end
	else
		main()
	end
end