package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.loaders.TexturePackerData;

class Pipes extends FlxObject
{
	private var pipeCap1:FlxSprite;
	private var pipeCap2:FlxSprite;
	private var pipeBod1:FlxSprite;
	private var pipeBod2:FlxSprite;
	private var hasPassed:Bool;

	public function new(xOffset:Float, holeHeight:Float, holeSize:Float, spritesheet:TexturePackerData)
	{
		super();

		x = xOffset;
		y = 0;

		pipeCap2 = new FlxSprite(xOffset, holeSize / 2 + holeHeight);
		pipeCap2.loadGraphicFromTexture(spritesheet, false, "pipe cap.png");
		pipeCap2.flipY = true;

		pipeCap1 = new FlxSprite(xOffset, holeHeight - holeSize / 2 - pipeCap2.height);
		pipeCap1.loadGraphicFromTexture(spritesheet, false, "pipe cap.png");

		pipeBod2 = new FlxSprite(xOffset, 0);
		pipeBod2.loadGraphicFromTexture(spritesheet, false, "pipe main.png");

		pipeBod1 = new FlxSprite(xOffset, 0);
		pipeBod1.loadGraphicFromTexture(spritesheet, false, "pipe main.png");

		pipeBod1.scale.y = pipeCap1.y / pipeBod1.height + 1;
		pipeBod1.updateHitbox();
		pipeBod1.y = 0;
		
		pipeBod2.scale.y = (flixel.FlxG.height - PlayState.groundHeight - (pipeCap2.y + pipeCap2.height)) / pipeBod2.height + 1;
		pipeBod2.updateHitbox();
		pipeBod2.y = pipeCap2.y + pipeCap2.height - 1;

		height = flixel.FlxG.height - PlayState.groundHeight;
		width = pipeCap1.width;
	}

	public function collided(bird:FlxSprite):Bool
	{
		if(!bird.alive)
			return false;

		if(!bird.inWorldBounds() && bird.x >= x)
			return true;

		if(bird.overlaps(pipeCap1) || bird.overlaps(pipeCap2) || bird.overlaps(pipeBod1) || bird.overlaps(pipeBod2))
			return true;

		return false;
	}

	public function passed(bird:FlxSprite):Bool
	{
		if(!bird.alive || hasPassed)
			return false;
		else if(bird.x > x + width)
		{
			hasPassed = true;
			return true;
		}

		return false;
	}
	
	public function setXVel(vel:Float):Void
	{
		pipeCap1.velocity.x = vel;
		pipeCap2.velocity.x = vel;
		pipeBod1.velocity.x = vel;
		pipeBod2.velocity.x = vel;
		velocity.x = vel;
	}

	public function reposition(xOffset:Float, holeHeight:Float, holeSize:Float):Void
	{
		hasPassed = false;

		x = xOffset;

		pipeBod1.scale.y = 1;
		pipeBod1.updateHitbox();
		pipeBod2.scale.y = 1;
		pipeBod2.updateHitbox();

		pipeCap1.x = xOffset;
		pipeCap2.x = xOffset;
		pipeBod1.x = xOffset;
		pipeBod2.x = xOffset;

		pipeCap1.y = holeHeight - holeSize / 2 - pipeCap2.height;
		pipeCap2.y = holeSize / 2 + holeHeight;

		pipeBod1.scale.y = pipeCap1.y / pipeBod1.height + 1;
		pipeBod1.updateHitbox();
		pipeBod1.y = 0;
		
		pipeBod2.scale.y = (flixel.FlxG.height - PlayState.groundHeight - (pipeCap2.y + pipeCap2.height)) / pipeBod2.height + 1;
		pipeBod2.updateHitbox();
		pipeBod2.y = pipeCap2.y + pipeCap2.height - 1;
	}

	override public function draw()
	{
		pipeBod1.draw();
		pipeBod2.draw();
		pipeCap1.draw();
		pipeCap2.draw();

		super.draw();
	}

	override public function update()
	{
		pipeCap1.update();
		pipeCap2.update();
		pipeBod1.update();
		pipeBod2.update();

		super.update();
	}
}