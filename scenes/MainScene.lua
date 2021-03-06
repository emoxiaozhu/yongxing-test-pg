
local JoyStick = import("..ctrl.JoyStick")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self.touchLayer = display.newLayer()
    self:addChild(self.touchLayer)
  	
  	self.m_Hero=nil
  	self.m_Boss=nil
  	
  	self.m_GuanIndex=1
  	self.m_GuanMapBgTable={}
  	self.m_GuanMap={}
  	for i=1,4 do
  		self.m_GuanMapBgTable[i]=string.format("gp%d.png",i)
  		self.m_GuanMap[i]=display.newBatchNode(string.format("gp%d.png",i))
  		self:addChild(self.m_GuanMap[i])
  	end
  	
    self.frame = 0
    local playerNode = display.newBatchNode("Boss7.png", 100)
    self:addChild(playerNode,-5)
    
   	local BossNode = display.newBatchNode("Boss8.png", 100)
    self:addChild(BossNode,-6)
    
    local layer=display.newLayer()
 		local emitter = CCParticleRain:create()
 		layer:addChild(emitter)
    self:addChild(layer, 10)  	
    
    print "CCParticleRain:create--------------> OK"
    
    self.m_ScreenSize = CCDirector:sharedDirector():getWinSize()
    
    self.m_BGTable={}
    
    
    self.m_MoveEnd=0
    self.m_MoveStar=0
    self.m_MoveDistance=0    
    
end

function MainScene:ViewMapBG()
 	-- 创建背景滚屏精灵
  --将四张图拼成一张完整背景    
  
  local nsbg=self.m_GuanMapBgTable[self.m_GuanIndex]
  
  --printf("ViewMapBG -- >%s",nsbg)
  local bg1 = CCSprite:create(nsbg)
  
  bg1:setFlipX(true)
  
  bg1:setPosition(CCPointMake(-bg1:getContentSize().width/2,self.m_ScreenSize.height/2))
  
  local bg1pos=ccp(bg1:getPosition())
  
  local bg2=CCSprite:create(nsbg)
  
  bg2:setFlipX(false)
  bg2:setPosition(CCPointMake(bg1pos.x+bg1:getContentSize().width-1,bg1pos.y))
    

  --让精灵都设置贴图无锯齿
  --bg1:getTexture():setAliasTexParameters()
  --bg2:getTexture():setAliasTexParameters()

 -- self:addChild(bg1,1)
  --self:addChild(bg2,2)
  self.m_GuanMap[self.m_GuanIndex]:addChild(bg1,1)
  self.m_GuanMap[self.m_GuanIndex]:addChild(bg2,1)
  self.m_BGTable[1]=bg1
  self.m_BGTable[2]=bg2
end


function MainScene:FlowerSnow()
    --随机得到该图片的初始x坐标
    local xf = math.random(1,680)
    --该精灵移动的最后坐标x轴的
    local xe =  math.random(10,680)
    --精灵缩放的比例
    local s = math.random()
    --旋转的角度
    local rol=math.random(1,360)
    --穿越屏幕的时间
    local sp = math.random(1,6)
    --透明度
    local t=math.random(1,50)
    
    local snowsprite = CCSprite:create("huaban.png")
    
    snowsprite:setPosition(CCPointMake(xf,480))
    snowsprite:setScale(s)
    snowsprite:setRotation(rol)
    snowsprite:setOpacity(t)
    self:addChild(snowsprite,MAX_ZORDER)
    
		local function remove()
		  snowsprite:stopAllActions()
		   --snowsprite:removeSelf()
		end
    
    local move2=CCMoveTo:create(3, CCPointMake(xe, -50))
    local fadout=CCFadeOut:create(1)
    local fcall=CCCallFuncN:create(remove)
    local arr = CCArray:create()
    arr:addObject(move2)    
    arr:addObject(fadout)  
    arr:addObject(fcall)  
    local sequence=CCSequence:create(arr)
    snowsprite:runAction(sequence)

end





function MainScene:onEditBoxBegan(editbox)
   
end

function MainScene:onEditBoxEnded(editbox)
   
end

function MainScene:onEditBoxReturn(editbox)
 
end

function MainScene:onEditBoxChanged(editbox)

end


