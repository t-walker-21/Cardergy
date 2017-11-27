-----------------------------------------------------------------------------------------
--
-- shooter.lua
--
-----------------------------------------------------------------------------------------

local physics = require("physics");
local composer = require("composer");
local scene = composer.newScene()

local Enemy = require ("Enemy");
local soundTable=require("soundTable");
local player = nil
local controlBar = nil

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

	physics.start();
	physics.setGravity(0,0);

	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-- create main menu text objects - Alex Indihar
	local bg = display.newImageRect("sky.png", 320, 570)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	bg:toFront()
	sceneGroup:insert(bg)

	-- Player score
   	local score = 0

   	-- Flag that marks if the game has ended
   	local endFlag = false

   	-- Create control bar for player
   	controlBar = display.newRect (display.contentCenterX, display.contentHeight-65, display.contentWidth, 70);
	controlBar:setFillColor(1,1,1,0.2);

	---------------------------------------------- MAIN PLAYER ----------------------------------------------
	-- Create the main player 
	local paint = {
		type = "image",
		filename = "quarter.png"
	}
	player = display.newCircle (display.contentCenterX, display.contentHeight-150, 20);
	player.fill = paint
	physics.addBody (player, "kinematic");
	player.isBullet = true
	playerHP = 5

	-- Function to move the player while control bar is touched
	local function move ( event )
		 if event.phase == "began" then	
		 	-- Check to ensure player's x coordinate is set
		 	if (player.x ~= nil) then	
				player.markX = player.x 
			end
		 elseif event.phase == "moved" then
		 	-- Check to ensure player's marked x value has been set
		 	if (player.markX ~= nil) then
		 		-- Calculate the x coordinate of the player vs control bar
			 	local x = (event.x - event.xStart) + player.markX	 	
			 	
			 	-- Checks and moves the player in congruence with the control bar
			 	if (x <= 20 + player.width/2) then
				   player.x = 20+player.width/2;
				elseif (x >= display.contentWidth-20-player.width/2) then
				   player.x = display.contentWidth-20-player.width/2;
				else
				   player.x = x;		
				end
			end
		 end
	end
	-- Add touch event listener for the  control bar to enable player movement
	controlBar:addEventListener("touch", move);

	-- Function to update the score
	local function updateScore()
		-- Remove old score
		display.remove(scoreText)

		-- Update with new score
		scoreText = display.newEmbossedText( "Hit: "..score, 240, 20, native.systemFont, 40 );
		scoreText:setFillColor(1,192/255,203/255)

		-- Set score format
		local color = 
		{
			highlight = {0,1,1},   
			shadow = {0,1,1}  
		}
		scoreText:setEmbossColor( color );
		sceneGroup:insert(scoreText)
	end

	-- Function to fire player projectile
	local cnt = 0;
	local function fire (event) 
	  	--if (cnt < 3) then
	    cnt = cnt+1;
	    local p = nil
	    -- Check to ensure that player x and y coordinates have been set
	    if (player.x ~= nil and player.y ~= nil) then
	    	-- Create and fire bullet
			p = display.newCircle (player.x, player.y-22, 5);
			p.anchorY = 1;
			p:setFillColor(0,1,0);
			physics.addBody (p, "dynamic", {radius=5, isSensor = true});
			p.isBullet = true
			p:applyForce(0, -0.4, p.x, p.y);
			sceneGroup:insert(p)

			-- Play shoot sound
			audio.play( soundTable["shootSound"] );

			-- Remove bullet if off screen
			timer.performWithDelay(2000, 
				function (event) display.remove(p) end);

			-- Function to remove bullet if collides with enemy or enemy bullet
			local function removeProjectile (event)
		      if (event.phase=="began") then
		      	 -- Remove bullet
			   	 display.remove(event.target);
		         event.target=nil;
		         --cnt = cnt - 1;

		         -- Update score and remove enemy if enemy is hit with player bullet
		         if (event.other.tag == "enemy") then
		         	score = score + 1
		         	updateScore()
		         	event.other.pp:hit();
		         end
		      end
		    end
		    -- Add collision event listener for player bullet
	   		p:addEventListener("collision", removeProjectile);
	  	end
	end
	-- Add tap event listener for firing player bullet
	Runtime:addEventListener("tap", fire)

	endTid = nil

	-- Custom event handler function for checking if player HP is 0
	local function hp_handler(event)
		-- Check if player HP is 0
		if (event.HP == 0) then
			-- Set the end-of-game flag to true
			endFlag = true

			-- Cancel the survival timer
			timer.cancel(endTid)

			-- Show the game over overlay scene
			local options = {
				isModal = true
			}
			composer.showOverlay("gameOver", options)
		end
	end
	-- Add hp event listener for the custom hp event
	player:addEventListener("hp", hp_handler)

	-- Function for ending the game after 3 minutes have passed
	local function ending()
		-- Remove the custom hp event listener
		player:removeEventListener("hp", hp_handler)

		-- Set the end-of-game flag to true
		endFlag = true

		-- Show the ending overlay scene
		local options = {
			isModal = true
		}
		composer.showOverlay("ending", options)
	end
	-- Start the 3-minute survival timer
	endTid = timer.performWithDelay(180000, ending)

	-- Function to handle enemy on player collision
	local function enemyCollide(event)
		-- Check there was no collision
		if(event.contact == nil) then
			return
		-- Check if enemy and player objects are what collided
		elseif (event.other.tag == "enemy" and event.target == player) then
			-- Decrement player's hp
			playerHP = playerHP - 1

			-- Remove enemy
			event.other.pp.HP = 0
			event.other.pp:hit()

			-- Dispatch the custom hp event for player
			local event = {name = "hp", target = player, HP = playerHP}
          	player:dispatchEvent(event)
		else
			-- Ignore the collision
			event.contact.isEnabled = false
		end
	end
	-- Add pre-collision event lisener for player
	player:addEventListener("preCollision", enemyCollide)
	---------------------------------------------- MAIN PLAYER ----------------------------------------------

	---------------------------------------------- PENTAGON ENEMY ----------------------------------------------
	-- Instantiate a new Enemy called Pentagon with 3 hit points
	local Pentagon = Enemy:new( {HP=3, fR=0, fT=15000, bT=700} );

	-- Function that spawns the Pentagon enemy
	function Pentagon:spawn()
	  --self.shape = display.newPolygon (self.xPos, self.yPos, {10,15,-10,15,-15,-3,0,-15,15,-3}); 
	  self.shape = display.newImageRect("start_qr.png", 50, 50)
	  self.shape.x = self.xPos
	  self.shape.y = self.yPos
	  self.shape.pp = self;
	  self.shape.tag = "enemy";
	  --self.shape:setFillColor ( 1, 1, 0);
	  physics.addBody(self.shape, "dynamic") --{shape = {10,15,-10,15,-15,-3,0,-15,15,-3}}); 
	  self.shape.isBullet = true
	  sceneGroup:insert(self.shape)
	end

	-- Function that moves the Pentagon enemy
	function Pentagon:forward()	
		transition.to(self.shape, {x=self.shape.x, y=570, time=self.fT, rotation=self.fR, 
	   	onComplete= function (obj) timer.cancel(self.timerRef) display.remove(self.shape) self.shape = nil self = nil end });
	end

	-- Function that recursively moves the Pentagon enemy
	function Pentagon:move()
		self:forward()
	end

	-- Function that makes the Pentagon enemy shoot
	function Pentagon:shoot (interval)
	  interval = interval or 1500;

	  -- Function to create the enemy bullet and fire it
	  local function createShot(obj)
	  	-- Check if the game has ended
	  	if (endFlag == true) then
	  		return
	  	end

	  	-- Create the enemy bullet and fire it
	    local p = display.newRect (obj.shape.x, obj.shape.y+30, 10, 10); --was 50
	    p:setFillColor(1,105/255,180/255);
	    p.anchorY=0;
	    physics.addBody (p, "dynamic", {isSensor = true});
	    p.isBullet = true
	    sceneGroup:insert(p)
	    p:applyForce(0, 0.2, p.x, p.y);
	  	
	  	-- Remove bullet if off screen
	    timer.performWithDelay(7000, 
			function (event) display.remove(p) end);
		
		-- Function to handle bullet collisions
	    local function shotHandler (event)
	      if (event.phase == "began") then
	      	-- Check if there was no collision
	      	if (event.contact == nil) then
	      		return
	      	-- Check if the collided object is an enemy
	        elseif (event.other.tag == "enemy") then
	          -- Ignore the collision
	          event.contact.isEnabled = false
	        -- Check if the collied object is the player 
	        elseif (event.other == player) then
	      	  -- Decrement player's HP
	          playerHP = playerHP - 1

	          -- Play hit sound
	          audio.play(soundTable["hitSound"])

	          -- Remove the bullet
	          display.remove(event.target);
	          event.target = nil;

	          -- Dispatch custom hp event for player
	          local event = {name = "hp", target = player, HP = playerHP}
	          player:dispatchEvent(event)
	        else
	          -- Play hit sound
	          audio.play(soundTable["hitSound"])

	          -- Remove the bullet
	          display.remove(event.target);
	          event.target = nil;
	        end
	      end
	    end
	    -- Add collision event listener for enemy bullet
	    p:addEventListener("collision", shotHandler);		
	  end
	  -- Recursively shoot bullets from enemy at set time intervals
	  self.timerRef = timer.performWithDelay(interval, 
		function (event) createShot(self) end, -1);
	end
	---------------------------------------------- PENTAGON ENEMY ----------------------------------------------

	---------------------------------------------- TRIANGLE ENEMY ----------------------------------------------
	-- Instantiate a new Enemy called Triangle with one hit point
	local Triangle = Enemy:new( {HP=1, bR=360, fT=1000, bT=300, fR=0});

	-- Function that spawns the Triangle enemy
	function Triangle:spawn()
	 --self.shape = display.newPolygon(self.xPos, self.yPos, {0,15,15,-15,-15,-15});
	 self.shape = display.newImageRect("start_card.png", 41, 65)
	 self.shape.x = self.xPos
	 self.shape.y = self.yPos
	 self.shape.pp = self;
	 self.shape.tag = "enemy";
	 --self.shape:setFillColor ( 0, 0, 1);
	 physics.addBody(self.shape, "dynamic")--, {shape={0,15,15,-15,-15,-15}}); 
	 self.shape.isBullet = true
	 sceneGroup:insert(self.shape)
	end

	-- Function that moves the Triangle enemy to target the player
	function Triangle:forward()
		if (self.shape ~= nil) then
		    if (self.moving == true) then
		    	transition.cancel(self.shape)
		    end
		    self.moving = true;

		    local function trackPlayer(enemyX, enemyY, playerX, playerY)
		    	deltaY = enemyY - playerY
		    	deltaX = enemyX - playerX

		    	angle = (math.atan2(deltaY, deltaX) * 180 / math.pi) * -1

		    	mult = 10^0

		    	return math.floor(angle * mult + 0.5) / mult
		    end

		    self.shape.rotation = (trackPlayer(self.shape.x,self.shape.y,player.x,player.y)+270)*-1
		    local V = 0.15
		    local t = math.sqrt((player.x - self.shape.x)^2 + (player.y - self.shape.y)^2) / V
		    transition.to(self.shape, {time=t, x=player.x, y=player.y,
		    	onComplete=function(obj) timer.cancel(self.timerRef) display.remove(self.shape) self.shape = nil self = nil end})
		end
	end

	-- Function that recursively moves the Triangle enemy
	function Triangle:move()
		timer.performWithDelay(50,
			function(event) self:forward() end, -1)
	end

	-- Function that makes the Triangle enemy shoot
	function Triangle:shoot (interval)
	  interval = interval or 1500;

	  -- Function to create the enemy bullet and fire it
	  local function createShot(obj)
	  	-- Check if game has ended
	  	if (endFlag == true) then
	  		return
	  	end

	  	-- Create the enemy bullet and fire it
	    local p = display.newRect (obj.shape.x, obj.shape.y+40, 10, 10);
	    p:setFillColor(1,105/255,180/255);
	    p.anchorY=0;
	    physics.addBody (p, "dynamic", {density=10, isSensor = true});
	    p.isBullet = true
	    sceneGroup:insert(p)
	    local V = 0.2
	    local t = math.sqrt((player.x - p.x)^2 + (player.y - p.y)^2) / V
	    transition.to(p, {time=t, x=player.x, y=player.y,
	    	-- Remove bullet if misses player
	    	onComplete=function (obj) display.remove(p) p = nil end})
		
	    -- Function to handle bullet collisions
	    local function shotHandler (event)
	      if (event.phase == "began") then
	      	-- Check if there was no collision
	      	if (event.contact == nil) then
	      		return
	      	-- Check if the collided object is an enemy
	      	elseif (event.other.tag == "enemy") then
	      		-- Ignore the collision
	      		event.contact.isEnabled = false
	      	-- Check if the collided object is the player
	      	elseif (event.other == player) then
	      		-- Decrement the player's HP
	            playerHP = playerHP - 1

	            -- Play hit sound
	            audio.play(soundTable["hitSound"])

	            -- Remove the bullet
	            display.remove(event.target);
	            event.target = nil;

	            -- Dispatch the custom hp event for player
	            local event = {name = "hp", target = player, HP = playerHP}
	          	player:dispatchEvent(event)
	      	else
	      		-- Play hit sound
	      		audio.play(soundTable["hitSound"])

	      		-- Remove bullet
	        	display.remove(event.target);
	       		event.target = nil;
	       	end
	      end
	    end
	    -- Add collision event listener for enemy bullet
	    p:addEventListener("collision", shotHandler);		
	  end
	  -- Recursively shoot bullets from enemy at set time intervals
	  self.timerRef = timer.performWithDelay(interval, 
		function (event) createShot(self) end, -1);
	end
	---------------------------------------------- TRIANGLE ENEMY ----------------------------------------------

	-- Function that spawns enemies
	local function spawnEnemies()
		-- Function that recursively spawns pentagon enemies at random time intervals
		local function spawnPenta()
			-- Check if game has ended
			if (endFlag == true) then
				return
			end

			-- Spawn the pentagon enemy
			sq = Pentagon:new({xPos=math.random(35,285), yPos=-100});
			sq:spawn();
			sq:move();
			sq:shoot(2500);

			-- Add pre-collision event listener for colliding with another object
			sq.shape:addEventListener("preCollision", enemyCollide)

			-- Spawn pentagon enemies recursively at random time intervals
			sqTid = timer.performWithDelay(math.random(1000, 6000), spawnPenta)
		end

		-- Spawn the first instance of a pentagon enemy at a random time interval
		timer.performWithDelay(math.random(1000, 6000), spawnPenta)

		-- Function that recursively spawns triangle enemies at random time intervals
		local function spawnTri()
			-- Check if game has ended
			if (endFlag == true) then
				return
			end

			-- Spawn the triangle enemy
			tr = Triangle:new({xPos=math.random(35,285), yPos=-200});
			tr:spawn();
			tr:move()
			tr:shoot(1500)

			-- Add pre-collision event listener for colliding with another object
			tr.shape:addEventListener("preCollision", enemyCollide)

			-- Spawn triangle enemies reccursively at random time intervals
			trTid = timer.performWithDelay(math.random(1000, 6000), spawnTri)
		end

		-- Spawn the first instance of a triangle enemy at a random time interval
		timer.performWithDelay(math.random(1000, 6000), spawnTri)
	end

	-- Display the starting score on the screen
	scoreText = display.newEmbossedText( "Hit: "..score, 240, 20, native.systemFont, 40 );
	scoreText:setFillColor(1,192/255,203/255);
	scoreText:toFront()

	-- Set the score format
	local color = 
	{
		highlight = {0,1,1},   
		shadow = {0,1,1}  
	}
	scoreText:setEmbossColor( color );
	scoreText:toFront()

	-- Add the player, control bar, and score to the scene group
	sceneGroup:insert(scoreText)
	sceneGroup:insert(player)
	sceneGroup:insert(controlBar)

	-- Delay by a small amount of time before spawning enemies at game start
	timer.performWithDelay(1000, spawnEnemies)
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

      -- Remove this scene when game ends
      composer.removeScene("shooter")
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