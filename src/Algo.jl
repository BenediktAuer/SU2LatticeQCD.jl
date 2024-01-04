abstract type AbstractAlgo{T} end
struct parallel end
struct serial end
struct Algo{T} <: AbstractAlgo{T}
    func::Function
end

function _metropolisSerial!(lattice::T,β,iterator,rounds,ϵ) where T<: GaugeField
    #not sure about this one
    #TODO:change to right value
    N=2
    #first and last iteration missing
    @inbounds for i in iterator
        #calculate the staple for the given lattice site
        A = staple(lattice,i)
        for _ in 1:rounds
            #choose new Matrix
            U = lattice[i]
            U′ = newSU2(U,ϵ)
            #get Old MAtrix
            #calculate the diffrence in Action from U′,U the staple and 
            DeltaS = ΔS(U′,U,A,β,N)
            #accept or reject U′
            if judge(DeltaS) 
                #newx has to bea a copy. newSU2() makes such a copy ithink
                lattice[i] = U′
            end
        end
        lattice[i] =  renormalize(lattice[i])
    end

    return
end

#paralell implementation
function _metropolisParallel!(lattice::T,β,iterator,rounds,ϵ) where T<: GaugeField4D
    #not sure about this one
    #TODO:change to right value
    N=2
    #
    for parity in (-1,1)
    for μ in (1,2,3,4)
        ThreadsX.foreach(  Iterators.filter(x->(-1)^sum(x.I)==parity,iterator)) do i
    #calculate the staple for the given lattice site
                A = staple(lattice,CartesianIndex(i,μ))
                for _ in 1:rounds
                #choose new Matrix
                   @inbounds U = lattice[i,μ]
                    U′ = newSU2(U,ϵ)
                    #get Old MAtrix
                    #calculate the diffrence in Action from U′,U the staple and 
                    DeltaS = ΔS(U′,U,A,β,N)
                #accept or reject U′
                    #removing the dot in .= changes algo ??
                        @inbounds lattice[i,μ] = ifelse(judge(DeltaS) , U′,U)
                end
                @inbounds lattice[i,μ] =  renormalize(lattice[i,μ])
            end
           
    end
end
    # _metropolishelper!(lattice,β,iterator,rounds,ϵ,1,N)
    # _metropolishelper!(lattice,β,iterator,rounds,ϵ,-1,N)

    return
end

#measure acceptRate
function _metropolisAccepRate!(lattice::T,β,iterator,rounds,ϵ,acceptRate::AcceptMeasurment) where T<: GaugeField
    #not sure about this one
    #TODO:change to right value
    N=2
    #first and last iteration missing
    @inbounds for i in iterator
        #calculate the staple for the given lattice site
        A = staple(lattice,i)
        for _ in 1:rounds
            #choose new Matrix
            U = lattice[i]
            U′ = newSU2(U,ϵ)
            #get Old MAtrix
            #calculate the diffrence in Action from U′,U the staple and 
            DeltaS = ΔS(U′,U,A,β,N)
            #accept or reject U′
            if judge(DeltaS,acceptRate) 
                #newx has to bea a copy. newSU2() makes such a copy ithink
                lattice[i] = U′
            end
        end
        lattice[i] =  renormalize(lattice[i])
    end

    return
end
MetropolisSerial() = Algo{serial}(_metropolisSerial!)
MetropolisParallel() = Algo{parallel}(_metropolisParallel!)
MetropolisAcceptRate() = Algo{serial}(_metropolisAccepRate!)


function getIterator(::Type{T},a::SU2Simulation) where T<: AbstractAlgo{serial}
    return CartesianIndices(a.lattice)
end
function getIterator(::Type{T},a::SU2Simulation) where T<: AbstractAlgo{parallel}
    return CartesianIndices((a.lattice.Nx,a.lattice.Ny,a.lattice.Nz,a.lattice.Nt))
end