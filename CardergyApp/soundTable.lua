-----------------------------------------------------------------------------------------
--
-- soundTable.lua
--
-----------------------------------------------------------------------------------------

-- Create sound table
local soundTable = {
    shootSound = audio.loadSound( "shoot.wav" ),
    hitSound = audio.loadSound( "hit.wav" ),
    explodeSound = audio.loadSound( "explode.wav" ),
}

return soundTable;
