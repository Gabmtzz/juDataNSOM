using FFTW

function GetFourierCoefs(data)
    n = length(data)

    dtaF = fft(data)

    PSD = real(conj(dtaF).*dtaF)/n
    PSD,dtaF
end

function GetFilteredData(dataF,nc)
    indices = zeros(length(dataF)); indices[1:nc] .= 1

    fhtat = indices.*dataF

    filtrD = real(ifft(fhtat))

    return filtrD, indices
end