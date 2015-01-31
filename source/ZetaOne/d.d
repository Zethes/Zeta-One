module ZetaOne.d;
import std.string;
import std.stdio;
import std.file;
import std.conv;
import std.datetime;
import derelict.opengl3.gl3;
import derelict.glfw3.glfw3;

public import ZetaOne.Game.game;
public import ZetaOne.Game.gameSettings;

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
			foreach (param; params)
			{
				auto date = Clock.currTime;
				string timestamp = format("%d-%d-%d %d:%d:%d", date.year, date.month, date.day, date.hour, date.minute, date.second);
				append(logFile, timestamp ~ ": ");
				append(logFile, to!string(param));
				write(timestamp, ": ", param);
			}
			writeln();
			append(logFile, "\n");
		}
		catch (Exception e) {
			writeln("Caught Exception: ", e);
		}
	}
private:
	static shared string logFile;
}
