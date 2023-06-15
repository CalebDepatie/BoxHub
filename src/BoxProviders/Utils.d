module BoxProviders.Utils;


auto getBoxProviders() {
	import BoxProviders: IBoxProvider, DistroBox;	

	IBoxProvider[] providers;

	providers ~= new DistroBox();

	return providers;
};