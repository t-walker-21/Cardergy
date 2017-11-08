local function onComplete( event )
   local photo = event.target
   password = "tevon"

local ftp = require("socket.ftp") -- ftp socket namespace


local path = system.pathForFile("somePhoto.jpg",system.DocumentsDirectory) --get system (lua) Documents directory

file, errorString = io.open(path,"r") -- open file for reading with path

local contents = file:read("*a") -- read contents of file into contents

f,e = ftp.put("ftp://tjw0018:".. password .."@198.54.112.233/home/tjw0018/video/somePhoto.jpg;type=i",contents) --login to ftp server and upload file at given directory using binary mode (not ascii)

--file:close() --close file pointer

print("you sent " .. f)
end
 
if media.hasSource( media.Camera ) then
    media.capturePhoto( { listener=onComplete,destination={baseDir=system.DocumentsDirectory,filename="somePhoto.jpg"}} )
else
    native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
end