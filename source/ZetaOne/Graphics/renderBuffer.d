module ZetaOne.Graphics.renderBuffer;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class RenderBuffer
{
public:
	this()
	{
		glGenRenderbuffers(1, &renderBuffer);
		Engine.GLCheck("Failed to generrate render buffer.");
		this.type = GL_RENDERBUFFER;
	}

	~this()
	{
		glDeleteFramebuffers(1, &renderBuffer);
		Engine.GLCheck("Failed to delete render buffer.");
	}

	void Bind()
	{
		glBindRenderbuffer(type, renderBuffer);
		Engine.GLCheck("Failed to bind render bufffer.");
	}

	void Unbind()
	{
		glBindRenderbuffer(type, 0);
		Engine.GLCheck("Failed to unbind render bufffer.");
	}

	void Storage(GLenum format, GLsizei width, GLsizei height)
	{
		glRenderbufferStorage(type, format, width, height);
		Engine.GLCheck("Failed to set render buffer's storage.");
	}

	@property GLuint ID() { return renderBuffer; }
private:
	GLuint renderBuffer;
	GLenum type;
}
