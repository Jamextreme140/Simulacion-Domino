import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class ResultState extends FlxSubState
{
	// var DataSet = new Array<Any>();
	var info:FlxText;

	public var p1:Int;
	public var p2:Int;
	public var p3:Int;
	public var p4:Int;
	public var pr:Float = 0;

	// 'State' de los resultados finales de la simulacion
	public function new(dataset:Array<Int>, pr:Float)
	{
		super(FlxColor.fromRGB(0, 0, 0, 160));
		p1 = dataset[0];
		p2 = dataset[1];
		p3 = dataset[2];
		p4 = dataset[3];
		this.pr = pr;
	}

	override public function create()
	{
		var text = new FlxText(430, 20);
		text.text = "Resultados Finales";
		text.color = FlxColor.BLUE;
		text.size = 36;
		text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.CYAN, 3);

		info = new FlxText();
		info.text = "Jugadas Ganadas: " + "\nJugador 1: " + p1 + "\nJugador 2: " + p2 + "\nJugador 3: " + p3 + "\nJugador 4: " + p4;
		info.size = 24;
		info.screenCenter();

		trace(pr);
		var player2 = new FlxText(400, 570);
		player2.size = 24;
		player2.text = "Probabilidad de ganar el jugador 2: " + pr + "%";
		player2.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.RED, 2);

		var closebtn = new FlxButton(0, 680, "Cerrar", () ->
		{
			close();
			Sys.exit(0);
		});
		closebtn.x = text.x + text.height;

		add(text);
		add(info);
		add(player2);
		add(closebtn);

		super.create();
	}
}
