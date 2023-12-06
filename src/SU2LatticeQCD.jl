module SU2LatticeQCD
using EfficentSU2
import Base: size,getindex,setindex!
# Write your package code here.
include("GaugeField.jl")
include("periodic.jl")
include("Metropolis.jl")
export GaugeField2D,apply_periodic_boundary_conditions,getindexPeriodic
end
