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
    ϵ::Float64
    function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ)
        lattice = GaugeField4D(Nx,Ny,Nz,Nt)
        iterator = CartesianIndices(lattice)
        return new(β,lattice,iterator,Nx,Ny,Nz,Nt,ϵ)
    end
end
function simulate!(a::SU2Simulation,rounds)
    @inline metropolis!(a.:lattice,a.:β,a.:iterator,rounds,a.:ϵ)
    
end
# Write your package code here.
include("periodic.jl")
include("Metropolis.jl")
include("stapels.jl")
include("RandomSU2.jl")
export GaugeField2D,getDirectionalIndex,SU2Simulation, simulate!
end
