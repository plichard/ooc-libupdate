use gtk, glade
import gtk/[Gtk, Widget, ProgressBar], glade/XML
import io/File
import structs/ArrayList

progressBar: Widget
usleep: extern func(...)

someSignalHandler: func (widget: Widget, userData: GPointer) {
  Gtk mainQuit()
}

on_main_menu_open_activate: func (widget: Widget, userData: GPointer){
	printf("Get [OPEN] signal!!!\n");
}

getUse: func(dir: File) -> File {
	set := ArrayList<File> new()
	set add("/usr/lib/ooc/" + dir name() + "/")
	i := 0
	printf("Got base file: %s\n",set get(0))
	/*while(i < 3) {
		nextSet := ArrayList<File> new()
		for(candidate in set) {
			if(candidate name() endsWith(".use")) {
				return candidate
			} else if(candidate isDir()) {
				for(child: File in candidate getChildren()) {
					nextSet add(child)
				}
			}
		}
		set = nextSet
		if(nextSet size() == 0) {
			i = 4
		}
	}*/
	return null
}

checkLibs: func {
	printf("Checking /usr/lib/ooc for installed bindings...\n")
	if(!(File new("/usr/lib/ooc") exists())) {
		if(!(File new("/usr/lib/ooc") mkdir())) {
			printf("/usr/lib/ooc could not be created, please check your permissions !!!\n")
			Gtk mainQuit()
		}
	}
	
	libdir := File new("/usr/lib/ooc/")
	libs := libdir getChildren()
	println()
	for(dir in libs) {	
		if(dir isDir()) {
			printf("======= %s ========\n",dir getAbsolutePath())
			usefile := getUse(dir)
			if(usefile) {
				printf("Found usefile: %s\n",usefile name())
			}
		}
	}
}


playWithProgress: func {
	
		progressBar as ProgressBar pulse()
	
}

main: func (argc : Int, argv: String*) {
    
    Gtk init(argc&, argv&)
    window: Widget

    /* load the interface */
    xml := XML new("interface.glade", null, null)
    window = xml getWidget("window1")
    
    xml signalConnect("on_window1_delete_event",someSignalHandler,null)
    xml signalConnect("on_checklibs_activate",checkLibs,null)
    
    progressBar = xml getWidget("progressbar1")
    
    Gtk addTimeout(30,playWithProgress,null)
    
    window showAll()

    /* connect the signals in the interface */
	//xml signalAutoConnect()
	

    /* start the event loop */
    Gtk main()
    
}
