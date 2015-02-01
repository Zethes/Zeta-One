module ZetaOne.Graphics.postProcessingEffect;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class PostProcessingEffect
{
public:
	this(Program program, GameSettings settings, GraphicsManager graphics)
	{
		this.settings = settings;
		this.program = program;
		this.graphics = graphics;

		this.frameBuffer = new FrameBuffer();
		this.frameBuffer.Bind();

		this.renderBuffer = new RenderBuffer();
		this.renderBuffer.Bind();
		this.renderBuffer.Storage(GL_DEPTH24_STENCIL8, settings.ScreenWidth, settings.ScreenHeight);
		this.renderBuffer.Unbind();

		this.frameBuffer.AttachRenderBuffer(GL_DEPTH_STENCIL_ATTACHMENT, this.renderBuffer);
		this.frameBuffer.Unbind();

		this.textureBuffer = new Texture(GL_TEXTURE_2D, this.frameBuffer, GL_COLOR_ATTACHMENT0, settings.ScreenWidth, settings.ScreenHeight);
	}

	void Render(Texture texture)
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		Graphics.GetRenderer2D.LinkProgram(GetProgram);
		Graphics.GetRenderer2D.RenderTexture(Transformf.Identity, texture);
	}

	
	@property Texture GetTexture() { return textureBuffer; }
	@property Program GetProgram() { return program; }
	@property GraphicsManager Graphics() { return graphics; }
	@property FrameBuffer GetFrameBuffer() { return frameBuffer; }
	@property RenderBuffer GetRenderBuffer() { return renderBuffer; }
protected:
	@property GameSettings GetSettings() { return settings; }
private:
	Program program;
	GameSettings settings;
	FrameBuffer frameBuffer;
	RenderBuffer renderBuffer;
	Texture textureBuffer;
	GraphicsManager graphics;
}

class GrayscaleEffect : PostProcessingEffect
{
public:
	this(GameSettings settings, GraphicsManager graphics)
	{
		super(BuiltInShaders.Grayscale.program, settings, graphics);
	}
}
