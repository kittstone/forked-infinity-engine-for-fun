package ui;

import mods.Mods;
import lime.utils.Assets;
import ui.TrackerSprite.TrackerDirection;
import flixel.FlxSprite;

using StringTools;

class Icon extends TrackerSprite
{
	var isPixel:Bool = false;

	public function new(?iconPath:String = "test", ?tracker:FlxSprite, ?isPlayer:Bool = false, ?xOff:Float = 10, ?yOff:Float = -30, ?direction:TrackerDirection = RIGHT, ?swagChar:String = "bf")
	{
		super(tracker, xOff, yOff, direction);

		switch(swagChar)
		{
			case "senpai" | "senpai-angry" | "spirit": // hardcoded char override bc i can't be bothered rn
				isPixel = true;
		}

		if(iconPath.contains('-pixel') || isPixel)
			antialiasing = false;
		else
			antialiasing = Options.getData('anti-aliasing');

		loadGraphic(Util.getImage(iconPath, false), true, 150, 150);

		animation.add("default", [0], 0, false, isPlayer);
		animation.add("dead", [1], 0, false, isPlayer);
		animation.add("winning", [2], 0, false, isPlayer);

		animation.play("default");
	}
}