local x,y = A.draw.getSize()

function install()
	data.save("/Library/Settings/users.json", {
		[
			{
				user = user.getText(),
				pass = A.hash.sha(pass.getText())
			}
		]
	})
	os.reboot()
end

A.draw.clear()

local screen = A.gui.screen()

local pallet = A.gui.colorscheme()

local shutdown = A.gui.button(x-9, y-2, 8, 1, "Shutdown", pallet, os.shutdown)
local reboot = A.gui.button(3, y-2, 6, 1, "Reboot", pallet, os.reboot)
local register = A.gui.button(2, 7, 8, 1, "Register", pallet, install)

local user = A.gui.label(2, 3, "Username:", pallet)
local pass = A.gui.label(2, 5, "Password:", pallet)
local installmsg = A.gui.label(2, 1, "Please choose a username and password", pallet)

local username = A.gui.textbox(12, 2, 10, pallet)
local password = A.gui.password(12, 4, 10, pallet)

screen:add(shutdown)
screen:add(reboot)
screen:add(register)
screen:add(user)
screen:add(pass)
screen:add(installmsg)
screen:add(username)
screen:add(password)

screen:listen()