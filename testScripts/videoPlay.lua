---------------------------------------



-----main.lua



---------------------------------------



videoPath = "some/path/to/video/file.mp4" -- file location

media.playVideo(videoPath,true,func) -- play video at location found in videoPath, displayControls = true, onComplete = func


function func()

--some function called at the end of the video


end
