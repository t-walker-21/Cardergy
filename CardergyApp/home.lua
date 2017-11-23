display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarBackground, menuBtn, cameraBtn, topbarInsignia, scrollView, searchField
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

-- overlay options
local overlayOptions = {
	isModal = true,
	effect = "slideRight",
	time = 400
}

function scene:showSearch()
   searchField.isVisible = true
end
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   -- Container for the top menu bar
   -- topbarContainer = display.newContainer(display.contentWidth, 100)
   -- topbarContainer:translate(display.contentWidth * 0.5, -5)

   -- Background for the top menu bar
   topbarBackground = display.newRect(display.contentCenterX, 50, display.contentWidth, 100)
   topbarBackground:setFillColor(135/255,206/255,250/255)
   -- topbarContainer:insert(topbarBackground, true)

   -- Handle the menu button's touch events
   function menuEvent(event)
      -- hide the search bar because it's a bitch
      searchField.isVisible = false
      
      -- Show the overlay in all its glory
      composer.showOverlay("menu", overlayOptions)
   end

   -- Create the menu button
   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })
   -- topbarContainer:insert(menuBtn, true)
   menuBtn.x = 30
   menuBtn.y = 40

   -- Cardergy logo for the top menu bar
   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.x = display.contentCenterX
   topbarInsignia.y = 40
   -- topbarContainer:insert(topbarInsignia)

   -- Handle the camera button events
   local function cameraEvent(event)
   end

   -- Create the camera button in the top menu bar
   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRlease = cameraEvent
   })
   -- topbarContainer:insert(cameraBtn)
   cameraBtn.x = 290
   cameraBtn.y = 40

   -- Handle the search bar's events
   local function onSearch(event)
      if ("began" == event.phase) then
      elseif ("editing" == event.phase) then
      elseif ("submitted" == event.phase) then
      elseif ("ended" == event.phase) then
      end
   end

   -- Create the search bar
   searchField = native.newTextField(0, 0, 300, 30)
   searchField.inputType = "default"
   searchField:setReturnKey("done")
   searchField.placeholder = "Search..."
   searchField:addEventListener("userInput", onSearch)
   -- topbarContainer:insert(searchField)
   searchField.x = display.contentCenterX
   searchField.y = 80

   -- Handle the scroll view events
   local function scrollListener(event)
   		local phase = event.phase
   		if ( phase == "began" ) then print( "Scroll view was touched" )
   		elseif ( phase == "moved" ) then print( "Scroll view was moved" )
   		elseif ( phase == "ended" ) then print( "Scroll view was released" )
   		end

   		if (event.limitReached) then
   			if (event.direction == "up") then print("Reached bottom limit")
   			elseif (event.direction == "down") then print("Reached top limit")
   			elseif (event.direction == "left") then print("Reached right limit")
   			elseif (event.directoin == "right") then print("Reached left limit")
   			end
   		end

   		return true
   end

   -- Create the scrollable view for the cards
   local scrollView = widget.newScrollView(
   		{
   			top = 100,
   			left = 0,
   			width = 320,
   			height = 470,
   			scrollWidth = 300,
   			scrollHeight = 800,
   			listener = scrollListener
   		}
   )

   -- Put a background in the scroll view to test functionality
   local scrollBackground = display.newImageRect("scrollBackground.jpg", 
      display.contentWidth, display.contentHeight)
   scrollView:insert(scrollBackground)
   scrollBackground.x = display.contentCenterX
   scrollBackground.y = 285
  
   -- Set the topbar's position
   -- topbarContainer.y = 50

   -- Add everything to the scenegroup
   sceneGroup:insert(scrollView)
   sceneGroup:insert(scrollBackground)
   sceneGroup:insert(topbarBackground)
   sceneGroup:insert(menuBtn)
   sceneGroup:insert(cameraBtn)
   sceneGroup:insert(topbarInsignia)
   sceneGroup:insert(searchField)
   -- sceneGroup:insert(scrollBackground)
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
      -- composer.setVariable("passScene", "")
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