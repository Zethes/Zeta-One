module ZetaOne.Graphics.shader;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Shader
{
public:
	this(GLenum type, string source)
	{
		shader = glCreateShader(type);
		Engine.GLCheck("Failed to create shader.");

		SetSource(source);
	}
	~this()
	{
		glDeleteShader(shader);
		Engine.GLCheck("Failed to delete shader.");
	}

	void SetSource(string source)
	{
		char* src = cast(char*)toStringz(source);
		GLint len = cast(GLint)source.length;
		glShaderSource(shader, cast(GLsizei)1, cast(const(GLchar**))&src, &len);
		Engine.GLCheck("Failed to set shader's source.");
	}	

	void Compile()
	{
		GLint status;
		glCompileShader(shader);
		Engine.GLCheck("Failed to compile shader.");
		glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
		Engine.GLCheck("Failed to get shader compilation status.");

		if (status != GL_TRUE)
		{
			GLint size;
			glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &size);
			Engine.GLCheck("Failed to get shader info log length.");
			GLsizei length;
			GLchar* buffer = cast(GLchar*)new GLchar[size];
			glGetShaderInfoLog(shader, cast(GLsizei)size, &length, buffer);
			Engine.GLCheck("Failed to get shader info log.");

			string log = "Failed to compile shader: \n" ~ cast(string)fromStringz(buffer);
			Engine.Log("OpenGL: " ~ log);
			throw new Exception("OpenGL: " ~ log);
		}
	}

	@property GLuint ID() { return shader; }
private:
	GLuint shader;
}
