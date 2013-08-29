require "math3d"
require "config"


local JoyStick = class("JoyStick", function(filename,x,y)
    layer=display.newLayer()
    layer:addChild(display.newSprite(filename,x,y))
    return layer
end)

function JoyStick:ctor()
	self.m_radius = 112
	self.m_delegate=nil
end
 
function JoyStick:destroy()
	self.m_delegate=nil    
	
end


function JoyStick:setDelegate(delegate)
	self.m_delegate=delegate
end 
 


--事件处理
function JoyStick:onTouch(event, x, y)
	--cclog("event:%s,x:%d,y:%d",event, x, y)
	if event=="began" then 
		return self:onTouchBegan(x,y)
	elseif event=="moved" then 
		return self:onTouchMoved(x,y)
	else
		return self:onTouchEnded(x,y)
	end
	
	return false
end


--事件处理
function JoyStick:onTouchBegan(x, y)
	local distanceSQ=ccpDistanceSQ(ccp(x,y),ccp(self:getPosition()))
	
    if (distanceSQ <= self.m_radius * self.m_radius) then
        self:updateDirectionForTouchLocation(ccp(x,y))
        self.m_isHeld=true
  	end
  	
	return true
end

function JoyStick:onTouchMoved(x,y)
	if self.m_isHeld==true then 
		self:updateDirectionForTouchLocation(ccp(x,y))
	end
end

function JoyStick:onTouchEnded(x,y)
	if self.m_isHeld ==true then
		self.m_direction = CCPointMake(0,0)
		self.m_isHeld = false
		if (self.m_delegate~=nil) then
			self.m_delegate:OnTouchEnded(self.m_direction)
		end
	end
end


function JoyStick:updateFrame(iDataTime)
	if (self.m_isHeld and self.m_delegate~=nil) then
		self.m_delegate:isHoldingDirection(self.m_direction)
	end
end

function JoyStick:updateDirectionForTouchLocation(location)
		--printf("JoyStick: location ->x:%d ,y:%d",location.x,location.y)
		mypos=ccp(50,50)
    local radians = ccpToAngle(ccpSub(location,mypos))
    
    
   -- printf("JoyStick:mypos->x:%d,y:%d radians ->x:%d",mypos.x,mypos.y,radians)
    local degrees = -1 * CC_RADIANS_TO_DEGREES(radians)

    if (degrees <= 22.5 and degrees >= -22.5)  then
        self.m_direction = ccp(1.0, 0.0)
    elseif (degrees > 22.5 and degrees < 67.5)  then
        self.m_direction = ccp(1.0, -1.0)
    elseif (degrees >= 67.5 and degrees <= 112.5)  then
        self.m_direction = ccp(0.0, -1.0)
    elseif (degrees > 112.5 and degrees < 157.5)  then
        self.m_direction = ccp(-1.0, -1.0)
    elseif (degrees >= 157.5 or degrees <= -157.5)  then
        self.m_direction = ccp(-1.0, 0.0)
    elseif (degrees < -22.5 and degrees > -67.5)  then
       self.m_direction = ccp(1.0, 1.0)
    elseif (degrees <= -67.5 and degrees >= -112.5)  then
        self.m_direction = ccp(0.0, 1.0)
    elseif (degrees < -112.5 and degrees > -157.5)  then
        self.m_direction = ccp(-1.0, 1.0)
    else
    	self.m_direction = 0
    end
   
   	if self.m_delegate~=nil then
		self.m_delegate:didChangeDirectionTo(self.m_direction)
	end
end


return JoyStick