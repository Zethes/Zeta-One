module ZetaOne.Scene.cube;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class CubeMesh : Mesh
{
public:
	this(Material material, vec3 size)
	{
		Material[] mats;
		mats ~= material;
		this(mats, size);
	}
	this(Material[] material, vec3 size)
	{
		VertexBuffer buffer = new VertexBuffer();
		Color c = new Color(1,1,1);
		GLfloat x = size.x;
		GLfloat y = size.y;
		GLfloat z = size.z;
		//					  POSITION				UV				NORMAL			COLOR
		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, -z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,0),		vec3(0,0,0),	c));

		buffer.Add(new Vertex(vec3(-x, -y, z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, z),		vec2(0,0),		vec3(0,0,0),	c));

		buffer.Add(new Vertex(vec3(-x, y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, z),		vec2(1,0),		vec3(0,0,0),	c));

		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,0),		vec3(0,0,0),	c));

		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, -y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, -y, -z),		vec2(0,1),		vec3(0,0,0),	c));

		buffer.Add(new Vertex(vec3(-x, y, -z),		vec2(0,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, -z),		vec2(1,1),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(x, y, z),		vec2(1,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, z),		vec2(0,0),		vec3(0,0,0),	c));
		buffer.Add(new Vertex(vec3(-x, y, -z),		vec2(0,1),		vec3(0,0,0),	c));

		buffer.CalculateNormals();

		super(GL_TRIANGLES, buffer, material);
	}
}
