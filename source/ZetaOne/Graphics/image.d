module ZetaOne.Graphics.image;
import derelict.devil.il;
import derelict.devil.ilu;
import std.string;
import ZetaOne.d;

class Image
{
public:
	this(string file)
	{
		ilGenImages(1, &image);
		Engine.ILCheck("Failed to generate image.");
		Bind();
		ilLoadImage(cast(char*)toStringz(file));
		Engine.ILCheck("Failed to load image.");
		Unbind();
	}

	~this()
	{
		ilDeleteImages(1, &image);
		Engine.ILCheck("Failed to delete image.");
	}

	void Bind()
	{
		ilBindImage(image);
		Engine.ILCheck("Failed to bind image.");
	}

	void Unbind()
	{
		ilBindImage(0);
		Engine.ILCheck("Failed to unbind image.");
	}

	void Save(string file)
	{
		Bind();
		ilEnable(IL_FILE_OVERWRITE);
		ilSaveImage(cast(char*)toStringz(file));
		Engine.ILCheck("Failed to save image.");
		Unbind();
	}

	@property uint Width() { return cast(uint)ilGetInteger(IL_IMAGE_WIDTH); }
	@property uint Height() { return cast(uint)ilGetInteger(IL_IMAGE_HEIGHT); }
	@property uint BPP() { return cast(uint)ilGetInteger(IL_IMAGE_BPP); }
	@property uint Format() { return cast(uint)ilGetInteger(IL_IMAGE_FORMAT); }
	@property ubyte* Data() { return cast(ubyte*)ilGetData(); }	
private:
	ILuint image;
}
