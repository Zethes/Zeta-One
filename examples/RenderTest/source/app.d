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
		BloomEffect bloom = new BloomEffect(Settings, Graphics);
		bloom.Samples = 8;

		Graphics.RegisterPostProcessingEffect(bloom);
//		Graphics.RegisterPostProcessingEffect(new GrayscaleEffect(Settings, Graphics));
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
