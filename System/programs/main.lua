A.draw.clear()

function main()

A.scratch:log("Building GUI")

A.draw.clear()

local x,y = A.draw.getSize()

local screen = A.gui.screen()

local pallet = A.gui.colorscheme()

local shutdown = A.gui.button(x-9, y-2, 8, 1, "Shutdown", pallet, os.shutdown)

local reboot = A.gui.button(3, y-2, 6, 1, "Reboot", pallet, os.reboot)

local user = A.gui.label(2, 2, "Username:", pallet)
local pass = A.gui.label(2, 4, "Password:", pallet)

local username = A.gui.textbox(12, 2, 10, pallet)
local password = A.gui.password(12, 4, 10, pallet)

screen:add(shutdown)
screen:add(reboot)
screen:add(user)
screen:add(pass)
screen:add(username)
screen:add(password)

A.scratch:log("Starting GUI")

screen:listen(true)
end

local upsettings = A.data.open("/Library/Settings/updater", {
	devel = true,
	confirm = true
})

os.run({["runTime"] = "main"}, "/System/programs/updater.lua")

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
			end)

			local no = A.gui.button(2, 3, 3, 1, "No", pallet, function()
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
	end
end