using Interpolations,LaTeXStrings,Plots; pyplot()

function plotImag(mo,dy,datIm, labelT,nEl,i)
    x = 1:1:size(datIm,1); y = 1:1:size(datIm,2)
    itp = LinearInterpolation((x,y),datIm)

    x2 = range(extrema(x)..., length=300); y2 = range(extrema(y)..., length=900)
    z2 = [itp(x,y) for y in y2, x in x2]

    AtrM = get_Attributes(mo,dy,i)
    
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    heatmap(y2,x2,z2', c = cgrad(:viridis, rev = true), xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd))),
    yticks = (x[1]:yΔ₁:x[end], string.(collect(yBeg:yΔ₂:yEnd))), xlabel = L"X ~[nm]", ylabel = L"Y ~[nm]", colorbar_title = labelT )

end

function plotProfile(mo,dy,datIm, labelT,nEl,index,i)
    y = 1:1:size(datIm,2)
    AtrM = DataAnNSOM.get_Attributes(mo,dy,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2];
    
    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl

    plot(datIm[index,:], c=:black, label=:none, xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd))), xlabel = L"X ~[nm]", ylabel = labelT)
end

function PlotFilter(PSD,indices,nct)
    ns = Int(round(length(PSD)/2))+5
    p = plot(indices[1:ns],color = :red, mark=:xcross,fg = :red,grid=false ,ylabel="Window Function", label="Widnow function", legend=:topright)
    p = vline!([nct nct], c=:black, line=(1,:dash), label=:none)
    p = annotate!(nct+0.6,1.0,text(L"n_{cut}", 12, :left, :top, :black))
    p = plot!(twinx(),PSD[1:ns], yaxis=:log, mark=:circle, color=:black,fg = :black, label=L"\log{C_n}", legend=:right,
             grid=false,ylabel =L"\log{C_n}", xlabel =L"n")
    p
end