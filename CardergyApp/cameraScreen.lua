display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   topbarContainer = display.newContainer(display.contentWidth, 100)
   topbarContainer:translate(display.contentWidth * 0.5, -5)

   topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 100)
   topbarBackground:setFillColor(135/255,206/255,250/255)
   topbarContainer:insert(topbarBackground, true)

   local function menuEvent(event)

      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("videoRecord", options)

   end

   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })
   topbarContainer:insert(menuBtn, true)
   menuBtn.x = -140
   menuBtn.y = -10

   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.y = -10

   topbarContainer:insert(topbarInsignia)

   local function cameraEvent(event)
      local options = {
         effect = "slideLeft",
         time = 800
      }
      composer.gotoScene("qrScanner", options)

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
   cameraBtn.y = -10
   cameraBtn:addEventListener("tap",cameraEvent)

   local function onSearch(event)
      if ("began" == event.phase) then
      elseif ("editing" == event.phase) then
      elseif ("submitted" == event.phase) then
      elseif ("ended" == event.phase) then
      end
   end

   searchField = native.newTextField(0, 0, 300, 30)
   searchField.inputType = "default"
   searchField:setReturnKey("done")
   searchField.placeholder = "Search..."
   searchField:addEventListener("userInput", onSearch)
   topbarContainer:insert(searchField)
   searchField.y = 30
  
   topbarContainer.y = 50

   sceneGroup:insert(topbarContainer)
   --sceneGroup:insert(searchField)
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
      --[[local options = {
         effect = "slideLeft",
         time = 800
      }
      composer.gotoScene("profile", options)--]]
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