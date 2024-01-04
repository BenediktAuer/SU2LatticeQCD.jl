mutable struct AcceptMeasurment{T<:Integer}
    samples::T
    accepted_negative::T
    accepted_exponential::T

    function AcceptMeasurment()
        return new{Int64}(0,0,0)
    end

end
function getAcceptRate(a::AcceptMeasurment)
    return (a.:accepted_negative+a.:accepted_exponential)/a.:samples
end
function resetAcceptMeasurment(a::AcceptMeasurment)
    a.:accepted_negative =0
    a.:accepted_exponential =0
    a.:samples =0
end
