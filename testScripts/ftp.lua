password = "ftp server password"

local ftp = require("socket.ftp") -- ftp socket namespace

f,e = ftp.get("ftp://username:".. password .."@host/directoryName/someVid.mov;type=i") --login to ftp server and fetch file at given directory using binary mode (not ascii)

local path = system.pathForFile( "downloadedFile.mov",system.DocumentsDirectory) --get system (lua) Documents directory

 
-- Open the file handle
local file, errorString = io.open( path, "w" ) -- open file for writing with path

file:write(f) --write ftp data to file


file:close() --close file


media.playVideo("downloadedFile.mov",system.DocumentsDirectory,true) -- play video from documents directory

--reading from file and sending to FTP server

local path = system.pathForFile("file.txt",system.DocumentsDirectory) --get system (lua) Documents directory

file, errorString = io.open(path,"r") -- open file for reading with path

local contents = file:read("*a") -- read contents of file into contents

f,e = ftp.put("ftp://username:".. password .."@host/directoryName/someFile.txt;type=i",contents) --login to ftp server and upload file at given directory using binary mode (not ascii)

file:close() --close file pointer




























































































