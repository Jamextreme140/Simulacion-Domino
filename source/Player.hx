import Token;
import flixel.FlxG;

class Player
{
	// Nombre del jugador
	public var name:String;
	// operadores
	public var token:Token;
	public var pass = false;

	// Arreglo de fichas
	public var tokens:Array<Token> = new Array<Token>();

	public function new(name:String)
	{
		this.name = name;
		// setToken();
	}

	@:deprecated("unused function")
	@:noCompletion
	function setToken()
	{
		for (i in 0...7)
		{
			token = new Token();
			token.set_North(FlxG.random.int(0, 6));
			switch (token.get_North())
			{
				case 0:
					token.set_South(0);
				case 1:
					token.set_South(FlxG.random.int(0, 1));
				case 2:
					token.set_South(FlxG.random.int(0, 2));
				case 3:
					token.set_South(FlxG.random.int(0, 3));
				case 4:
					token.set_South(FlxG.random.int(0, 4));
				case 5:
					token.set_South(FlxG.random.int(0, 5));
				case 6:
					token.set_South(FlxG.random.int(0, 6));
			}
			// Valor del sprite(para mostrar la ficha correspondiente)
			if (token.get_North() == 0 && token.get_South() == 0)
				token.SpriteValue = "0_0";
			else if (token.get_North() == 1 && token.get_South() == 0)
				token.SpriteValue = "1_0";
			else if (token.get_North() == 1 && token.get_South() == 1)
				token.SpriteValue = "1_1";
			else if (token.get_North() == 2 && token.get_South() == 0)
				token.SpriteValue = "2_0";
			else if (token.get_North() == 2 && token.get_South() == 1)
				token.SpriteValue == "2_1";
			else if (token.get_North() == 2 && token.get_South() == 2)
				token.SpriteValue == "2_2";
			else if (token.get_North() == 3 && token.get_South() == 0)
				token.SpriteValue = "3_0";
			else if (token.get_North() == 3 && token.get_South() == 1)
				token.SpriteValue = "3_1";
			else if (token.get_North() == 3 && token.get_South() == 2)
				token.SpriteValue = "3_2";
			else if (token.get_North() == 3 && token.get_South() == 3)
				token.SpriteValue = "3_3";
			else if (token.get_North() == 4 && token.get_South() == 0)
				token.SpriteValue = "4_0";
			else if (token.get_North() == 4 && token.get_South() == 1)
				token.SpriteValue = "4_1";
			else if (token.get_North() == 4 && token.get_South() == 2)
				token.SpriteValue = "4_2";
			else if (token.get_North() == 4 && token.get_South() == 3)
				token.SpriteValue = "4_3";
			else if (token.get_North() == 4 && token.get_South() == 4)
				token.SpriteValue = "4_4";
			else if (token.get_North() == 5 && token.get_South() == 0)
				token.SpriteValue = "5_0";
			else if (token.get_North() == 5 && token.get_South() == 1)
				token.SpriteValue = "5_1";
			else if (token.get_North() == 5 && token.get_South() == 2)
				token.SpriteValue = "5_2";
			else if (token.get_North() == 5 && token.get_South() == 3)
				token.SpriteValue = "5_3";
			else if (token.get_North() == 5 && token.get_South() == 4)
				token.SpriteValue = "5_4";
			else if (token.get_North() == 5 && token.get_South() == 5)
				token.SpriteValue = "5_5";
			else if (token.get_North() == 6 && token.get_South() == 0)
				token.SpriteValue = "6_0";
			else if (token.get_North() == 6 && token.get_South() == 1)
				token.SpriteValue = "6_1";
			else if (token.get_North() == 6 && token.get_South() == 2)
				token.SpriteValue = "6_2";
			else if (token.get_North() == 6 && token.get_South() == 3)
				token.SpriteValue = "6_3";
			else if (token.get_North() == 6 && token.get_South() == 4)
				token.SpriteValue = "6_4";
			else if (token.get_North() == 6 && token.get_South() == 5)
				token.SpriteValue = "6_5";
			else if (token.get_North() == 6 && token.get_South() == 6)
				token.SpriteValue = "6_6";
			// Se agrega al grupo de fichas
			tokens.push(token);
		}
	}

	public inline function getToken(index:Int)
	{
		return this.tokens[index];
	}

	public function getName()
	{
		return name;
	}
}
