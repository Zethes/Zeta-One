module ZetaOne.Graphics.vertexBuffer;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class VertexBuffer
{
public:	
	this(vec3 pos, vec2 uv, vec3 norm, Color color = new Color(1,1,1,1))
	{
		this.position = pos;
		this.uv = uv;
		this.normal = norm;
		this.color = color;
	}

	@property GLfloat[] Raw()
	{
		GLfloat[] ret;
		ret ~= position.x;
		ret ~= position.y;
		ret ~= position.z;
		ret ~= uv.x;
		ret ~= uv.y;
		ret ~= normal.x;
		ret ~= normal.y;
		ret ~= normal.z;
		ret ~= color.R;
		ret ~= color.G;
		ret ~= color.B;
		ret ~= color.A;
		return ret;
	}
private:
	vec3 position, normal;
	vec2 uv;
	Color color;
}