-- 背景移动方式
function MainScene:moveBG()
 local bgTile1=self.m_BGTable[1]
  local bgTile2=self.m_BGTable[2]
  local screenSize = self.m_ScreenSize
  
  local bgTile1Pos=ccp(bgTile1:getPosition())
  local bgTile2Pos=ccp(bgTile2:getPosition())
  
  local bgTile1Size=bgTile1:getContentSize()
  local bgTile2Size=bgTile2:getContentSize()
  
  --背景左边边界值判断
  
  --如果背景的x数值小于屏幕宽度/2
  if (bgTile1Pos.x<screenSize.width/2) then 
    bgTile2:setPosition(CCPointMake(bgTile1Pos.x+bgTile1Size.width-1,bgTile1Pos.y))--screenSize.height/2))
 end
	
  if (bgTile2Pos.x<screenSize.width/2) then
     bgTile1:setPosition(CCPointMake(bgTile2Pos.x+bgTile2Size.width-1,bgTile2Pos.y))
  end

  --背景右边边界值判断
  if (bgTile1Pos.x>screenSize.width/2+bgTile1Size.width) then
        bgTile1:setPosition(CCPointMake(bgTile2Pos.x-bgTile1Size.width+1,screenSize.height*0.5))
  end
  
  
  if (bgTile2Pos.x>screenSize.width/2+bgTile2Size.width) then
       bgTile2:setPosition(CCPointMake(bgTile1Pos.x-bgTile2Size.width+1,bgTile2Pos.y))
  end
   
  local heropos = ccp(self.m_Hero:getPosition()) 
  
  local bgTile1Pos=ccp(bgTile1:getPosition())
  local bgTile2Pos=ccp(bgTile2:getPosition())  
  
  local bossPos=ccp(self.m_Boss:getPosition())
  
  local function ccpAdd(o,c)
  	return ccp(o.x+c.x,o.y+c.y)
  end
   
 	if (self.m_MoveStar~=self.m_MoveEnd) then
     
     bgTile1:setPosition(ccpAdd(bgTile1Pos, CCPointMake(-self.m_MoveDistance*3,0)))
     bgTile2:setPosition(ccpAdd(bgTile2Pos, CCPointMake(-self.m_MoveDistance*3,0)))
        
     self.m_Boss:setPosition(ccpAdd(bossPos, CCPointMake(-self.m_MoveDistance*3,0)))

  elseif (heropos.x>screenSize.width/2) then
	  bgTile1:setPosition(ccpAdd(bgTile1Pos, CCPointMake(-3,0)))
	  bgTile2:setPosition(ccpAdd(bgTile2Pos, CCPointMake(-3,0)))
	         
	  self.m_Hero:setPosition(CCPointMake(heropos.x-3,heropos.y))
	  self.m_Boss:setPosition(CCPointMake(bossPos.x-3,bossPos.y))
         
  elseif (heropos.x<screenSize.width/2-30) then
    bgTile1:setPosition(ccpAdd(bgTile1Pos, CCPointMake(3,0)))
    bgTile2:setPosition(ccpAdd(bgTile2Pos, CCPointMake(3,0)))
     self.m_Hero:setPosition(CCPointMake(heropos.x+3,heropos.y))
     self.m_Boss:setPosition(CCPointMake(bossPos.x+3,bossPos.y))
  end
  
  self.m_MoveStar=self.m_MoveEnd
   
end

