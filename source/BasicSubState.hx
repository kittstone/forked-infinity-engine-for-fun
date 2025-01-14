package;

import menus.TitleScreenState;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.FlxG;
import game.Conductor;
import flixel.FlxSprite;

class BasicSubState extends FlxSubState
{
	//bpm and step
	var curStep:Int = 0;
	var curBeat:Int = 0;

	public function new()
	{
		super();

		if(TitleScreenState.optionsInitialized)
			Controls.refreshControls();

		//if(FlxG.camera != null)
		//	FlxG.camera.fade(FlxColor.TRANSPARENT, 0.5, true);
	}

	override function create() {
		super.create();

		if(TitleScreenState.optionsInitialized)
			Controls.refreshControls();
	}

	public function funkyBpm(BPM:Float, ?songMultiplier:Float = 1)
	{
		Conductor.changeBPM(BPM, songMultiplier);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if(oldStep != curStep)
			stepHit();

		FlxG.stage.frameRate = Options.getData('fpsCap');

		if(TitleScreenState.optionsInitialized)
			Controls.refreshControls();
	}

	//transition
	var transitionSpr:FlxSprite = new FlxSprite(0, 0, 'assets/images/transition.png');

	public function transitionState(state:FlxState)
	{
		if(TitleScreenState.optionsInitialized)
			Controls.refreshControls();

		FlxG.switchState(state);

		if(TitleScreenState.optionsInitialized)
			Controls.refreshControls();
		//FlxG.camera.fade(FlxColor.BLACK, 0.5, true, function(){ FlxG.switchState(state); }, true);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / (16 / Conductor.timeScale[1]));
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		Conductor.recalculateStuff();

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);

		updateBeat();
	}

	public function stepHit():Void
	{
		if (curStep % Conductor.timeScale[0] == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
