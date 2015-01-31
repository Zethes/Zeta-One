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
			this.settings = new GameSettings(vidmode.width, vidmode.height, true, "ZetaOne", 0);
		}
		else
			this.settings = gameSettings;
		super(&Run);
	}
protected:
	protected void Initialize()
	{

	}

	protected void Deinitialize()
	{

	}
	
	protected void Update()
	{

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

		Engine.Log("Entering main game loop.");
		while (!glfwWindowShouldClose(window))
		{
			glfwPollEvents();

			glfwSwapBuffers(window);
		}
	}

	GameSettings settings;
	GLFWwindow* window;
}
