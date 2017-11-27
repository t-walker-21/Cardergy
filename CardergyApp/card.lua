-----------------------------------------------------------------------------------------
--
-- card.lua
--
-----------------------------------------------------------------------------------------

-- Card Object
local Card = { name = "", category = "", message = "", qr = "", backImage="",video = "" }

-- Create new card
function Card:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

-- Set card's name
function Card:setName(name)
	self.name = name
end

-- Set card's message for front of card
function Card:setMessage(message)
 	self.message = message
end

-- Set card's QR code
function Card:setQr(qr)
 	self.qr = qr
end

-- Set card's design image for back of card
function Card:setBackImage(backImage)
 	self.backImage = backImage
end

-- Set card's category
function Card:setCategory(category)
 	self.category = category
end

-- Set card's linked video
function Card:setVideo(video)
 	self.video = video
end

return Card