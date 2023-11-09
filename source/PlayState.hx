package;

import Player;
import Token;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIInputText;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import haxe.Timer;
import haxe.ds.Map;
import openfl.system.System;

class PlayState extends FlxState
{
	var title:FlxText;
	var xy:FlxText;
	var mem:FlxText;
	var textfield:FlxUIInputText;
	var button:FlxButton;

	// Operadores de juego
	var end = false;
	var firstGame = false;
	var timer = new FlxTimer();
	// Jugadores
	var player1 = new Player("Mario");
	var player2 = new Player("Juan");
	var player3 = new Player("Maria");
	var player4 = new Player("Antonio");

	public static var p1 = 0;
	public static var p2 = 0;
	public static var p3 = 0;
	public static var p4 = 0;

	// Mesa
	// false = izquierda | true = derecha

	/**
	 * Lado izquierdo de las fichas (false)
	 */
	var left = new Array<Token>();

	/**
	 * Lado derecho de las fichas (true)
	 */
	var right = new Array<Token>();

	// Scores
	var scores:Map<Int, Int> = new Map<Int, Int>();
	var winner:Int;

	public static var pr:Float = 0;

	public static var pr_f:Float = 0;

	inline function sleep(Seconds:Float)
	{
		new FlxTimer().start(Seconds, printWait, 1);
	}

	function printWait(_):Void
	{
		haxe.Log.trace("Wait...", null);
	}

	/**
	 * Busca en el arreglo si existe el valor dado
	 * @param item - Arreglo lineal (Array<?>)
	 * @param value - Valor a buscar (String)
	 */
	function searchSpriteValue(item:Array<Token>, value:String)
	{
		for (i in item)
		{
			if (i.SpriteValue == value)
				return true;
		}
		return false;
	}

	/**
	 * devuelve el numero de indice del arreglo dado
	 * @param item - Arreglo lineal (Array<?>)
	 * @param value - Valor a buscar
	 */
	function searchSpriteIndex(item:Array<Token>, value:String)
	{
		for (i in item)
		{
			if (i.SpriteValue == value)
				return item.indexOf(i);
		}
		return null;
	}

	function searchValueIndex(item:Array<Token>, value:Int)
	{
		for (i in item)
		{
			if (i.get_North() == value || i.get_South() == value)
				return item.indexOf(i);
		}
		return null;
	}

	function searchSVArr(item:Array<Token>, arr:Array<String>)
	{
		for (i in item)
		{
			if (arr.contains(i.SpriteValue))
				return true;
		}
		return false;
	}

	/**
	 * verifica si hay fichas activas (en pantalla)
	 */
	function tokenActive()
	{
		if (player1.tokens[0] != null)
		{
			trace(player1.tokens[0].get_SpriteValue());
			return true;
		}
		else
		{
			trace("not created. execute");
			return false;
		}
	}

	function checkTokens(players:Array<Player>)
	{
		if (players[0].tokens.length == 0)
		{
			winner = 1;
			trace("Jugador 1 ganó");
			return false;
		}
		else if (players[1].tokens.length == 0)
		{
			winner = 2;
			trace("Jugador 2 ganó");
			return false;
		}
		else if (players[2].tokens.length == 0)
		{
			winner = 3;
			trace("Jugador 3 ganó");
			return false;
		}
		else if (players[3].tokens.length == 0)
		{
			winner = 4;
			trace("Jugador 4 ganó");
			return false;
		}
		return true;
	}

	function checkPass(players:Array<Player>)
	{
		if (players[0].pass == players[1].pass == players[2].pass == players[3].pass == true)
			return true;
		else
			return false;
	}

	/**
	 * Elimina las fichas de los jugadores
	 */
	function restartTokens()
	{
		FlxDestroyUtil.destroyArray(player1.tokens);
		FlxDestroyUtil.destroyArray(player2.tokens);
		FlxDestroyUtil.destroyArray(player3.tokens);
		FlxDestroyUtil.destroyArray(player4.tokens);
		FlxDestroyUtil.destroyArray(left);
		FlxDestroyUtil.destroyArray(right);
		player1.tokens.splice(0, player1.tokens.length);
		player2.tokens.splice(0, player2.tokens.length);
		player3.tokens.splice(0, player3.tokens.length);
		player4.tokens.splice(0, player4.tokens.length);
		left.splice(0, left.length);
		right.splice(0, right.length);
		scores.clear();
		clear();
		#if debug Sys.sleep(0.2); #end
	}

	/**
	 * Crea y reparte las fichas a cada jugador
	 */
	function giveTokens()
	{
		for (l in 0...4) // Cada jugador
		{
			var i = 0; // Contador de control
			while (i < 7) // 7 fichas
			{
				var token = new Token();
				token.set_North(FlxG.random.int(0, 6));
				// used.push(token.get_North()); // Se añade al arreglos de valores usados
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
				#if debug trace(token.get_North() + " | " + token.get_South()); #end
				// Valor del sprite(para mostrar la ficha correspondiente)
				// dependiendo de los valores generados
				if (token.get_North() == 0 && token.get_South() == 0)
					token.SpriteValue = "0_0";
				else if (token.get_North() == 1 && token.get_South() == 0)
					token.SpriteValue = "1_0";
				else if (token.get_North() == 1 && token.get_South() == 1)
					token.SpriteValue = "1_1";
				else if (token.get_North() == 2 && token.get_South() == 0)
					token.SpriteValue = "2_0";
				else if (token.get_North() == 2 && token.get_South() == 1)
					token.SpriteValue = "2_1";
				else if (token.get_North() == 2 && token.get_South() == 2)
					token.SpriteValue = "2_2";
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
				// Se carga la imagen
				token.loadGraphic("assets/images/" + token.SpriteValue + ".png");
				#if debug trace(i + " -> " + token.get_SpriteValue()); #end
				token.scale.set(0.2, 0.2);
				token.updateHitbox();
				token.updateFramePixels();
				// Se agrega al grupo de fichas
				// Dependiendo del jugador
				if (l == 0)
				{
					if (i > 1)
					{
						if (searchSpriteValue(player1.tokens, token.get_SpriteValue()))
						{
							continue;
						}
					}
					token.angle = 90; // A la izquierda
					token.setPosition(25, 130 + (45 * i));
					player1.tokens.push(token);
				}
				if (l == 1)
				{
					// Verifica si el token generado es igual al del otro jugador
					if (searchSpriteValue(player1.tokens, token.get_SpriteValue()))
						continue; // Vuelve a hacer la iteracion
					// Verifica si el token generado no se repite
					else if (searchSpriteValue(player2.tokens, token.get_SpriteValue()))
						continue;
					else
					{
						token.angle = 180; // Arriba
						token.setPosition(475 + (45 * i), 10);
						player2.tokens.push(token);
					}
				}
				if (l == 2)
				{
					if (searchSpriteValue(player2.tokens, token.get_SpriteValue())
						|| searchSpriteValue(player1.tokens, token.get_SpriteValue()))
						continue;
					else if (searchSpriteValue(player3.tokens, token.get_SpriteValue()))
						continue;
					else
					{
						token.angle = -90; // A la derecha
						token.setPosition(1210, 130 + (45 * i));
						player3.tokens.push(token);
					}
				}
				if (l == 3)
				{
					if (searchSpriteValue(player3.tokens, token.get_SpriteValue())
						|| searchSpriteValue(player2.tokens, token.get_SpriteValue())
						|| searchSpriteValue(player1.tokens, token.get_SpriteValue()))
						continue;
					else if (searchSpriteValue(player4.tokens, token.get_SpriteValue()))
						continue;
					else
					{
						token.setPosition(475 + (45 * i), 610);
						player4.tokens.push(token); // Abajo
					}
				}
				i++;
			}
			#if debug
			haxe.Log.trace("Jugador " + (l + 1) + " preparado", null);
			// Sys.command("cls");
			#end
			// reinicia la lista
		}
	}

