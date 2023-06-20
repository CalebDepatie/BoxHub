module BoxProviders.IBoxProvider;

interface IBoxProvider {
	import BoxProviders.DBox;
	import std.process: Pid;

	DBox[] ListBoxes();
	Pid enter(in DBox b);
	void remove(in DBox b);
	bool create(in string Name, in string Image);
}

