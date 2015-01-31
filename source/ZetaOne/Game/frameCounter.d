module ZetaOne.Game.frameCounter;
import std.datetime;

class FrameCounter
{
public:
	this()
	{
		watch.start();
		lastTick = watch.peek();
	}

	void AddFrame()
	{
		auto newTick = watch.peek();
		frameTimes[index++] = newTick - lastTick;
		lastFrameTime = frameTimes[index-1];
		if (index >= 100)
			index = 0;
		lastTick = newTick;
	}

	@property TickDuration FrameTime() { return lastFrameTime; }
	@property float FPS()
	{
		float sum = 0;
		foreach (f; frameTimes)
			sum += f.msecs;
		float avgTime = sum / 100.0f;

		return 1000.0f / avgTime;
	}
private:
	int index = 0;
	TickDuration[100] frameTimes;
	TickDuration lastTick;
	TickDuration lastFrameTime;
	StopWatch watch;
}