	function openResult()
	{
		pr_f = pr;
		trace(pr_f);
		openSubState(new ResultState([p1, p2, p3, p4], pr_f));
	}

	function setTitle(text:String, /* x:Int, y:Int,*/ size:Int)
	{
		title = new FlxText();
		title.text = text;
		title.color = FlxColor.fromRGB(54, 54, 54);
		title.size = size;
		title.screenCenter();
		return title;
	}

	function setButton(text:String, x:Float, y:Float)
	{
		button = new FlxButton(x, y, text, onButtonClicked);
		return button;
	}

	function setTextField(x:Float, y:Float)
	{
		textfield = new FlxUIInputText(x, y, 100, null, 16);
		return textfield;
	}

	function setText(text:String, x:Float, y:Float)
	{
		var Text = new FlxText(x, y);
		Text.text = text;
		Text.color = FlxColor.WHITE;
		Text.size = 16;
		return Text;
	}

	#if debug
	function setXY(text:String, x:Float, y:Float)
	{
		xy = new FlxText(x, y);
		xy.text = text;
		xy.color = FlxColor.WHITE;
		xy.size = 12;
		return xy;
	}

	function setMem(x:Float, y:Float)
	{
		mem = new FlxText(x, y);
		mem.text = "Memory: " + Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
		mem.color = FlxColor.WHITE;
		mem.size = 12;
		return mem;
	}
	#end

	// Boton para iniciar la simulacion
	function onButtonClicked()
	{
		haxe.Log.trace("Starting...", null);
		// openResult();
		Simulation(Std.parseInt(textfield.text));
	}

