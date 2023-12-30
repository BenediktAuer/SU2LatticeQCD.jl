
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
                        @inbounds lattice[i,μ] .= ifelse(judge(DeltaS) , U′,U)
                end
                renormalize!(lattice[i,μ])
            end
           
    end
end
    # _metropolishelper!(lattice,β,iterator,rounds,ϵ,1,N)
    # _metropolishelper!(lattice,β,iterator,rounds,ϵ,-1,N)

    return
end
function _metropolishelper!(lattice::T,β,iterator,rounds,ϵ,parity,N) where T<: GaugeField4DP
    
    for μ in [1,2,3,4]
        
        ThreadsX.foreach(  Iterators.filter(x->(-1)^sum(x.I)==parity,iterator)) do i
    #calculate the staple for the given lattice site
                idx =CartesianIndex(i,μ)
                A = staple(lattice,idx)
                for _ in 1:rounds
                #choose new Matrix
                   @inbounds U = lattice[idx]
                    U′ = newSU2(U,ϵ)
                    #get Old MAtrix
                    #calculate the diffrence in Action from U′,U the staple and 
                    DeltaS = ΔS(U′,U,A,β,N)
                #accept or reject U′
                    #removing the dot in .= changes algo ??
                        @inbounds lattice[idx] .= ifelse(judge(DeltaS) , U′,U)
                end
                renormalize!(lattice[idx])
            end
           
    end
end

#TODO: Maybe as inplace variant 
@inline function ΔS(U′,U,A,β,N=2)
    diff= (U′-U)
    temp = diff*A
    return -β/N*tr(temp)
end