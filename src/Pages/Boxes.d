module Pages.Boxes;

import BoxProviders: IBoxProvider, DistroBox, getBoxProviders;

auto createBoxes() {
	import gtk.Label;

	auto providers = getBoxProviders();
	auto m = new BoxManager(providers);

	return m;
}

import gtk.Box;
class BoxManager : Box {
	const IBoxProvider[] Providers;
	
	this(const IBoxProvider[] providers) {
		super(GtkOrientation.VERTICAL, 10);

		Providers = providers;

		render(); // setup box
	}

	void render() {
		import gtk.Button;
		import gtk.Label;

		auto hbox = new Box(GtkOrientation.HORIZONTAL, 10);
		auto refreshButton = new Button("refresh", GtkIconSize.BUTTON);
		hbox.packEnd(refreshButton, false, false, 0);
		packStart(hbox, false, false, 0);

	}
}