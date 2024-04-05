-- Objects
testWindow       = nil
testWindowButton = nil
jumpButton			 = nil

--Constants
local OFFSET_X = 10
local OFFSET_Y = 32

--Position Variables
local initialPosX = 0
local initialPosY = 0
local limitMoveX = 0
local limitMoveY = 0

--Size Variables
local windowWidth = 0
local windowHeight = 0
local windowPosition = 0
local buttonWidth = 0
local buttonHeight = 0

function online() -- callback on game start
  testWindowButton:show() -- show the icon button on client right top bar
end

function offline() -- callback on game end
  -- hide window and set the icon button on client right top bar to off
  testWindow:hide()
  testWindowButton:setOn(false)
end

function init()
  connect(g_game, { onGameStart = online,
                    onGameEnd   = offline}) -- Register callbacks on game state

  testWindow = g_ui.displayUI('test', modules.game_interface.getRightPanel()) -- Getting the panel object
  testWindow:hide() -- Hiding the panel on init()

  testWindowButton = modules.client_topmenu.addRightGameToggleButton('testWindowButton', tr('Test'), '/images/topbuttons/particles', toggle) -- Getting the icon button on client right top bar
  testWindowButton:setOn(false) -- Setting to off

  jumpButton = testWindow:recursiveGetChildById('buttonJump') -- Get the jump button object

  -- Getting the width, height and position of panel window and button to calculate position limits
  windowWidth = testWindow:getWidth()
  windowHeight = testWindow:getHeight()
  windowPosition = testWindow:getPosition()
  buttonWidth = jumpButton:getWidth()
  buttonHeight = jumpButton:getHeight()

  -- Calculating initial positions and limits of X and Y
  initialPosX = windowPosition.x + windowWidth - buttonWidth - OFFSET_X
  initialPosY = windowPosition.y + OFFSET_Y
  limitMoveX = windowPosition.x + OFFSET_X
  limitMoveY = windowPosition.y + windowHeight - buttonHeight - (OFFSET_Y/4)  
end

-- Here we move the jumpButton object position X with the value of OFFSET_X
function update()
	local buttonPosition = jumpButton:getPosition()
  buttonPosition.x = buttonPosition.x - OFFSET_X
  -- Here is the condition if the button reaches the limit on left side of the panel, it will move to the right side of the panel
  -- Otherwise will just set the position
  if(buttonPosition.x < limitMoveX) then
    resetButtonPosition()
  else
    jumpButton:setPosition(buttonPosition)
  end
end

function jumpClick() -- Here is the click callback of jumpButton object, will reset the button position
  resetButtonPosition()
end

-- this it the icon button on client right top bar click callback
-- will check if the window is visible of not
-- if is visible, will cancel move event and hide the window
-- Otherwise will show the window and start the jumpButton move event
function toggle()
  if testWindowButton:isOn() then
    if moveEvent then
      moveEvent:cancel()
    end
    testWindowButton:setOn(false)
    testWindow:hide()
  else
    testWindowButton:setOn(true)
    testWindow:show()
    testWindow:raise()
    testWindow:focus()
    resetButtonPosition()
  end
end

-- Here will reset the jumpButton position to initialPositionX in X, but will calculate a randomic position in Y inside the window height limit
-- Will cancel the move event if exists and start another one
function resetButtonPosition()
  jumpButton:move(initialPosX, math.random(initialPosY, limitMoveY))
  if moveEvent then
    moveEvent:cancel()
  end
  moveEvent = cycleEvent(update, 100)
end

-- Callback on close game
-- Will cancel the move event, disconnect game state callbacks and destroy objects
function terminate()
  if moveEvent then
    moveEvent:cancel()
  end
  
  disconnect(g_game, { onGameStart = online,
                       onGameEnd   = offline })

  testWindow:destroy()
  testWindowButton:destroy()
  jumpButton:destroy()
end