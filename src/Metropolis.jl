
function judge(ΔS)
    return (ΔS ≤ 0) || (rand(Float64) < exp(-ΔS))
end

function metropolis!(lattice::T,β,iterator,rounds,ϵ) where T<: GaugeField
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
                lattice[i] .= U′
            end
        end
        renormalize!(lattice[i])
    end

    return
end
#paralell implementation
function metropolis!(lattice::T,β,iterator,rounds,ϵ) where T<: GaugeField4DP
    #not sure about this one
    #TODO:change to right value
    N=2
    #
    for parity in [-1,1]
        for μ in [1,2,3,4]
            @tturbo for i in Iterators.filter(x->(-1)^sum(x.I)==parity,indices)
        #calculate the staple for the given lattice site
            A = staple(lattice,CartesianIndex(i,μ))
            for _ in 1:rounds
            #choose new Matrix
                U = lattice[i,μ]
                U′ = newSU2(U,ϵ)
                #get Old MAtrix
                #calculate the diffrence in Action from U′,U the staple and 
                DeltaS = ΔS(U′,U,A,β,N)
            #accept or reject U′
                if judge(DeltaS) 
                #newx has to bea a copy. newSU2() makes such a copy ithink
                    lattice[i,μ] .= U′
                end
            end
            renormalize!(lattice[i,μ])
        end
    end

    return
end
#TODO: Maybe as inplace variant 
function ΔS(U′,U,A,β,N=2)
    diff= (U′-U)
    temp = diff*A
    return -β/N*tr(temp)
end