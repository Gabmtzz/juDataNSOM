using HDF5

function get_dir(mo,dy)
    direction ="/home/martinez/Documents/dataNSOM"
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

function get_filesNames(mo,dy)
    direction = get_dir(mo,dy)
    NameFiles = cd(readdir,direction)
    if ~isempty(NameFiles)
        return NameFiles,direction
    else
        error("The folder is empty")
    end
end

function read_FileData(mo,dy,ind)
    NameFiles,direction = get_filesNames(mo,dy)

    cd(direction)
    fname = direction*"/"*NameFiles[ind]
    fNs = h5open(fname,"r")

    groupF = keys(fNs)

    dataSm = keys(fNs[groupF[1]])
    datMeas = read(fNs[groupF[1]*"/"*dataSm[1]])

    dataExt = keys(fNs[groupF[2]])
    datAmp = read(fNs[groupF[2]*"/"*dataExt[1]]); datFase = read(fNs[groupF[2]*"/"*dataExt[2]]) 

    return datMeas,datAmp,datFase

end