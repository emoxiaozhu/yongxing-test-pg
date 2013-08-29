
function createBoss(x,y)
	display.addSpriteFramesWithFile("Boss8.plist", "Boss8.png") --º”‘ÿplist
	local boss=require("boss.BossObject").new("Boss8Stand1.png",x,y)
	boss:idle()
	return boss
end