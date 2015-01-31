import std.stdio;
import ZetaOne.d;

void main()
{
	Engine.Initialize("Log.txt");
	writeln("ZetaOne version: ", Engine.Version());

	Game g = new Game(new GameSettings(1600,900,false,"Zeta One - Render Test",false));
	g.start();
	g.join();

	Engine.Deinitialize();
}
