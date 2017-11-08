-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here


-- Video completion listener
local onVideoComplete = function( event )
    print( "video session ended" )
end
 
-- Capture completion listener
local function onComplete( event )
    if event.completed then
        media.playVideo( event.url, media.RemoteSource, true, onVideoComplete )
	print( event.duration )
        print( event.fileSize )
    end
end

--media.capturePhoto() for photos https://docs.coronalabs.com/api/library/media/capturePhoto.html
 
if media.hasSource( media.Camera ) then
    media.captureVideo( { listener=onComplete,preferredQuality="high",preferredMaxDuration=5} )



else
    native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
end
