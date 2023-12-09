module SU2LatticeQCD
using EfficentSU2,LinearAlgebra,Random
import Base: size,getindex,setindex!
include("GaugeField.jl") 
struct SU2Simulation
    β::Float32
    lattice::GaugeField4D
    iterator::CartesianIndices
    Nx::Int64
    Ny::Int64
    Nz::Int64
    Nt::Int64
    ϵ::Float32
    """
    SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ)
    initialize a SU2 Simulation container 
    
    # Arguments
    `β::Float32`: inverse temperature, or equivallently ``a⋅Nt=β`` where `a` is the Lattice spacing
    `Ni::Int64`: Size of the lattice in direction `i`
    `Nt::Int64`: Size of the lattice in the temporal direction
    `ϵ::Float32`: Parameter to adjust the acceptance rate of the Metropolisalgorithem
    ...
    TBW
    """
    function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ)
        lattice = GaugeField4D(Nx,Ny,Nz,Nt)
        iterator = CartesianIndices(lattice)
        return new(β,lattice,iterator,Nx,Ny,Nz,Nt,ϵ)
    end
end
function simulate!(a::SU2Simulation,rounds::T) where T<:Integer
    @inline metropolis!(a.:lattice,a.:β,a.:iterator,rounds,a.:ϵ)
    
end
# Write your package code here.
include("periodic.jl")
include("Metropolis.jl")
include("stapels.jl")
include("RandomSU2.jl")
export GaugeField2D,getDirectionalIndex,SU2Simulation, simulate!
end
