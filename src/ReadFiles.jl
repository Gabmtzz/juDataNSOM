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

    dataSm = keys(fNs[groupF[1]])
    datMeas = read(fNs[groupF[1]*"/"*dataSm[1]])

    dataExt = keys(fNs[groupF[2]])
    datAmp = read(fNs[groupF[2]*"/"*dataExt[1]]); datFase = read(fNs[groupF[2]*"/"*dataExt[2]]) 

    return datMeas,transpose(datAmp),transpose(datFase)

end

function get_Attributes(mo,dy,yr,i)
    NameFiles, direction = get_filesNames(mo,dy,yr)

    cd(direction)
    fname = direction*"/"*NameFiles[i]
    fNs = h5open(fname,"r")
    
    groupF = keys(fNs)
    dataSm = keys(fNs[groupF[1]])
    datMeasAtr = fNs[groupF[1]*"/"*dataSm[1]]
    nameAttr = keys(attributes(datMeasAtr))
    AttrVal = []
    
    for i ∈ eachindex(nameAttr)
        
        push!(AttrVal,read_attribute(datMeasAtr,nameAttr[i]))
    end
    
    hcat(nameAttr,AttrVal)
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

function getVibData(i)
    dirVib = "/home/martinez/Documents/frec/archivos/"
    names = cd(readdir,dirVib)
    nameFil = names[i]
    dataVib = readdlm(dirVib*nameFil)

    return dataVib,nameFil
end