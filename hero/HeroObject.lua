require("AcitonSprite")

local HeroObject = class("HeroObject", function(filename,x,y)
    sprite=require("AcitonSprite").new(filename,x,y)
    return sprite
end)

function HeroObject:ctor()


	function CreateAction(actionname,filename,iStart,iEnd,iTime)
		local frames = display.newFrames(filename,iStart,iEnd)
		local animation = display.newAnimation(frames, iTime/(iEnd*1.0))
		CCAnimationCache:sharedAnimationCache():addAnimation(animation, actionname)
		return animation
		--local animate = display.newAnimate(animation)
	end
		
	---StressTest1_layer:runAction(CCSequence:createWithTwoActions(CCRotateBy:create(2, 360), CCCallFuncN:create(removeMe)))	
		
	self.m_Actions.Stand=CreateAction("Boss7Stand","Boss7Stand%d.png", 1, 16,0.6)
	self.m_Actions.Walk=CreateAction("Boss7Run","Boss7Walk%d.png", 1, 16,0.6)
	self.m_Actions.Attack1=CreateAction("Boss7Attack1","Boss7Attack1_%d.png", 1, 11,0.3)
	self.m_Actions.Attack2=CreateAction("Boss7Attack2","Boss7Attack2_%d.png", 1, 9,0.3)
	self.m_Actions.Attack3=CreateAction("Boss7Attack3","Boss7Attack3_%d.png", 1, 12,0.3)
	self.m_Actions.Attack4=CreateAction("Boss7Attack4","Boss7Attack4_%d.png", 1, 11,0.3)
	self.m_Actions.Attack5=CreateAction("Boss7Attack5","Boss7Attack5_%d.png", 1, 17,0.3)
  self.m_Actions.Dead=CreateAction("Boss7Dead","Boss7Dead%d.png", 1, 18,0.6)
  self.m_Actions.Hurt=CreateAction("Boss7Hurt","Boss7Hurt%d.png", 1, 10,0.25)
	self.m_Actions.KnockedOut=CreateAction("Boss7KnockedOut","Boss7Dead%d.png", 1, 18,0.6)

	self.m_Measurements.Bottom=39.0
	self.m_Measurements.Sides=29.0
	self.m_AttrData.HitPoints=100.0
	self.m_AttrData.Damage=20.0
	self.m_Movement.WalkSpeed=1.0	
	
	--printf("Walk Session --->%s",self.m_Actions.Walk)

	self.m_HitBox=self:createBoundingBoxWithOrigin(ccp(-self:getCenterToSides(), -self:getCenterToBottom()),CCSizeMake(self:getCenterToSides() * 2, self:getCenterToBottom() * 2))

	self.m_AttackBox=self:createBoundingBoxWithOrigin(ccp(self:getCenterToSides(), -10), CCSizeMake(40, 30))
	
	

end

 
function HeroObject:destroy()


end


function HeroObject:getAttackTarget()
	if self.m_Scene~=nil then
		return self.m_Scene.m_Boss
	end	
	
end

function HeroObject:update(frame)

	local direction = self.m_DesiredPosition
	if direction==0 then
		return
	end
	self.m_DesiredPosition=0
	--继续做走路
	if (self.m_ActionState == ACTION_STATE_IDLE) then 
		self:RunWalk()
	elseif self.m_AttrData.Walking == false then
		self.m_AttrData.Walking=true
	end

	if (self.m_ActionState == ACTION_STATE_WALK) then
		if (direction.x > 0) then
			self:setScaleX(-1.0)
		else
			self:setScaleX(1.0)
		end
	end
     --精灵坐标点
	mypos=ccp(self:getPosition());

	local iWalkSpeed=self.m_Movement.WalkSpeed
	local nextx=mypos.x+direction.x*(iWalkSpeed)
	local nexty=mypos.y+direction.y*(iWalkSpeed)
	
	self.m_Scene.m_MoveDistance=direction.x
	self.m_Scene.m_MoveEnd=nextx
	
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

return HeroObject