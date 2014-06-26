package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var currChoice:Int = 0;
	private var choices:Array<MenuItem> = [];

	private var prevMouseX:Int;
	private var prevMouseY:Int;

	private var mouseSelected:Bool = false;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//TODO: Better menu for mobile
		var title:FlxText = new FlxText(0, 30, FlxG.width, "Cloney Bird", 35);
		title.setFormat(null, 35, 0xFFFFFFFF, "center");
		add(title);

		var tmp = new MenuItem(0, 150, "Play");
		tmp.onClick = function():Void
		{
			FlxG.switchState(new PlayState());
		}
		choices.push(tmp);
		add(tmp);

		//Dummy option
		tmp = new MenuItem(0, 150 + tmp.height, "Options");
		tmp.onClick = function():Void
		{
			this.openSubState(new OptionsMenu());
		}
		choices.push(tmp);
		add(tmp);

		prevMouseX = FlxG.mouse.screenX;
		prevMouseY = FlxG.mouse.screenY;

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
		//TODO: Not this
		if(FlxG.keys.anyJustReleased(["SPACE", "ENTER"]) || (mouseSelected && FlxG.mouse.justReleased))
		{
			if(!((FlxG.keys.anyJustReleased(["SPACE", "ENTER"]) && mouseSelected && FlxG.mouse.pressed) || 
				 (FlxG.keys.anyPressed(["SPACE", "ENTER"]) && mouseSelected && FlxG.mouse.justReleased)))
			{
				choices[currChoice].onClick();
				choices[currChoice].onLeave();
			}
		}
		else if(FlxG.keys.anyPressed(["SPACE", "ENTER"]) || (mouseSelected && FlxG.mouse.pressed))
		{
			choices[currChoice].onHold();

			super.update();
			return;
		}
		

		//Mouse hover, ignores if mouse is still
		if(FlxG.mouse.screenX - prevMouseX != 0 || FlxG.mouse.screenY - prevMouseY != 0)
		{
			mouseSelected = false;
			for (i in 0...choices.length)
			{
				if(FlxG.mouse.screenX > choices[i].x && FlxG.mouse.screenX < choices[i].x + choices[i].width)
				{
					if(FlxG.mouse.screenY > choices[i].y && FlxG.mouse.screenY < choices[i].y + choices[i].height)
					{
						choices[currChoice].onLeave();
						currChoice = i;
						choices[currChoice].onHover();

						mouseSelected = true;
					}
				}
			}

			prevMouseX = FlxG.mouse.screenX;
			prevMouseY = FlxG.mouse.screenY;

			if(!mouseSelected)
				choices[currChoice].onLeave();
		}

		//Key hover, overriden by mouse
		if(FlxG.keys.anyJustPressed(["DOWN", "S"]))
		{
			choices[currChoice].onLeave();

			currChoice = (currChoice + 1) % choices.length;
			choices[currChoice].onHover();

			mouseSelected = false;
		}
		else if(FlxG.keys.anyJustPressed(["UP", "W"]))
		{
			choices[currChoice].onLeave();
			
			if(currChoice == 0)
				currChoice = choices.length - 1;
			else
				currChoice = (currChoice - 1) % choices.length;

			choices[currChoice].onHover();

			mouseSelected = false;
		}

		super.update();
	}	
}