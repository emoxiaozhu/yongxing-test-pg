require("AcitonSprite")

local BossObject = class("BossObject", function(filename,x,y)
    sprite=require("AcitonSprite").new(filename,x,y)
    return sprite
end)

function BossObject:ctor()

	function CreateAction(actionname,filename,iStart,iEnd,iTime)
		local frames = display.newFrames(filename,iStart,iEnd)
		local animation = display.newAnimation(frames, iTime/(iEnd*1.0))
		CCAnimationCache:sharedAnimationCache():addAnimation(animation, actionname)
		return animation
	end

	self.m_Actions.Stand=CreateAction("Boss8Stand","Boss8Stand%d.png", 1, 16,0.6)
	self.m_Actions.Walk=CreateAction("Boss8Run","Boss8Walk%d.png", 1, 16,0.6)
	self.m_Actions.Attack1=CreateAction("Boss8Attack1","Boss8Attack1_%d.png", 1, 16,0.5)
	self.m_Actions.Attack2=CreateAction("Boss8Attack2","Boss8Attack2_%d.png", 1, 16,0.5)
  self.m_Actions.Dead=CreateAction("Boss8Dead","Boss8Dead%d.png", 1, 9,0.6)
  self.m_Actions.Hurt=CreateAction("Boss8Hurt","Boss8Hurt%d.png", 1, 5,0.3)
	self.m_Actions.KnockedOut=CreateAction("Boss8KnockedOut","Boss8Dead%d.png", 1, 9,0.6)

	self.m_Measurements.Bottom=39.0
	self.m_Measurements.Sides=29.0
	self.m_AttrData.HitPoints=100.0
	self.m_AttrData.Damage=20.0
	self.m_Movement.WalkSpeed=1.0	
	
	printf("Walk Session --->%s",self.m_Actions.Walk)

	self.m_HitBox=self:createBoundingBoxWithOrigin(ccp(-self:getCenterToSides(), -self:getCenterToBottom()),CCSizeMake(self:getCenterToSides() * 2, self:getCenterToBottom() * 2))
	self.m_AttackBox=self:createBoundingBoxWithOrigin(ccp(self:getCenterToSides(), -10), CCSizeMake(40, 30))
	
end

 
function BossObject:destroy()

end

function BossObject:update2(frame)
	if (self.m_ActionState == ACTION_STATE_ATTACK) then
		local boss=self.m_Scene.m_Hero
		local bosspos=ccp(boss:getPosition())
		local mypos=ccp(self:getPosition())
		if (math.abs(mypos.y - bosspos.y) < 10) then
			local check=self.m_HitBox.actual:intersectsRect(boss.m_HitBox.actual)
			printf("check---->%s",check)
			if (self.m_HitBox.actual:intersectsRect(boss.m_HitBox.actual)) then
				boss:hurtWithDamage(100)
			end
		end
		return
	end

end

function BossObject:getAttackTarget()
	if self.m_Scene~=nil then
		return self.m_Scene.m_Hero
	end
end

function BossObject:update(frame)
	if (self.m_ActionState == ACTION_STATE_HURT) then
		return
	end
	
	
	hero=self.m_Scene.m_Hero
	
	bosspos=ccp(self:getPosition())
	heropos=ccp(self.m_Scene.m_Hero:getPosition())
	
  if (bosspos.x>heropos.x) then
    self:setFlipX(false)
  else
    self:setFlipX(true)
  end
  
  local function dist(a,b)
	return (math.sqrt(math.pow(a.x-b.x,2) + math.pow(a.y-b.y,2) ))  
  end
  
  if (self.m_ActionState == ACTION_STATE_WALK and  dist(heropos,bosspos)<50) then
	  self:idle()
	  return
 elseif (self.m_ActionState == ACTION_STATE_IDLE and dist(heropos,bosspos) <50) then
  	self:attack()
 end
  
  
  
	if (self.m_ActionState == ACTION_STATE_IDLE) then 
		self:RunWalk()
	elseif self.m_AttrData.Walking == false then
		self.m_AttrData.Walking=true
	end  
  
 -- if self.m_ActionState~=ACTION_STATE_IDLE then
 -- 	return
 -- end
  
  
 -- local distance_x=60
