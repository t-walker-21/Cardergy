-----------------------------------------------------------------------------------------
--
-- start.lua
--
-- Name: Alex Indihar
-- Assigment: Homework 4
-- Date: 11/19/2017
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar )

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

	local bg = display.newImageRect("sky.png", 320, 570)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	bg:toFront()
	sceneGroup:insert(bg)
   
   -- Display start scene credits
   titleTxt = display.newText("Card Shooter", display.contentCenterX, display.contentCenterY-110, native.systemFont, 42)
   alexTxt = display.newText("By: Team Cardergy", display.contentCenterX, display.contentCenterY-50, native.systemFont, 28)

   -- Function to start the game
   local function startEvent(event)
      local options = {
         effect = "fade",
         time = 1000
      }
      -- Go to the game screen
      composer.gotoScene("shooter", options)
   end

   -- Create a start button to initiate game sequence
   local startBtn = widget.newButton(
   {
      label = "Start",
      fontSize = 20,
      font = native.systemFontBold,
      emboss = true,
      onRelease = startEvent,
      shape = "roundedRect",
      width = 220,
      height = 60,
      cornerRadius = 30,
      fillColor = {default={1,1,1}, over={1,0,0.5}},
   })
   startBtn.x = display.contentCenterX
   startBtn.y = display.contentCenterY + 40

   -- Add start screen objects to scene group
   sceneGroup:insert(titleTxt)
   sceneGroup:insert(alexTxt)
   sceneGroup:insert(startBtn)
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
      composer.removeScene("shooter")
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