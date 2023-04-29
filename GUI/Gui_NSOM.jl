using Pkg
Pkg.activate("..")

using Gtk

using DataAnNSOM


mutable struct TopWidget <: Gtk.GtkGrid
    handle::Ptr{Gtk.GObject}
    b_read
    label_month
    label_day
    label_year
    entry_month 
    entry_day 
    entry_year

    function TopWidget()
        g = GtkGrid()
        b_read = GtkButton("Open Folder")
        label_month,label_day,label_year = GtkLabel("Month"),GtkLabel("Day"), GtkLabel("Year")
        entry_month,entry_day,entry_year = GtkEntry(),GtkEntry(),GtkEntry()

        g[1,1] = label_month; g[2,1] = label_day; g[3,1] = label_year
        g[1,2]= entry_month;g[2,2] = entry_day; g[3,2] = entry_year; g[4,2] = b_read

        set_gtk_property!(g,:column_spacing, 5)
        set_gtk_property!(g, :column_homogeneous, true)
        w = new(g.handle,b_read,label_day,label_month,label_year,entry_month,entry_day,entry_year)
        return Gtk.gobject_move_ref(w, g)
    end
end

mutable struct FileListWidget <: Gtk.Box
    handle::Ptr{Gtk.GObject}
    ls
    list_files
    label_f

    function FileListWidget(NameFiles)
        hbox = GtkBox(:h)

        label_f = GtkLabel("Files")
        push!(hbox,label_f)

        ls = GtkListStore(String,Int64)
        i=1
        for filename in NameFiles
            push!(ls,(filename,i))
        end
        list_files = GtkTreeView(GtkTreeModel(ls))
        rTxt = GtkCellRendererText()
        rTog = GtkCellRendererToggle()
        c1 = GtkTreeViewColumn("Name File", rTxt, Dict([("text",0)]))
        c2 = GtkTreeViewColumn("index", rTxt, Dict([("text",1)]))
        push!(list_files,c1,c2)

        push!(hbox,list_files)

        w = new(hbox.handle,ls,list_files,label_f)

        return Gtk.gobject_move_ref(w,hbox)

    end
end



win = GtkWindow("NSOM",400,200)

vbox1 = GtkBox(:v)
NameF1 = [""]
c = TopWidget()
NameF = [""]
listF = FileListWidget(NameF)




function buttonReqar(widget, user_data)
    listF,nameF,vbox1 = user_data
    str_Dy,str_Mo,str_Yr = get_gtk_property(c.entry_day,:text, String),get_gtk_property(c.entry_month,:text, String),get_gtk_property(c.entry_year,:text, String)
    dy,mo,yr = parse(Int64,str_Dy), parse(Int64,str_Mo),parse(Int64,str_Yr)
    NameFiles1,direction = DataAnNSOM.get_filesNames(mo,dy,yr)
    nameF = NameFiles1
    println(nameF)
    #destroy(listF)
    #listF = FileListWidget(nameF)
    #push!(vbox1,listF)
    nameF
end

nameF = signal_connect(buttonReqar,c.b_read,"clicked",Vector{String}, (), false, (listF,NameF,vbox1))



#signal_connect(c.b_read,"clicked") do widget
#    str_Dy,str_Mo,str_Yr = get_gtk_property(c.entry_day,:text, String),get_gtk_property(c.entry_month,:text, String),get_gtk_property(c.entry_year,:text, String)
#    dy,mo,yr = parse(Int64,str_Dy), parse(Int64,str_Mo),parse(Int64,str_Yr)
#    NameFiles1,direction = DataAnNSOM.get_filesNames(mo,dy,yr)
#    println(NameFiles1)
#    listF = FileListWidget([""])
#end


#listF = FileListWidget(NameFiles)
#println(nameFiles)
#push!(vbox1,listF)

push!(vbox1,c)
push!(vbox1,listF)
push!(win,vbox1)

showall(win)
