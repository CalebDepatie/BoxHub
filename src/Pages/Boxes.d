module Pages.Boxes;

import BoxProviders: IBoxProvider, DistroBox, getBoxProviders, DBox;
import gtk.Frame;
import gtk.Box;
import gtk.Label;
import gtk.Button;
import gtk.Dialog;

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

		auto refreshButton = new Button("view-refresh-symbolic", GtkIconSize.BUTTON);
		refreshButton.addOnClicked(&refresh);
		hbox.packEnd(refreshButton, false, false, 0);

		auto addButton = new Button("list-add-symbolic", GtkIconSize.BUTTON);
		auto addForm = new AddBoxForm(Providers[0]);
		addButton.addOnClicked(delegate (Button b) {
			addForm.showAll();
			addForm.run();
			refresh(null);
		});
		hbox.packEnd(addButton, false, false, 2);

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

class AddBoxForm : Dialog {
	import gtk.Entry;
	
	IBoxProvider Prov;

	immutable int submitSignal = 1;
	immutable int cancelSignal = 2;

	Entry nameEntry;
	Entry imageEntry;

	this(IBoxProvider Provider) {
		super();
		Prov = Provider;

		render();
	}

	void render() {
		setTitle("Add New Box");
		setKeepAbove(true);

		auto nameBox = new Box(GtkOrientation.HORIZONTAL, 20);
		auto imageBox = new Box(GtkOrientation.HORIZONTAL, 20);

		nameEntry = new Entry("");
		nameBox.packStart(new Label("Box Name"), false, false, 0);
		nameBox.packStart(nameEntry, false, false, 0);
		
		imageEntry = new Entry("");
		imageBox.packStart(new Label("Box Image"), false, false, 0);
		imageBox.packStart(imageEntry, false, false, 0);

		auto content = getContentArea();
		content.packStart(nameBox, false, false, 0);
		content.packStart(imageBox, false, false, 0);

		addOnResponse(&submit);
		addOnResponse(&cancel);

		addButton("Submit", submitSignal);
		addButton("Cancel", cancelSignal);
	}

	void submit(int s, Dialog d) {
		if (s != submitSignal)
			return;

		Prov.create(nameEntry.getText(), imageEntry.getText());

		close();		
	}

	void cancel(int s, Dialog d) {
		if (s != cancelSignal)
			return;

		close();
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

		auto DelButton = new Button("window-close", GtkIconSize.BUTTON);
		DelButton.addOnClicked(&delBox);
		hbox.packEnd(DelButton, false, false, 2);

		auto BoxButton = new Button("input-tablet-symbolic", GtkIconSize.BUTTON);
		BoxButton.addOnClicked(&enterShell);
		hbox.packEnd(BoxButton, false, false, 2);

		add(hbox);
	}

	void enterShell(Button b) {
		Provider.enter(self);
		// disregard Pid
	}

	void delBox(Button b) {
		Provider.remove(self);
	}
}