-----------------------------------------------------------------------------------------
--
-- videoRecord.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local crypto = require("crypto")
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   function takeVideo()
   --c6media.captureVideo({listener = confirmVideo, destination = {baseDir=system.DocumentsDirectory,filename=fname,type="image"}})
      media.captureVideo( { listener=processVideo,preferredQuality="high",preferredMaxDuration=5} )
   end

   function onComplete()
      takeVideo()
   end

   function processVideo(event)
      --ftp to server at file directory that processes qr codes
      if (event.completed == false) then
         prevScene = composer.getSceneName("previous")
         composer.gotoScene(prevScene)
         return
      end

      --local myText = display.newText( "fetching video", 100, 200, native.systemFont, 16 )

      --local path = system.pathForFile(event.url,system.TemporaryDirectory) --get system (lua) Documents directory

      local sourcePath = string.sub(event.url,6,-1)

      file, errorString = io.open(sourcePath,"r") -- open file for reading with path
      
      writePath = system.pathForFile("tempVid.mov", system.DocumentsDirectory)
      fileWrite, errString = io.open(writePath,"w") -- open file for reading with path

      Niall = composer.getVariable("Niall")
      Niall:setVideo("tempVid.mov")
      composer.setVariable("Niall",Niall)

      --local myText = display.newText( errorString, 100, 200, native.systemFont, 16 )

      local contents = file:read("*a") -- read contents of file into contents

      file:close() --close file pointer--
      fileWrite:write(contents)
      fileWrite:close()

      --print ("the data was " .. s)
      
      --prevScene = composer.getSceneName("previous")
      composer.gotoScene("order")
      --listen to socket to determine if image contained a qr code
   end 
end
 
-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      onComplete()
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