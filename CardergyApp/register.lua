-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setDefault("background", 249,250,252)

local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view
   	local g = display.newGroup()

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	local bg = display.newImageRect("background1.jpg", 320, 570)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	bg:toBack()
	sceneGroup:insert(bg)

	local function onUser(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(passField)
			print(userField.text)
		end
	end

	local function onPass(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(confirmField)
		end
	end

	local function onConfirm(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(emailField)
		end
	end

	local function onEmail(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(phoneField)
		end
	end

	local function onPhone(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(nil)
		end
	end

	userField = native.newTextField(display.contentCenterX, display.contentCenterY-150, 240, 30)
	userField.inputType = "default"
	userField:setReturnKey("next")
	userField.placeholder = "Username"
	userField:addEventListener("userInput", onUser)
	sceneGroup:insert(userField)

	passField = native.newTextField(display.contentCenterX, display.contentCenterY-110, 240, 30)
	passField.inputType = "default"
	passField:setReturnKey("next")
	passField.placeholder = "Password"
	passField.isSecure = true
	passField:addEventListener("userInput", onPass)
	sceneGroup:insert(passField)

	confirmField = native.newTextField(display.contentCenterX, display.contentCenterY-70, 240, 30)
	confirmField.inputType = "default"
	confirmField:setReturnKey("next")
	confirmField.placeholder = "Confirm Password"
	confirmField.isSecure = true
	confirmField:addEventListener("userInput", onConfirm)
	sceneGroup:insert(confirmField)

	emailField = native.newTextField(display.contentCenterX, display.contentCenterY-30, 240, 30)
	emailField.inputType = "default"
	emailField:setReturnKey("next")
	emailField.placeholder = "Email"
	emailField:addEventListener("userInput", onEmail)
	sceneGroup:insert(emailField)

	phoneField = native.newTextField(display.contentCenterX, display.contentCenterY+10, 240, 30)
	phoneField.inputType = "default"
	phoneField:setReturnKey("done")
	phoneField.placeholder = "Phone #"
	phoneField:addEventListener("userInput", onPhone)
	sceneGroup:insert(phoneField)

	local function submitEvent()

		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
		userField:removeSelf()
		passField:removeSelf()
		confirmField:removeSelf()
		emailField:removeSelf()
		phoneField:removeSelf()
		composer.removeScene("register")
		composer.gotoScene("start")
	end

	local submitBtn = widget.newButton(
	{
		label = "Submit",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = submitEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}},
	})
	submitBtn.x = display.contentCenterX
	submitBtn.y = display.contentCenterY + 100
	sceneGroup:insert(submitBtn)
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene