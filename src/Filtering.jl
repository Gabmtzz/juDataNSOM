using FFTW

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

    dtaF = fft(data)

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

    filtrD = real(ifft(fhtat))

    return filtrD, indices
end

function getFiltImag1(datIm,n0,nct,option,n=0)
    datFiltr = zeros(size(datIm))
    for i in 1:size(datIm,1)
        dta = datIm[i,:]
        _,dataF = DataAnNSOM.GetFourierCoefs1(dta)
        filtrD,_ = DataAnNSOM.GetFilteredData1(dataF,n0,nct,option,n)
        datFiltr[i,:] = filtrD
    end
    datFiltr
end