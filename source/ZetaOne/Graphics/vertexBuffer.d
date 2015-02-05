module ZetaOne.Graphics.vertexBuffer;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Vertex
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

	@property void Position(vec3 v) { position = v; }
	@property void Normal(vec3 v) { normal = v; }
	@property void UV(vec2 v) { uv = v; }
	@property void VertexColor(Color v) { color = v; }

	@property vec3 Position() { return position; }
	@property vec3 Normal() { return normal; }
	@property vec2 UV() { return uv; }
	@property Color VertexColor() { return color; }
private:
	vec3 position, normal;
	vec2 uv;
	Color color;
}

class VertexBuffer
{
public:
	void Add(Vertex vertex)
	{
		vertices ~= vertex;
	}

	void CalculateNormals()
	{
		if (vertices.length % 3 != 0)
			return;
		
		for (int i = 0; i < vertices.length; i+=3)
		{
			vec3 norm = vec3(0,0,0);
			vec3 p1 = vertices[i].Position;
			vec3 p2 = vertices[i+1].Position;
			vec3 p3 = vertices[i+2].Position;

			vec3 u = (p2 - p1);
			vec3 v = (p3 - p1);
			norm.x = (u.y * v.z) - (u.z * v.y);
			norm.y = (u.z * v.x) - (u.x * v.z);
			norm.z = (u.x * v.y) - (u.y * v.x);

			vertices[i].Normal = norm;
			vertices[i+1].Normal = norm;
			vertices[i+2].Normal = norm;
		}
	}
	
	@property GLsizei Count()
	{
		return cast(GLsizei)vertices.length;
	}

	@property GLsizei Length()
	{
		return cast(GLsizei)((12 * GLfloat.sizeof) * vertices.length);
	}
		
	@property GLfloat[] Raw()
	{
		GLfloat[] ret;
		foreach (vert; vertices)
		{
			GLfloat[] raw = vert.Raw();
			foreach (data; raw)
				ret ~= data;
		}
		return ret;
	}
private:
	Vertex[] vertices;
}
