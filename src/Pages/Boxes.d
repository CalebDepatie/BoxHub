module Pages.Boxes;

import BoxProviders: IBoxProvider, DistroBox, getBoxProviders, DBox;
import gtk.Frame;
import gtk.Box;
import gtk.Label;

auto createBoxes() {
	import gtk.Label;

	auto providers = getBoxProviders();
	auto m = new BoxManager(providers);

	return m;
}

class BoxManager : Box {
	import gtk.Button;

	IBoxProvider[] Providers;
	DBox[] boxes;
	
	this(IBoxProvider[] providers) {
		super(GtkOrientation.VERTICAL, 10);

		Providers = providers;

		refresh(null);

		render(); // setup box
	}

	void render() {
		auto hbox = new Box(GtkOrientation.HORIZONTAL, 20);
		auto refreshButton = new Button("refresh", GtkIconSize.BUTTON);
		refreshButton.addOnClicked(&refresh);

		hbox.packEnd(refreshButton, false, false, 0);
		packStart(hbox, false, false, 0);

		foreach(b; boxes) {
			packStart(new BoxListItem(b), false, false, 0);
		}
	}

	void refresh(Button b) {
		import std.array: join;

		this.boxes = [];
		foreach(prov; Providers) {
			this.boxes = join([boxes, prov.ListBoxes()]);
		}
	}

}


class BoxListItem : Frame {
	const DBox self;
	
	this(const DBox b) {
		super(b.Name);

		self = b;

		render();
	}

	void render() {
		import gtk.Separator;

		auto hbox = new Box(GtkOrientation.HORIZONTAL, 10);
		hbox.setValign(GtkAlign.CENTER);

		hbox.packStart(new Label("ID: " ~ self.ID[self.ID.length-12 .. self.ID.length]), false, false, 5);
		hbox.packStart(new Separator(GtkOrientation.HORIZONTAL), false, false, 5);
		hbox.packStart(new Label("Image: " ~ self.Image), false, false, 5);
		hbox.packStart(new Separator(GtkOrientation.HORIZONTAL), false, false, 5);
		hbox.packStart(new Label("Status: " ~ self.Status), false, false, 5);

		add(hbox);
	}
}