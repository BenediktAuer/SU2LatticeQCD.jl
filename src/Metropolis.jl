
function judge(ΔS)
    return (ΔS ≤ 0) || (rand(Float64) < exp(-ΔS))
end

function metropolis!(lattice,β,rounds)

    Δ=2*sqrt(a)
    #first and last iteration missing
    for i in eachindex(lattice)
        #calculate the staple for the given lattice site
        A = staple(lattice,i)
        for j in 1:rounds
            #choose new Matrix
            U′ = newSU2(ϵ)
            #get Old MAtrix
            U = lattice[i]
            #calculate the diffrence in Action from U′,U the staple and 
            DeltaS = ΔS(U′,U,A,β,N)
            #accept or reject U′
            if judge(DeltaS) 
                lattice[i] = newx
            end
        end
    end

    return
end
#TODO: Maybe as inplace variant 
function ΔS(U′,U,A,β,N=2)
    return -β/N*tr((U′-U)*A)
end