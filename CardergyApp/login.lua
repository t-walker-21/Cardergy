-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local crypto = require("crypto")
local user, pass
local regStr1 = ""
local backBtn,loginBtn = nil
local errOpts = nil
local sceneGroup = nil
local emptyUser,emptyPass = false
local userField, passField = nil

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
	local paint = {
	    type = "gradient",
	    color1 = {115/255,3/255,192/255},
	    color2 = {253/255,239/255,249/255},
	    direction = "down"
	}

	local bg = display.newRect(display.contentCenterX, display.contentCenterY, 320, 570)
	bg.fill = paint
	bg:toBack()
	sceneGroup:insert(bg)

	logTxt = display.newText("Sign In", display.contentCenterX, display.contentCenterY-130, native.systemFont, 32)
	sceneGroup:insert(logTxt)

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

	local function loginEvent(event)
		user = userField.text
		pass = crypto.digest(crypto.sha1, passField.text)
		logStr = "login:"..user..":"..pass.."\n"
		composer.setVariable("logStr", logStr)
		composer.setVariable("pass", "")

		tcp:connect(host, port)
		tcp:send(logStr)
   		local s, status, partial = tcp:receive()
   		tcp:close()

   		if (s == "login_incorrect") then
   			changeError(nil, "ERROR", "Username or password was incorrect.")
   			composer.showOverlay("error", errOpts)
   		elseif (s == "login_fail") then
   			changeError(nil, "ERROR", "Database problem. Try again later.")
			composer.showOverlay("error", errOpts)
   		else
   			composer.setVariable("pass", "logScene")
   			changeError(nil, "SUCCESS", "Login successful.")
			composer.showOverlay("error", errOpts)
		end

		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
	end

	local function validateInput()
		display.remove(loginBtn)
		if (emptyUser == true and emptyPass) then
			loginBtn = widget.newButton(
			{
				label = "Login",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = loginEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={1,1,1}, over={1,0,0.5}}
			})
			loginBtn.x = display.contentCenterX
			loginBtn.y = display.contentCenterY + 60
			loginBtn:setEnabled(true)
			sceneGroup:insert(loginBtn)
		else
			loginBtn = widget.newButton(
			{
				label = "Login",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = loginEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
				labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
			})
			loginBtn.x = display.contentCenterX
			loginBtn.y = display.contentCenterY + 60
			loginBtn:setEnabled(false)
			sceneGroup:insert(loginBtn)
		end
	end

	local function onUser(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			emptyUser = false
			validateInput()
		elseif ("submitted" == event.phase) then
	   		if (userField.text ~= "") then
				emptyUser = true
				validateInput()
			else
				emptyUser = false
				validateInput()
			end

			native.setKeyboardFocus(passField)
		elseif ("ended" == event.phase) then
	   		if (userField.text ~= "") then
				emptyUser = true
				validateInput()
			else
				emptyUser = false
				validateInput()
			end
		end
	end

	local function onPass(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			emptyPass = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (passField.text ~= "") then
				emptyPass = true
				validateInput()
			else
				emptyPass = false
				validateInput()
			end

			native.setKeyboardFocus(confirmField)
		elseif ("ended" == event.phase) then
			if (passField.text ~= "") then
				emptyPass = true
				validateInput()
			else
				emptyPass = false
				validateInput()
			end
		end
	end

	userField = native.newTextField(display.contentCenterX, display.contentCenterY-60, 240, 30)
	userField.inputType = "default"
	userField:setReturnKey("done")
	userField.placeholder = "Username"
	userField:addEventListener("userInput", onUser)

	passField = native.newTextField(display.contentCenterX, display.contentCenterY-20, 240, 30)
	passField.inputType = "default"
	passField:setReturnKey("done")
	passField.isSecure = true
	passField.placeholder = "Password"
	passField:addEventListener("userInput", onPass)

	sceneGroup:insert(userField)
	sceneGroup:insert(passField)

	loginBtn = widget.newButton(
	{
		label = "Login",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = loginEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
		labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
	})
	loginBtn.x = display.contentCenterX
	loginBtn.y = display.contentCenterY + 60
	loginBtn:setEnabled(false)
	sceneGroup:insert(loginBtn)

	local function backEvent(event)
		local options = {
			effect = "slideRight",
			time = 800
		}
		composer.gotoScene("start", options)
	end

	backBtn = widget.newButton(
	{
		label = "Back",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = backEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}},
	})
	backBtn.x = display.contentCenterX
	backBtn.y = display.contentCenterY + 135
	sceneGroup:insert(backBtn)

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
      composer.setVariable("back", 1)
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