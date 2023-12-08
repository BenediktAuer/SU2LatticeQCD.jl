module SU2LatticeQCD
using EfficentSU2
import Base: size,getindex,setindex!
struct SU2Simulation{N,T<:GaugeField{SU2{ComplexF32},N}}
    β::Float32
    lattice::T
    iterator::CartesianIndices
    Nx::Int64
    Ny::Int64
    Nz::Int64
    Nt::Int64
    
end

# Write your package code here.
include("GaugeField.jl")
include("periodic.jl")
include("Metropolis.jl")
include("stapels.jl")
export GaugeField2D,getDirectionalIndex
end
