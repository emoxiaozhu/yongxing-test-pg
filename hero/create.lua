
function createPlayerHero(x,y)
	display.addSpriteFramesWithFile("Boss7.plist", "Boss7.png") --����plist
	local hero=require("hero.HeroObject").new("Boss7Stand1.png",x,y)
	hero:idle()
	return hero
end