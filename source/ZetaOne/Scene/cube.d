module ZetaOne.Scene.cube;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Cube : SceneObject
{
public:
	this(string name, mat4 transform, vec3 size)
	{
		super(name, transform, AABB(-size, size));
	
		glGenVertexArrays(1, &vao);
		glBindVertexArray(vao);
		Engine.GLCheck("Failed to generate vertex array.");

		glGenBuffers(1, &vbo);
		Engine.GLCheck("Failed to generate vertex buffer.");
		
		glBindVertexArray(0);

		SetAttributes();

		Resize(size);
	}

	void Resize(vec3 size)
	{
		float x = size.x;
		float y = size.y;
		float z = size.z;

		Color c = new Color(1,1,1);
		//TODO: Normal vectors 
		vertices = [
			///				POSITION			UV				NORMAL			COLOR
			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, -z),	vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 0),		vec3(0,0,0),	c),

			new VertexBuffer(vec3(-x, -y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, z),	vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, z),		vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, z),		vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, z),	vec2(0, 0),		vec3(0,0,0),	c),

			new VertexBuffer(vec3(-x, y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, z),	vec2(1, 0),		vec3(0,0,0),	c),

			new VertexBuffer(vec3(x, y, z),		vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, z),		vec2(1, 0),		vec3(0,0,0),	c),

			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, z),	vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, -y, z),	vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, -y, -z),	vec2(0, 1),		vec3(0,0,0),	c),

			new VertexBuffer(vec3(-x, y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, -z),	vec2(1, 1),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, z),		vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(x, y, z),		vec2(1, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, z),	vec2(0, 0),		vec3(0,0,0),	c),
			new VertexBuffer(vec3(-x, y, -z),	vec2(0, 1),		vec3(0,0,0),	c),
		];
	
		// Update bounding box
		boundingBox = AABB(-size, size);

		// Update buffer data
		glBindVertexArray(vao);
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		GLfloat[] raw;
		foreach (vertex; vertices)
			raw ~= vertex.Raw;
		glBufferData(GL_ARRAY_BUFFER, raw.length * GLfloat.sizeof, cast(void*)raw, GL_STATIC_DRAW);
		Engine.GLCheck("Failed to set cube's buffer data.");
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
	}

	override void Render()
	{
		//Material crap here
		glBindVertexArray(vao);
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glDrawArrays(GL_TRIANGLES, 0, 36);
		Engine.GLCheck("Failed to draw cube's arrays.");
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
	}
private:
	VertexBuffer[] vertices;
	GLuint vao, vbo;

	void SetAttributes()
	{

	}
}
