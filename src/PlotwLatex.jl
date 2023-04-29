using PGFPlotsX

function plotImagLx(mo,dy,yr,image,ϕ,θ,labelC,unitC,nEl,i,micr=false,bk=true,α=0, rangeX = 1:size(image,2) )
    ImPlot = image[:,rangeX]
    x,y = collect(axes(ImPlot,1)),collect(axes(ImPlot,2))

    AtrM = get_Attributes(mo,dy,yr,i)

    if size(AtrM,1) == 7
        xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   
    elseif size(AtrM,1) == 9
        xBeg,xEnd = AtrM[3,2],AtrM[7,2]; yBeg,yEnd = AtrM[4,2],AtrM[8,2]   
    end 

    if length(rangeX) < size(image,2)
        xEnd = (xEnd*length(rangeX)) / size(image,2) 
    end

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    if bk

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
                xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
                ytick = x[1]:yΔ₁:x[end],
                yticklabels = string.(round.((collect(yBeg:yΔ₂:yEnd)./fc).*cos((π*α)/180),digits = 1)),
            },
            Plot3(
                {
                    surf,
                    shader="interp",
                },
                Table(y,x,ImPlot')

            )
        ))
    else
        p = @pgf TikzPicture({scale=1.5}, Axis(
            {
                view = (ϕ,θ),
                enlargelimits=false,
                "colormap/viridis",
        		"axis on top",
                colorbar,
                xlabel = L"X~"*unit,
                ylabel = L"Y~"*unit,
                "colorbar style"={title=labelC, ylabel=unitC},
                xtick = y[1]:xΔ₁:y[end],
                xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
                ytick = x[1]:yΔ₁:x[end],
                yticklabels = string.(round.((collect(yBeg:yΔ₂:yEnd)./fc).*cos((π*α)/180),digits = 1)),
            },
            Plot3(
                {
                    surf,
                    shader="interp",
                },
                Table(y,x,ImPlot')
        
            )
        ))
    end

    p
end

function plotCompPlorilesLx(mo,dy,yr,i,prof1,prof2,label1,label2,nEl,labelleg1="AFM",labelleg2="NSOM",micr=false,xL=0.6,yL=0.9,α=0, rangeX = 1:length(prof1))
    profIm1, profIm2 = prof1[rangeX],prof2[rangeX]
    x = collect(axes(profIm1,1))

    AtrM = get_Attributes(mo,dy,yr,i)
    if size(AtrM,1) == 7
        xBeg,xEnd = AtrM[1,2],AtrM[5,2]  
    elseif size(AtrM,1) == 9
        xBeg,xEnd = AtrM[3,2],AtrM[7,2]   
    end

    if length(rangeX) < length(prof1)
        xEnd = (xEnd*length(rangeX)) / length(prof1)
    end
    
    xΔ₁,xΔ₂  = (x[end]-x[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale = 1.5}, Axis(
        {
            "axis y line*" = "left",
            ylabel=label1,
            xlabel = L"X~"*unit,
            xtick = x[1]:xΔ₁:x[end],
            xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
            ymax = maximum(profIm1)+0.25*maximum(profIm1)
        },
        Plot(
        {
            color="red",
            "solid",
            "line width"="2pt",
        },
        Table(x,profIm1)
    ),
    raw"\label{PL1}",
    ),
    Axis(
    {
        legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
        "axis y line*" = "right",
        "axis x line"="none", 
        ylabel=label2,
        ymax = maximum(profIm2)+0.25*maximum(profIm2)
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
        Table(x,profIm2)
    ),
    LegendEntry(labelleg2)
    )

    )
    p
end

function plotProfilesLx(mo,dy,yr,i,prof1,prof2,label1,nEl,labelleg1="NSOM1",labelleg2="NSOM2",micr=false,xL=0.6,yL=0.9,α=0, rangeX = 1:length(prof1))
    profIm1, profIm2 = prof1[rangeX],prof2[rangeX]
    x = collect(axes(profIm1,1))

    AtrM = get_Attributes(mo,dy,yr,i)
    if size(AtrM,1) == 7
        xBeg,xEnd = AtrM[1,2],AtrM[5,2]  
    elseif size(AtrM,1) == 9
        xBeg,xEnd = AtrM[3,2],AtrM[7,2]   
    end

    if length(rangeX) < length(prof1)
        xEnd = (xEnd*length(rangeX)) / length(prof1)
    end
    
    xΔ₁,xΔ₂  = (x[end]-x[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = @pgf TikzPicture({scale = 1.5}, Axis(
        {
            legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
            ylabel=label1,
            xlabel = L"X~"*unit,
            xtick = x[1]:xΔ₁:x[end],
            xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
            ymax = maximum(profIm1)+0.25*maximum(profIm1)
        },
        Plot(
        {
            color="red",
            "solid",
            "line width"="2pt",
        },
        Table(x,profIm1)
    ),
    LegendEntry(labelleg1),
    Plot(
        {
            color="black",
            "dashdotted",
            "line width"="2pt",
        },
        Table(x,profIm2)
    ),
    LegendEntry(labelleg2)
    ))

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
        ylabel = L"Fase~[\circ]",
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

function plotprofilesImageLx(ix,iy,mo,dy,yr,i,imAFM,imNSOM,ϕ,θ,xL,yL,nEl,label1,label2,labelC,unitA,unitB,micr=true,α=0, rangeX = 1:size(imAFM,2))
    ImPlotA = imAFM[:,rangeX]
    x,y = collect(axes(ImPlotA,1)),collect(axes(ImPlotA,2))

    AtrM = get_Attributes(mo,dy,yr,i)

    if size(AtrM,1) == 7
        xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   
    elseif size(AtrM,1) == 9
        xBeg,xEnd = AtrM[3,2],AtrM[7,2]; yBeg,yEnd = AtrM[4,2],AtrM[8,2]   
    end 

    if length(rangeX) < size(imAFM,2)
        xEnd = (xEnd*length(rangeX)) / size(imAFM,2) 
    end

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    profIm1h,profIm2h = imAFM'[ix,:],imNSOM'[ix,:]
    profIm1v,profIm2v = imAFM'[:,iy],imNSOM'[:,iy]

    pAFM = @pgf Axis(
                {
                    view = (ϕ,θ),
                    enlargelimits=false,
                    "colormap/hot2",
            		"axis on top",
                    xlabel = L"X~"*unit,
                    ylabel = L"Y~"*unit,
                    xtick = y[1]:xΔ₁:y[end],
                    xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
                    ytick = x[1]:yΔ₁:x[end],
                    yticklabels = string.(round.((collect(yBeg:yΔ₂:yEnd)./fc).*cos((π*α)/180),digits = 1)),
                },
                Plot3(
                    {
                        surf,
                        shader="interp",
                    },
                    Table(y,x,imAFM')

                ),
                Plot3(
                    {
                      mesh,
                      color="blue",
                      style="ultra thick",
                      "dashed"

                    },
                    Table(ix*ones(length(x)),x,imAFM'[ix,:])
                ),
                Plot3(
                    {
                      mesh,
                      color="purple",
                      style="ultra thick",
                      "dashed"

                    },
                    Table(y,iy*ones(length(y)),imAFM'[:,iy])
                )
            )

    pNSOM = @pgf Axis(
                    {
                        view = (ϕ,θ),
                        enlargelimits=false,
                        "colormap/viridis",
                		"axis on top",
                        xlabel = L"X~"*unit,
                        ylabel = L"Y~"*unit,
                        xtick = y[1]:xΔ₁:y[end],
                        xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
                        ytick = x[1]:yΔ₁:x[end],
                        yticklabels = string.(round.((collect(yBeg:yΔ₂:yEnd)./fc).*cos((π*α)/180),digits = 1)),
                    },
                    Plot3(
                        {
                            surf,
                            shader="interp",
                        },
                        Table(y,x,imNSOM')

                    ),
                    Plot3(
                        {
                          mesh,
                          color="red",
                          style="ultra thick",
                          "dashed"

                        },
                        Table(ix*ones(length(x)),x,imNSOM'[ix,:])
                    ),
                    Plot3(
                        {
                          mesh,
                          color="darkgray",
                          style="ultra thick",
                          "dashed"

                        },
                        Table(y,iy*ones(length(y)),imNSOM'[:,iy])
                    )
            )

        gP = @pgf GroupPlot(
            {
              group_style = { group_size="2 by 1","horizontal sep"=72 },
              no_markers,
            },
            pAFM,pNSOM
        )

        Pch1 = @pgf Axis(
            {
             "axis y line*" = "left",
                ylabel=label1,
                xlabel = L"X~"*unit,
                xtick = x[1]:yΔ₁:x[end],
                xticklabels = string.(round.((collect(xBeg:xΔ₂:xEnd)./fc).*cos((π*α)/180),digits = 1)),
                ymax = maximum(profIm1h)+0.25*maximum(profIm1h)
            },
            Plot(
            {
                color="blue",
                "solid",
                "line width"="2pt",
            },
            Table(x,profIm1h)
            ),
            raw"\label{PL1}",

            )

    Pch2 = @pgf Axis(
        {
            legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
            "axis y line*" = "right",
            "axis x line"="none", 
            #"axis line style"={"red"},
            ylabel=label2,
            ymax = maximum(profIm2h)+0.25*maximum(profIm2h)
        },
        [raw"\textsc",
        {raw"\addlegendimage{/pgfplots/refstyle=PL1}"},
        LegendEntry("AFM")
        ],
        Plot(
            {
                color="red",
                "dashdotted",
                "line width"="2pt",
            },
            Table(x,profIm2h)
        ),
        LegendEntry("R")
        )
    pProfh = @pgf (TikzPicture({scale = 1.5},Pch1,Pch2))

    Pcv1 = @pgf Axis(
            {
             "axis y line*" = "left",
                ylabel=label1,
                xlabel = L"Y~"*unit,
                xtick =  y[1]:xΔ₁:y[end],
                xticklabels = string.(round.((collect(yBeg:yΔ₂:yEnd)./fc).*cos((π*α)/180),digits = 1)),
                ymax = maximum(profIm1v)+0.25*maximum(profIm1v)
            },
            Plot(
            {
                color="purple",
                "solid",
                "line width"="2pt",
            },
            Table(y,profIm1v)
            ),
            raw"\label{PL1}",

            )

    Pcv2 = @pgf Axis(
        {
            legend_style={at = Coordinate(xL,yL),nodes = {scale=0.5, transform_shape},font=raw"\large",draw="none"},
            "axis y line*" = "right",
            "axis x line"="none", 
            ylabel=label2,
            ymax = maximum(profIm2v)+0.25*maximum(profIm2v)
        },
        [raw"\textsc",
        {raw"\addlegendimage{/pgfplots/refstyle=PL1}"},
        LegendEntry("AFM")
        ],
        Plot(
            {
                color="darkgray",
                "dashdotted",
                "line width"="2pt",
            },
            Table(y,profIm2v)
        ),
        LegendEntry("R")
        )
    pProfv = @pgf (TikzPicture({scale = 1.5},Pcv1,Pcv2))


    pImage = @pgf TikzPicture({scale = 1.5},gP)

    return(pImage,pProfh,pProfv)
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