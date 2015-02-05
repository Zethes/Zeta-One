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

		// Initialize the scene
		GetScene.GetCamera.LookAt(vec3(10,10,10), vec3(0,0,0), vec3(0,1,0));
		Material mat = new FlatMaterial("flat", Settings);
		GetScene.AddObject(new SceneObject("cube0", mat4.identity.translate(0,0,0), new CubeMesh(mat, vec3(1,1,1))));
		GetScene.AddObject(new SceneObject("cube1", mat4.identity.translate(3,3,3), new CubeMesh(mat, vec3(1,1,1))));
		GetScene.AddObject(new SceneObject("cube2", mat4.identity.translate(0,6,6), new CubeMesh(mat, vec3(1,1,1))));
		GetScene.AddObject(new SceneObject("cube3", mat4.identity.translate(-6,-6,0), new CubeMesh(mat, vec3(1,1,1))));
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
