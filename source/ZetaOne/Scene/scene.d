module ZetaOne.Scene.scene;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Scene
{
public:
	this(GameSettings settings)
	{
		SetCamera(new Camera(settings));
	}

	void SetCamera(Camera cam)
	{
		this.camera = cam;
	}

	void AddObject(SceneObject obj)
	{
		objects ~= obj;
	}

	void Render()
	{
		foreach (object; objects)
		{
			object.Render(camera);
		}
	}

	@property GetCamera() { return camera; }
private:
	SceneObject[] objects;
	GameSettings settings;
	Camera camera;
}
