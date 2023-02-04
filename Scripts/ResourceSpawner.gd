extends StaticBody

var erected = false

func hurt(damage: int):
	if erected:
		return
	$Shroom.visible = true
	erected = true
