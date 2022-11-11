using FFTW

Recf(n0,nC,x) = (x ≤ n0+nC)&&(x ≥ n0-nC) ? 1 : 0 

function funRec(n,n0,nC)
    fW = zeros(n)
    for i in 1:n
        fW[i] = Recf(n0,nC,i)
    end

    fW
end

function GetFourierCoefs1(data)
    n = length(data)

    dtaF = fft(data)

    PSD = real(conj(dtaF).*dtaF)/n
    PSD,dtaF
end

function GetFilteredData1(dataF,n0,nc)
    indices = funRec(length(dataF),n0,nc)

    fhtat = indices.*dataF

    filtrD = real(ifft(fhtat))

    return filtrD, indices
end

function getFiltImag1(datIm,n0,nct)
    datFiltr = zeros(size(datIm))
    for i in 1:size(datIm,1)
        dta = datIm[i,:]
        _,dataF = DataAnNSOM.GetFourierCoefs1(dta)
        filtrD,_ = DataAnNSOM.GetFilteredData1(dataF,n0,nct)
        datFiltr[i,:] = filtrD
    end
    datFiltr
end