module ZetaOne.Graphics.color;
import std.string;
import std.math;

class Color
{
public:
	this(float c)
	{
		this(c,c,c);
	}
	
	this(float r, float g, float b, float a = 1.0)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	override string toString()
	{
		return format("%f, %f, %f, %f", r, g, b, a);
	}

	@property R() { return r; }
	@property R(float r) { this.r = fmax(0, fmin(1.0, r)); }

	@property G() { return g; }
	@property G(float g) { this.g = fmax(0, fmin(1.0, g)); }

	@property B() { return b; }
	@property B(float b) { this.b = fmax(0, fmin(1.0, b)); }

	@property A() { return a; }
	@property A(float a) { this.a = fmax(0, fmin(1.0, a)); }
private:
	float r, g, b, a;
}
