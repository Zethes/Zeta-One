module ZetaOne.Scene.material;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Material
{
public:
	this(string name, GameSettings settings, Program program)
	{
		this.name = name;
		this.settings = settings;
		this.program = program;
	}

	void Bind(mat4 model, Camera camera)
	{
		program.Bind();
		GLint loc = program.Location(ProgramLocations.MATRIX0);
		if (loc >= 0)
			program.UniformMatrixf(loc, true, model);
		loc = program.Location(ProgramLocations.MATRIX1);
		if (loc >= 0)
			program.UniformMatrixf(loc, true, camera.GetMatrix());
	}

	void Unbind()
	{
		program.Unbind();
	}

	@property string GetName() { return name; }
	@property Program GetProgram() { return program; }
private:
	string name;
	GameSettings settings;
	Program program;
}

class FlatMaterial : Material
{
public:
	this(string name, GameSettings settings)
	{
		super(name, settings, BuiltInShaders.Flat.program);
	}
}
