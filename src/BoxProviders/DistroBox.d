module BoxProviders.DistroBox;

import BoxProviders.IBoxProvider;

class DistroBox : IBoxProvider {
	import BoxProviders.Box;

	private static string CmdPath = "~/.local/bin/distrobox ";
	
	Box[] ListBoxes() {
		import std.process: executeShell;
		import std.string: split, splitLines;

		auto shellOut = executeShell(CmdPath ~ "list");

		Box[] boxes;

		if (shellOut.status == 0) {
			auto lines = splitLines(shellOut.output);

			// skip header and look at each line
			for (int i = 1; i < lines.length-1; i++) {
				auto sections = split(lines[i], " | ");
				
				Box new_box = {
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
} 