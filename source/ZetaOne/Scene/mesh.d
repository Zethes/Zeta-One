module ZetaOne.Scene.mesh;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Mesh
{
public:
	this(GLenum renderType, VertexBuffer vertices, Material[] materials)
	{
		this.useElements = false;
		this.renderType = renderType;
		this.vertices = vertices;
		this.materials = materials;
		this.Setup();
	}

	this(GLenum renderType, VertexBuffer vertices, GLuint[] indices, Material[] materials)
	{
		this.useElements = true;
		this.renderType = renderType;
		this.vertices = vertices;
		this.indices = indices;
		this.materials = materials;
		this.Setup();
	}
	
	void Render(mat4 model, Camera camera)
	{
		foreach (material; materials)
		{
			material.Bind(model, camera);

			glBindVertexArray(this.VAO);
			glBindBuffer(GL_ARRAY_BUFFER, this.VBO);
			Attributes(material);
			glBindBuffer(GL_ARRAY_BUFFER, 0); 

			if (this.useElements)
			{
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this.EBO);
				glDrawElements(renderType, cast(GLint)this.indices.length, GL_UNSIGNED_INT, cast(void*)0);
				Engine.GLCheck("Failed to draw mesh's elements.");
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
			}
			else
			{
				glDrawArrays(renderType, 0, vertices.Count);
				Engine.GLCheck("Failed to draw mesh's arrays.");
			}
			glBindVertexArray(0);

		material.Unbind();
		}
	}
protected:
	void Attributes(Material material)
	{
		GLint posAttrib = material.GetProgram().Location(ProgramLocations.POSITION0);
		if (posAttrib >= 0) {
			glVertexAttribPointer(posAttrib, 3, GL_FLOAT, GL_FALSE, 12 * GLfloat.sizeof, cast(GLvoid*)(0));
			glEnableVertexAttribArray(posAttrib);
			Engine.GLCheck("Failed to set mesh's position attribute.");
		}

		GLint uvAttrib = material.GetProgram().Location(ProgramLocations.TEXCOORD0);
		if (uvAttrib >= 0) {
			glVertexAttribPointer(uvAttrib, 2, GL_FLOAT, GL_FALSE, 12 * GLfloat.sizeof, cast(GLvoid*)(3 * GLfloat.sizeof));
			glEnableVertexAttribArray(uvAttrib);
			Engine.GLCheck("Failed to set mesh's texcoord attribute.");
		}

		GLint normAttrib = material.GetProgram().Location(ProgramLocations.NORMAL0);
		if (normAttrib >= 0) {
			glVertexAttribPointer(normAttrib, 3, GL_FLOAT, GL_FALSE, 12 * GLfloat.sizeof, cast(GLvoid*)(5 * GLfloat.sizeof));
			glEnableVertexAttribArray(normAttrib);
			Engine.GLCheck("Failed to set mesh's normal attribute.");
		}

		GLint colorAttrib = material.GetProgram().Location(ProgramLocations.COLOR0);
		if (colorAttrib >= 0) {
			glVertexAttribPointer(colorAttrib, 4, GL_FLOAT, GL_FALSE, 12 * GLfloat.sizeof, cast(GLvoid*)(8 * GLfloat.sizeof));
			glEnableVertexAttribArray(colorAttrib);
			Engine.GLCheck("Failed to set mesh's color attribute.");
		}
	}

	void Setup()
	{
		glGenVertexArrays(1, &this.VAO);
		glGenBuffers(1, &this.VBO);
		glGenBuffers(1, &this.EBO);
		Engine.GLCheck("Failed to generate buffers.");
		
		glBindVertexArray(this.VAO);
		glBindBuffer(GL_ARRAY_BUFFER, this.VBO);
		GLfloat[] raw = this.vertices.Raw();
		glBufferData(GL_ARRAY_BUFFER, this.vertices.Length(), cast(void*)raw, GL_STATIC_DRAW);
		Engine.GLCheck("Failed to set vertex buffer's data.");
		
		if (this.useElements)
		{
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this.EBO);
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, this.indices.length * GLuint.sizeof, &indices, GL_STATIC_DRAW);
			Engine.GLCheck("Failed to set indices buffer data.");
		}

		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
		Engine.GLCheck("Failed to unbind.");
	}
private:
	Material[] materials;
	VertexBuffer vertices;
	GLuint[] indices;
	GLuint VAO, VBO, EBO;
	GLenum renderType;
	bool useElements;
}
