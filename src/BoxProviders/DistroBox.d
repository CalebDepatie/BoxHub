module BoxProviders.DistroBox;

import BoxProviders.IBoxProvider;

class DistroBox : IBoxProvider {
	import BoxProviders.Box;

	private static string CmdPath = "~/.local/bin/distrobox ";
	
	Box[] ListBoxes() {
		import std.process: executeShell;

		auto shellOut = executeShell(CmdPath ~ "list");

		debug {
			import std.stdio: writeln;

			writeln("Status: ", shellOut.status);
			writeln("Out: ", shellOut.output);
		}

		Box[] boxes;

		return boxes;
	}
} 