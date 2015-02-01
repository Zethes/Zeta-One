module ZetaOne.Game.game;
import ZetaOne.d;
import core.thread;
import std.string;
import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;
import derelict.devil.il;
import derelict.devil.ilu;

class Game : Thread
{
public:
	this(GameSettings gameSettings = null)
	{
		if (gameSettings is null)
		{
			const GLFWvidmode * vidmode = glfwGetVideoMode(glfwGetPrimaryMonitor());
			this.settings = new GameSettings(vidmode.width, vidmode.height, true, "ZetaOne");
		}
		else
			this.settings = gameSettings;
		super(&Run);
	}

	void Close()
	{
		gameRunning = false;
	}

	@property GameSettings Settings() { return settings; }
	@property FrameCounter FrameRate() { return frameCounter; }
	@property GraphicsManager Graphics() { return graphicsManager; }
protected:
	Texture watch;

	void Initialize()
	{
		Engine.Log("Renderer: ", fromStringz(glGetString(GL_RENDERER)));
		Engine.Log("OpenGL Version: ", fromStringz(glGetString(GL_VERSION)));
		
		Image img = new Image("watch.png");
		watch = new Texture(GL_TEXTURE_2D, img);
		
		mainFrameBuffer = new FrameBuffer();
		mainFrameBuffer.Bind();

		mainRenderBuffer = new RenderBuffer();
		mainRenderBuffer.Bind();
		mainRenderBuffer.Storage(GL_DEPTH24_STENCIL8, settings.ScreenWidth, settings.ScreenHeight);
		mainRenderBuffer.Unbind();
			
		mainFrameBuffer.AttachRenderBuffer(GL_DEPTH_STENCIL_ATTACHMENT, mainRenderBuffer);
		mainFrameBuffer.Unbind();

		mainFrameBufferTexture = new Texture(GL_TEXTURE_2D, mainFrameBuffer, GL_COLOR_ATTACHMENT0, settings.ScreenWidth, settings.ScreenHeight);
	}

	void Deinitialize()
	{

	}
	
	void Update()
	{

	}
private:
	void Render()
	{
		//Render the scene:
		mainFrameBuffer.Bind();
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		Graphics.GetRenderer2D.LinkProgram(BuiltInShaders.Screen.program);
		Graphics.GetRenderer2D.RenderTexture(mat4.identity, watch);
		mainFrameBuffer.Unbind();

		// Render the post processing effects in order.
		Texture lastTexture = mainFrameBufferTexture;
		foreach (effect; Graphics.GetPostProcessingEffects())
		{
			effect.GetFrameBuffer.Bind();
			effect.Render(lastTexture);
			effect.GetFrameBuffer.Unbind();
			lastTexture = effect.GetTexture;
		}

		// Render the final framebuffer to the screen.
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		Graphics.GetRenderer2D.LinkProgram(BuiltInShaders.Screen.program);
		Graphics.GetRenderer2D.RenderTexture(mat4.identity, lastTexture);
	}

	void Run()
	{
		Engine.Log("-----------------------------------------------");
		Engine.Log("Creating Engine Modules");
		Engine.Log("-----------------------------------------------");
		
		Engine.Log("Preparing display");
		if (!settings.Fullscreen)
			window = glfwCreateWindow(settings.ScreenWidth, settings.ScreenHeight, toStringz(settings.WindowTitle), cast(GLFWmonitor*)0, cast(GLFWwindow*)0);
		else 
		{
			int count = 0;
			GLFWmonitor** monitors = glfwGetMonitors(&count);
			if (settings.Monitor >= count) {
				Engine.Log("Error: Invalid monitor number '", settings.Monitor, "'.");
				return;
			}
			window = glfwCreateWindow(settings.ScreenWidth, settings.ScreenHeight, toStringz(settings.WindowTitle), monitors[settings.Monitor], cast(GLFWwindow*)0);
		}
		if (window is null) {
			Engine.Log("Error: Failed to create window.");
			return;
		}

		glfwMakeContextCurrent(window);
		DerelictGL3.reload();
		glfwSwapInterval(settings.VSync ? 1 : 0);

		// Initialize the graphics manager after setting the context.
		graphicsManager = new GraphicsManager(settings);

		// Run the game's intialize method
		Engine.Log("-----------------------------------------------");
		Engine.Log("Initializing the game.");
		Engine.Log("-----------------------------------------------");
		Initialize();

		// Enter the main game loop. Running until window is closed or gameRunning is set to false. 
		gameRunning = true;
		frameCounter = new FrameCounter();
		Engine.Log("-----------------------------------------------");
		Engine.Log("Entering main game loop.");
		Engine.Log("-----------------------------------------------");
		while (!glfwWindowShouldClose(window) && gameRunning)
		{
			glfwPollEvents();

			Update();
			Render();

			frameCounter.AddFrame();
			glfwSwapBuffers(window);
		}

		Deinitialize();
	}

	GameSettings settings;
	GLFWwindow* window;
	bool gameRunning;
	FrameCounter frameCounter;
	GraphicsManager graphicsManager;
	FrameBuffer mainFrameBuffer;
	RenderBuffer mainRenderBuffer;
	Texture mainFrameBufferTexture;
}
