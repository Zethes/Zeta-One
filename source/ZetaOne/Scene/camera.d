module ZetaOne.Scene.camera;
import derelict.opengl3.gl3;
import std.string;
import ZetaOne.d;

class Camera
{
public:
	this(GameSettings settings)
	{
		this.settings = settings;
		LookAt(vec3(1,1,1), vec3(0,0,0), vec3(0,1,0));
		Perspective(45.0f, 0.1f, 1000.0f);
	}
	this(GameSettings settings, mat4 view, mat4 projection)
	{
		this.settings = settings;
		this.view = view;
		this.projection = projection;
	}

	void LookAt(vec3 eye, vec3 at, vec3 up)
	{
		view = mat4.identity.look_at(eye, at, up);
	}

	void Perspective(float fov, float near, float far)
	{
		projection = mat4.identity.perspective(settings.ScreenWidth, settings.ScreenHeight, fov, near, far);
	}

	@property mat4 GetMatrix() { return projection * view; }
private:
	mat4 view, projection;
	GameSettings settings;
}
