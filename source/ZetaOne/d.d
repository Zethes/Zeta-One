module ZetaOne.d;
import std.string;
import std.stdio;
import std.file;
import std.conv;
import std.datetime;
import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;
import derelict.devil.il;
import derelict.devil.ilu;

public import ZetaOne.Game.game;
public import ZetaOne.Game.gameSettings;
public import ZetaOne.Game.frameCounter;
public import ZetaOne.Graphics.color;
public import ZetaOne.Graphics.graphicsManager;
public import ZetaOne.Graphics.builtInShaders;
public import ZetaOne.Graphics.renderer2D;
public import ZetaOne.Graphics.shader;
public import ZetaOne.Graphics.program;
public import ZetaOne.Graphics.texture;
public import ZetaOne.Graphics.image;
public import ZetaOne.Graphics.frameBuffer;
public import ZetaOne.Graphics.renderBuffer;
public import ZetaOne.Graphics.postProcessingEffect;
public import gl3n.aabb;
public import gl3n.frustum;
public import gl3n.interpolate;
public import gl3n.linalg;
public import gl3n.math;
public import gl3n.util;

class Engine 
{
public:
	static const int VERSION_MAJOR = 0;
	static const int VERSION_MINOR = 1;
	static const int VERSION_PATCH = 0;

	/// Get the version of ZetaOne
	/// Returns: The version as a string
	static string Version()
	{
		return format("%d.%d.%d", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
	}

	/// Initializes the engine.
	/// Returns: Whether or not it was successful.
	static bool Initialize(string logOut)
	{
		logFile = logOut;
		try {
			remove(logFile);
		} catch 
		{}

		DerelictGL3.load();
		DerelictGLFW3.load();
		DerelictIL.load();
		DerelictILU.load();
		ilInit();

		if (!glfwInit()) {
			Log("Failed to initialize GLFW.");
			return false;
		}
		return true;
	}

	/// Deinitialize's the engine
	static void Deinitialize()
	{
		glfwTerminate();
	}

	/// Writes to the log and console.
	static void Log(T...)(T params)
	{
		try {
			auto date = Clock.currTime;
			string timestamp = format("%02d:%02d:%02d", date.hour, date.minute, date.second);
			append(logFile, timestamp ~ ": ");
			write(timestamp ~ ": ");

			foreach (param; params)
			{
				append(logFile, to!string(param));
				write(param);
			}
			writeln();
			append(logFile, "\n");
		}
		catch (Exception e) {
			writeln("Caught Exception: ", e);
		}
	}
	
	/// Throws an exception of there is an OpenGL error.
	static void GLCheck(string msg)
	{
		uint err = glGetError();
		if (err != GL_NO_ERROR)
		{
			Engine.Log("OpenGL: " ~ msg, "  Code: ", err);
			throw new Exception("OpenGL: " ~ msg);
		}
	}

	/// Throws an exception of there is an DevIL error.
	static void ILCheck(string msg)
	{
		uint err = ilGetError();
		if (err != IL_NO_ERROR)
		{
			Engine.Log("DevIL: " ~ msg);
			throw new Exception("DevIL: " ~ cast(string)fromStringz(iluErrorString(err)));
		}
	}
private:
	static shared string logFile;
}
