package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.loaders.TexturePackerData;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var bird:FlxSprite;
	private var bgArr:Array<FlxSprite>;
	private var groundArr:Array<FlxSprite>;
	private var pipeArr:Array<Pipes>;
	private var score:Int = 0;
	private var scoreText:FlxText;
	private var deadTimer:FlxTimer;
	private var grav:Float = 2;

	public static var flapSpeed:Float = 100;
	public static var forwardSpeed:Float = 50;
	public static var pipeGap:Float = 70;			//How far between pipes
	public static var groundHeight:Float = 50;
	public static var maxHoleSize:Float = 100;
	public static var minHoleSize:Float = 30;
	private static var pipeMargin:Float = 20;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		var spritesheet = new TexturePackerData("assets/images/spritesheet2.json", "assets/images/spritesheet2.png");

		//-------------------BACKGROUND
		var i:Int = 0;
		var bgWidth:Float = spritesheet.frames[0].sourceSize.x; 	//bg.png is the first sprite in the spritesheet
		bgArr = new Array<FlxSprite>();
		while(bgWidth * (i - 1) < FlxG.width)						//Have an extra bg for scrolling
		{
			var tempBG = new FlxSprite(bgWidth * i, 0);
			tempBG.loadGraphicFromTexture(spritesheet, false, "bg.png");

			tempBG.velocity.x = -forwardSpeed / 2;

			bgArr.push(tempBG);
			add(tempBG);
			i++;
		}

		//-------------------PIPES
		i = 0;
		pipeArr = new Array<Pipes>();
		var pipeWidth:Float = spritesheet.frames[6].sourceSize.x; 	//pipe cap.png is the 7th sprite in the spritesheet
		pipeMargin += spritesheet.frames[6].sourceSize.y;

		while((pipeWidth + pipeGap) * (i - 1) < FlxG.width)
		{
			var size = FlxRandom.floatRanged(minHoleSize, maxHoleSize);
			var height =  FlxRandom.floatRanged(pipeMargin + size / 2, FlxG.height - groundHeight - pipeMargin - size / 2);

			var tmp:Pipes = new Pipes(300 + i * (pipeGap + pipeWidth), height, size, spritesheet);
			tmp.setXVel(-forwardSpeed);
			
			pipeArr.push(tmp);
			add(tmp);
			i++;	
		}

		//-------------------BIRD
		bird = new FlxSprite(100, 100);
		bird.loadGraphicFromTexture(spritesheet);
		var names:Array<String> = ["flap up.png","flap mid.png","flap down.png","flap mid.png"];
		bird.animation.addByNames("flapping", names, 10);
		bird.animation.addByNames("dead", ["dead.png"], 10);
		bird.animation.play("flapping");
		bird.resetSizeFromFrame();
		bird.centerOrigin();
		add(bird);

		//-------------------GROUND
		i = 0;
		groundArr = new Array<FlxSprite>();
		var groundWidth:Float = spritesheet.frames[5].sourceSize.x; 	//ground.png is the 6th sprite in the spritesheet
		while(groundWidth * (i - 1) < FlxG.width)								//Have an extra ground for scrolling
		{
			var tempG = new FlxSprite(groundWidth * i, FlxG.height - groundHeight);
			tempG.loadGraphicFromTexture(spritesheet, false, "ground.png");

			tempG.velocity.x = -forwardSpeed;

			groundArr.push(tempG);
			add(tempG);
			i++;
		}

		scoreText = new FlxText(10, 10, FlxG.width, "SCORE: " + score, 15);
		scoreText.setFormat(null, 15, "center");
		scoreText.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 2);
		scoreText.x = Math.floor(scoreText.x);
		scoreText.y = Math.floor(scoreText.y);
		scoreText.antialiasing = false;
		add(scoreText);

		deadTimer = new FlxTimer();
		deadTimer.active = false;

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		//Collision
		for(i in 0...pipeArr.length)
		{
			if(pipeArr[i].collided(bird))
			{
				bird.alive = false;
				bird.animation.play("dead");
				bird.velocity.x = 0;

				if(bird.inWorldBounds())
					bird.velocity.y = -2 * flapSpeed;

				grav *= 5;
				break;
			}
			else if(pipeArr[i].passed(bird))
			{
				score += 10;
				scoreText.text = "SCORE: " + score;
			}
		}

		//BG rounding fix + scrolling
		for(i in 0...bgArr.length)
			bgArr[i].x = Math.round(bgArr[i].x * 1000) / 1000;

		if(bgArr[0].x + bgArr[0].width < 0)
		{
			var temp = bgArr[0];
			bgArr.remove(bgArr[0]);
			temp.x += (bgArr.length + 1) * temp.width;
			bgArr.push(temp);
		}

		//Ground rounding fix + scrolling
		for(i in 0...groundArr.length)
			groundArr[i].x = Math.round(groundArr[i].x * 10000) / 10000;

		if(groundArr[0].x + groundArr[0].width < 0)
		{
			var temp = groundArr[0];
			groundArr.remove(groundArr[0]);
			temp.x += (groundArr.length + 1) * temp.width;
			groundArr.push(temp);
		}

		//Pipe scrolling
		if(pipeArr[0].x + pipeArr[0].width < 0)
		{
			var temp = pipeArr[0];
			pipeArr.remove(pipeArr[0]);
			var size = FlxRandom.floatRanged(minHoleSize, maxHoleSize);
			var height =  FlxRandom.floatRanged(pipeMargin + size / 2, FlxG.height - groundHeight - pipeMargin - size / 2);
			var xOff = pipeArr[pipeArr.length - 1].x + temp.width + pipeGap;
			temp.reposition(xOff, height, size);
			pipeArr.push(temp);
		}


		if(bird.alive && (FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed))
			bird.velocity.y = -flapSpeed;


		//Ground collision
		if(bird.y + bird.height >= FlxG.height - groundHeight)
		{
			bird.alive = false;
			bird.animation.play("dead");
			bird.velocity.y = 0;
			//bird.angle = 0;
			bird.y = FlxG.height - groundHeight - bird.height;

			if(!bird.alive && !deadTimer.active)
			{
				deadTimer.start(1, function (t:FlxTimer):Void
				{
					this.openSubState(new GameoverScreen(score));
				});
			}
		}
		else
			bird.velocity.y += grav;

		//FUN ROTATION
		bird.angle += bird.velocity.y / 12;

		//Boring rotation
		/*if(bird.angle <= 70 && bird.angle >= -45)
			bird.angle += bird.velocity.y / 12;
		else if(bird.angle > 70)
			bird.angle = 70;
		else if(bird.angle < -45)
			bird.angle = -45;*/

		super.update();
	}	
}