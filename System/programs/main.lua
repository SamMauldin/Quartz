A.scratch:log("Building GUI")

A.draw.clear()

local x,y = A.draw.getSize()

local screen = A.gui.screen()

local pallet = A.gui.colorscheme()

local shutdown = A.gui.button(x-9, y-2, 8, 1, "Shutdown", pallet, os.shutdown)

local reboot = A.gui.button(3, y-2, 6, 1, "Reboot", pallet, os.reboot)

local user = A.gui.label(2, 4, "Username:", pallet)
local pass = A.gui.label(2, 6, "Password:", pallet)

local username = A.gui.textbox(12, 4, 10, pallet)
local password = A.gui.password(12, 6, 10, pallet)

screen:add(shutdown)
screen:add(reboot)
screen:add(user)
screen:add(pass)
screen:add(username)
screen:add(password)

A.scratch:log("Starting GUI")

screen:listen(true)