--[[

]]
function MainScene:CreatePlayer()
	local x =100
	local y =200
	require "hero.create"

    sprite=createPlayerHero(x,y)
		self.m_Hero=sprite
    self:addChild(sprite,y)
    sprite:setScene(self)
    
    
    
    --创建血条
    local hpbar = CCProgressTimer:create(CCSprite:create("hp.png"))
    hpbar:setType(kCCProgressTimerTypeBar)
    hpbar:setMidpoint(CCPointMake(0, 1))
    hpbar:setPosition(ccp(78, 439))
    hpbar:setAnchorPoint(ccp(0,0))
    hpbar:setPercentage(100)
    hpbar:setBarChangeRate(ccp(1, 0))
		self:addChild(hpbar,MAX_ZORDER-6)
    --创建血条
    local expbar = CCProgressTimer:create(CCSprite:create("mp.png"))
    expbar:setMidpoint(CCPointMake(0, 1))
    expbar:setAnchorPoint(ccp(0,0))
    expbar:setBarChangeRate(ccp(1, 0))
    expbar:setType(kCCProgressTimerTypeBar)
    expbar:setPosition(ccp(74, 430))
    expbar:setPercentage(100)
	self:addChild(expbar,MAX_ZORDER-7)

	--头像背景
  local photoback=display.newSprite("photoback.png")
  photoback:setPosition(ccp(80,430))	
  self:addChild(photoback,MAX_ZORDER-9)	
    
  --创建头像

  local herophotoitem = CCMenuItemImage:create("herophoto.png", "herophoto.png")
  local herophoto = CCMenu:createWithItem(herophotoitem)
  herophoto:setPosition(ccp(30,440))	
  self:addChild(herophoto,MAX_ZORDER-8)   
    
    
  --创建技能面板
  
  
  --背包图标
  local backpackimage = CCMenuItemImage:create("ruck.png", "ruckbg.png")
  backpackimage:setScale(0.6) --缩放
  local backpack = CCMenu:createWithItem(backpackimage)
  backpack:setPosition(CCPointMake(290,25))	
  self:addChild(backpack,MAX_ZORDER)  
    
  local jnsprite=CCSprite:create("jinengban3.png")
  jnsprite:setOpacity(165)
  jnsprite:setPosition(CCPointMake(580,60))
  self:addChild(jnsprite,MAX_ZORDER-8)     
    
end

function MainScene:CreateBoss()
	require "boss.create"
	local x =500
	local y =200
  sprite=createBoss(x,y)
	self.m_Boss=sprite
  self:addChild(sprite,y)
  sprite:setScene(self)

end






--[[
帧事件处理函数
@param dt
]]
function MainScene:updateFrame(dt)
  self.frame = self.frame + 1
  self:moveBG()
	self.m_Hero:update(self.frame)
	
	if self.m_Boss ~= nil then
		self.m_Boss:update(self.frame)
	end
	
	if self.frame%10==0 then
		self:FlowerSnow()
	end

end


--[[
touch事件处理函数
@param event
@param x
@param y
]]
function MainScene:onTouch(event, x, y)
    self:moveObjects(x, y)
    return false
end



--[[
移动对象
@param x
@param y
]]
function MainScene:moveObjects(x, y)

	
end



--[[
检查更新
]]
function MainScene:checkUpdate()
	 --printf("checkUpdate-->")
end


function MainScene:CreateJoyStick(filename,x,y)
	joyobj=JoyStick.new(filename,x,y)
    joyobj:registerScriptTouchHandler(function(event, x, y)
          return joyobj:onTouch(event, x, y)
    end)
    joyobj:scheduleUpdate(function(dt) joyobj:updateFrame(dt) end) --更新      
    joyobj:setTouchEnabled(true)	
    return joyobj
end


function MainScene:AttackMenu()

    local function AttackEvent()
    	self.m_Hero:attack()
    end
    
    local AttackMenu = CCMenuItemImage:create("attack1.png", "attack2.png")
    AttackMenu:registerScriptTapHandler(AttackEvent)
    menuPopup = CCMenu:createWithItem(AttackMenu)
    menuPopup:setPosition(ccp(602,40))


    return menuPopup
end 
    
    

function MainScene:walkWithDirection(direction)
	self.m_Hero:walkWithDirection(direction)
end

function MainScene:didChangeDirectionTo(direction)
	self.m_Hero:walkWithDirection(direction)
end

function MainScene:isHoldingDirection(direction)
	self.m_Hero:walkWithDirection(direction)
end

function MainScene:OnTouchEnded(direction)
	if self.m_Hero.m_ActionState==ACTION_STATE_WALK then
		self.m_Hero:idle()
	end
end


function MainScene:onEnter()

    display.addSpriteFramesWithFile("Boss7.plist", "Boss7.png") --加载plist
   	display.addSpriteFramesWithFile("Boss8.plist", "Boss8.png") --加载plist
   	 
    self:ViewMapBG()
  
    self:CreatePlayer()
    
    self:CreateBoss()
    joyobj=self:CreateJoyStick("Dock1.png",50,50)
    self:addChild(joyobj,MAX_ZORDER)
    joyobj:setDelegate(self)
    
    local attackMenu=self:AttackMenu()
    self:addChild(attackMenu,MAX_ZORDER)    
    self:scheduleUpdate(function(dt) self:updateFrame(dt) end)
    -- 检查更新
    self:checkUpdate()    
    
    
    --增加几句测试合并
    --继续测试
    
end

return MainScene

