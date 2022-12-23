using PGFPlotsX

function plotImagLx(mo,dy,image,labelC,unitC,nEl,i,micr=false)
    x,y = collect(axes(image,1)),collect(axes(image,2))

    AtrM = get_Attributes(mo,dy,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale=1.5}, Axis(
        {
            view = (0,90),
            enlargelimits=false,
            "colormap/blackwhite",
    		"axis on top",
            colorbar,
            xlabel = L"X~"*unit,
            ylabel = L"Y~"*unit,
            "colorbar style"={title=labelC, ylabel=unitC},
            xtick = y[1]:xΔ₁:y[end],
            xticklabels = string.(collect(xBeg:xΔ₂:xEnd)./fc),
            ytick = x[1]:yΔ₁:x[end],
            yticklabels = string.(collect(yBeg:yΔ₂:yEnd)./fc),
        },
        Plot3(
            {
                surf,
                shader="interp",
            },
            Table(y,x,image')

        )
    ))

    p
end

function plotCompPlorilesLx(mo,dy,i,prof1,prof2,label1,label2,nEl,labelleg1="AFM",labelleg2="NSOM",micr=false)
    x = collect(axes(prof1,1))

    AtrM = get_Attributes(mo,dy,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2];
    xΔ₁,xΔ₂  = (x[end]-x[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale = 1.5}, Axis(
        {
            "legend pos"="north west",
            "axis y line*" = "left",
            ylabel=label1,
            xlabel = L"X~"*unit,
            xtick = x[1]:xΔ₁:x[end],
            xticklabels = string.(collect(xBeg:xΔ₂:xEnd)./fc),
            ymax = maximum(prof1)+0.25*maximum(prof1)
        },
        Plot(
        {
            color="black",
            "solid",
            "line width"="2pt",
        },
        Table(x,prof1)
    ),
    LegendEntry(labelleg1)
    ),
    Axis(
    {
        "legend pos" = "north east",
        "axis y line*" = "right",
        "axis x line"="none", 
        ylabel=label2,
        ymax = maximum(prof2)+0.25*maximum(prof2)
    },
    Plot(
        {
            color="black",
            "dashdotted",
            "line width"="2pt",
        },
        Table(x,prof2)
    ),
    LegendEntry(labelleg2)
    )

    )
end