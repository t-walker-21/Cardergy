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

password = "tevon"

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

	local paint = {
		type = "gradient",
		color1 = {248/255,181/255,0/255},
		color2 = {252/255,234/255,187/255},
		direction = "down"
	}

	local topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 60)
	topbarBackground.fill = paint
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

   topbarInsignia = display.newImageRect("logo_black.png", 100, 33)
   topbarInsignia.y = 10

   topbarContainer:insert(topbarInsignia)

   local function cameraEvent(event)
   end

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

   	orderTxt = display.newText("Order Summary", display.contentCenterX, display.contentCenterY-180, native.systemFont, 32)
   	sceneGroup:insert(orderTxt)

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

	Niall = composer.getVariable("Niall")
	orderImg = display.newImageRect(Niall.backImage,system.TemporaryDirectory,107,170)
	orderImg.x = display.contentCenterX - 90
	orderImg.y = display.contentCenterY - 70
	


	local function playVideo()
		print("hello there playVideo")
		media.playVideo(Niall.video,system.DocumentsDirectory,true)
	end


	msgField = native.newTextBox(display.contentCenterX, display.contentCenterY + 50, 250, 150)
	msgField.y = display.contentCenterY + 105
	msgField.inputType = "default"
	msgField:setReturnKey("done")
	msgField.isEditable = false
	msgField.size = 20
	msgField.isFontSizeScaled = false
	msgField.text = Niall.message
	sceneGroup:insert(msgField)
	rect = display.newImage("playbutt.png",120,120)
	rect.x = display.contentCenterX + 50
	rect.y = display.contentCenterY - 90
	rect:addEventListener("tap",playVideo)

	--recipient = display.newText("Recipient:" .. composer.getVariable("recipientUser"),display.contentCenterX+50, display.contentCenterY-10, native.systemFont, 17)


	sceneGroup:insert(msgField)
	sceneGroup:insert(rect)
	sceneGroup:insert(orderImg)
	sceneGroup:insert(orderTxt)
	--sceneGroup:insert(recipient)
	
	

	local function orderEvent(event) -- function to push card object to server and ftp video to user directory

		orderType = composer.getVariable("recipientFlag")
		sUser = composer.getVariable("user")

		if (orderType == "auto") then
			--
			rUser = composer.getVariable("recipientUser")
		else
			name = composer.getVariable("recipientName")
			address = composer.getVariable("recipientAddress")
			city = composer.getVariable("recipientCity")
			state = composer.getVariable("recipientState")
			zip = composer.getVariable("recipientZip")
		end

		

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
		tcp:send("cardgen:"..sUser..":"..rUser..":".."John Smith:123 Daisy Lane:Dallas:Texas:12345:"..Niall.message..":"..Niall.backImage..":"..fname)
		tcp:close()

		local options = {
			effect = "slideRight",
			time = 500
		}

		native.showAlert("SUCCESS","Your card was sent",{"OK"})

		composer.removeScene("home")
		composer.gotoScene("home",options)

	end

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