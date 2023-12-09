function staple(lattice,i)
    μ = i.I[end]
    iterator = Iterators.filter(x->x!=μ,1:4)
    staple = sum( lattice[getDirectionalIndex(i,μ,ν)] *lattice[getDirectionalIndex(i,ν,μ)]'*lattice[getDirectionalIndex(i,0,ν)]' +lattice[getDirectionalIndex(i,μ-ν,ν)]'*lattice[getDirectionalIndex(i,-ν,μ)]'*lattice[getDirectionalIndex(i,-ν,ν)] for ν in iterator)
end

"""
    getDirectionalIndex(i::CartesianIndex,μ)
    returns the Index in diection μ at ν,i.e ``U_\\nu(x+\\mu)``

"""
function getDirectionalIndex(i::CartesianIndex,μ,ν)
    sign = sign(μ)
    return i+sign*(μ==1||μ==-1)*CartesianIndex(1,0,0,0,0)+sign*(μ==2||μ==-2)*CartesianIndex(0,1,0,0,0)+sign*(μ==3||μ==-3)*CartesianIndex(0,0,1,0,0)+sign*(μ==4||μ==-4)*CartesianIndex(0,0,0,1,0)-CartesianIndex(0,0,0,0,i.I[end]-ν)
end
