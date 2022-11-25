using FFTW,LsqFit,Dierckx,Statistics,SparseArrays

Recf(n0,nC,x) = (x ≤ n0+nC)&&(x ≥ n0-nC) ? 1 : 0 

function funRec(n,n0,nC)
    fW = zeros(n)
    for i in 1:n
        fW[i] = Recf(n0,nC,i)
    end

    fW
end

function Bf(x,x0,xC,n)
    arg = ((x-x0)^2)/(xC^2)
    
    if n ==0
        B = exp(-arg)
    else
        sum1 = 0
        for i ∈ 0:n
            sum1 += (1/factorial(i))*arg^i
        end
        B = sum1*exp(-arg)
    end
    B
end

function GetFourierCoefs1(data)
    n = length(data)

    dtaF = fftshift(fft(data))

    PSD = real(conj(dtaF).*dtaF)/n
    PSD,dtaF
end

function GetFilteredData1(dataF,n0,nc,option,n=0)
    if option == "Rec"
        indices = funRec(length(dataF),n0,nc)
    elseif option == "GH"
        indices = Bf.(1:length(dataF),n0,nc,n)
    else
        indices = ones(length(dataF))
    end

    fhtat = indices.*dataF

    filtrD = real(ifft(ifftshift(fhtat)))

    return filtrD, indices
end

function getFiltImag1(datIm,n0,nct,option,n=0)
    datFiltr = zeros(size(datIm))
    for i in axes(datIm,1)
        dta = datIm[i,:]
        _,dataF = GetFourierCoefs1(dta)
        filtrD,_ = GetFilteredData1(dataF,n0,nct,option,n)
        datFiltr[i,:] = filtrD
    end
    datFiltr
end

function fitFrecData(dataVib,pA,pF)
    model1(x,p)=p[3]./sqrt.((p[1]*x).^2 .+(p[2]^2 .-x.^2).^2)
    model2(x,p)=(180/π)*atan.((1.0 .-(x/p[2]).^2)./(p[1]*x))

    fit1 = curve_fit(model1,dataVib[:,1],dataVib[:,2],pA);
    pF1 = fit1.param;
    fitDataAm =  model1(dataVib[:,1],pF1)

    fit2 = curve_fit(model2,dataVib[:,1],dataVib[:,3],pF)
    pF2 = fit2.param;
    fitDataF= model2(dataVib[:,1],pF2)

    return fitDataAm,fitDataF,pF1,pF2
end

function Erasebaseline(BsPoints, data)
    spL = Spline1D(BsPoints[:,1],BsPoints[:,2])
    spLineP = spL(1:length(data))
    (spLineP-data),spLineP
end

function EraseBL(y,λ,ratio,itrM)
    N = length(y)
    D = sparse(diff(diff(I(N),dims=1),dims=1))
    H = λ*D'*D
    w = ones(N)

    i = 1;e=1.0
    flag = true
    z = zeros(N)
    while flag
        W = Diagonal(w)
        C = cholesky(Matrix(H+W));C = C.U
        z = C\(C' \ (w.*y))
        d = y-z
        d⁻ = d[d.<0]
        m = mean(d⁻); s = std(d⁻)
        wt = 1 ./ (1 .+exp.(2*(d.-(2*s-m))/s))
    
        e = norm(w-wt)/norm(w)
        if  e < ratio || i > itrM
            flag = false
        end

        w = wt
        i+=1    
    end
    return z,e
end