	/**
	 * Inicia la simulacion
	 */
	function Simulation(times:Int)
	{
		// Comienza la simulación
		var player_C = 0;
		var i = 0;
		var execute = true;
		trace(times);

		// Ultima ficha tirada (derecha)
		var lastToken = {
			North: 0,
			South: 0,
			x: 0.0,
			y: 0.0
		};

		// Ultima ficha tirada (izquierda)
		var lastToken1 = {
			North: 0,
			South: 0,
			x: 0.0,
			y: 0.0
		}
		var mula = "6_6";
		// var execute = true;
		var x = 618;
		var y = 317;

		var move = 40;
		var move_1 = move * 2;
		// Busca el jugador con la ficha mas alta (mula de 6)
		function firstPlay()
		{
			var init = 0;
			init = Std.int(Math.random() * 2);
			// Jugador 1
			if (searchSpriteValue(player1.tokens, mula))
			{
				player_C = 0;
				player1.tokens[searchSpriteIndex(player1.tokens, mula)].screenCenter();
				player1.tokens[searchSpriteIndex(player1.tokens, mula)].angle = 0;
				if (init == 0)
					left.push(player1.tokens[searchSpriteIndex(player1.tokens, mula)]);
				else
					right.push(player1.tokens[searchSpriteIndex(player1.tokens, mula)]);
				lastToken.North = player1.tokens[searchSpriteIndex(player1.tokens, mula)].get_North();
				lastToken1.North = player1.tokens[searchSpriteIndex(player1.tokens, mula)].get_North();
				lastToken.South = player1.tokens[searchSpriteIndex(player1.tokens, mula)].get_South();
				lastToken1.South = player1.tokens[searchSpriteIndex(player1.tokens, mula)].get_South();
				lastToken.x = player1.tokens[searchSpriteIndex(player1.tokens, mula)].x;
				lastToken1.x = player1.tokens[searchSpriteIndex(player1.tokens, mula)].x;
				lastToken.y = player1.tokens[searchSpriteIndex(player1.tokens, mula)].y;
				lastToken1.y = player1.tokens[searchSpriteIndex(player1.tokens, mula)].y;
				player1.tokens.remove(player1.tokens[searchSpriteIndex(player1.tokens, mula)]);
			}
			// Jugador 2
			else if (searchSpriteValue(player2.tokens, mula))
			{
				player_C = 1;
				player2.tokens[searchSpriteIndex(player2.tokens, mula)].screenCenter();
				if (init == 0)
					left.push(player2.tokens[searchSpriteIndex(player2.tokens, mula)]);
				else
					right.push(player2.tokens[searchSpriteIndex(player2.tokens, mula)]);
				lastToken.North = player2.tokens[searchSpriteIndex(player2.tokens, mula)].get_North();
				lastToken1.North = player2.tokens[searchSpriteIndex(player2.tokens, mula)].get_North();
				lastToken.South = player2.tokens[searchSpriteIndex(player2.tokens, mula)].get_South();
				lastToken1.South = player2.tokens[searchSpriteIndex(player2.tokens, mula)].get_South();
				lastToken.x = player2.tokens[searchSpriteIndex(player2.tokens, mula)].x;
				lastToken1.x = player2.tokens[searchSpriteIndex(player2.tokens, mula)].x;
				lastToken.y = player2.tokens[searchSpriteIndex(player2.tokens, mula)].y;
				lastToken1.y = player2.tokens[searchSpriteIndex(player2.tokens, mula)].y;
				player2.tokens.remove(player2.tokens[searchSpriteIndex(player2.tokens, mula)]);
			}
			// Jugador 3
			else if (searchSpriteValue(player3.tokens, mula))
			{
				player_C = 2;
				player3.tokens[searchSpriteIndex(player3.tokens, mula)].screenCenter();
				player3.tokens[searchSpriteIndex(player3.tokens, mula)].angle = 0;
				if (init == 0)
					left.push(player3.tokens[searchSpriteIndex(player3.tokens, mula)]);
				else
					right.push(player3.tokens[searchSpriteIndex(player3.tokens, mula)]);
				lastToken.North = player3.tokens[searchSpriteIndex(player3.tokens, mula)].get_North();
				lastToken1.North = player3.tokens[searchSpriteIndex(player3.tokens, mula)].get_North();
				lastToken.South = player3.tokens[searchSpriteIndex(player3.tokens, mula)].get_South();
				lastToken1.South = player3.tokens[searchSpriteIndex(player3.tokens, mula)].get_South();
				lastToken.x = player3.tokens[searchSpriteIndex(player3.tokens, mula)].x;
				lastToken1.x = player3.tokens[searchSpriteIndex(player3.tokens, mula)].x;
				lastToken.y = player3.tokens[searchSpriteIndex(player3.tokens, mula)].y;
				lastToken1.y = player3.tokens[searchSpriteIndex(player3.tokens, mula)].y;
				player3.tokens.remove(player3.tokens[searchSpriteIndex(player3.tokens, mula)]);
			}
			// Jugador 4
			else if (searchSpriteValue(player4.tokens, mula))
			{
				player_C = 3;
				player4.tokens[searchSpriteIndex(player4.tokens, mula)].screenCenter();
				if (init == 0)
					left.push(player4.tokens[searchSpriteIndex(player4.tokens, mula)]);
				else
					right.push(player4.tokens[searchSpriteIndex(player4.tokens, mula)]);
				lastToken.North = player4.tokens[searchSpriteIndex(player4.tokens, mula)].get_North();
				lastToken1.North = player4.tokens[searchSpriteIndex(player4.tokens, mula)].get_North();
				lastToken.South = player4.tokens[searchSpriteIndex(player4.tokens, mula)].get_South();
				lastToken1.South = player4.tokens[searchSpriteIndex(player4.tokens, mula)].get_South();
				lastToken.x = player4.tokens[searchSpriteIndex(player4.tokens, mula)].x;
				lastToken1.x = player4.tokens[searchSpriteIndex(player4.tokens, mula)].x;
				lastToken.y = player4.tokens[searchSpriteIndex(player4.tokens, mula)].y;
				lastToken1.y = player4.tokens[searchSpriteIndex(player4.tokens, mula)].y;
				player4.tokens.remove(player4.tokens[searchSpriteIndex(player4.tokens, mula)]);
			}
			#if debug
			haxe.Log.trace("Jugador " + (player_C + 1) + " comienza", null);
			haxe.Log.trace(lastToken.x + " | " + lastToken.y);
			#end
		}

		// Dibuja las fichas
		function drawTokens()
		{
			for (i in 0...4)
			{
				for (j in 0...7)
				{
					if (i == 0)
						add(player1.getToken(j));
					if (i == 1)
						add(player2.getToken(j));
					if (i == 2)
						add(player3.getToken(j));
					if (i == 3)
						add(player4.getToken(j));
				}
				#if TRACING haxe.Log.trace("Jugador " + (i + 1) + " listo", null); #end
			}
		}

		function setLastToken(North:Int, South:Int, x:Float, y:Float, side:Bool)
		{
			// true = derecha | false = izquierda
			if (side == true)
			{
				lastToken.North = North;
				lastToken.South = South;
				lastToken.x = x;
				lastToken.y = y;
			}
			else
			{
				lastToken1.North = North;
				lastToken1.South = South;
				lastToken1.x = x;
				lastToken1.y = y;
			}
		}

		function calculate(player:Player)
		{
			var p = 0;
			for (i in player.tokens)
			{
				p += i.get_Points();
			}
			return p;
		}

		function highScore(ref:Map<Int, Int>)
		{
			var player_n = 1;
			var high = 0;
			for (i => v in ref)
			{
				if (v > high)
				{
					high = v;
					player_n = i;
				}
			}
			return player_n;
		}

		function play(t:FlxTimer)
		{
			if (firstGame == true)
			{
				restartTokens();
			}
			giveTokens();
			drawTokens();
			firstPlay();
			// Sys.sleep(0.1);
			// sleep(0.1);
			var used = new Array<String>();
			used.push(mula);

			// Movimiento de las fichas
			// true = derecha | false = izquierda
			// Jugador 1 - comienza 2
			if (player_C == 0)
			{
				if (searchValueIndex(player2.tokens, lastToken.North) != null)
				{
					var ValueIndex = searchValueIndex(player2.tokens, lastToken.North);
					if (FlxG.random.bool())
					{
						player2.tokens[ValueIndex].angle = 270;
						player2.tokens[ValueIndex].updateHitbox();
						player2.tokens[ValueIndex].setPosition(x + move, y);
						setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
							player2.tokens[ValueIndex].y, true);
						used.push(player2.tokens[ValueIndex].SpriteValue);
						right.push(player2.tokens[ValueIndex]);
						player2.tokens.remove(player2.tokens[ValueIndex]);
						trace("derecha");
					}
					else
					{
						player2.tokens[ValueIndex].angle = 90;
						player2.tokens[ValueIndex].updateHitbox();
						player2.tokens[ValueIndex].setPosition(x - move, y);
						setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
							player2.tokens[ValueIndex].y, false);
						used.push(player2.tokens[ValueIndex].SpriteValue);
						left.push(player2.tokens[ValueIndex]);
						player2.tokens.remove(player2.tokens[ValueIndex]);
						trace("izquierda");
					}
					player2.pass = false;
				}
				else
				{
					player2.pass = true;
					if (searchValueIndex(player3.tokens, lastToken.North) != null)
					{
						var ValueIndex = searchValueIndex(player3.tokens, lastToken.North);
						if (FlxG.random.bool())
						{
							player3.tokens[ValueIndex].setPosition(x + move, y);
							setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
								player3.tokens[ValueIndex].y, true);
							used.push(player3.tokens[ValueIndex].SpriteValue);
							right.push(player3.tokens[ValueIndex]);
							player3.tokens.remove(player3.tokens[ValueIndex]);
							trace("derecha");
						}
						else
						{
							player3.tokens[ValueIndex].angle = 90;
							player3.tokens[ValueIndex].updateHitbox();
							player3.tokens[ValueIndex].setPosition(x - move, y);
							setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
								player3.tokens[ValueIndex].y, false);
							used.push(player3.tokens[ValueIndex].SpriteValue);
							left.push(player3.tokens[ValueIndex]);
							player3.tokens.remove(player3.tokens[ValueIndex]);
							trace("izquierda");
						}
						player3.pass = false;
					}
					else
					{
						player3.pass = true;
						if (searchValueIndex(player4.tokens, lastToken.North) != null)
						{
							var ValueIndex = searchValueIndex(player4.tokens, lastToken.North);
							if (FlxG.random.bool())
							{
								player4.tokens[ValueIndex].angle = -90;
								player4.tokens[ValueIndex].updateHitbox();
								player4.tokens[ValueIndex].setPosition(x + move, y);
								setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
									player4.tokens[ValueIndex].y, true);
								used.push(player4.tokens[ValueIndex].SpriteValue);
								right.push(player4.tokens[ValueIndex]);
								player4.tokens.remove(player4.tokens[ValueIndex]);
								trace("derecha");
							}
							else
							{
								player4.tokens[ValueIndex].angle = 90;
								player4.tokens[ValueIndex].updateHitbox();
								player4.tokens[ValueIndex].setPosition(x - move, y);
								setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
									player4.tokens[ValueIndex].y, false);
								used.push(player4.tokens[ValueIndex].SpriteValue);
								left.push(player4.tokens[ValueIndex]);
								player4.tokens.remove(player4.tokens[ValueIndex]);
								trace("izquierda");
							}
							player4.pass = false;
						}
						else
						{
							player4.pass = true;
						}
					}
				}
			}
			// Jugador 2 - comienza 3
			if (player_C == 1)
			{
				if (searchValueIndex(player3.tokens, lastToken.North) != null)
				{
					var ValueIndex = searchValueIndex(player3.tokens, lastToken.North);
					if (FlxG.random.bool())
					{
						player3.tokens[ValueIndex].setPosition(x + move, y);
						setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
							player3.tokens[ValueIndex].y, true);
						used.push(player3.tokens[ValueIndex].SpriteValue);
						right.push(player3.tokens[ValueIndex]);
						player3.tokens.remove(player3.tokens[ValueIndex]);
						trace("derecha");
					}
					else
					{
						player3.tokens[ValueIndex].angle = 90;
						player3.tokens[ValueIndex].updateHitbox();
						player3.tokens[ValueIndex].setPosition(x - move, y);
						setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
							player3.tokens[ValueIndex].y, false);
						used.push(player3.tokens[ValueIndex].SpriteValue);
						left.push(player3.tokens[ValueIndex]);
						player3.tokens.remove(player3.tokens[ValueIndex]);
						trace("izquierda");
					}
					player3.pass = false;
				}
				else
				{
					player3.pass = true;
					if (searchValueIndex(player4.tokens, lastToken.North) != null)
					{
						var ValueIndex = searchValueIndex(player4.tokens, lastToken.North);
						if (FlxG.random.bool())
						{
							player4.tokens[ValueIndex].angle = -90;
							player4.tokens[ValueIndex].updateHitbox();
							player4.tokens[ValueIndex].setPosition(x + move, y);
							setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
								player4.tokens[ValueIndex].y, true);
							used.push(player4.tokens[ValueIndex].SpriteValue);
							right.push(player4.tokens[ValueIndex]);
							player4.tokens.remove(player4.tokens[ValueIndex]);
							trace("derecha");
						}
						else
						{
							player4.tokens[ValueIndex].angle = 90;
							player4.tokens[ValueIndex].updateHitbox();
							player4.tokens[ValueIndex].setPosition(x - move, y);
							setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
								player4.tokens[ValueIndex].y, false);
							used.push(player4.tokens[ValueIndex].SpriteValue);
							left.push(player4.tokens[ValueIndex]);
							player4.tokens.remove(player4.tokens[ValueIndex]);
							trace("izquierda");
						}
						player4.pass = false;
					}
					else
					{
						player4.pass = true;
						if (searchValueIndex(player1.tokens, lastToken.North) != null)
						{
							var ValueIndex = searchValueIndex(player1.tokens, lastToken.North);
							if (FlxG.random.bool())
							{
								player1.tokens[ValueIndex].angle = -90;
								player1.tokens[ValueIndex].updateHitbox();
								player1.tokens[ValueIndex].setPosition(x + move, y);
								setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
									player1.tokens[ValueIndex].y, true);
								used.push(player1.tokens[ValueIndex].SpriteValue);
								right.push(player1.tokens[ValueIndex]);
								player1.tokens.remove(player1.tokens[ValueIndex]);
								trace("derecha");
							}
							else
							{
								player1.tokens[ValueIndex].setPosition(x - move, y);
								setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
									player1.tokens[ValueIndex].y, false);
								used.push(player1.tokens[ValueIndex].SpriteValue);
								left.push(player1.tokens[ValueIndex]);
								player1.tokens.remove(player1.tokens[ValueIndex]);
								trace("izquierda");
							}
							player1.pass = false;
						}
						else
						{
							player1.pass = true;
						}
					}
				}
			}
			// Jugador 3 - comienza 4
			if (player_C == 2)
			{
				if (searchValueIndex(player4.tokens, lastToken.North) != null)
				{
					var ValueIndex = searchValueIndex(player4.tokens, lastToken.North);
					if (FlxG.random.bool())
					{
						player4.tokens[ValueIndex].angle = -90;
						player4.tokens[ValueIndex].updateHitbox();
						player4.tokens[ValueIndex].setPosition(x + move, y);
						setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
							player4.tokens[ValueIndex].y, true);
						used.push(player4.tokens[ValueIndex].SpriteValue);
						right.push(player4.tokens[ValueIndex]);
						player4.tokens.remove(player4.tokens[ValueIndex]);
						trace("derecha");
					}
					else
					{
						player4.tokens[ValueIndex].angle = 90;
						player4.tokens[ValueIndex].updateHitbox();
						player4.tokens[ValueIndex].setPosition(x - move, y);
						setLastToken(player4.tokens[ValueIndex].get_North(), player4.tokens[ValueIndex].get_South(), player4.tokens[ValueIndex].x,
							player4.tokens[ValueIndex].y, false);
						used.push(player4.tokens[ValueIndex].SpriteValue);
						left.push(player4.tokens[ValueIndex]);
						player4.tokens.remove(player4.tokens[ValueIndex]);
						trace("izquierda");
					}
					player4.pass = false;
				}
				else
				{
					player4.pass = true;
					if (searchValueIndex(player1.tokens, lastToken.North) != null)
					{
						var ValueIndex = searchValueIndex(player1.tokens, lastToken.North);
						if (FlxG.random.bool())
						{
							player1.tokens[ValueIndex].angle = -90;
							player1.tokens[ValueIndex].updateHitbox();
							player1.tokens[ValueIndex].setPosition(x + move, y);
							setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
								player1.tokens[ValueIndex].y, true);
							used.push(player1.tokens[ValueIndex].SpriteValue);
							right.push(player1.tokens[ValueIndex]);
							player1.tokens.remove(player1.tokens[ValueIndex]);
							trace("derecha");
						}
						else
						{
							player1.tokens[ValueIndex].setPosition(x - move, y);
							setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
								player1.tokens[ValueIndex].y, false);
							used.push(player1.tokens[ValueIndex].SpriteValue);
							left.push(player1.tokens[ValueIndex]);
							player1.tokens.remove(player1.tokens[ValueIndex]);
							trace("izquierda");
						}
						player1.pass = false;
					}
					else
					{
						player1.pass = true;
						if (searchValueIndex(player2.tokens, lastToken.North) != null)
						{
							var ValueIndex = searchValueIndex(player2.tokens, lastToken.North);
							if (FlxG.random.bool())
							{
								player2.tokens[ValueIndex].angle = 270;
								player2.tokens[ValueIndex].updateHitbox();
								player2.tokens[ValueIndex].setPosition(x + move, y);
								setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
									player2.tokens[ValueIndex].y, true);
								used.push(player2.tokens[ValueIndex].SpriteValue);
								right.push(player2.tokens[ValueIndex]);
								player2.tokens.remove(player2.tokens[ValueIndex]);
								trace("derecha");
							}
							else
							{
								player2.tokens[ValueIndex].angle = 90;
								player2.tokens[ValueIndex].updateHitbox();
								player2.tokens[ValueIndex].setPosition(x - move, y);
								setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
									player2.tokens[ValueIndex].y, false);
								used.push(player2.tokens[ValueIndex].SpriteValue);
								left.push(player2.tokens[ValueIndex]);
								player2.tokens.remove(player2.tokens[ValueIndex]);
								trace("izquierda");
							}
							player2.pass = false;
						}
					}
				}
			}
			// Jugador 4 - comienza 1
			if (player_C == 3)
			{
				if (searchValueIndex(player1.tokens, lastToken.North) != null)
				{
					var ValueIndex = searchValueIndex(player1.tokens, lastToken.North);
					if (FlxG.random.bool())
					{
						player1.tokens[ValueIndex].angle = -90;
						player1.tokens[ValueIndex].updateHitbox();
						player1.tokens[ValueIndex].setPosition(x + move, y);
						setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
							player1.tokens[ValueIndex].y, true);
						used.push(player1.tokens[ValueIndex].SpriteValue);
						right.push(player1.tokens[ValueIndex]);
						player1.tokens.remove(player1.tokens[ValueIndex]);
						trace("derecha");
					}
					else
					{
						player1.tokens[ValueIndex].setPosition(x - move, y);
						setLastToken(player1.tokens[ValueIndex].get_North(), player1.tokens[ValueIndex].get_South(), player1.tokens[ValueIndex].x,
							player1.tokens[ValueIndex].y, false);
						used.push(player1.tokens[ValueIndex].SpriteValue);
						left.push(player1.tokens[ValueIndex]);
						player1.tokens.remove(player1.tokens[ValueIndex]);
						trace("izquierda");
					}
					player1.pass = false;
				}
				else
				{
					player1.pass = true;
					if (searchValueIndex(player2.tokens, lastToken.North) != null)
					{
						var ValueIndex = searchValueIndex(player2.tokens, lastToken.North);
						if (FlxG.random.bool())
						{
							player2.tokens[ValueIndex].angle = 270;
							player2.tokens[ValueIndex].updateHitbox();
							player2.tokens[ValueIndex].setPosition(x + move, y);
							setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
								player2.tokens[ValueIndex].y, true);
							used.push(player2.tokens[ValueIndex].SpriteValue);
							right.push(player2.tokens[ValueIndex]);
							player2.tokens.remove(player2.tokens[ValueIndex]);
							trace("derecha");
						}
						else
						{
							player2.tokens[ValueIndex].angle = 90;
							player2.tokens[ValueIndex].updateHitbox();
							player2.tokens[ValueIndex].setPosition(x - move, y);
							setLastToken(player2.tokens[ValueIndex].get_North(), player2.tokens[ValueIndex].get_South(), player2.tokens[ValueIndex].x,
								player2.tokens[ValueIndex].y, false);
							used.push(player2.tokens[ValueIndex].SpriteValue);
							left.push(player2.tokens[ValueIndex]);
							player2.tokens.remove(player2.tokens[ValueIndex]);
							trace("izquierda");
						}
						player2.pass = false;
					}
					else
					{
						player2.pass = true;
						if (searchValueIndex(player3.tokens, lastToken.North) != null)
						{
							var ValueIndex = searchValueIndex(player3.tokens, lastToken.North);
							if (FlxG.random.bool())
							{
								player3.tokens[ValueIndex].setPosition(x + move, y);
								setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
									player3.tokens[ValueIndex].y, true);
								used.push(player3.tokens[ValueIndex].SpriteValue);
								right.push(player3.tokens[ValueIndex]);
								player3.tokens.remove(player3.tokens[ValueIndex]);
								trace("derecha");
							}
							else
							{
								player3.tokens[ValueIndex].angle = 90;
								player3.tokens[ValueIndex].updateHitbox();
								player3.tokens[ValueIndex].setPosition(x - move, y);
								setLastToken(player3.tokens[ValueIndex].get_North(), player3.tokens[ValueIndex].get_South(), player3.tokens[ValueIndex].x,
									player3.tokens[ValueIndex].y, false);
								used.push(player3.tokens[ValueIndex].SpriteValue);
								left.push(player3.tokens[ValueIndex]);
								player3.tokens.remove(player3.tokens[ValueIndex]);
								trace("izquierda");
							}
							player3.pass = false;
						}
						else
						{
							player3.pass = true;
						}
					}
				}
			}
			// true = derecha | false = izquierda

			switch (player_C)
			{
				// Jugador 1 - comienza 2
				case 0:
					do
					{
						if (checkTokens([player1, player2, player3, player4]) == false)
						{
							execute = false;
							break;
						}
						// jugador 3
						// Derecha
						if (searchValueIndex(player3.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken.North);
							if (player3.tokens[VI].get_North() == lastToken.North)
							{
								player3.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player3.tokens[VI].get_North() == lastToken.North && player3.tokens[VI].get_South() == lastToken.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken.North = player3.tokens[VI].get_North();
								lastToken.South = player3.tokens[VI].get_South();
								lastToken.x = player3.tokens[VI].x;
								lastToken.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								right.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player3.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken1.North);
							if (player3.tokens[VI].get_North() == lastToken1.North)
							{
								player3.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player3.tokens[VI].get_North() == lastToken1.North
									&& player3.tokens[VI].get_South() == lastToken1.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken1.North = player3.tokens[VI].get_North();
								lastToken1.South = player3.tokens[VI].get_South();
								lastToken1.x = player3.tokens[VI].x;
								lastToken1.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								left.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						else
							player3.pass = true;

						// jugador 4
						// Derecha
						if (searchValueIndex(player4.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken.North);
							if (player4.tokens[VI].get_North() == lastToken.North)
							{
								player4.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player4.tokens[VI].get_North() == lastToken.North && player4.tokens[VI].get_South() == lastToken.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken.North = player4.tokens[VI].get_North();
								lastToken.South = player4.tokens[VI].get_South();
								lastToken.x = player4.tokens[VI].x;
								lastToken.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								right.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player4.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken1.North);
							if (player4.tokens[VI].get_North() == lastToken1.North)
							{
								player4.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player4.tokens[VI].get_North() == lastToken1.North
									&& player4.tokens[VI].get_South() == lastToken1.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken1.North = player4.tokens[VI].get_North();
								lastToken1.South = player4.tokens[VI].get_South();
								lastToken1.x = player4.tokens[VI].x;
								lastToken1.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								left.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						else
							player4.pass = true;

						// jugador 1
						// Derecha
						if (searchValueIndex(player1.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken.North);
							if (player1.tokens[VI].get_North() == lastToken.North)
							{
								player1.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player1.tokens[VI].get_North() == lastToken.North && player1.tokens[VI].get_South() == lastToken.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken.North = player1.tokens[VI].get_North();
								lastToken.South = player1.tokens[VI].get_South();
								lastToken.x = player1.tokens[VI].x;
								lastToken.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								right.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player1.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken1.North);
							if (player1.tokens[VI].get_North() == lastToken1.North)
							{
								player1.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player1.tokens[VI].get_North() == lastToken1.North
									&& player1.tokens[VI].get_South() == lastToken1.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken1.North = player1.tokens[VI].get_North();
								lastToken1.South = player1.tokens[VI].get_South();
								lastToken1.x = player1.tokens[VI].x;
								lastToken1.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								left.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						else
							player1.pass = true;

						// jugador 2
						// Derecha
						if (searchValueIndex(player2.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken.North);
							if (player2.tokens[VI].get_North() == lastToken.North)
							{
								player2.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player2.tokens[VI].get_North() == lastToken.North && player2.tokens[VI].get_South() == lastToken.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken.North = player2.tokens[VI].get_North();
								lastToken.South = player2.tokens[VI].get_South();
								lastToken.x = player2.tokens[VI].x;
								lastToken.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								right.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player2.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken1.North);
							if (player2.tokens[VI].get_North() == lastToken1.North)
							{
								player2.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player2.tokens[VI].get_North() == lastToken1.North
									&& player2.tokens[VI].get_South() == lastToken1.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken1.North = player2.tokens[VI].get_North();
								lastToken1.South = player2.tokens[VI].get_South();
								lastToken1.x = player2.tokens[VI].x;
								lastToken1.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								left.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						else
							player2.pass = true;

						// Termina el juego por pases
						if (checkPass([player1, player2, player3, player4]))
							execute = false;
					}
					while (execute == true);
						// Jugador 2 - comienza 3
				case 1:
					do
					{
						if (checkTokens([player1, player2, player3, player4]) == false)
						{
							execute = false;
							break;
						}
						// jugador 4
						// Derecha
						if (searchValueIndex(player4.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken.North);
							if (player4.tokens[VI].get_North() == lastToken.North)
							{
								player4.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player4.tokens[VI].get_North() == lastToken.North && player4.tokens[VI].get_South() == lastToken.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken.North = player4.tokens[VI].get_North();
								lastToken.South = player4.tokens[VI].get_South();
								lastToken.x = player4.tokens[VI].x;
								lastToken.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								right.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player4.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken1.North);
							if (player4.tokens[VI].get_North() == lastToken1.North)
							{
								player4.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player4.tokens[VI].get_North() == lastToken1.North
									&& player4.tokens[VI].get_South() == lastToken1.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken1.North = player4.tokens[VI].get_North();
								lastToken1.South = player4.tokens[VI].get_South();
								lastToken1.x = player4.tokens[VI].x;
								lastToken1.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								left.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						else
							player4.pass = true;

						// jugador 1
						// Derecha
						if (searchValueIndex(player1.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken.North);
							if (player1.tokens[VI].get_North() == lastToken.North)
							{
								player1.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player1.tokens[VI].get_North() == lastToken.North && player1.tokens[VI].get_South() == lastToken.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken.North = player1.tokens[VI].get_North();
								lastToken.South = player1.tokens[VI].get_South();
								lastToken.x = player1.tokens[VI].x;
								lastToken.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								right.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player1.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken1.North);
							if (player1.tokens[VI].get_North() == lastToken1.North)
							{
								player1.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player1.tokens[VI].get_North() == lastToken1.North
									&& player1.tokens[VI].get_South() == lastToken1.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken1.North = player1.tokens[VI].get_North();
								lastToken1.South = player1.tokens[VI].get_South();
								lastToken1.x = player1.tokens[VI].x;
								lastToken1.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								left.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						else
							player1.pass = true;

						// jugador 2
						// Derecha
						if (searchValueIndex(player2.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken.North);
							if (player2.tokens[VI].get_North() == lastToken.North)
							{
								player2.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player2.tokens[VI].get_North() == lastToken.North && player2.tokens[VI].get_South() == lastToken.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken.North = player2.tokens[VI].get_North();
								lastToken.South = player2.tokens[VI].get_South();
								lastToken.x = player2.tokens[VI].x;
								lastToken.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								right.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player2.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken1.North);
							if (player2.tokens[VI].get_North() == lastToken1.North)
							{
								player2.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player2.tokens[VI].get_North() == lastToken1.North
									&& player2.tokens[VI].get_South() == lastToken1.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken1.North = player2.tokens[VI].get_North();
								lastToken1.South = player2.tokens[VI].get_South();
								lastToken1.x = player2.tokens[VI].x;
								lastToken1.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								left.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						else
							player2.pass = true;

						// jugador 3
						// Derecha
						if (searchValueIndex(player3.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken.North);
							if (player3.tokens[VI].get_North() == lastToken.North)
							{
								player3.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player3.tokens[VI].get_North() == lastToken.North && player3.tokens[VI].get_South() == lastToken.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken.North = player3.tokens[VI].get_North();
								lastToken.South = player3.tokens[VI].get_South();
								lastToken.x = player3.tokens[VI].x;
								lastToken.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								right.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player3.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken1.North);
							if (player3.tokens[VI].get_North() == lastToken1.North)
							{
								player3.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player3.tokens[VI].get_North() == lastToken1.North
									&& player3.tokens[VI].get_South() == lastToken1.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken1.North = player3.tokens[VI].get_North();
								lastToken1.South = player3.tokens[VI].get_South();
								lastToken1.x = player3.tokens[VI].x;
								lastToken1.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								left.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						else
							player3.pass = true;

						if (checkPass([player1, player2, player3, player4]))
							execute = false;
					}
					while (execute == true);

						// Jugador 3 - comienza 4
				case 2:
					do
					{
						if (checkTokens([player1, player2, player3, player4]) == false)
						{
							execute = false;
							break;
						}
						// jugador 1
						// Derecha
						if (searchValueIndex(player1.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken.North);
							if (player1.tokens[VI].get_North() == lastToken.North)
							{
								player1.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player1.tokens[VI].get_North() == lastToken.North && player1.tokens[VI].get_South() == lastToken.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken.North = player1.tokens[VI].get_North();
								lastToken.South = player1.tokens[VI].get_South();
								lastToken.x = player1.tokens[VI].x;
								lastToken.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								right.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player1.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken1.North);
							if (player1.tokens[VI].get_North() == lastToken1.North)
							{
								player1.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player1.tokens[VI].get_North() == lastToken1.North
									&& player1.tokens[VI].get_South() == lastToken1.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken1.North = player1.tokens[VI].get_North();
								lastToken1.South = player1.tokens[VI].get_South();
								lastToken1.x = player1.tokens[VI].x;
								lastToken1.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								left.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						else
							player1.pass = true;

						// jugador 2
						// Derecha
						if (searchValueIndex(player2.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken.North);
							if (player2.tokens[VI].get_North() == lastToken.North)
							{
								player2.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player2.tokens[VI].get_North() == lastToken.North && player2.tokens[VI].get_South() == lastToken.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken.North = player2.tokens[VI].get_North();
								lastToken.South = player2.tokens[VI].get_South();
								lastToken.x = player2.tokens[VI].x;
								lastToken.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								right.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player2.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken1.North);
							if (player2.tokens[VI].get_North() == lastToken1.North)
							{
								player2.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player2.tokens[VI].get_North() == lastToken1.North
									&& player2.tokens[VI].get_South() == lastToken1.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken1.North = player2.tokens[VI].get_North();
								lastToken1.South = player2.tokens[VI].get_South();
								lastToken1.x = player2.tokens[VI].x;
								lastToken1.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								left.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						else
							player2.pass = true;

						// jugador 3
						// Derecha
						if (searchValueIndex(player3.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken.North);
							if (player3.tokens[VI].get_North() == lastToken.North)
							{
								player3.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player3.tokens[VI].get_North() == lastToken.North && player3.tokens[VI].get_South() == lastToken.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken.North = player3.tokens[VI].get_North();
								lastToken.South = player3.tokens[VI].get_South();
								lastToken.x = player3.tokens[VI].x;
								lastToken.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								right.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player3.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken1.North);
							if (player3.tokens[VI].get_North() == lastToken1.North)
							{
								player3.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player3.tokens[VI].get_North() == lastToken1.North
									&& player3.tokens[VI].get_South() == lastToken1.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken1.North = player3.tokens[VI].get_North();
								lastToken1.South = player3.tokens[VI].get_South();
								lastToken1.x = player3.tokens[VI].x;
								lastToken1.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								left.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						else
							player3.pass = true;

						// jugador 4
						// Derecha
						if (searchValueIndex(player4.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken.North);
							if (player4.tokens[VI].get_North() == lastToken.North)
							{
								player4.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player4.tokens[VI].get_North() == lastToken.North && player4.tokens[VI].get_South() == lastToken.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken.North = player4.tokens[VI].get_North();
								lastToken.South = player4.tokens[VI].get_South();
								lastToken.x = player4.tokens[VI].x;
								lastToken.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								right.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player4.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken1.North);
							if (player4.tokens[VI].get_North() == lastToken1.North)
							{
								player4.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player4.tokens[VI].get_North() == lastToken1.North
									&& player4.tokens[VI].get_South() == lastToken1.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken1.North = player4.tokens[VI].get_North();
								lastToken1.South = player4.tokens[VI].get_South();
								lastToken1.x = player4.tokens[VI].x;
								lastToken1.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								left.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						else
							player4.pass = true;

						if (checkPass([player1, player2, player3, player4]))
							execute = false;
					}
					while (execute == true);

						// Jugador 4 - comienza 1
				case 3:
					do
					{
						if (checkTokens([player1, player2, player3, player4]) == false)
						{
							execute = false;
							break;
						}
						// jugador 2
						// Derecha
						if (searchValueIndex(player2.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken.North);
							if (player2.tokens[VI].get_North() == lastToken.North)
							{
								player2.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player2.tokens[VI].get_North() == lastToken.North && player2.tokens[VI].get_South() == lastToken.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken.North = player2.tokens[VI].get_North();
								lastToken.South = player2.tokens[VI].get_South();
								lastToken.x = player2.tokens[VI].x;
								lastToken.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								right.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player2.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player2.tokens, lastToken1.North);
							if (player2.tokens[VI].get_North() == lastToken1.North)
							{
								player2.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player2.tokens[VI].get_North() == lastToken1.North
									&& player2.tokens[VI].get_South() == lastToken1.South)
								{
									player2.tokens[VI].angle = 0;
								}
								lastToken1.North = player2.tokens[VI].get_North();
								lastToken1.South = player2.tokens[VI].get_South();
								lastToken1.x = player2.tokens[VI].x;
								lastToken1.y = player2.tokens[VI].y;
								used.push(player2.tokens[VI].get_SpriteValue());
								left.push(player2.tokens[VI]);
								player2.tokens.remove(player2.tokens[VI]);
								player2.pass = false;
							}
						}
						else
							player2.pass = true;

						// jugador 3
						// Derecha
						if (searchValueIndex(player3.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken.North);
							if (player3.tokens[VI].get_North() == lastToken.North)
							{
								player3.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player3.tokens[VI].get_North() == lastToken.North && player3.tokens[VI].get_South() == lastToken.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken.North = player3.tokens[VI].get_North();
								lastToken.South = player3.tokens[VI].get_South();
								lastToken.x = player3.tokens[VI].x;
								lastToken.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								right.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player3.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player3.tokens, lastToken1.North);
							if (player3.tokens[VI].get_North() == lastToken1.North)
							{
								player3.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player3.tokens[VI].get_North() == lastToken1.North
									&& player3.tokens[VI].get_South() == lastToken1.South)
								{
									player3.tokens[VI].angle = 0;
								}
								lastToken1.North = player3.tokens[VI].get_North();
								lastToken1.South = player3.tokens[VI].get_South();
								lastToken1.x = player3.tokens[VI].x;
								lastToken1.y = player3.tokens[VI].y;
								used.push(player3.tokens[VI].get_SpriteValue());
								left.push(player3.tokens[VI]);
								player3.tokens.remove(player3.tokens[VI]);
								player3.pass = false;
							}
						}
						else
							player3.pass = true;

						// jugador 4
						// Derecha
						if (searchValueIndex(player4.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken.North);
							if (player4.tokens[VI].get_North() == lastToken.North)
							{
								player4.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player4.tokens[VI].get_North() == lastToken.North && player4.tokens[VI].get_South() == lastToken.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken.North = player4.tokens[VI].get_North();
								lastToken.South = player4.tokens[VI].get_South();
								lastToken.x = player4.tokens[VI].x;
								lastToken.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								right.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player4.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player4.tokens, lastToken1.North);
							if (player4.tokens[VI].get_North() == lastToken1.North)
							{
								player4.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player4.tokens[VI].get_North() == lastToken1.North
									&& player4.tokens[VI].get_South() == lastToken1.South)
								{
									player4.tokens[VI].angle = 0;
								}
								lastToken1.North = player4.tokens[VI].get_North();
								lastToken1.South = player4.tokens[VI].get_South();
								lastToken1.x = player4.tokens[VI].x;
								lastToken1.y = player4.tokens[VI].y;
								used.push(player4.tokens[VI].get_SpriteValue());
								left.push(player4.tokens[VI]);
								player4.tokens.remove(player4.tokens[VI]);
								player4.pass = false;
							}
						}
						else
							player4.pass = true;

						// jugador 1
						// Derecha
						if (searchValueIndex(player1.tokens, lastToken.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken.North);
							if (player1.tokens[VI].get_North() == lastToken.North)
							{
								player1.tokens[VI].setPosition(lastToken.x + move_1, lastToken.y);
								if (player1.tokens[VI].get_North() == lastToken.North && player1.tokens[VI].get_South() == lastToken.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken.North = player1.tokens[VI].get_North();
								lastToken.South = player1.tokens[VI].get_South();
								lastToken.x = player1.tokens[VI].x;
								lastToken.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								right.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						// Izquierda
						else if (searchValueIndex(player1.tokens, lastToken1.North) != null)
						{
							var VI = searchValueIndex(player1.tokens, lastToken1.North);
							if (player1.tokens[VI].get_North() == lastToken1.North)
							{
								player1.tokens[VI].setPosition(lastToken1.x - move_1, lastToken1.y);
								if (player1.tokens[VI].get_North() == lastToken1.North
									&& player1.tokens[VI].get_South() == lastToken1.South)
								{
									player1.tokens[VI].angle = 0;
								}
								lastToken1.North = player1.tokens[VI].get_North();
								lastToken1.South = player1.tokens[VI].get_South();
								lastToken1.x = player1.tokens[VI].x;
								lastToken1.y = player1.tokens[VI].y;
								used.push(player1.tokens[VI].get_SpriteValue());
								left.push(player1.tokens[VI]);
								player1.tokens.remove(player1.tokens[VI]);
								player1.pass = false;
							}
						}
						else
							player1.pass = true;

						if (checkPass([player1, player2, player3, player4]))
							execute = false;
					}
					while (execute == true);
			}

			// sleep(0.2);
			i++;
			trace(i);
			firstGame = true;

			haxe.Log.trace("Jugador 1: " + calculate(player1) + " puntos", null);
			haxe.Log.trace("Jugador 2: " + calculate(player2) + " puntos", null);
			haxe.Log.trace("Jugador 3: " + calculate(player3) + " puntos", null);
			haxe.Log.trace("Jugador 4: " + calculate(player4) + " puntos", null);

			scores.set(1, calculate(player1));
			scores.set(2, calculate(player2));
			scores.set(3, calculate(player3));
			scores.set(4, calculate(player4));

			if (checkPass([player1, player2, player3, player4]))
			{
				winner = highScore(scores);
				haxe.Log.trace("Jugador " + winner + " ganó por minoria de puntos (" + scores.get(winner) + " puntos)", null);
			}

			switch (winner)
			{
				case 1:
					p1 += 1;
				case 2:
					p2 += 1;
				case 3:
					p3 += 1;
				case 4:
					p4 += 1;
			}
			trace(p1 + "|" + p2 + "|" + p3 + "|" + p4);

			add(setText("Jugador " + winner + " ganó", 20, 615));

			if (t.elapsedLoops == times)
			{
				end = true;
				haxe.Log.trace("Fin del juego", null);
			}
			if (t.finished)
			{
				pr = p2 / times * 100;
				haxe.Log.trace("La probabilidad de que el jugador 2 gane es de " + pr_f + "%", null);
				openResult();
			}
		}
		timer.start(0.05, play, times);
	}

	override public function create()
	{
		super.create();
		// giveTokens();
		add(setTitle("Domino", /*550, 20,*/ 48));
		add(setText("¿Cuantos juegos quieres jugar?", 20, 650));
		add(setTextField(20, 675));
		add(setButton("Simular", 150, 680));
		#if debug
		add(setXY("X: \n" + "Y: \n", 5, 5));
		add(setMem(5, 45));
		#end
	}

	override public function update(elapsed:Float)
	{
		// Para el recuadro
		if (textfield.hasFocus)
		{
			FlxG.sound.volumeDownKeys = FlxG.sound.volumeUpKeys = FlxG.sound.muteKeys = null;
		}
		else
		{
			FlxG.sound.volumeDownKeys = [MINUS, NUMPADMINUS];
			FlxG.sound.volumeUpKeys = [MINUS, NUMPADPLUS];
			FlxG.sound.muteKeys = [ZERO, NUMPADZERO];
		}
		super.update(elapsed);
		#if debug
		xy.text = "X: " + FlxG.mouse.x + "\nY: " + FlxG.mouse.y;
		mem.text = "Memory: " + Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
		#end
	}
}
