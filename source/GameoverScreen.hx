package;

import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.util.loaders.TexturePackerData;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxSave;

class GameoverScreen extends FlxSubState
{
	private var scoreSave:FlxSave;

	public function new(score:Int)
	{
		super();

		//------------- TODO: Highscores! -------------//
	/*	scoreSave = new FlxSave();
		scoreSave.bind("highscores");

		if(scoreSave.data.highNames == null)
		{
			var highNames:Array<String> = new Array<String>();
			var highScores:Array<Int> = new Array<Int>();

			for (i in 0...10) 
				highNames.push("Eric the Great");

			highScores.push(20);
			highScores.push(40);
			highScores.push(60);
			highScores.push(80);
			highScores.push(100);
			highScores.push(200);
			highScores.push(400);
			highScores.push(600);
			highScores.push(800);
			highScores.push(1000);

			scoreSave.data.highNames = highNames;
			scoreSave.data.highScores = highScores;
		}*/

		var bgOverlay:FlxSprite = new FlxSprite(0, 0);
		bgOverlay.makeGraphic(flixel.FlxG.width, flixel.FlxG.height, 0x80000000);
		add(bgOverlay);

		var spritesheet:TexturePackerData = new TexturePackerData("assets/images/spritesheet2.json", "assets/images/spritesheet2.png");
		var gameoverSprite:FlxSprite = new FlxSprite(0, 70);
		gameoverSprite.loadGraphicFromTexture(spritesheet, false, "gameover.png");
		gameoverSprite.scale.x = 2;
		gameoverSprite.scale.y = 2;
		gameoverSprite.updateHitbox();
		gameoverSprite.x = (flixel.FlxG.width - gameoverSprite.width) / 2;
		add(gameoverSprite);

		var pressAnything:FlxText = new FlxText(0, 200, flixel.FlxG.width, "Press space to restart.", 13);
		pressAnything.setFormat(null, 13, "center");

		#if mobile
			pressAnything.text = "Tap anywhere to restart.";
		#end

		add(pressAnything);
	}

	override public function update():Void
	{
		if(flixel.FlxG.keys.justReleased.SPACE || flixel.FlxG.mouse.justReleased)
		{
			//flixel.FlxG.state.closeSubState();
			flixel.FlxG.resetState();
		}

		super.update();
	}
}