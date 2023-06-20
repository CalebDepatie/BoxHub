module BoxProviders.IBoxProvider;

interface IBoxProvider {
	import BoxProviders.DBox;
	import std.process: Pid;

	DBox[] ListBoxes();
	Pid enter(inout DBox b);
}

