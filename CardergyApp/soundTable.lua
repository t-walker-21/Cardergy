-----------------------------------------------------------------------------------------
--
-- soundTable.lua
--
-- Name: Alex Indihar
-- Assigment: Homework 4
-- Date: 11/19/2017
-----------------------------------------------------------------------------------------

-- Create sound table
local soundTable = {
    shootSound = audio.loadSound( "shoot.wav" ),
    hitSound = audio.loadSound( "hit.wav" ),
    explodeSound = audio.loadSound( "explode.wav" ),
}

return soundTable;
