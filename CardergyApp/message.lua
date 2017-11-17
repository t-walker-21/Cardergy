local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local name, address, city, state, zip
local recVidBtn = nil
local errorOpts = nil
local sceneGroup = nil
local validMsg = false

function scene:revertAlpha(field)
	--sceneGroup.alpha = 1
	native.setKeyboardFocus(field)
end

-- "scene:create()"
function scene:create( event )
 
   	sceneGroup = self.view
   	local g = display.newGroup()

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	local topbarContainer = display.newContainer(display.contentWidth, 60)
   topbarContainer:translate(display.contentWidth * 0.5, -5)

   local topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 60)
   topbarBackground:setFillColor(135/255,206/255,250/255)
   topbarContainer:insert(topbarBackground, true)

   local function backIcnEvent(event)
   		local backScene = composer.getSceneName("previous")

		local options = {
			effect = "slideRight",
			time = 800
		}

		composer.gotoScene(backScene, options)
   end

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

   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.y = 10

   topbarContainer:insert(topbarInsignia)

   local function cameraEvent(event)
   end

   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRlease = cameraEvent
   })
   topbarContainer:insert(cameraBtn)
   cameraBtn.x = 140
   cameraBtn.y = 10

   topbarContainer.y = 30

   sceneGroup:insert(topbarContainer)

   	recipientTxt = display.newText("Custom Message", display.contentCenterX, display.contentCenterY-180, native.systemFont, 32)
   	sceneGroup:insert(recipientTxt)

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

	local function recVidEvent(event)

		if (string.len(msgField.text) > 1200) then
			----sceneGroup.alpha = 0.5
			changeError(msgField, "ERROR", "Message has gone over the 1200 character limit.")
			composer.showOverlay("error", errOpts)
		else
			msg = msgField.text
			
			composer.setVariable("recipientMsg", msg)

			local options = {
				effect = "slideLeft",
				time = 800
			}

			composer.gotoScene("videoRecord", options)
		end

		stateMatch = false
		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
	end

	local function validateInput()
		display.remove(recVidBtn)
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

	msgField = native.newTextBox(display.contentCenterX, display.contentCenterY, 300, 300)
	msgField.inputType = "default"
	msgField:setReturnKey("done")
	msgField.placeholder = "Write a message to your\nselected recipient..."
	msgField.isEditable = true
	msgField.size = 20
	msgField.isFontSizeScaled = false
	msgField:addEventListener("userInput", onMsg)

	sceneGroup:insert(msgField)

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

	local function removeKeyboard()
		native.setKeyboardFocus(nil)
	end

	Runtime:addEventListener("tap", removeKeyboard)
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