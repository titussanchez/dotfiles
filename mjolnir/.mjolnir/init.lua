local alert = require "mjolnir.alert"
local application = require "mjolnir.application"
local fnutils = require "mjolnir.fnutils"
local grid = require "mjolnir.bg.grid"
local modal_hotkey = require "mjolnir._asm.modal_hotkey"
local window = require "mjolnir.window"

grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDWIDTH = 4
grid.GRIDHEIGHT = 4

k = modal_hotkey.new( {"ctrl", "cmd"}, "w" )

--- function k:entered() alert.show("Entered mjolnir") end
--- function k:exited() alert.show("Exited mjolnir") end

function focusAndExitMjolnir(name)
  application.launchorfocus(name)
  k:exit()
end

function pushwindow_lefthalf()
  local win = window.focusedwindow()
  local frame = { x = 0, y = 0, w = (grid.GRIDWIDTH / 2), h = grid.GRIDHEIGHT }
  grid.set(win, frame, win:screen())
end

function pushwindow_righthalf()
  local win = window.focusedwindow()
  local frame = { x = 2, y = 0, w = (grid.GRIDWIDTH / 2), h = grid.GRIDHEIGHT }
  grid.set(win, frame, win:screen())
end

function pushwindow_center()
  local win = window.focusedwindow()
  local frame = { x = .75, y = .75, w = (grid.GRIDWIDTH / 1.5), h = (grid.GRIDHEIGHT / 1.5) }
  grid.set(win, frame, win:screen())
end


k:bind({"ctrl", "cmd"}, 'w', function() k:exit() end)
k:bind({}, 'escape', function() k:exit() end)
k:bind({}, 'w', function() mjolnir.reload() k:exit() end)
k:bind({}, 'a', function() focusAndExitMjolnir("Adium") end)
k:bind({}, 'b', function() focusAndExitMjolnir("Google Chrome") end)
k:bind({}, 'c', function() focusAndExitMjolnir("iTerm") end)
k:bind({}, 'e', function() focusAndExitMjolnir("Eclipse") end)
k:bind({}, 'o', function() focusAndExitMjolnir("Microsoft OneNote") end)
k:bind({}, 'r', function() focusAndExitMjolnir("Royal TSX") end)
k:bind({}, 'v', function() focusAndExitMjolnir("MacVim") end)
k:bind({"ctrl"}, 'n', function() pushwindow_lefthalf() k:exit() end)
k:bind({"ctrl"}, 'i', function() grid.maximize_window() k:exit() end)
k:bind({"ctrl"}, 'o', function() pushwindow_righthalf() k:exit() end)
k:bind({"ctrl"}, 'y', function() pushwindow_center() k:exit() end)
k:bind({}, ']', function() grid.pushwindow_prevscreen() k:exit() end)
k:bind({}, '[', function() grid.pushwindow_nextscreen() k:exit() end)
