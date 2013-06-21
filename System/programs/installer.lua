local x,y = A.draw.getSize()

function done()
	A.file.write("/Library/Settings/.done", "true")
	os.reboot()
end

function updater()
	local screen = A.gui.screen()

	local installmsg = A.gui.label(2, 1, "Please choose updater settings")

	local devel = A.gui.label(2, 3, "Devel:")
	local confirm = A.gui.label(2, 5, "Confirm:")

	local develcb = A.gui.checkbox(x-2, 3, nil, false)
	local confirmcb = A.gui.checkbox(x-2, 5, nil, true)

	local done = A.gui.button(2, 7, 4, 1, "Done", nil, function()
		A.data.save("/Library/Settings/updater.json", {
			devel = develcb.getValue(),
			confirm = confirmcb.getValue()
		})
		done()
	end)

	screen:add(installmsg)

	screen:add(devel)
	screen:add(confirm)
	screen:add(develcb)
	screen:add(confirmcb)

	screen:add(done)
	screen:listen()
end

function registerUser()
	A.draw.clear()

	local screen = A.gui.screen()

	local shutdown = A.gui.button(x-9, y-2, 8, 1, "Shutdown", nil, os.shutdown)
	local reboot = A.gui.button(3, y-2, 6, 1, "Reboot", nil, os.reboot)

	local user = A.gui.label(2, 3, "Username:")
	local pass = A.gui.label(2, 5, "Password:")
	local installmsg = A.gui.label(2, 1, "Please choose a username and password")

	local username = A.gui.textbox(12, 3, 10)
	local password = A.gui.password(12, 5, 10)

	local register = A.gui.button(2, 7, 8, 1, "Register", nil, function()
		A.data.save("/Library/Settings/users.json", {
			{username.getText(), A.hash.sha(password.getText()), true}
		})
		updater()
	end)

	screen:add(shutdown)
	screen:add(reboot)
	screen:add(register)
	screen:add(user)
	screen:add(pass)
	screen:add(installmsg)
	screen:add(username)
	screen:add(password)

	screen:listen()
end

registerUser()