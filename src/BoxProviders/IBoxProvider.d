module BoxProviders.IBoxProvider;

interface IBoxProvider {
	import BoxProviders.DBox;

	DBox[] ListBoxes();
}

