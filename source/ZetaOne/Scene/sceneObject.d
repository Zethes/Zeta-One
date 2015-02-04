module ZetaOne.Scene.sceneObject; 
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class SceneObject
{
public:
	this(string name, mat4 transform, AABB boundingBox) // and Material
	{
		this.boundingBox = boundingBox;
		this.name = name;
		this.transform = transform;
	}

	void Render()
	{
		throw new Exception("Unimplemented: SceneObject.Render()");
	}

	@property string GetName() { return name; }
	@property AABB GetBoundingBox() { return boundingBox; }
protected:
	AABB boundingBox;
	mat4 transform;
private:
	string name;
}
