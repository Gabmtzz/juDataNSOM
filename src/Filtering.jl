using FFTW

function GetFourierCoefs1(data)
    n = length(data)

    dtaF = fft(data)

    PSD = real(conj(dtaF).*dtaF)/n
    PSD,dtaF
end

function GetFilteredData1(dataF,nc)
    indices = zeros(length(dataF)); indices[1:nc] .= 1

    fhtat = indices.*dataF

    filtrD = real(ifft(fhtat))

    return filtrD, indices
end

function getFiltImag1(datIm,nct)
    datFiltr = zeros(size(datIm))
    for i in 1:size(datIm,1)
        dta = datIm[i,:]
        _,dataF = DataAnNSOM.GetFourierCoefs1(dta)
        filtrD,_ = DataAnNSOM.GetFilteredData1(dataF,nct)
        datFiltr[i,:] = filtrD
    end
    datFiltr
end