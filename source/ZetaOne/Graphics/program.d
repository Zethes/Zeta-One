module ZetaOne.Graphics.program;
import derelict.opengl3.gl3;
import m3d.m3d;
import std.string;
import ZetaOne.d;

class Program
{
public:
	this()
	{
		program = glCreateProgram();
		Engine.GLCheck("Failed to create program.");
	}
	~this()
	{
		glDeleteProgram(program);
		Engine.GLCheck("Failed to delete program.");
	}

	void Bind()
	{
		glUseProgram(program);
		Engine.GLCheck("Failed to bind program.");
	}

	void Unbind()
	{
		glUseProgram(0);
		Engine.GLCheck("Failed to unbind program.");
	}

	void AttachShader(Shader shader)
	{
		glAttachShader(program, shader.ID);
		Engine.GLCheck("Failed to attach shader to program.");
	}

	void DetachShader(Shader shader)
	{
		glDetachShader(program, shader.ID);
		Engine.GLCheck("Failed to detach shader from program.");
	}

	void Link()
	{
		GLint status;
		glLinkProgram(program);
		Engine.GLCheck("Failed to link program.");
		glGetProgramiv(program, GL_LINK_STATUS, &status);
		Engine.GLCheck("Failed to get link status of program.");
		if (status != GL_TRUE)
		{
			GLint size;
			glGetProgramiv(program, GL_INFO_LOG_LENGTH, &size);
			Engine.GLCheck("Failed to get program info log length.");
			GLsizei length;
			GLchar* buffer = cast(GLchar*)new GLchar[size];
			glGetProgramInfoLog(program, cast(GLsizei)size, &length, buffer);
			Engine.GLCheck("Failed to get program info log.");
			
			string log = cast(string)fromStringz(buffer);
			Engine.Log("OpenGL: " ~ log);
			throw new Exception("OpenGL: " ~ log);
		}
	}

	void Validate()
	{
		GLint status;
		glValidateProgram(program);
		Engine.GLCheck("Failed to validate program.");
		glGetProgramiv(program, GL_VALIDATE_STATUS, &status);
		Engine.GLCheck("Failed to get validate status of program.");
		if (status != GL_TRUE)
		{
			GLint size;
			glGetProgramiv(program, GL_INFO_LOG_LENGTH, &size);
			Engine.GLCheck("Failed to get program info log length.");
			GLsizei length;
			GLchar* buffer = cast(GLchar*)new GLchar[size];
			glGetProgramInfoLog(program, cast(GLsizei)size, &length, buffer);
			Engine.GLCheck("Failed to get program info log.");
			
			string log = cast(string)fromStringz(buffer);
			Engine.Log("OpenGL: " ~ log);
			throw new Exception("OpenGL: " ~ log);
		}
	}

	GLint GetUniformLocation(string name)
	{
		GLint loc = glGetUniformLocation(program, toStringz(name));
		Engine.GLCheck("Failed to get uniform location.");
		return loc;
	}

	void Uniform1(GLint location, float value0)
	{
		glUniform1f(location, value0);
		Engine.GLCheck("glUniform1f failed!");
	}

	void Uniform2(GLint location, float value0, float value1)
	{
		glUniform2f(location, value0, value1);
		Engine.GLCheck("glUniform2f failed!");
	}

	void Uniform3(GLint location, float value0, float value1, float value2)
	{
		glUniform3f(location, value0, value1, value2);
		Engine.GLCheck("glUniform3f failed!");
	}

	void Uniform4(GLint location, float value0, float value1, float value2, float value3)
	{
		glUniform4f(location, value0, value1, value2, value3);
		Engine.GLCheck("glUniform4f failed!");
	}

	void UniformMatrix2x3(T)(GLint location, bool transpose, Matrix2x3f m)
	{
		glUniformMatrix2x3fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix2x3 failed!");
	}

	void UniformMatrix3x2(GLint location, bool transpose, Matrix3x2f m)
	{
		glUniformMatrix3x2fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix3x2 failed!");
	}

	void UniformMatrix2x4(T)(GLint location, bool transpose, Matrix2x4f m)
	{
		glUniformMatrix2x4fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix2x4 failed!");
	}

	void UniformMatrix3x4(T)(GLint location, bool transpose, Matrix3x4f m)
	{
		glUniformMatrix3x4fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix3x4 failed!");
	}

	void UniformMatrix4x3(T)(GLint location, bool transpose, Matrix4x3f m)
	{
		glUniformMatrix4x3fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix4x3 failed!");
	}

	void UniformMatrix4x4(T)(GLint location, bool transpose, Matrix4x4f m)
	{
		glUniformMatrix4x4fv(location, 1, transpose, cast(float*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix4x3 failed!");
	}

	@property GLuint ID() { return program; }
private:
	GLuint program;
}
