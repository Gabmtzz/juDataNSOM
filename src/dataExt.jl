function EraseZeros(data,i)
    datVec = data[i,:]
    ind = length(datVec); flag = true; j = length(datVec)

    while flag
        if datVec[j] ≠ 0.0
            ind = j
            flag = false
        end
    
        if j == 0
            flag = false
        end
    
        j -= 1
    end
    
    if ind != 0
       datVec = datVec[3:ind]
    else 
       datVec = datVec[3:end]
    end
    datVec
end
    
function GetArrdat(imArr,data)
    DatArrS = Array{Array{Float64,1}}(undef,size(imArr))

    for i ∈ 1:size(imArr,2)
        dataSer = EraseZeros(data,i)
        pos99 = findall(dataSer .== 999)
        posi = 0 
        for j ∈ eachindex(pos99)
            DatArrS[j,i] = dataSer[posi+3:pos99[j]-1];
            posi = pos99[j]
        end
    end
    DatArrS
end