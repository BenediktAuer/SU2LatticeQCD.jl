function save(path, a)
    open(path, "w") do file
        println(file,"Dims"," ", a.:Nx," ", a.:Ny," ", a.:Nz," ", a.:Nt)
        println(file,"β", " ", a.:β[])
        println(file,"ϵ", " ", a.:ϵ[])
        println(file,"RNGState: ", " ", copy(Random.default_rng()))
        for i in eachindex(a.:lattice)
            println(file,convert(SU2{ComplexF64},a.:lattice[i]))
        end
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
        rng = split(readline(file))
        println(rng[2])
        state= parse.(UInt64,split(join(rng[2:end]),('(',',',')'))[2:5])
        println(state)
        if occursin("Xoshiro",rng[2]) == true
            copy!(Random.default_rng(),Xoshiro(state...))
        else
            throw(DomainError("The used Numbergenerator is not supported!"))
        end
        for i in eachindex(a.:lattice)
            
            a.:lattice[i].=parse.(ComplexF32, split(readline(file),('[',',', ']'))[2:3])
        end
        #
    end
end