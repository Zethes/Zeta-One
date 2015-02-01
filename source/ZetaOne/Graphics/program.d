module ZetaOne.Graphics.program;
import derelict.opengl3.gl3;
import m3d.m3d;
import std.string;
import ZetaOne.d;

enum ProgramLocations
{
	POSITION0,
	POSITION1,
	POSITION2,
	POSITION3,
	POSITION4,

	NORMAL0,
	NORMAL1,
	NORMAL2,
	NORMAL3,
	NORMAL4,

	TEXCOORD0,
	TEXCOORD1,
	TEXCOORD2,
	TEXCOORD3,
	TEXCOORD4,

	MATRIX0,
	MATRIX1,
	MATRIX2,
	MATRIX3,
	MATRIX4,

	COLOR0,
	COLOR1,
	COLOR2,
	COLOR3,
	COLOR4,

	TEXTURE0,
	TEXTURE1,
	TEXTURE2,
	TEXTURE3,
	TEXTURE4,

	CUSTOM0,
	CUSTOM1,
	CUSTOM2,
	CUSTOM3,
	CUSTOM4,
	CUSTOM5,
	CUSTOM6,
	CUSTOM7,
	CUSTOM8,
	CUSTOM9,

	SIZE_OF_ENUM
}

class Program
{
public:
	this()
	{
		program = glCreateProgram();
		Engine.GLCheck("Failed to create program.");
		for (int i = 0; i < ProgramLocations.SIZE_OF_ENUM; ++i)
			locations[i] = -1;
	}

	this(Shader vert, Shader frag)
	{
		this();
		AttachShader(vert);
		AttachShader(frag);
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
	
	void MapAttribute(uint id, string name)
	{
		locations[id] = GetAttribLocation(name);
	}

	void MapUniform(uint id, string name)
	{
		locations[id] = GetUniformLocation(name);
	}

	GLint GetUniformLocation(string name)
	{
		GLint loc = glGetUniformLocation(program, toStringz(name));
		Engine.GLCheck("Failed to get uniform location.");
		return loc;
	}

	void Uniform1f(GLint location, float value0)
	{
		glUniform1f(location, value0);
		Engine.GLCheck("glUniform1f failed!");
	}

	void Uniform2f(GLint location, float value0, float value1)
	{
		glUniform2f(location, value0, value1);
		Engine.GLCheck("glUniform2f failed!");
	}

	void Uniform3f(GLint location, float value0, float value1, float value2)
	{
		glUniform3f(location, value0, value1, value2);
		Engine.GLCheck("glUniform3f failed!");
	}

	void Uniform4f(GLint location, float value0, float value1, float value2, float value3)
	{
		glUniform4f(location, value0, value1, value2, value3);
		Engine.GLCheck("glUniform4f failed!");
	}

	void Uniform1i(GLint location, GLint value0)
	{
		glUniform1i(location, value0);
		Engine.GLCheck("glUniform1i failed!");
	}

	void Uniform2i(GLint location, GLint value0, GLint value1)
	{
		glUniform2i(location, value0, value1);
		Engine.GLCheck("glUniform2i failed!");
	}

	void Uniform3i(GLint location, GLint value0, GLint value1, GLint value2)
	{
		glUniform3i(location, value0, value1, value2);
		Engine.GLCheck("glUniform3i failed!");
	}

	void Uniform4i(GLint location, GLint value0, GLint value1, GLint value2, GLint value3)
	{
		glUniform4i(location, value0, value1, value2, value3);
		Engine.GLCheck("glUniform4i failed!");
	}

	void UniformMatrixf(GLint location, bool transpose, Matrix4x4f m)
	{
		glUniformMatrix4fv(location, 1, transpose, cast(const(float)*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix4fv failed!");
	}

	void UniformMatrixd(GLint location, bool transpose, Matrix4x4d m)
	{
		glUniformMatrix4dv(location, 1, transpose, cast(double*)m.Raw()); 
		Engine.GLCheck("glUniformMatrix4iv failed!");
	}

	void BindFragDataLocation(GLuint number, string name)
	{
		glBindFragDataLocation(program, number, cast(const(char)*)toStringz(name));
		Engine.GLCheck("glBindFragDataLocation failed!");
	}

	GLint GetAttribLocation(string name)
	{
		return glGetAttribLocation(program, cast(const(char)*)toStringz(name));
	}

	@property GLuint ID() { return program; }
	GLint Location(uint id) { return locations[id]; }
private:
	GLuint program;
	GLint[ProgramLocations.SIZE_OF_ENUM] locations;
}
