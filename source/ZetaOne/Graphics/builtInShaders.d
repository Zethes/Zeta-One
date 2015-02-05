module ZetaOne.Graphics.builtInShaders;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class BuiltInShaders
{
	static union Screen
	{
		static string vertexSource = "
			#version 330 core 
			in vec2 position;
			in vec2 texcoord;
			out vec2 Texcoord;
			uniform mat4 transform;
			void main() {
				Texcoord = texcoord;
				gl_Position = transform * vec4(position, 0.0, 1.0);
			}
		";
		static string fragmentSource = "
			#version 330 core 
			in vec2 Texcoord;
			out vec4 outColor;
			uniform sampler2D tex;
			void main() {
				outColor = texture(tex, Texcoord);
			}
		";
		static Shader vertex;
		static Shader fragment;
		static Program program;
	}

	static union Flat
	{
		static string vertexSource = "
			#version 330 core
			in vec3 position;
			in vec4 color;
			out vec4 Color;
			uniform mat4 model;
			uniform mat4 viewProj;
			void main() {
				Color = color;
				gl_Position = viewProj * model * vec4(position, 1.0);
			}
		";
		static string fragmentSource = "
			#version 330 core
			in vec4 Color;
			out vec4 outColor;
			void main() { 
				outColor = Color;
			}
		";
		static Shader vertex;
		static Shader fragment;
		static Program program;
	}

	static void BuildShaders()
	{
		Engine.Log("    Compiling Screen shader.");
		Screen.vertex = new Shader(GL_VERTEX_SHADER, Screen.vertexSource);
		Screen.fragment = new Shader(GL_FRAGMENT_SHADER, Screen.fragmentSource);
		Screen.vertex.Compile();
		Screen.fragment.Compile();
		Screen.program = new Program(Screen.vertex, Screen.fragment);
		Screen.program.BindFragDataLocation(0, "outColor");
		Screen.program.Link();
		Screen.program.Validate();
		Screen.program.MapAttribute(ProgramLocations.POSITION0, "position");
		Screen.program.MapAttribute(ProgramLocations.TEXCOORD0, "texcoord");
		Screen.program.MapUniform(ProgramLocations.TEXTURE0, "tex");
		Screen.program.MapUniform(ProgramLocations.MATRIX0, "transform");

		Engine.Log("    Compiling Flat shader.");
		Flat.vertex = new Shader(GL_VERTEX_SHADER, Flat.vertexSource);
		Flat.fragment = new Shader(GL_FRAGMENT_SHADER, Flat.fragmentSource);
		Flat.vertex.Compile();
		Flat.fragment.Compile();
		Flat.program = new Program(Flat.vertex, Flat.fragment);
		Flat.program.BindFragDataLocation(0, "outColor");
		Flat.program.Link();
		Flat.program.Validate();
		Flat.program.MapAttribute(ProgramLocations.POSITION0, "position");
		Flat.program.MapAttribute(ProgramLocations.COLOR0, "color");
		Flat.program.MapUniform(ProgramLocations.MATRIX0, "model");
		Flat.program.MapUniform(ProgramLocations.MATRIX1, "viewProj");
	}
}
