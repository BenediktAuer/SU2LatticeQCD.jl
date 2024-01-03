mutable struct AcceptMeasurment{T<:Integer}
    samples::T
    accepted_negative::T
    accepted_exponential::T

    function AcceptMeasurment()
        return new{Int64}(0,0,0)
    end

end
getAcceptRate(a::K) where {K<:SU2Simulation{<:GaugeField,AcceptMeasurment}} = getAcceptRate(a.:acceptRate)
function getAcceptRate(a::AcceptMeasurment)
    return (a.:accepted_negative+a.:accepted_exponential)/a.:samples
end
function resetAcceptMeasurment(a::AcceptMeasurment)
    a.:accepted_negative =0
    a.:accepted_exponential =0
    a.:samples =0
end


function metropolis!(lattice::T,β,iterator,rounds,ϵ,acceptRate::AcceptMeasurment) where T<: GaugeField
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
function judge(ΔS,acceptRate::AcceptMeasurment)
    acceptRate.samples +=1
    if ΔS ≤ 0
        acceptRate.accepted_negative +=1
        return true
    end
    if  (rand(Float64) < exp(-ΔS))
        acceptRate.accepted_exponential +=1
        return true
    end
    return false

end
