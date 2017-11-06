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
local user, pass, confirm, email, phone
local regStr1 = ""
local backBtn,continueBtn = nil
local errOpts = nil
local sceneGroup = nil
local previous = false
local validUser,validPass,validConfirm,validEmail,validPhone = false
local userField, passField, confirmField, emailField, phoneField = nil

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

	regTxt = display.newText("Registration", display.contentCenterX, display.contentCenterY-200, native.systemFont, 32)
	sceneGroup:insert(regTxt)

	local function continueEvent(event)
		user = userField.text
		pass = crypto.digest(crypto.sha1, passField.text)
		email = emailField.text
		phone = phoneField.text
		regStr1 = "register:"..user..":"..pass..":"..email..":"..phone..":"
		composer.setVariable("regStr1", regStr1)
		
		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
		
		if (previous == false) then
			sceneGroup:remove(regTxt)
			g:insert(regTxt)
			sceneGroup:remove(backBtn)
			g:insert(backBtn)
		end
		local options = {
			effect = "slideLeft",
			time = 800
		}

		composer.gotoScene("register2", options)
	end

	local function validateInput()
		display.remove(continueBtn)
		if (validUser == true and validPass == true and validConfirm == true and validEmail == true and validPhone == true) then
			continueBtn = widget.newButton(
			{
				label = "Continue",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = continueEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={1,1,1}, over={1,0,0.5}}
			})
			continueBtn.x = display.contentCenterX
			continueBtn.y = display.contentCenterY + 115
			continueBtn:setEnabled(true)
			sceneGroup:insert(continueBtn)
		else
			continueBtn = widget.newButton(
			{
				label = "Continue",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = continueEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
				labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
			})
			continueBtn.x = display.contentCenterX
			continueBtn.y = display.contentCenterY + 115
			continueBtn:setEnabled(false)
			sceneGroup:insert(continueBtn)
		end
	end

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

	local function onUser(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validUser = false
			validateInput()
		elseif ("submitted" == event.phase) then
			tcp:connect(host, port)
			tcp:send("username:"..userField.text)
	   		local s, status, partial = tcp:receive()
	   		tcp:close()

	   		if (s == "user_taken") then
				changeError(userField, "ERROR", "Username has already been taken.")
				composer.showOverlay("error", errOpts)
			elseif (string.find(userField.text,"^[^%a]") ~= nil) then
				--sceneGroup.alpha = 0.5
				changeError(userField, "ERROR", "Username must start with an uppercase or lowercase letter.")
				composer.showOverlay("error", errOpts)
			elseif (string.find(userField.text,"[^%w%._]") ~= nil) then
				--sceneGroup.alpha = 0.5
				changeError(userField, "ERROR", "Username can only be alphanumeric and have .'s, and _'s.")
				composer.showOverlay("error", errOpts)
			elseif (string.len(userField.text) < 6 or string.len(userField.text) > 25) then
				--sceneGroup.alpha = 0.5
				changeError(userField, "ERROR", "Username must be 6 to 25 characters in length.")
				composer.showOverlay("error", errOpts)
			else
				validUser = true
				validateInput()
				native.setKeyboardFocus(passField)
			end
		end
	end

	local function onPass(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validPass = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (string.len(passField.text) < 8 or string.len(passField.text) > 32) then
				--sceneGroup.alpha = 0.5
				changeError(passField, "ERROR", "Password must be 8 to 32 characters in length.")
				composer.showOverlay("error", errOpts)
			else
				validPass = true
				validateInput()
				native.setKeyboardFocus(confirmField)
			end
		end
	end

	local function onConfirm(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validConfirm = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (confirmField.text ~= passField.text) then
				--sceneGroup.alpha = 0.5
				changeError(confirmField, "ERROR", "Passwords do not match.")
				composer.showOverlay("error", errOpts)
			else
				validConfirm = true
				validateInput()
				native.setKeyboardFocus(emailField)
			end
		end
	end

	local function onEmail(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validEmail = false
			validateInput()
		elseif ("submitted" == event.phase) then
			tcp:connect(host, port)
			tcp:send("email:"..emailField.text)
	   		local s, status, partial = tcp:receive()
	   		tcp:close()

	   		if (s == "email_taken") then
				changeError(emailField, "ERROR", "Email has already been taken.")
				composer.showOverlay("error", errOpts)
			elseif (not(string.match(emailField.text, "^[%w%.%%%+%-_]+@[%w%.%%%+%-_]+%.[%w]+$"))) then
				--sceneGroup.alpha = 0.5
				changeError(emailField, "ERROR", "Invalid email.")
				composer.showOverlay("error", errOpts)
			elseif(string.len(emailField.text) > 50) then
				--sceneGroup.alpha = 0.5
				changeError(emailField, "ERROR", "Email cannot exceed 50 characters in length.")
				composer.showOverlay("error", errOpts)
			else
				validEmail = true
				validateInput()
				native.setKeyboardFocus(phoneField)
			end
		end
	end

	local function onPhone(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validPhone = false
			validateInput()
		elseif ("submitted" == event.phase) then
			tcp:connect(host, port)
			tcp:send("phone:"..phoneField.text)
	   		local s, status, partial = tcp:receive()
	   		tcp:close()

	   		if (s == "phone_taken") then
				changeError(emailField, "ERROR", "Phone number has already been taken.")
				composer.showOverlay("error", errOpts)
			elseif (string.find(phoneField.text, "[^%d]") ~= nil) then
				--sceneGroup.alpha = 0.5
				changeError(phoneField, "ERROR", "Invalid phone number.")
				composer.showOverlay("error", errOpts)
			elseif (string.len(phoneField.text) ~= 10) then
				--sceneGroup.alpha = 0.5
				changeError(phoneField, "ERROR", "Phone number must be exactly 10 digits in length.")
				composer.showOverlay("error", errOpts)
			else
				validPhone = true
				validateInput()
				native.setKeyboardFocus(nil)
			end
		end
	end

	userField = native.newTextField(display.contentCenterX, display.contentCenterY-130, 240, 30)
	userField.inputType = "default"
	userField:setReturnKey("done")
	userField.placeholder = "Username"
	userField:addEventListener("userInput", onUser)

	passField = native.newTextField(display.contentCenterX, display.contentCenterY-90, 240, 30)
	passField.inputType = "default"
	passField:setReturnKey("done")
	passField.isSecure = true
	passField.placeholder = "Password"
	passField:addEventListener("userInput", onPass)

	confirmField = native.newTextField(display.contentCenterX, display.contentCenterY-50, 240, 30)
	confirmField.inputType = "default"
	confirmField:setReturnKey("done")
	confirmField.isSecure = true
	confirmField.placeholder = "Confirm Password"
	confirmField:addEventListener("userInput", onConfirm)

	emailField = native.newTextField(display.contentCenterX, display.contentCenterY-10, 240, 30)
	emailField.inputType = "default"
	emailField:setReturnKey("done")
	emailField.placeholder = "Email"
	emailField:addEventListener("userInput", onEmail)

	phoneField = native.newTextField(display.contentCenterX, display.contentCenterY+30, 240, 30)
	phoneField.inputType = "default"
	phoneField:setReturnKey("done")
	phoneField.placeholder = "Phone: XXXXXXXXXX"
	phoneField:addEventListener("userInput", onPhone)

	sceneGroup:insert(userField)
	sceneGroup:insert(passField)
	sceneGroup:insert(confirmField)
	sceneGroup:insert(emailField)
	sceneGroup:insert(phoneField)

	continueBtn = widget.newButton(
	{
		label = "Continue",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = continueEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
		labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
	})
	continueBtn.x = display.contentCenterX
	continueBtn.y = display.contentCenterY + 115
	continueBtn:setEnabled(false)
	sceneGroup:insert(continueBtn)

	local function backEvent(event)
		local options = {
			effect = "slideRight",
			time = 800
		}
		back = composer.getVariable("back")
		if (back == 1) then
			sceneGroup:insert(backBtn)
			sceneGroup:insert(regTxt)
			previous = false
			composer.gotoScene("start", options)
		else
			previous = true
			composer.gotoScene("register1", options)
		end
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
	backBtn.y = display.contentCenterY + 190
	sceneGroup:insert(backBtn)

	local function removeKeyboard()
		-- add code to validate fields here too
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