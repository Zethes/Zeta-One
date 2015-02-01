module ZetaOne.Graphics.builtInShaders;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class BuiltInShaders
{
	static union Screen
	{
		static string vertexSource = "
			#version 150
			in vec2 position;
			in vec2 texcoord;
			out vec2 Texcoord;
			uniform mat4 transform;
			void main() {
				Texcoord = texcoord;
				gl_Position = vec4(position, 0.0, 1.0);
			}
		";
		static string fragmentSource = "
			#version 150
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
		Screen.program.MapAttribute(ProgramLocations.MATRIX0, "transform");
		Screen.program.MapUniform(ProgramLocations.TEXTURE0, "tex");
	}
}
