-----------------------------------------------------------------------------------------
--
-- Enemy.lua
--
-- Name: Alex Indihar
-- Assigment: Homework 4
-- Date: 11/19/2017
-----------------------------------------------------------------------------------------

local soundTable=require("soundTable");

-- Instantiate a default enemy
local Enemy = {tag="enemy", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

-- Function to instantiate new enemy
function Enemy:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

-- Function to spawn new enemy
function Enemy:spawn()
 self.shape=display.newCircle(self.xPos, self.yPos,15);
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “enemy”
 self.shape:setFillColor (1,1,0);
 physics.addBody(self.shape, "kinematic"); 
end

-- Function to move enemy backwards
function Enemy:back ()
  transition.to(self.shape, {x=self.shape.x+100, y=150,  
  time=self.fB, rotation=self.bR, 
  onComplete=function (obj) self:forward() end} );
end

-- Function to move enemy sideways
function Enemy:side ()   
   transition.to(self.shape, {x=self.shape.x-200, 
   time=self.fS, rotation=self.sR, 
   onComplete=function (obj) self:back() end } );
end

-- Function to move enemy forwards
function Enemy:forward ()   
   transition.to(self.shape, {x=self.shape.x+100, y=800, 
   time=self.fT, rotation=self.fR, 
   onComplete= function (obj) self:side() end } );
end

-- Function to move enemy
function Enemy:move ()	
	self:forward();
end

-- Function to handle when enemy gets hit
function Enemy:hit () 
  -- Decrement enemy's HP
	self.HP = self.HP - 1;

  -- Check if HP greater than 0
	if (self.HP > 0) then 
    -- Play hit sound
		audio.play( soundTable["hitSound"] );
		self.shape:setFillColor(0.5,0.5,0.5);
	
	else 
    -- Play explosion sound
		audio.play( soundTable["explodeSound"] );

    -- Cancel the transition
		transition.cancel( self.shape );
		
    -- Check if enemy's timer is still going
		if (self.timerRef ~= nil) then
      -- Cancel the enemy's timer
			timer.cancel ( self.timerRef );
		end

		-- Remove the enemy
		self.shape:removeSelf();
		self.shape=nil;	
		self = nil;  
	end		
end

-- Function to make the enemy shoot
function Enemy:shoot (interval)
  interval = interval or 1500;

  -- Function to create enemy bullet
  local function createShot(obj)
    -- Create enemy bullet and fire it
    local p = display.newRect (obj.shape.x, obj.shape.y+20, 10, 10); --was 50
    p:setFillColor(1,0,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic");
    p:applyForce(0, 0.2, p.x, p.y);
		
    -- Function to handle bullet collisions
    local function shotHandler (event)
      if (event.phase == "began") then
        -- Check if collided object is an enemy
        if (event.other.tag == "enemy") then
          -- Ignore the collision
          event.contact.isEnabled = false
        else
          -- Remove the bullet
          audio.play(soundTable["hitSound"])
          event.target:removeSelf();
          event.target = nil;
        end
      end
    end
    -- Add collision event listener for bullet
    p:addEventListener("collision", shotHandler);		
  end
  -- Recursively fire bullets from enemy at set time intervals
  self.timerRef = timer.performWithDelay(interval, 
	function (event) createShot(self) end, -1);
end


return Enemy

