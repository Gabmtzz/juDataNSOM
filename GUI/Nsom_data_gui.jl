using Pkg
Pkg.activate("..")

using Gtk

using DataAnNSOM

win = GtkWindow("Data Analysis")

vBox1 = GtkBox(:v)
g = GtkGrid()
label_month,label_day,label_year = GtkLabel("Month"),GtkLabel("Day"), GtkLabel("Year")
entry_month,entry_day,entry_year = GtkEntry(),GtkEntry(),GtkEntry()
b_read = GtkButton("Read")

g[1,1] = label_month; g[2,1] = label_day; g[3,1] = label_year  
g[1,2]= entry_month;g[2,2] = entry_day; g[3,2] = entry_year ;g[4,2] = b_read
set_gtk_property!(g,:column_spacing, 5)
set_gtk_property!(g, :column_homogeneous, true)

push!(vBox1,g)

ls = GtkListStore(String,Int64)
push!(ls,("None",0))
tv = GtkTreeView(GtkTreeModel(ls))
rTxt = GtkCellRendererText()
rTog = GtkCellRendererToggle()
c1 = GtkTreeViewColumn("Name File", rTxt, Dict([("text",0)]))
c2 = GtkTreeViewColumn("index", rTxt, Dict([("text",1)]))
push!(tv,c1,c2)

push!(vBox1,tv)
push!(win,vBox1)


signal_connect(b_read,"clicked") do widget
    str_Dy,str_Mo,str_Yr = get_gtk_property(entry_day,:text, String),get_gtk_property(entry_month,:text, String),get_gtk_property(entry_year,:text, String)
    dy,mo,yr = parse(Int64,str_Dy), parse(Int64,str_Mo),parse(Int64,str_Yr)
    NameFiles,_ = DataAnNSOM.get_filesNames(mo,dy,yr)
    i=1
    Gtk.ListStore.clear(ls)
    insert!(ls,i,(NameFiles[i],i))
    
    println(NameFiles[i])
end

signal_connect(ls, "changed") do widget
    
end


showall(win)
