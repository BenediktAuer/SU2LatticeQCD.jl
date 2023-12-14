function staple(lattice,i)
    μ = i.I[end]
    iterator = Iterators.filter(x->x!=μ,1:4)
    #staple = sum( lattice[getDirectionalIndex(i,μ,ν)] *lattice[getDirectionalIndex(i,ν,μ)]'*lattice[getDirectionalIndex(i,0,ν)]' +lattice[getDirectionalIndex(i,μ-ν,ν)]'*lattice[getDirectionalIndex(i,-ν,μ)]'*lattice[getDirectionalIndex(i,-ν,ν)] for ν in iterator)
    #[((SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),μ,ν)  , SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),ν,μ) , SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),0,ν))  ,( SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),μ-ν,ν) , SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),-ν,μ) , SU2LatticeQCD.getDirectionalIndex(CartesianIndex(1,1,1,1,1),-ν,ν)))  for ν in iterator]
    #TODO: getDirectionalIndex just for the addition to index i, new:
    staple = sum( lattice[i+getDirectionalUnitvector(μ)+getNu(i,ν)]*(lattice[i+getDirectionalUnitvector(ν)+getNu(i,μ)])'*(lattice[i+getDirectionalUnitvector(0)+getNu(i,ν)]')+(lattice[i+getDirectionalUnitvector(μ)+getDirectionalUnitvector(ν,-1)+getNu(i,ν)])'*(lattice[i+getDirectionalUnitvector(ν,-1)+getNu(i,μ)]')*lattice[i+getDirectionalUnitvector(ν,-1)+getNu(i,ν)] for ν in iterator)
    # staple = [((CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(μ)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν)  , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),μ) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(0)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν)) ,( CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(μ)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),μ) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν,)))  for ν in iterator]
end

"""
    getDirectionalIndex(i::CartesianIndex,μ)
    returns the Index in diection μ at ν,i.e ``U \\_nu (x+\\mu)``

"""
# function getDirectionalIndex(i::CartesianIndex,μ,ν,mul=1)
#     #TODO anstatt sign use multiplicity
#     signofμ = sign(μ)
#     return i+mul*signofμ*(μ==1||μ==-1)*CartesianIndex(1,0,0,0,0)+mul*signofμ*(μ==2||μ==-2)*CartesianIndex(0,1,0,0,0)+mul*signofμ*(μ==3||μ==-3)*CartesianIndex(0,0,1,0,0)+mul*signofμ*(μ==4||μ==-4)*CartesianIndex(0,0,0,1,0)-CartesianIndex(0,0,0,0,i.I[end]-ν)
# end
@inline function getNu(i::CartesianIndex,ν)
    return -CartesianIndex(0,0,0,0,i.I[end]-ν)
end
@inline function getDirectionalUnitvector(μ,mul=1)
    mul*((μ==1)*CartesianIndex(1,0,0,0,0)+(μ==2)*CartesianIndex(0,1,0,0,0)+(μ==3)*CartesianIndex(0,0,1,0,0)+(μ==4)*CartesianIndex(0,0,0,1,0))
    
end
#Proposal shold be right
# [((CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(μ)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν)  , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),μ) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(0)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν)) ,( CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(μ)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),μ) , CartesianIndex(1,1,1,1,1)+SU2LatticeQCD.getDirectionalUnitvector(ν,-1)+SU2LatticeQCD.getNu(CartesianIndex(1,1,1,1,1),ν,)))  for ν in iterator]