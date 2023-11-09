import flixel.FlxSprite;

// Clase ficha
class Token extends FlxSprite
{
	// Superior e inferior
	var North:Int;
	var South:Int;
	var Points:Int;

	// Valor del sprite
	public var SpriteValue:String;

	public function new()
	{
		super();
	}

	public function set_North(value:Int):Void
	{
		North = value;
	}

	public function get_North():Int
	{
		return North;
	}

	public function set_South(value:Int):Void
	{
		South = value;
	}

	public function get_South():Int
	{
		return South;
	}

	public function get_SpriteValue():String
	{
		return SpriteValue;
	}

	public function set_SpriteValue(value:String):Void
	{
		SpriteValue = value;
	}

	public function get_Points()
	{
		return North + South;
	}

	override public function destroy()
	{
		super.destroy();
	}
}
