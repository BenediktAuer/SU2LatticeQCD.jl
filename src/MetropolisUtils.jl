
function judge(ΔS)
    return (ΔS ≤ 0) || (rand(Float64) < exp(-ΔS))
end

@inline function ΔS(U′,U,A,β,N=2)
    diff= (U′-U)
    temp = diff*A
    return -β/N*tr(temp)
end