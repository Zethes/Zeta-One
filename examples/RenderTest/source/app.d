import std.stdio;
import ZetaOne.d;

class TestGame : Game
{
	this(GameSettings sett = null)
	{
		super(sett);
	}

	override void Initialize()
	{
		super.Initialize();
		Graphics.ClearColor(new Color(0.392, 0.584, 0.929));

		Graphics.RegisterPostProcessingEffect(new BloomEffect("pass 1", Settings, Graphics));
		Graphics.RegisterPostProcessingEffect(new GrayscaleEffect("pass 2", Settings, Graphics));
		(cast(BloomEffect)Graphics.GetPostProcessingEffect("pass 1")).Samples = 8;
	}

	override void Update()
	{
		super.Update();
		//Engine.Log("FPS: ", FrameRate.FPS, " frames per second, ", FrameRate.FrameTime.msecs, " ms");
	}
}

void main()
{
	Engine.Initialize("Log.txt");
	writeln("ZetaOne version: ", Engine.Version());

	TestGame g = new TestGame(new GameSettings(1600,900,false,"Zeta One - Render Test",false));
	g.start();
	g.join();

	Engine.Deinitialize();
}
