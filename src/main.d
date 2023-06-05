import BoxProviders;

void main(string[] args) {
    import gtk.MainWindow;
    import gtk.Label;
    import gtk.Main;

    // Main.init(args);
    // MainWindow win = new MainWindow("BoxHub");
    // win.setDefaultSize(800, 500);

    // win.add(new Label("Hello World"));

    // win.showAll();
    // Main.run();

    DistroBox test = new DistroBox();

    test.ListBoxes();

    return;
}