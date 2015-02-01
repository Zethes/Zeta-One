module ZetaOne.Graphics.frameBuffer;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class FrameBuffer
{
public:
	this()
	{
		glGenFramebuffers(1, &frameBuffer);
		Engine.GLCheck("Failed to generate framebuffer.");
		this.type = GL_FRAMEBUFFER;
	}

	~this()
	{
		glDeleteFramebuffers(1, &frameBuffer);
		Engine.GLCheck("Failed to delete framebuffer.");
	}

	void Bind()
	{
		glBindFramebuffer(type, frameBuffer);
		Engine.GLCheck("Failed to bind framebuffer.");
	}

	void Unbind()
	{
		glBindFramebuffer(type, 0);
		Engine.GLCheck("Failed to unbind framebuffer.");
	}

	void AttachRenderBuffer(GLenum attachment, RenderBuffer buffer)
	{
		glFramebufferRenderbuffer(type, attachment, GL_RENDERBUFFER, buffer.ID);
	}

	@property GLuint ID() { return frameBuffer; }
private:
	GLuint frameBuffer;
	GLenum type;
}
