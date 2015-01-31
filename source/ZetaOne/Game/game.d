module ZetaOne.Game.game;
import ZetaOne.d;
import core.thread;
import std.string;
import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;

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

	@property FrameCounter FrameRate() { return frameCounter; }
protected:
	protected void Initialize()
	{

	}

	protected void Deinitialize()
	{

	}
	
	protected void Update()
	{
		Engine.Log("FPS: ", FrameRate.FPS, " frames per second, ", FrameRate.FrameTime.msecs, " ms");
	}

	protected void Render()
	{
		
	}

private:
	void Run()
	{
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

		gameRunning = true;

		Initialize();
		frameCounter = new FrameCounter();
		Engine.Log("Entering main game loop.");
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
}
