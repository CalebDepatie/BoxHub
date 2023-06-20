module Pages.Boxes;

import BoxProviders: IBoxProvider, DistroBox, getBoxProviders, DBox;
import gtk.Frame;
import gtk.Box;
import gtk.Label;
import gtk.Button;

auto createBoxes() {
	import gtk.Label;

	auto providers = getBoxProviders();
	auto m = new BoxManager(providers);

	return m;
}

class BoxManager : Box {
	import gtk.Widget;

	IBoxProvider[] Providers;
	BoxListItem[] boxes;
	
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

		foreach (b; boxes) {
			packStart(b, false, false, 0);
		}
	}

	void refresh(Button b) {
		import std.array: join;

		this.boxes = [];
		foreach (prov; Providers) {
			foreach (dbox; prov.ListBoxes()) {
				this.boxes ~= new BoxListItem(dbox, prov);
			}
		}
	}
}


class BoxListItem : Frame {
	import BoxProviders: IBoxProvider;

	const DBox self;
	IBoxProvider Provider;
	
	this(const DBox b, ref IBoxProvider p) {
		super(b.Name);

		self = b;
		Provider = p;

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

		auto BoxButton = new Button("enter", GtkIconSize.BUTTON);
		BoxButton.addOnClicked(&enterShell);

		hbox.packEnd(BoxButton, false, false, 5);

		add(hbox);
	}

	void enterShell(Button b) {
		Provider.enter(self);
		// disregard Pid
	}
}