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