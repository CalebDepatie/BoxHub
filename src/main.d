void main(string[] args) {
    import gtk.MainWindow;
    import gtk.Label;
    import gtk.Main;
    import gtk.Stack;
    import gtk.StackSwitcher;
    import gtk.Box;
    import Pages : createSettings, createBoxes;

    Main.init(args);
    MainWindow win = new MainWindow("BoxHub");
    win.setDefaultSize(800, 500);
    win.setBorderWidth(10);

    auto box = new Box(GtkOrientation.VERTICAL, 5);

    auto stack = new Stack();

    stack.addTitled(createSettings(), "settings", "Settings");
    stack.addTitled(createBoxes(), "boxes", "Boxes");

    auto stack_switch = new StackSwitcher();
    stack_switch.setStack(stack);
    stack_switch.setHalign(GtkAlign.CENTER);

    box.packStart(stack_switch, false, false, 0);
    box.packStart(stack, true, true, 0);

    win.add(box);
    win.setIconName("package-x-generic-symbolic");
    // win.add(stack);

    win.showAll();
    stack.setVisibleChildName("boxes");
    Main.run();

    return;
}