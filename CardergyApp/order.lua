-----------------------------------------------------------------------------------------
--
-- order.lua
--
-----------------------------------------------------------------------------------------

local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local ftp = require("socket.ftp") -- ftp socket namespace
local tcp = assert(socket.tcp())
local name, address, city, state, zip
local orderBtn = nil
local errorOpts = nil
local sceneGroup = nil
local validMsg = false
local msgField = nil
local completionSound = audio.loadSound("cardSent.m4a")

password = "tevon"

name = "null"
address = "null"
city = "null"
state = "null"
zip = "null"
rUser = "null"

-- Function to handle reverting to the field that triggered the error
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
   	local g = display.newGroup()

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
   	-- Create the top bar menu
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

		-- Show the side menu
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

   -- Function to handle going to the QR scanner
   local function cameraEvent(event)
   	-- Go to te QR scanner
   	msgField.isVisible = false
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

    -- Show the order summary title
   	orderTxt = display.newText("Order Summary", display.contentCenterX, display.contentCenterY-180, native.systemFont, 32)
   	sceneGroup:insert(orderTxt)

   	-- Function to change the error
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

	-- Get message from card object
	Niall = composer.getVariable("Niall")

	-- Display the card object's design image
	orderImg = display.newImageRect(Niall.backImage,system.TemporaryDirectory,107,170)
	orderImg.x = display.contentCenterX - 70
	orderImg.y = display.contentCenterY - 70

	-- Function to handle playing the card object's video
	local function playVideo()
		media.playVideo(Niall.video,system.DocumentsDirectory,true)
	end

	-- Create the message field
	msgField = native.newTextBox(display.contentCenterX, display.contentCenterY + 50, 250, 150)
	msgField.y = display.contentCenterY + 105
	msgField.inputType = "default"
	msgField:setReturnKey("done")
	msgField.isEditable = false
	msgField.size = 20
	msgField.isFontSizeScaled = false
	msgField.text = Niall.message
	sceneGroup:insert(msgField)

	-- Display the play button to play the card object's stored video
	rect = display.newImage("playbutt.png",120,120)
	rect.x = display.contentCenterX + 60
	rect.y = display.contentCenterY - 90
	-- Add event listener to play video after play button is pressed
	rect:addEventListener("tap",playVideo)

	-- Check if the recipient was searched in the database
	if (composer.getVariable("recipientFlag") == "auto") then
		recipient = display.newText("Recipient: "..composer.getVariable("recipientUser"),display.contentCenterX+65, display.contentCenterY-10, native.systemFont, 12)
	-- Check if the recipient was manually entered
	else
		recipient = display.newText("Recipient: "..composer.getVariable("recipientName"),display.contentCenterX+65, display.contentCenterY-10, native.systemFont, 12)
	end

	sceneGroup:insert(msgField)
	sceneGroup:insert(rect)
	sceneGroup:insert(orderImg)
	sceneGroup:insert(orderTxt)
	sceneGroup:insert(recipient)

	-- Function to handle the order
	local function orderEvent(event) 
		-- Get the order type and sending user
		orderType = composer.getVariable("recipientFlag")
		sUser = composer.getVariable("user")

		-- Check if the recipient was searched in the database
		if (orderType == "auto") then
			-- Get the recipient's username
			rUser = composer.getVariable("recipientUser")
		-- Check if the recipient was manually entered
		else
			-- Get the recipient's info
			name = composer.getVariable("recipientName")
			address = composer.getVariable("recipientAddress")
			city = composer.getVariable("recipientCity")
			state = composer.getVariable("recipientState")
			zip = composer.getVariable("recipientZip")
			
		end
		
		-- Store video in system's documens directory
		local sourcePath = system.pathForFile("tempVid.mov", system.DocumentsDirectory)

   		file, errorString = io.open(sourcePath,"r") -- open file for reading with path

		local contents = file:read("*a") -- read contents of file into contents

		fname = crypto.digest(crypto.sha1, contents)
		fname = fname .. ".mov"

		f,e = ftp.put("ftp://tjw0018:".. password .."@34.230.251.252/var/www/html/profiles/"..sUser.."/videos/"..fname..";type=i",contents) --login to ftp server and upload file at given directory using binary mode (not ascii)

		file:close() --close file pointer--

		tcp:connect("34.230.251.252", 40001)
		tcp:send("qrgen:/var/www/html/profiles/"..sUser.."/videos/"..fname)
		tcp:close()

		tcp:connect("34.230.251.252", 40001)
		tcp:send("cardgen:"..sUser..":"..rUser..":"..name..":"..address..":"..city..":"..state..":"..zip..":"..Niall.message..":"..Niall.backImage..":"..Niall.category..":"..fname)
		tcp:close()

		local options = {
			effect = "slideRight",
			time = 800
		}

		-- Function to go home on completion of the order
		function onComplete()
			-- Go to home scene
			composer.gotoScene("home",options)
		end

		-- Show alert to notify sender that his or her order has been sent successfully

		
		audio.play(completionSound)

		native.showAlert("SUCCESS","Your card was sent",{"OK"},onComplete)
	end

	-- Create the order button
	orderBtn = widget.newButton(
	{
		label = "Submit Order",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = orderEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}}
	})
	orderBtn.x = display.contentCenterX
	orderBtn.y = display.contentCenterY+ 225
	orderBtn:setEnabled(true)
	sceneGroup:insert(orderBtn)

	-- Function to remove keyboard after runtime is pressed
	local function removeKeyboard()
		native.setKeyboardFocus(nil)
	end

	-- Add tap event listener for runtime for removing keyboard when runtime is pressed
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
      --orderVid:play()
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
      -- Reset home scene
      composer.removeScene("home")
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