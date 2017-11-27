-----------------------------------------------------------------------------------------
--
-- manually.lua
--
-----------------------------------------------------------------------------------------

local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local name, address, city, state, zip
local writeMsgBtn = nil
local errorOpts = nil
local sceneGroup = nil
local stateMatch = false
local validName,validAddress,validCity,validState,validZip = false
local nameField, addressField, cityField, stateField, zipField = nil
local states = {"California", "Alabama", "Arkansas", "Arizona", "Alaska", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"};

-- Function to handle reverting back to the field that triggered an error
function scene:revertAlpha(field)
	--sceneGroup.alpha = 1
	native.setKeyboardFocus(field)
end

-- Function to show the search field if one exists
function scene:showSearch(event)
   return
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
   	  native.setKeyboardFocus(nil)
   	  -- Go to the item scene
      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("item", options)
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

   -- Function to handle pressing the menu button
   local function menuEvent(event)
   	  native.setKeyboardFocus(nil)
   	  -- Show the side menu overlay
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
   	-- Go to the camera scene
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

    -- Display recipient info title
   	recipientTxt = display.newText("Recipient Info", display.contentCenterX, display.contentCenterY-180, native.systemFont, 32)
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

	-- function to handle validating the recipient info
	local function writeMsgEvent(event)
		-- Verify state is valid
		for i=1,50 do
			if (states[i] == stateField.text) then
				stateMatch = true
				break
			end
		end	

		-- Check all fields using regex to make sure they are valid entries
		if (not(string.match(nameField.text, "^[%u][%l]* [%u][%l]*$"))) then
			----sceneGroup.alpha = 0.5
			changeError(nameField, "ERROR", "Name must be entered as \"First Last\" without the quotes.")
			composer.showOverlay("error", errOpts)
		elseif (string.len(nameField.text) > 50) then
			----sceneGroup.alpha = 0.5
			changeError(nameField, "ERROR", "Name cannot exceed 50 characters in length.")
			composer.showOverlay("error", errOpts)
		elseif (not(string.match(addressField.text, "^[%d]+ .+$"))) then
			----sceneGroup.alpha = 0.5
			changeError(addressField, "ERROR", "Address must start with a number followed by a space and the name.")
			composer.showOverlay("error", errOpts)
		elseif (string.find(addressField.text, "[^%w%.%-#, ]") ~= nil) then
			----sceneGroup.alpha = 0.5
			changeError(addressField, "ERROR", "Invalid characters in address.")
			composer.showOverlay("error", errOpts)
		elseif(string.len(addressField.text) > 64) then
			----sceneGroup.alpha = 0.5
			changeError(addressField, "ERROR", "Address cannot exceed 64 characters in length.")
			composer.showOverlay("error", errOpts)
		elseif (string.find(cityField.text, "[^%a%.- ]") ~= nil) then
			--sceneGroup.alpha = 0.5
			changeError(cityField, "ERROR", "City contains invalid characters.")
			composer.showOverlay("error", errOpts)
		elseif (not(string.match(cityField.text, "^[%u][%l%.-]*[ ]?.*$"))) then
			--sceneGroup.alpha = 0.5
			changeError(cityField, "ERROR", "Invalid city.")
			composer.showOverlay("error", errOpts)
		elseif (string.len(cityField.text) > 24) then
			--sceneGroup.alpha = 0.5
			changeError(cityField, "ERROR", "City cannot exceed 24 characters in length.")
			composer.showOverlay("error", errOpts)
		elseif (stateMatch == false) then
			----sceneGroup.alpha = 0.5
			changeError(stateField, "ERROR", "Invalid state.")
			composer.showOverlay("error", errOpts)
		elseif (string.find(zipField.text, "[^%d]") ~= nil) then
			--sceneGroup.alpha = 0.5
			changeError(zipField, "ERROR", "Invalid zip code.")
			composer.showOverlay("error", errOpts)
		elseif (string.len(zipField.text) ~= 5) then
			--sceneGroup.alpha = 0.5
			changeError(zipField, "ERROR", "Zip code must be exactly 5 digits in length.")
			composer.showOverlay("error", errOpts)
		-- Check if all user input is valid
		else
			-- Store recipient data
			name = nameField.text
			address = addressField.text
			city = cityField.text
			state = stateField.text
			zip = zipField.text
			
			-- Assign recipient data to composer globals
			composer.setVariable("recipientName", name)
			composer.setVariable("recipientAddress", address)
			composer.setVariable("recipientCity", city)
			composer.setVariable("recipientState", state)
			composer.setVariable("recipientZip", zip)
			composer.setVariable("recipientFlag", "manual")

			-- Go to message scene
			local options = {
				effect = "slideLeft",
				time = 800
			}
			composer.gotoScene("message", options)
		end

		stateMatch = false
		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
	end

	-- Validate user input
	local function validateInput()
		-- Remove the message button
		display.remove(writeMsgBtn)

		-- Check if recipient info fields are not empty
		if (validName == true and validAddress == true and validCity == true and validState == true and validZip == true) then
			writeMsgBtn = widget.newButton(
			{
				label = "Write Message",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = writeMsgEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={1,1,1}, over={1,0,0.5}}
			})
			writeMsgBtn.x = display.contentCenterX
			writeMsgBtn.y = display.contentCenterY + 115
			writeMsgBtn:setEnabled(true)
			sceneGroup:insert(writeMsgBtn)
		-- Check if recipient info fields are empty
		else
			writeMsgBtn = widget.newButton(
			{
				label = "Write Message",
				fontSize = 20,
				font = native.systemFontBold,
				emboss = true,
				onRelease = writeMsgEvent,
				shape = "roundedRect",
				width = 220,
				height = 60,
				cornerRadius = 30,
				fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
				labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
			})
			writeMsgBtn.x = display.contentCenterX
			writeMsgBtn.y = display.contentCenterY + 115
			writeMsgBtn:setEnabled(false)
			sceneGroup:insert(writeMsgBtn)
		end
	end

	-- Function to handle editing the name field
	local function onName(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validName = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (nameField.text ~= "") then
				validName = true
				validateInput()
			else
				validName = false
				validateInput()
			end

			native.setKeyboardFocus(addressField)
		elseif ("ended" == event.phase) then
			if (nameField.text ~= "") then
				validName = true
				validateInput()
			else
				validName = false
				validateInput()
			end
		end
	end

	-- Function to handle editing the address field
	local function onAddress(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validAddress = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (addressField.text ~= "") then
				validAddress = true
				validateInput()
			else
				validAddress = false
				validateInput()
			end

			native.setKeyboardFocus(cityField)
		elseif ("ended" == event.phase) then
			if (addressField.text ~= "") then
				validAddress = true
				validateInput()
			else
				validAddress = false
				validateInput()
			end
		end
	end

	-- Function to handle editing the city field
	local function onCity(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validCity = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (cityField.text ~= "") then
				validCity = true
				validateInput()
			else
				validCity = false
				validateInput()
			end

			native.setKeyboardFocus(stateField)
		elseif ("ended" == event.phase) then
			if (cityField.text ~= "") then
				validCity = true
				validateInput()
			else
				validCity = false
				validateInput()
			end
		end
	end

	-- Function to handle editing the state field
	local function onState(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validState = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (stateField.text ~= "") then
				validState = true
				validateInput()
			else
				validName = false
				validateInput()
			end

			native.setKeyboardFocus(zipField)
		elseif ("ended" == event.phase) then
			if (stateField.text ~= "") then
				validState = true
				validateInput()
			else
				validState = false
				validateInput()
			end
		end
	end

	-- Function to handle editing the zip code field
	local function onZip(event)
		if ("began" == event.phase) then
		elseif ("editing" == event.phase) then
			validZip = false
			validateInput()
		elseif ("submitted" == event.phase) then
			if (zipField.text ~= "") then
				validZip = true
				validateInput()
			else
				validZip = false
				validateInput()
			end

			native.setKeyboardFocus(nil)
		elseif ("ended" == event.phase) then
			if (zipField.text ~= "") then
				validZip = true
				validateInput()
			else
				validZip = false
				validateInput()
			end
		end
	end

	-- Create the name field
	nameField = native.newTextField(display.contentCenterX, display.contentCenterY-130, 240, 30)
	nameField.inputType = "default"
	nameField:setReturnKey("done")
	nameField.placeholder = "Name: First Last"
	nameField:addEventListener("userInput", onName)

	-- Creeate the address field
	addressField = native.newTextField(display.contentCenterX, display.contentCenterY-90, 240, 30)
	addressField.inputType = "default"
	addressField:setReturnKey("done")
	addressField.placeholder = "Street Address"
	addressField:addEventListener("userInput", onAddress)

	-- Create the city field
	cityField = native.newTextField(display.contentCenterX, display.contentCenterY-50, 240, 30)
	cityField.inputType = "default"
	cityField:setReturnKey("done")
	cityField.placeholder = "City"
	cityField:addEventListener("userInput", onCity)

	-- Create the state field
	stateField = native.newTextField(display.contentCenterX, display.contentCenterY-10, 240, 30)
	stateField.inputType = "default"
	stateField:setReturnKey("done")
	stateField.placeholder = "State"
	stateField:addEventListener("userInput", onState)

	-- Create the zip coe field
	zipField = native.newTextField(display.contentCenterX, display.contentCenterY+30, 240, 30)
	zipField.inputType = "default"
	zipField:setReturnKey("done")
	zipField.placeholder = "Zip Code"
	zipField:addEventListener("userInput", onZip)

	sceneGroup:insert(nameField)
	sceneGroup:insert(addressField)
	sceneGroup:insert(cityField)
	sceneGroup:insert(stateField)
	sceneGroup:insert(zipField)

	-- Create the message button
	writeMsgBtn = widget.newButton(
	{
		label = "Write Message",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = writeMsgEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={211/255,211/255,211/255}, over={1,0,0.5}},
		labelColor = {default={169/255,169/255,169/255}, over={0,0,0.5}}
	})
	writeMsgBtn.x = display.contentCenterX
	writeMsgBtn.y = display.contentCenterY + 115
	writeMsgBtn:setEnabled(true)
	sceneGroup:insert(writeMsgBtn)

	-- Function to handle removing the keyboard from runtime when it is pressed
	local function removeKeyboard()
		native.setKeyboardFocus(nil)
	end

	-- Add event listender for removing keyboard from runtime after it is pressed
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