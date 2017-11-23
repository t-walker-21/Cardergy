
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local ftp = require("socket.ftp") -- ftp socket namespace
local socket = require("socket")
local tcp = assert(socket.tcp())

password = "tevon"
fname = "temp5.jpg"

myText = nil


--f,e = ftp.put("ftp://tjw0018:".. password .."@34.240.251.252/var/www/html/videos/codeUpload/temp.jpg;type=i") --login to ftp server and fetch file at given directory using binary mode (not ascii)

--reading from file and sending to FTP server




 
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
  

   

end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      
      takePhoto()
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
function takePhoto()
	media.capturePhoto({listener = processPhoto, destination = {baseDir=system.DocumentsDirectory,filename=fname,type="image"}})
	myText = display.newText( "uploading photo...", 100, 200, native.systemFont, 16)
end

function onComplete(event)
   if event.action == "clicked" then
      local i = event.index
      if i == 2 then
         takePhoto()
      else
         prevScene = composer.getSceneName("previous")
         composer.gotoScene(prevScene)
         return
      end
   end
	
end


function processPhoto(event)
	--ftp to server at file directory that processes qr codes

if (event.completed == false) then
   print "i pushed cancel"
   prevScene = composer.getSceneName("previous")
   composer.gotoScene(prevScene)
   return
end



local path = system.pathForFile(fname,system.DocumentsDirectory) --get system (lua) Documents directory



file, errorString = io.open(path,"r") -- open file for reading with path





local contents = file:read("*a") -- read contents of file into contents

print(contents)


f,e = ftp.put("ftp://tjw0018:".. password .."@34.230.251.252/var/www/html/videos/codeUpload/"..fname..";type=i",contents) --login to ftp server and upload file at given directory using binary mode (not ascii)

print(f .. "bytes written")

file:close() --close file pointer--
--myText = nil
--myText = display.newText( "contacting server..", 100, 200, native.systemFont, 16 )
print("inside process photo")
tcp:connect("34.230.251.252", 40001)
tcp:send("qrgrab:/var/www/html/videos/codeUpload/"..fname)
local s, status, partial = tcp:receive()
tcp:close()
print ("the data was " .. (s or partial))

if (s == "error" or partial == "error") then

   native.showAlert("Qr Error","The picture you sent had no code",{"Quit","Retry"},onComplete)--,listener=takePhoto)

else

f,e = ftp.get("ftp://tjw0018:".. password .."@34.230.251.252".. (s or partial) ..";type=i") --login to ftp server and fetch file at given directory using binary mode (not ascii)

local path = system.pathForFile( "downloadedFile.mov",system.DocumentsDirectory) --get system (lua) Documents directory

 
-- Open the file handle
local file, errorString = io.open( path, "w" ) -- open file for writing with path

file:write(f) --write ftp data to file


file:close() --close file


media.playVideo("downloadedFile.mov",system.DocumentsDirectory,true) -- play video from documents directory

prevScene = composer.getSceneName("previous")
composer.gotoScene(prevScene)

end


	--listen to socket to determine if image contained a qr code
end

return scene