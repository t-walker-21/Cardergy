display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local crypto = require("crypto")

-------------------------Variables-----------------------------------------------
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia
local i
local rowTitle = nil
local getProfile = ""
local setProfile = ""
local parts
local errorOpts = nil
local uname, pass, email, phone, name, street, city, state, zip
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
function scene:revertAlapha(field)
   native.setKeyboardFocus(field)
end

function scene:showSearch()
   return
end
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   local user = composer.getVariable("user")
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

   local function menuEvent(event)
      local options = {
        isModal = true,
        effect = "slideRight",
        time = 400
      }

      -- Show the overlay in all its glory
      composer.showOverlay("menu", options)
   end

   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })
   topbarContainer:insert(menuBtn)
   menuBtn.x = -140
   menuBtn.y = 10

   topbarInsignia = display.newImageRect("logo_black.png", 100, 33)
   topbarInsignia.y = 10

   topbarContainer:insert(topbarInsignia)

   local function cameraEvent(event)
      composer.gotoScene("qrScanner")
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