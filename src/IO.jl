function save(path, a)
    open(path, "w") do file
        println(file,"Dims"," ", a.:Nx," ", a.:Ny," ", a.:Nz," ", a.:Nt)
        println(file,"β", " ", a.:β[])
        println(file,"ϵ", " ", a.:ϵ[])
    end
end

function loadConfig!(a,path)
    open(path,"r") do file
        dims = parse.(Int64,split(readline(file))[2:end])
        (dims[1]==a.:Nx)||(dims[2]==a.:Ny)||(dims[3]==a.:Nz)||(dims[4]==a.:Nt)||throw(DimensionMismatch("The Dimension of the given Simulation dont match the Dimension from the saved Simulation"))
        β= parse(Float32,split(readline(file))[2])
        a.:β[]=β
        println("Set β to $(β)!")
        ϵ= parse(Float32,split(readline(file))[2])
        a.:ϵ[] = ϵ
        println("Set ϵ to $(ϵ)!")
    end
end