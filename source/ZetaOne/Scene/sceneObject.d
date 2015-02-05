module ZetaOne.Scene.sceneObject; 
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class SceneObject
{
public:
	this(string name, mat4 transform, Mesh mesh) // and Material
	{
		this.name = name;
		this.transform = transform;
		this.mesh = mesh;
	}

	void Render(Camera camera)
	{
		if (mesh is null)
			return;
		mesh.Render(transform, camera);
	}

	@property string GetName() { return name; }
	@property mat4 GetTransform() { return transform; }
	@property Mesh GetMesh() { return mesh; }
private:
	string name;
	mat4 transform;
	Mesh mesh;
}
