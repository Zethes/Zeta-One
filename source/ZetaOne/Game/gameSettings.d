module ZetaOne.Game.gameSettings;
import std.string;
import std.json;

class GameSettings
{
public:
	this(int sw, int sh, bool full, string title, int mon = 0)
	{
		screenWidth = sw;
		screenHeight = sh;
		fullscreen = full;
		windowTitle = title;
		monitorNumber = mon;
	}

	@property int Monitor() { return monitorNumber; }
	@property int ScreenWidth() { return screenWidth; }
	@property int ScreenHeight() { return screenHeight; }
	@property bool Fullscreen() { return fullscreen; }
	@property string WindowTitle() { return windowTitle; }
	
private:
	int monitorNumber;
	int screenWidth, screenHeight;
	bool fullscreen;
	string windowTitle;
}
