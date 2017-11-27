-----------------------------------------------------------------------------------------
--
-- login.lua
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

-- Function to set the keyboard focus back to the field that triggered the error
function scene:revertAlpha(field)
	--sceneGroup.alpha = 1
	native.setKeyboardFocus(field)
end

-- "scene:create()"
function scene:create( event )
 
   	sceneGroup = self.view

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
   	-- Create the login text
	logTxt = display.newText("Sign In", display.contentCenterX, display.contentCenterY-130, native.systemFont, 32)
	sceneGroup:insert(logTxt)

	-- Function to handle an error change
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

	-- Function to handle the login
	local function loginEvent(event)
		-- Store username and password
		user = userField.text
		pass = crypto.digest(crypto.sha1, passField.text)
		logStr = "login:"..user..":"..pass.."\n"
		composer.setVariable("logStr", logStr)
		composer.setVariable("pass", "")

		-- Send the username and password to the database for verification
		tcp:connect(host, port)
		tcp:send(logStr)
   		local s, status, partial = tcp:receive()
   		tcp:close()

   		-- Check if the login is invalid
   		if (s == "login_incorrect" or partial == "login_incorrect") then
   			changeError(nil, "ERROR", "Username or password was incorrect.")
   			composer.showOverlay("error", errOpts)
   		-- Check if the login failed
   		elseif (s == "login_fail" or partial == "login_fail") then
   			changeError(nil, "ERROR", "Database problem. Try again later.")
			composer.showOverlay("error", errOpts)
		-- Check if the login succeeded
   		else
   			composer.setVariable("passScene", "logScene")
   			composer.setVariable("user", user)
   			changeError(nil, "SUCCESS", "Login successful.")
			composer.showOverlay("error", errOpts)
		end
	end

	-- Validate the user input
	local function validateInput()
		-- Remove the login button
		display.remove(loginBtn)

		-- Check if the username and password fields are not empty
		if (emptyUser == true and emptyPass == true) then
			-- Enable the login button
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
		-- Check if the username and password fields are empty
		else
			-- Disable the login button 
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

	-- Function to handle editing the username field
	local function onUser(event)
		if ("began" == event.phase) then
		-- Check if the username field is being edited
		elseif ("editing" == event.phase) then
			emptyUser = false
			validateInput()
		-- Check if the username field has been submitted
		elseif ("submitted" == event.phase) then
	   		if (userField.text ~= "") then
				emptyUser = true
				validateInput()
			else
				emptyUser = false
				validateInput()
			end

			native.setKeyboardFocus(passField)
		-- Check if editing the username field has been ended
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

	-- Function to handle editing the password field
	local function onPass(event)
		if ("began" == event.phase) then
		-- Check if password field is being edited
		elseif ("editing" == event.phase) then
			emptyPass = false
			validateInput()
		-- Check if password field has been submitted
		elseif ("submitted" == event.phase) then
			if (passField.text ~= "") then
				emptyPass = true
				validateInput()
			else
				emptyPass = false
				validateInput()
			end

			native.setKeyboardFocus(confirmField)
		-- Check if editing the password field has ended
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

	-- Create the username field
	userField = native.newTextField(display.contentCenterX, display.contentCenterY-60, 240, 30)
	userField.inputType = "default"
	userField:setReturnKey("done")
	userField.placeholder = "Username"
	userField:addEventListener("userInput", onUser)

	-- Create the password field
	passField = native.newTextField(display.contentCenterX, display.contentCenterY-20, 240, 30)
	passField.inputType = "default"
	passField:setReturnKey("done")
	passField.isSecure = true
	passField.placeholder = "Password"
	passField:addEventListener("userInput", onPass)

	sceneGroup:insert(userField)
	sceneGroup:insert(passField)

	-- Create the login button
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

	-- Function to handle going back to the start scene
	local function backEvent(event)
		-- Go to the start scene
		local options = {
			effect = "slideRight",
			time = 800
		}
		composer.gotoScene("start", options)
	end

	-- Create the back button
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

	-- Function to handle removing the keyboard if runtime is pressed
	local function removeKeyboard()
		native.setKeyboardFocus(nil)
	end

	-- Add event listener for removing keyboard when runtime is preessed
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