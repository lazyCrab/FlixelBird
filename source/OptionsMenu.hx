package;

import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.addons.ui.FlxSlider;
import flixel.ui.FlxButton;
import flixel.FlxG;

class OptionsMenu extends FlxSubState
{
	var back:MenuItem;
	public function new()
	{
		super();

		var bgOverlay:FlxSprite = new FlxSprite(0, 0);
		bgOverlay.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(bgOverlay);

		var title:FlxText = new FlxText(0, 30, FlxG.width, "Options", 25);
		title.setFormat(null, 25, 0xFFFFFFFF, "center");
		add(title);

		var slider:FlxSlider = new FlxSlider(PlayState, "flapSpeed", 20, 70, 0, 200, 100, 20, 2, 0xFFFFFFFF, 0xFFAAAAAA);
		slider.nameLabel.text = "Flapping force";
		add(slider);

		slider = new FlxSlider(PlayState, "forwardSpeed", 200, 70, 0, 200, 100, 20, 2, 0xFFFFFFFF, 0xFFAAAAAA);
		slider.nameLabel.text = "Forward speed";
		add(slider);

		slider = new FlxSlider(PlayState, "minHoleSize", 20, 130, 0, 200, 100, 20, 2, 0xFFFFFFFF, 0xFFAAAAAA);
		slider.nameLabel.text = "Minimum pipe gap";
		add(slider);

		slider = new FlxSlider(PlayState, "maxHoleSize", 200, 130, 0, 200, 100, 20, 2, 0xFFFFFFFF, 0xFFAAAAAA);
		slider.nameLabel.text = "Maximum pipe gap";
		add(slider);


		back = new MenuItem(0, 200, "Back");
		back.onClick = function ():Void
		{
			FlxG.state.closeSubState();
		};
		add(back);
	}

	override public function update():Void
	{
		if(FlxG.mouse.justReleased)
		{
			if(FlxG.mouse.screenX > back.x && FlxG.mouse.screenX < back.x + back.width)
			{
				if(FlxG.mouse.screenY > back.y && FlxG.mouse.screenY < back.y + back.height)
				{
					back.onClick();
				}
			}
		}

		super.update();
	}
}