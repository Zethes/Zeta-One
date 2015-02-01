module ZetaOne.Graphics.renderer2D;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;
import m3d.m3d;

class Renderer2D
{
public:
	this(GameSettings settings)
	{
		this.settings = settings;
		
		Engine.Log("    Creating vertex array object.");
		glGenVertexArrays(1, &vao);
		glBindVertexArray(vao);
		Engine.Log("    Creating vertex buffer object.");

		glGenBuffers(1, &vbo);

		Engine.Log("    Setting vertex buffer data."); 
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * GLfloat.sizeof, cast(void*)vertices, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		Engine.GLCheck("Failed to set vertex buffer data.");
		glBindVertexArray(0);
	}

	~this()
	{
		glDeleteBuffers(1, &vbo);
		Engine.GLCheck("Failed to delete vertex buffer object.");
		glDeleteVertexArrays(1, &vao);
		Engine.GLCheck("Failed to delete vertex array object.");
	}

	void LinkProgram(Program program)
	{
		glBindVertexArray(vao);
		Engine.GLCheck("Failed to bind vertex array object.");
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		Engine.GLCheck("Failed to bind vertex buffer object.");

		program.Bind();
		GLint pos = program.Location(ProgramLocations.POSITION0);
		glEnableVertexAttribArray(pos);
		glVertexAttribPointer(pos, 2, GL_FLOAT, GL_FALSE, 4 * GLfloat.sizeof, cast(void*)0);
		Engine.GLCheck("Failed to attach position pointer.");

		GLint tex = program.Location(ProgramLocations.TEXCOORD0);
		glEnableVertexAttribArray(tex);
		glVertexAttribPointer(tex, 2, GL_FLOAT, GL_FALSE, 4 * GLfloat.sizeof, cast(void*)(2 * GLfloat.sizeof));
		Engine.GLCheck("Failed to attach texcoord pointer.");

		program.Unbind();

		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindVertexArray(0);
		this.program = program;
	}

	void RenderTexture(Transformf transform, Texture texture)
	{
		glBindVertexArray(vao);
		Engine.GLCheck("Failed to bind vertex array.");

		glDisable(GL_DEPTH_TEST);

		program.Bind();
		texture.Active(GL_TEXTURE0);
		texture.Bind();

		program.Uniform1i(program.Location(ProgramLocations.TEXTURE0), 0);
		if (program.Location(ProgramLocations.MATRIX0) >= 0)
			program.UniformMatrixf(program.Location(ProgramLocations.MATRIX0), false, transform.GetMatrix().Transpose());

		glDrawArrays(GL_TRIANGLES, 0, 6);

		texture.Unbind();
		program.Unbind();

		glEnable(GL_DEPTH_TEST);
		glBindVertexArray(0);
	}
private:
	GameSettings settings;
	Program program;
	GLuint vao;
	GLuint vbo;
	GLfloat[] vertices = [
	    -1.0f,  1.0f,  0.0f, 0.0f,
	     1.0f,  1.0f,  1.0f, 0.0f,
	     1.0f, -1.0f,  1.0f, 1.0f,

		 1.0f, -1.0f,  1.0f, 1.0f,
	    -1.0f, -1.0f,  0.0f, 1.0f,
	    -1.0f,  1.0f,  0.0f, 0.0f
	];
}
