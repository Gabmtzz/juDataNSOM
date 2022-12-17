using Interpolations,LaTeXStrings,Measures,LazyGrids,Plots

function plotImag(mo,dy,datIm,cm,labelT,nEl,i,micr=false)
    x = 1:1:size(datIm,1); y = 1:1:size(datIm,2)
    itp = LinearInterpolation((x,y),datIm)

    x2 = range(extrema(x)..., length=300); y2 = range(extrema(y)..., length=900)
    z2 = [itp(x,y) for y in y2, x in x2]

    AtrM = get_Attributes(mo,dy,i)
    
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    heatmap(y2,x2,z2', c = cm, xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd)./fc)),
    yticks = (x[1]:yΔ₁:x[end], string.(collect(yBeg:yΔ₂:yEnd)./fc)), xlabel = L"X ~"*unit, ylabel = L"Y ~"*unit, colorbar_title = labelT )

end

function plotProfile(mo,dy,datIm, labelT,nEl,index,i,micr=false)
    y = 1:1:size(datIm,2)
    AtrM = get_Attributes(mo,dy,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2];
    
    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    plot(datIm[index,:], c=:black, label=:none, xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd)./fc)), xlabel = L"X ~"*unit, ylabel = labelT)
end

function PlotFilter(PSD,indices)
    p = plot(indices,color = :red, mark=:xcross,fg = :red,grid=false ,ylabel="Window Function", xlabel =L"n", label="Widnow function", legend=:topleft)
    p = plot!(twinx(),PSD, yaxis=:log, mark=:circle, color=:black,fg = :black, label=L"\log{C_n}", legend=:topright,
             grid=false,ylabel =L"\log{C_n}")
    p
end

function PlotCompProfiles(mo,dy,i,dat1,dat2,label1,label2,nEl,micr=false)
    y = 1:1:size(dat1,1)
    AtrM = get_Attributes(mo,dy,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2];
        
    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"
    
    p = plot(dat2, c=:black, label="AFM", xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd)./fc)), xlabel = L"X ~"*unit, ylabel = label1, legend=:topleft)
    p = plot!(twinx(p),c=:red,dat1,ylabel=label2,label="NSOM", line=(1,:dash),legend=:topright)
    
    p
    
end

function PlotCompFrecDat(dataVib)
    p = plot(dataVib[:,1],dataVib[:,2], c=:black, mark=:circle, label="Amplitud", legend=:left, xlabel=L"Frec.~[Hz]", ylabel=L"Amplidud~ [U.A.]")
    p = plot!(twinx(),dataVib[:,1],dataVib[:,3], c=:red, mark=:xcross, label="Fase", ylabel=L"Fase~[deg]")
    p
end

function plotFit(datX,datY,label,fitY,error)
    if error
        p = plot(datX,fitY, label="fit", c=:black, line=(2,:dash))
        p = scatter!(datX,datY,ylabel = label, xlabel=L"Frec.~[Hz]",label="data",c=:red)
        p = yerror!(datX,datY; yerror = abs.(datY-fitY))
    else
        p = plot(datX,fitY,label="fit",c=:black, line=(2,:dash))
        p = scatter!(datX,datY,ylabel = label, xlabel=L"Frec.~[Hz]",label="data",c=:red)
    end
    p
end

function plotImagwDataEx(mo,dy,imArr,labelT,fi,ArrAmp,ArrFase,YArr,j,cm)
    AmplArrPl = []; AmplArrFs = [] 

    for i ∈ YArr
        pA = plot(ArrAmp[i,j], color=:black, mark=:circle, xlabel="Paso", ylabel="Amplitud [U.A.]",title="Y = "*string(i) ,legend=:none)
        pF = plot(ArrFase[i,j], color=:blue, mark=:circle, xlabel="Paso", ylabel="Fase [Deg.]",fg=:blue, legend=:none); pF = plot!(fg=:black)
        push!(AmplArrPl,pA); push!(AmplArrFs,pF)
    end
    
    pA = plot(AmplArrPl..., size=(600,300), margin=3mm); pF = plot(AmplArrFs..., size=(600,300), margin=3mm)
    pDat = plot(pA,pF, layout=(2,1), size =(900,450))
    pIm = plotImag(mo,dy,imArr/1000,cm, labelT,5,fi); pIm = vline!([j j], c=:red, line=(2,:dash), label=:none)
    plot(pIm,pDat, size=(1200,500))
end

function plot3Ddata(mo,dy,i,zArr,nEl,cm,zlb,ϕ,θ,micr=false)
    x,y = 1:size(zArr,1),1:size(zArr,2)
    AtrM = get_Attributes(mo,dy,i)
    
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   

    xΔ₁,xΔ₂  = (y[end]-y[1])/nEl, (xEnd-xBeg)/nEl; yΔ₁,yΔ₂  = (x[end]-x[1])/nEl, (yEnd-yBeg)/nEl

    xArr,yArr = ndgrid(size(zArr,1),size(zArr,2));

    fc = micr ? 1000 : 1
    unit = micr ? L"[\mu m]" : L"[n m]"

    p = surface(yArr,xArr,zArr,c=cm,camera=(ϕ,θ),colorbar=:none, xticks = (y[1]:xΔ₁:y[end], string.(collect(xBeg:xΔ₂:xEnd)./fc)),
        yticks = (x[1]:yΔ₁:x[end], string.(collect(yBeg:yΔ₂:yEnd)./fc)), xlabel = L"X ~"*unit, ylabel = L"Y ~"*unit,zlabel = zlb,xguidefontrotation = abs(ϕ^3/90^2),yguidefontrotation = abs((90-ϕ)^3/90^2), zguidefontrotation=90)
    p
end