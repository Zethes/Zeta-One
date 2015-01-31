module ZetaOne.Graphics.graphicsManager;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class GraphicsManager
{
public:
	this(GameSettings gameSettings)
	{
		settings = gameSettings;
		
		Engine.Log("Creating Graphics Manager.");
		Engine.Log("  Building built in shaders");
		BuiltInShaders.BuildShaders();
		Engine.Log("  Creating 2D renderer.");
		renderer2D = new Renderer2D(settings);
		Engine.Log("  Done");

		// OpenGL settings:
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_DEPTH_TEST);
	}

	void ClearColor(Color c)
	{
		glClearColor(c.R, c.G, c.B, c.A);
	}

	@property Renderer2D GetRenderer2D() { return renderer2D; }
private:
	GameSettings settings;
	Renderer2D renderer2D;
}
