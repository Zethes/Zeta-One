module ZetaOne.Graphics.postProcessingEffect;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class PostProcessingEffect
{
public:
	this(string name, GameSettings settings, GraphicsManager graphics)
	{
		this.name = name;
		this.settings = settings;
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
		Compile();
	}

	void Compile()
	{
		throw new Exception("Unimplemented: PostProcessingEffect.Compile()");
	}

	void Bind()
	{
		frameBuffer.Bind();
	}

	void Unbind()
	{
		frameBuffer.Unbind();
	}

	void Render(Texture texture)
	{
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		Graphics.GetRenderer2D.LinkProgram(GetProgram);
		Graphics.GetRenderer2D.RenderTexture(vec2(settings.ScreenWidth/2.0f,settings.ScreenHeight/2.0f), vec2(settings.ScreenWidth, -settings.ScreenHeight), texture);
	}

	@property string GetName() { return name; }
	@property Texture GetTexture() { return textureBuffer; }
	@property Program GetProgram() { return program; }
	@property GraphicsManager Graphics() { return graphics; }
	@property FrameBuffer GetFrameBuffer() { return frameBuffer; }
	@property RenderBuffer GetRenderBuffer() { return renderBuffer; }
protected:
	@property GameSettings GetSettings() { return settings; }

	Program program;
private:
	string name;
	GameSettings settings;
	FrameBuffer frameBuffer;
	RenderBuffer renderBuffer;
	Texture textureBuffer;
	GraphicsManager graphics;
}

class GrayscaleEffect : PostProcessingEffect
{
public:
	this(string name, GameSettings settings, GraphicsManager graphics)
	{
		super(name, settings, graphics);
	}

	override void Compile()
	{
		string vertexSource = "
			#version 330 core 
			in vec2 position;
			in vec2 texcoord;
			out vec2 Texcoord;
			uniform mat4 transform;
			void main() {
				Texcoord = texcoord;
				gl_Position = vec4(position, 0.0, 1.0);
			}
		";

		string fragmentSource = "
			#version 330 core 
			in vec2 Texcoord;
			out vec4 outColor;
			uniform sampler2D tex;
			void main() {
				outColor = texture(tex, Texcoord);
				float avg = 0.2126 * outColor.r + 0.7152 * outColor.g + 0.0722 * outColor.b;
				outColor = vec4(avg, avg, avg, 1.0);
			}
		";

		Shader vertex;
		Shader fragment;

		Engine.Log("Compiling ", name, " shader.");
		vertex = new Shader(GL_VERTEX_SHADER, vertexSource);
		fragment = new Shader(GL_FRAGMENT_SHADER, fragmentSource);
		vertex.Compile();
		fragment.Compile();
		program = new Program(vertex, fragment);
		program.BindFragDataLocation(0, "outColor");
		program.Link();
		program.Validate();
		program.MapAttribute(ProgramLocations.POSITION0, "position");
		program.MapAttribute(ProgramLocations.TEXCOORD0, "texcoord");
		program.MapUniform(ProgramLocations.TEXTURE0, "tex");
	}
}

class BloomEffect : PostProcessingEffect
{
public:
	this(string name, GameSettings settings, GraphicsManager graphics)
	{
		super(name, settings, graphics);
		Samples = 5;
	}	

	override void Compile()
	{
		string vertexSource = "
			#version 330 core 
			in vec2 position;
			in vec2 texcoord;
			out vec2 Texcoord;
			void main() {
				Texcoord = texcoord;
				gl_Position = vec4(position, 0.0, 1.0);
			}
		";

		string fragmentSource = "
			#version 330 core 
			in vec2 Texcoord;
			out vec4 outColor;
			uniform sampler2D tex;
			uniform int samples = 5;
			
			void main() {
				vec4 color = texture(tex, Texcoord);

				int i,j;
				vec4 sum = vec4(0);
				for (i = -2; i <= 2; i++) {
					for (j = -2; j <= 2; j++) {
						vec2 offset = vec2(i, j) * 0.005;
						sum += texture(tex, Texcoord + offset);
					}
				}
				outColor = (sum / (samples * samples)) + color;
			}
		";

		Shader vertex;
		Shader fragment;

		Engine.Log("Compiling ", name, " shader.");
		vertex = new Shader(GL_VERTEX_SHADER, vertexSource);
		fragment = new Shader(GL_FRAGMENT_SHADER, fragmentSource);
		vertex.Compile();
		fragment.Compile();
		program = new Program(vertex, fragment);
		program.BindFragDataLocation(0, "outColor");
		program.Link();
		program.Validate();
		program.MapAttribute(ProgramLocations.POSITION0, "position");
		program.MapAttribute(ProgramLocations.TEXCOORD0, "texcoord");
		program.MapUniform(ProgramLocations.TEXTURE0, "tex");
		program.MapUniform(ProgramLocations.CUSTOM0, "samples");
	}

	@property int Samples() { return samples; }
	@property void Samples(int s) 
	{
		samples = s;
		program.Bind();
		program.Uniform1i(program.Location(ProgramLocations.CUSTOM0), samples);
		program.Unbind();
	}
private:
	int samples;
}
