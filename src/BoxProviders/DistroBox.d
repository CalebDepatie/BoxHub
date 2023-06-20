module BoxProviders.DistroBox;

import BoxProviders.IBoxProvider;

class DistroBox : IBoxProvider {
	import BoxProviders.DBox;
	import std.process: Pid;

	private static string CmdPath = "~/.local/bin/distrobox ";
	
	DBox[] ListBoxes() {
		import std.process: executeShell;
		import std.string: split, splitLines;

		auto shellOut = executeShell(CmdPath ~ "list");

		DBox[] boxes;

		if (shellOut.status == 0) {
			auto lines = splitLines(shellOut.output);

			// skip header and look at each line
			for (int i = 1; i < lines.length-1; i++) {
				auto sections = split(lines[i], " | ");
				
				DBox new_box = {
					ID: sections[0],
					Name: sections[1],
					Status: sections[2],
					Image: sections[3]
				};

				boxes ~= new_box;
			}
		}

		return boxes;
	}

	Pid enter(inout DBox b) {
		import std.process: spawnShell;
		import std.process: Config;

		immutable string termName = "kitty --title " ~ b.Name ~ " -d $HOME";

		auto pid = spawnShell(termName ~ " " ~ CmdPath ~ "enter " ~ b.Name ~ " && cd ~/");//, null, Config.none, "/home");
		
		return pid;
	}
} 