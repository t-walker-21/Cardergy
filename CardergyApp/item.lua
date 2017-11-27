-----------------------------------------------------------------------------------------
--
-- item.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia

function scene:showSearch(event)
   return
end

-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   -- Create the topbar menu
   local topbarContainer = display.newContainer(display.contentWidth, 60)
   topbarContainer:translate(display.contentWidth * 0.5, -5)

   -- Format the topbar menu
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
      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("home", options)
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

   -- Show enlarged versions of the selected card's image, name, and category
   Niall = composer.getVariable("Niall")
   genreTxt = display.newText("Genre: "..Niall.category, display.contentCenterX, display.contentCenterY-210, native.systemFont, 24)
   styleTxt = display.newText("Style: "..Niall.name, display.contentCenterX, display.contentCenterY-180, native.systemFont, 24)
   genreTxt.anchorX = 0
   styleTxt.anchorX = 0
   genreTxt.x = 5
   styleTxt.x = 5
   card = display.newImageRect(Niall.backImage, system.TemporaryDirectory, 157, 250)
   card.x = display.contentCenterX
   card.y = display.contentCenterY - 20

   sceneGroup:insert(genreTxt)
   sceneGroup:insert(styleTxt)
   sceneGroup:insert(card)

   -- Function to handle continuing with the order
   local function continueEvent(event)
   	  -- Function to handle whether the user chooses to search for registered recipient or manually enter recipient info
      local function onComplete(event)
         local options = {
            effect = "slideLeft",
            time = 800
         }
         local i = event.index
         -- Check if search is selected
         if (i == 1) then
         	-- Go to auto search scene
            composer.gotoScene("search", options)
         -- Check if manually is selected
         elseif (i == 2) then
         	-- Go to manual entry scene
            composer.gotoScene("manually", options)
         end
      end

      -- Alert user to choose search for registered recipient and manually enter recipient info
      local alert = native.showAlert("Search or Enter Manually", "Would you like to search for your recipient or enter his or her data in manually?", {"Search", "Manually"}, onComplete)
   end

   -- Create continue button
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
      fillColor = {default={1,1,1}, over={1,0,0.5}},
   })
   continueBtn.x = display.contentCenterX
   continueBtn.y = display.contentCenterY + 165
   sceneGroup:insert(continueBtn)
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
      -- Clear the manual entry scene
      composer.removeScene("manually")
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
      composer.setVariable("passScene", "")
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