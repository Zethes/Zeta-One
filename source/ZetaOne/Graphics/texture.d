module ZetaOne.Graphics.texture;
import derelict.opengl3.gl3;
import derelict.devil.il;
import derelict.devil.ilu;
import std.string;
import ZetaOne.d;

class Texture
{
public:
	this(GLenum type)
	{
		glGenTextures(1, &texture);
		Engine.GLCheck("Failed to generate texture.");
		this.type = type;

		SetTextureWrapS(GL_CLAMP_TO_EDGE);
		SetTextureWrapT(GL_CLAMP_TO_EDGE);
		SetMinFilter(GL_LINEAR);
		SetMagFilter(GL_LINEAR);
	}

	this(Image image)
	{
		this(GL_TEXTURE_2D);
		image.Bind();
		glTexImage2D(GL_TEXTURE_2D, 0, image.BPP, image.Width, image.Height, 0, image.Format, image.Type, cast(GLvoid*)image.Data);
		Engine.GLCheck("Failed to set texture.");
		image.Unbind();
	}

	~this()
	{
		glDeleteTextures(1, &texture);
		Engine.GLCheck("Failed to delete texture.");
	}

	void Bind()
	{
		glBindTexture(type, texture);
		Engine.GLCheck("Failed to bind texture.");
	}

	void Unbind()
	{
		glBindTexture(type, 0);
		Engine.GLCheck("Failed to unbind texture.");
	}

	void SetMinFilter(GLenum param)
	{
		glTexParameteri(type, GL_TEXTURE_MIN_FILTER, param);
		Engine.GLCheck("Failed to set min filter.");
	}

	void SetMagFilter(GLenum param)
	{
		glTexParameteri(type, GL_TEXTURE_MAG_FILTER, param);
		Engine.GLCheck("Failed to set mag filter.");
	}

	void SetTextureWrapS(GLenum param)
	{
		glTexParameteri(type, GL_TEXTURE_WRAP_S, param);
		Engine.GLCheck("Failed to set texture wrap s.");
	}

	void SetTextureWrapT(GLenum param)
	{
		glTexParameteri(type, GL_TEXTURE_WRAP_T, param);
		Engine.GLCheck("Failed to set texture wrap t.");
	}

	void SetTextureWrapR(GLenum param)
	{
		glTexParameteri(type, GL_TEXTURE_WRAP_R, param);
		Engine.GLCheck("Failed to set texture wrap r.");
	}

	void Parameteri(GLenum param, GLint value)
	{
		glTexParameteri(type, param, value);
	}

	void Parameterf(GLenum param, float value)
	{
		glTexParameterf(type, param, value);
	}

	void Active(GLenum param)
	{
		glActiveTexture(param);
		Engine.GLCheck("Failed to change active texture.");
	}

	void PixelStorei(GLenum param, GLint value)
	{
		glPixelStorei(param, value);
	}

	@property GLuint ID() { return texture; }
private:
	GLuint texture;
	GLenum type;
}
