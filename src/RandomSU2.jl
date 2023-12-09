function newSU2(U,ϵ)
    X = get_randomSU2(ϵ)
    return X*U
end
function get_randomSU2(ϵ)
    #distance = 1/2--1/2 gives interval -1/2 to 1/2
    r = getRandUniformly(Float32,1,4)
    r24 = view(r,2:4)
    r24 .*= ϵ/norm(r24)
     r[1] = sign(r[1])*sqrt(1-ϵ^2)
     return SU2(r[1]+r[4]*im,r[3]+r[2]*im)

end
"""
    get_randomSU2!(R,ϵ)
     generating of a random SU2 Matrix, the RandomNumbers are inplace generated
TBW
"""
function get_randomSU2!(R,ϵ)
    #distance = 1/2--1/2 gives interval -1/2 to 1/2
    getRandUniformly!(R,1)
         R .= R./norm(R)
     R[1] = sign(R[1])*sqrt(1-ϵ^2)/ϵ 
          R .= R.* ϵ
     return SU2(R[1]+R[4]*im,R[3]+R[2]*im)

end
"""
    getRandUniformly(::Type{T},distance,nums::Int64) where T
    returns `nums` RAndomNumbers Uniformly in the Intervall 0-distance to 0+distance 
TBW
"""
function getRandUniformly(::Type{T},distance,nums::Int64) where T
    rand(T,nums)./distance .-T(distance/2)
end

function getRandUniformly!(x::T,distance) where {N<:Number,T<:Array{N}}
    rand!(x)
    x.= x ./distance .-distance/2
end