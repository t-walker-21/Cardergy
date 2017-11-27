-----------------------------------------------------------------------------------------
--
-- message.lua
--
-----------------------------------------------------------------------------------------

local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local name, address, city, state, zip
local recVidBtn = nil
local errorOpts = nil
local sceneGroup = nil
local validMsg = false
local msgField = nil

-- Function to handle reverting back to the field that triggered the error
function scene:revertAlpha(field)
	--sceneGroup.alpha = 1
	native.setKeyboardFocus(field)
end

-- Function to show the message field
function scene:showSearch()
	msgField.isVisible = true
end

-- "scene:create()"
function scene:create( event )
 
   	sceneGroup = self.view

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
   	-- Create top bar menu
	local topbarContainer = display.newContainer(display.contentWidth, 60)
   	topbarContainer:translate(display.contentWidth * 0.5, -5)
	local paint = {
		type = "gradient",
		color1 = {248/255,181/255,0/255},
		color2 = {252/255,234/255,187/255},
		direction = "down"
	}
	local topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 60)
	topbarBackground.fill = paint
	topbarContainer:insert(topbarBackground, true)
   
   -- Function to handle going back to the previous scene
   local function backIcnEvent(event)
   		-- Remove the keyboard from the screen
   		native.setKeyboardFocus(nil)

   		-- Get the previous scene
   		local backScene = composer.getSceneName("previous")

   		-- Go to the previous scene
		local options = {
			effect = "slideRight",
			time = 800
		}
		composer.gotoScene(backScene, options)
   end

   -- Create the back button
   backIcn = widget.newButton({
      width = 30,
      height = 30,
      defaultFile = "back_icon.png",
      --overFile = "back_pressed.png"
      onRelease = backIcnEvent
   }) 
   topbarContainer:insert(backIcn)
   backIcn.x = -140
   backIcn.y = 10

   	-- Function to handle the menu button being pressed
	function menuEvent(event)
		-- Hide the message field 
		msgField.isVisible = false

		-- Remove the keyboard from the screen
		native.setKeyboardFocus(nil)

		-- Show the menu overlay
		local options = {
		  isModal = true,
		  effect = "slideRight",
		  time = 400
		}
		composer.showOverlay("menu", options)
	end

   -- Create the menu button
   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })
   topbarContainer:insert(menuBtn, true)
   menuBtn.x = -105
   menuBtn.y = 10

   topbarInsignia = display.newImageRect("logo_black.png", 100, 33)
   topbarInsignia.y = 10

   topbarContainer:insert(topbarInsignia)

   -- Function to handle pressing the camera button
   local function cameraEvent(event)
   	msgField.isVisible = false
   	-- Go to the QR scanner scene
   	composer.gotoScene("qrScanner")
   end

   -- Create the camera button
   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRelease = cameraEvent
   })
   topbarContainer:insert(cameraBtn)
   cameraBtn.x = 140
   cameraBtn.y = 10

   topbarContainer.y = 30

   sceneGroup:insert(topbarContainer)

    -- Show the custom message title
   	recipientTxt = display.newText("Custom Message", display.contentCenterX, display.contentCenterY-180, native.systemFont, 32)
   	sceneGroup:insert(recipientTxt)

   	-- Function to handle changing the error
	local function changeError(f, t, s)
		errOpts = {
			isModal = true,
			effect = "fade",
			time = 400,
			params = {
				errTitle = t,
				errStr = s,
				errField = f
			}
		}
	end

	-- Function to handle going to the recording video scene
	local function recVidEvent(event)
		-- Validate message input
		if (string.len(msgField.text) > 1200) then
			----sceneGroup.alpha = 0.5
			changeError(msgField, "ERROR", "Message has gone over the 1200 character limit.")
			composer.showOverlay("error", errOpts)
		-- Check if valid input has been used
		else
			-- Store the message
			msg = msgField.text
			
			-- Set the message on the global card object
			Niall = composer.getVariable("Niall")
			Niall:setMessage(msg)
			composer.setVariable("Niall", Niall)
			
			-- Go to the video recording scene
			local options = {
				effect = "slideLeft",
				time = 800
			}
			composer.gotoScene("videoRecord", options)
		end

		stateMatch = false
		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
	end

	-- Validate the user's input
	local function validateInput()
		display.remove(recVidBtn)

		-- Check if message field is not empty
		if (validMsg == true) then
			recVidBtn = widget.newButton(
			{
				label = "Record Video",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = recVidEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={1,1,1}, over={1,0,0.5}}
			})
			recVidBtn.x = display.contentCenterX
			recVidBtn.y = display.contentCenterY + 200
			recVidBtn:setEnabled(true)
			sceneGroup:insert(recVidBtn)
		-- Check if message field is empty
		else
			recVidBtn = widget.newButton(
			{
				label = "Record Video",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = recVidEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
				labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
			})
			recVidBtn.x = display.contentCenterX
			recVidBtn.y = display.contentCenterY + 200
			recVidBtn:setEnabled(false)
			sceneGroup:insert(recVidBtn)
		end
	end

	-- Function to handle editing the message
	local function onMsg(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validMsg = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (msgField.text ~= "") then
				validMsg = true
				validateInput()
			else
				validMsg = false
				validateInput()
			end

			native.setKeyboardFocus(nil)
		elseif ("ended" == event.phase) then
			if (msgField.text ~= "") then
				validMsg = true
				validateInput()
			else
				validMsg = false
				validateInput()
			end
		end
	end

	-- Create the message field
	msgField = native.newTextBox(display.contentCenterX, display.contentCenterY, 300, 300)
	msgField.inputType = "default"
	--msgField:setReturnKey("done")
	msgField.placeholder = "Write a message to your\nselected recipient..."
	msgField.isEditable = true
	msgField.size = 20
	msgField.isFontSizeScaled = false
	msgField:addEventListener("userInput", onMsg)

	sceneGroup:insert(msgField)

	-- Create the video record button
	recVidBtn = widget.newButton(
	{
		label = "Record Video",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = recVidEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
		labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
	})
	recVidBtn.x = display.contentCenterX
	recVidBtn.y = display.contentCenterY+ 200
	recVidBtn:setEnabled(true)
	sceneGroup:insert(recVidBtn)

	-- Function to handle removing the keyboard from the screen if runtime is pressed
	local function removeKeyboard()
		native.setKeyboardFocus(nil)
	end

	-- Add tap event listener for removing keyboard from screen after runtime is pressed
	Runtime:addEventListener("tap", removeKeyboard)
end

-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      msgField.isVisible = true
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
      composer.setVariable("passScene", "")
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