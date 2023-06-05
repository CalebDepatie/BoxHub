module BoxProviders.IBoxProvider;

interface IBoxProvider {
	import BoxProviders.Box;

	Box[] ListBoxes();
}