--  local distance_y = 10
  
 -- local function move(pos)
  --    local function runwalkdone()
   --   	self:idle()
   --   end  	 
      
    --   self:stopAllActions()
  	 
  --    local move=CCMoveTo:create(2.0,pos)
   --   local animate = display.newAnimate(self.m_Actions.Walk)
   --   local spawn = CCSpawn:createWithTwoActions(move, animate)
  --    local actionArray = CCArray:create()
  --    local act1=CCCallFuncN:create(runwalkdone)
  --     actionArray:addObject(spawn)     
 --      actionArray:addObject(act1)   
   --   local sequence = CCSequence:create(actionArray)
   --   self:runAction(sequence)  
  --    self.m_ActionState=ACTION_STATE_WALK
     
  --end
  
  if self.m_ActionState~=ACTION_STATE_WALK then
 	return
  end
   
    local radians = ccpToAngle(ccpSub(bosspos,heropos))
    local degrees = -1 * CC_RADIANS_TO_DEGREES(radians)
	
	local direction = 0
	
    if (degrees <= 22.5 and degrees >= -22.5)  then
        direction = ccp(-1.0, 0.0)
    elseif (degrees > 22.5 and degrees < 67.5)  then
        direction = ccp(-1.0, 1.0)
    elseif (degrees >= 67.5 and degrees <= 112.5)  then
        direction = ccp(0.0, 1.0)
    elseif (degrees > 112.5 and degrees < 157.5)  then
        direction = ccp(1.0, 1.0)
    elseif (degrees >= 157.5 or degrees <= -157.5)  then
        direction = ccp(1.0, 0.0)
    elseif (degrees < -22.5 and degrees > -67.5)  then
       direction = ccp(-1.0, -1.0)
    elseif (degrees <= -67.5 and degrees >= -112.5)  then
        direction = ccp(0.0, -1.0)
    elseif (degrees < -112.5 and degrees > -157.5)  then
        direction = ccp(-1.0, 1.0)
    else
    	direction = 0
    end   
    
    if direction== 0 then 
    	return
    end
   --在右边距离60的位置左右
   --if (bosspos.x>heropos.x+distance_x)  then
    --  if (bosspos.y>heropos.y)  then
	--	move(CCPointMake(bosspos.x-distance_x,bosspos.y-distance_y))
  --    else
   --   	move(CCPointMake(bosspos.x-distance_x,bosspos.y+distance_y))
   --   end
 --  elseif (bosspos.x<heropos.x-distance_x) then
   --    if (bosspos.y>heropos.y)  then
	--	move(CCPointMake(bosspos.x+distance_x,bosspos.y-distance_y))
   --   else
   --   	move(CCPointMake(bosspos.x+distance_x,bosspos.y+distance_y))  
   --   end
  -- elseif   (bosspos.y>heropos.y+distance_y and hero.m_ActionState==ACTION_STATE_IDLE) then
   	--	move(CCPointMake(bosspos.x+1,bosspos.y-15))
 --  elseif   (bosspos.y<heropos.y-distance_y and hero.m_ActionState==ACTION_STATE_IDLE) then
  -- 		move(CCPointMake(bosspos.x-1,bosspos.y+15))
   		
   --else
   --		self:idle()
   	
  -- end
  
     --精灵坐标点
	mypos=ccp(self:getPosition())

	local iWalkSpeed=self.m_Movement.WalkSpeed
	local nextx=mypos.x+direction.x*(iWalkSpeed)
	local nexty=mypos.y+direction.y*(iWalkSpeed)
	
	if nextx>600 then 
		nextx=600
	elseif nextx<50 then 
		nextx=50
	end
	
	if nexty>440 then 
		nexty=440
	elseif nexty<50 then 
		nexty=50
	end	
	
	self:setPosition(ccp(nextx,nexty))	
	self:transformBoxes()
	self:setZOrder(MAX_ZORDER-nexty)

end

return BossObject