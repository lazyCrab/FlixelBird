package;

import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuItem extends FlxObject
{
	private var text:FlxText;

	public function new(x:Float, y:Float, size:Int = 15, label:String)
	{
		super();

		text = new FlxText(x, y, flixel.FlxG.width, label, 15);
		text.setFormat(null, size, "center");

		this.x = x;
		this.y = y;
		this.height = text.height;
		this.width = text.width;
	}

	public dynamic function onClick():Void
	{
		
	}

	public function onHover():Void
	{
		text.setBorderStyle(FlxText.BORDER_OUTLINE_FAST, 0x555555, 2);
	}

	public function onHold():Void
	{
		text.setBorderStyle(FlxText.BORDER_OUTLINE_FAST, 0x333333, 2);
	}

	public function onLeave():Void
	{
		text.setBorderStyle(FlxText.BORDER_NONE);
	}

	override public function draw():Void
	{
		text.draw();

		super.draw();
	}
}