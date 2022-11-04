@testset "test Open Files" begin
    @testset "Obtain the dir String" begin
        direction = DataAnNSOM.get_dir(10,12)
        @test typeof(direction) == String

    end

    @testset "Folder does no exist" begin
        @test_throws ErrorException direction = DataAnNSOM.get_dir(10,22)
    end

    @testset "Get the filenames" begin
        FilesN,_ = DataAnNSOM.get_filesNames(10,12)
        @test ~isempty(FilesN)
    end

    @testset "Get data" begin
        data,_ = DataAnNSOM.read_FileData(10,12,1)
        @test typeof(data) == Array{Float64,3}
    end
end