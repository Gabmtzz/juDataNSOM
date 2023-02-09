using HDF5,DelimitedFiles

function get_dirYr(mo,dy,yr)
    direction ="/home/martinez/Documents/dataNSOM"
    folder = "med_"*string(yr,pad=2)
    elementDir = cd(readdir,direction)
    indexF = findall(elementDir .== folder)

    try
        indexF = indexF[1]
        direction = direction*"/"*folder
        dirFull = get_dir(mo,dy,direction)
        dirFull
    catch
        error("The folder does not exist.")
    end

end

function get_dir(mo,dy,direction)
    #direction ="/home/martinez/Documents/dataNSOM"
    folder = "med_"*string(mo,pad=2)*"_"*string(dy,pad=2)
    elementDir = cd(readdir,direction)
    indexFol = findall(elementDir .==folder)

    try
        indexFol = indexFol[1]
        direction = direction*"/"*folder
        direction
    catch 
        error("The folder does not exist.")
    end

end

function get_filesNames(mo,dy,yr)
    direction = get_dirYr(mo,dy,yr)
    NameFiles = cd(readdir,direction)
    if ~isempty(NameFiles)
        return NameFiles,direction
    else
        error("The folder is empty")
    end
end

function read_FileData(mo,dy,yr,ind)
    NameFiles,direction = get_filesNames(mo,dy,yr)

    cd(direction)
    fname = direction*"/"*NameFiles[ind]
    fNs = h5open(fname,"r")

    groupF = keys(fNs)

    if length(groupF) ==2
        dataSm = keys(fNs[groupF[1]])
        datMeas = read(fNs[groupF[1]*"/"*dataSm[1]])

        dataExt = keys(fNs[groupF[2]])
        datAmp = read(fNs[groupF[2]*"/"*dataExt[1]]); datFase = read(fNs[groupF[2]*"/"*dataExt[2]]) 
        #return datMeas,transpose(datAmp),transpose(datFase)
    elseif length(groupF) ==1
        datMeas = read(fNs[groupF[1]])
        datAmp,datFase = zeros(10,10),zeros(10,10)
        #return datMeas
    end

    close(fNs)

    return datMeas,transpose(datAmp),transpose(datFase)

end

function get_Attributes(mo,dy,yr,i)
    NameFiles, direction = get_filesNames(mo,dy,yr)

    cd(direction)
    fname = direction*"/"*NameFiles[i]
    fNs = h5open(fname,"r")
    
    groupF = keys(fNs)
    
    if length(groupF) == 2
        dataSm = keys(fNs[groupF[1]])
        datMeasAtr = fNs[groupF[1]*"/"*dataSm[1]]
        nameAttr = keys(attributes(datMeasAtr))
    elseif length(groupF) == 1
        datMeasAtr = fNs[groupF[1]]
        nameAttr = keys(attributes(datMeasAtr))
    end

    AttrVal = []
    
    for i ∈ eachindex(nameAttr)
        
        push!(AttrVal,read_attribute(datMeasAtr,nameAttr[i]))
    end
    close(fNs)
    hcat(nameAttr,AttrVal)
end

function getPromData(mo,dy,yr,mMult,mLock,inArr)
    data,_ = read_FileData(mo,dy,yr,inArr[1])
    ImAFM1,_ = DataAnNSOM.getDataExp(data)

    promArr = zeros(3,size(ImAFM1,1),size(ImAFM1,2))

    for i ∈ inArr
        data,_ = DataAnNSOM.read_FileData(mo,dy,yr,i);
        ImAFM,ImLock,ImMult = DataAnNSOM.getDataExp(data)
        ImAFM = correct100(ImAFM,mo,dy,yr,i)

        promArr[1,:,:] += ImAFM
        promArr[2,:,:] += ImLock
        promArr[3,:,:] += ImMult
    end
    promArr = promArr ./ length(inArr)

    promAFM,promLock,promMult = promArr[1,:,:],promArr[2,:,:],promArr[3,:,:]
    promLock,promMult = promLock.-mLock,promMult.-mMult

    promDiv = promLock./promMult

    return promAFM,promLock,promMult,promDiv
end

function getDataExp(data)
    if size(data,1) ==3
        ImAFM,ImNSOM,ImMult = data[1,:,:]/1000,data[2,:,:],-data[3,:,:]
        return  ImAFM,ImNSOM,ImMult
    elseif size(data,1) ==1
        ImAFM = data[1,:,:]/1000
        return  ImAFM
    end
end

function correct100(imAFM,mo,dy,yr,i)

    AtrM = DataAnNSOM.get_Attributes(mo,dy,yr,i)
    xBeg,xEnd = AtrM[1,2],AtrM[5,2]; yBeg,yEnd = AtrM[2,2],AtrM[6,2]   
    step=AtrM[7,2]
    Xline =  collect(xBeg:step:xEnd)
    xst = findall(Xline .== 100000)

    if ~isempty(xst)
        xst = xst[1]
        Δs = imAFM[:,xst-1]-imAFM[:,xst]
        imAFM[:,xst:end] = imAFM[:,xst:end] .+ Δs
    end
    imAFM
end

function getVibData(i)
    dirVib = "/home/martinez/Documents/dataNSOM/frec/"
    names = cd(readdir,dirVib)
    nameFil = names[i]
    dataVib = readdlm(dirVib*nameFil)

    return dataVib,nameFil
end