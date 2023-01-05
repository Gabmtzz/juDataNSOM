using PGFPlotsX

function plotImagLx(mo,dy,yr,image,ϕ,θ,labelC,unitC,nEl,i,micr=false)
    x,y = collect(axes(image,1)),collect(axes(image,2))

    AtrM = get_Attributes(mo,dy,yr,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale=1.5}, Axis(
        {
            view = (ϕ,θ),
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

function plotCompPlorilesLx(mo,dy,yr,i,prof1,prof2,label1,label2,nEl,labelleg1="AFM",labelleg2="NSOM",micr=false,xL=0.6,yL=0.9)
    x = collect(axes(prof1,1))

    AtrM = get_Attributes(mo,dy,yr,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2];
    xΔ₁,xΔ₂  = (x[end]-x[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale = 1.5}, Axis(
        {
            "axis y line*" = "left",
            ylabel=label1,
            xlabel = L"X~"*unit,
            xtick = x[1]:xΔ₁:x[end],
            xticklabels = string.(collect(xBeg:xΔ₂:xEnd)./fc),
            ymax = maximum(prof1)+0.25*maximum(prof1)
        },
        Plot(
        {
            color="red",
            "solid",
            "line width"="2pt",
        },
        Table(x,prof1)
    ),
    raw"\label{PL1}",
    ),
    Axis(
    {
        legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
        "axis y line*" = "right",
        "axis x line"="none", 
        ylabel=label2,
        ymax = maximum(prof2)+0.25*maximum(prof2)
    },
    [raw"\textsc",
    {raw"\addlegendimage{/pgfplots/refstyle=PL1}"},
    LegendEntry(labelleg1)
    ],
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
    p
end

function PlotCompfrecDatLx(dataVib,xL=0.9,yL=0.8)

   p = @pgf TikzPicture({scale= 1.5}, Axis(
    {
        "axis y line*" = "left",
        ylabel = L"Amplitud~[U.A.]",
        xlabel = L"Frec.~[Hz]",
    },
    Plot(
        {
            color="black",
            "solid",
            "line width"="2pt",
        },
        Table(dataVib[:,1],dataVib[:,2])
    ),
    raw"\label{PL1}",
   ),
   Axis(
    {
        legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
        "axis y line*" = "right",
        "axis x line"="none", 
        ylabel = L"Fase~[deg]",
    },
    [raw"\textsc",
    {raw"\addlegendimage{/pgfplots/refstyle=PL1}"},
    LegendEntry(L"Amplitud")
    ],
    Plot(
        {
            color="red",
            "dashdotted",
            "line width"="2pt",
        },
        Table(dataVib[:,1],dataVib[:,3])
    ),
    LegendEntry(L"Fase")
   )

   ) 
  p
end

function plotFitLx(datX,datY,label,fitY,error=true,xL=0.9,yL=0.8)
    p = @pgf TikzPicture({scale=1.5}, Axis(
        {
            legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
            xlabel=L"Frec.~ [Hz]",
            ylabel=label,
        },
        Plot(
            {
                color="red",
                "only marks",
            },
            Table(datX,datY)
        ),
        LegendEntry("Datos"),
        Plot(
            {
                color="black",
                "dashdotted",
                "line width"="2pt",
                "error bars/y dir=both",
                "error bars/y explicit",
            },
            if error
                Coordinates(datX,fitY; yerror=abs.(datY-fitY))
            else
                Table(datX,fitY)
            end
        ),
        LegendEntry("Fit")
    )

    )
    
end

function saveFilePlot(dir,filename,pl)
    file=dir*filename

    pgfsave(file,pl)
    
end
