module SU2LatticeQCD
using EfficentSU2,LinearAlgebra,Random,Statistics
import Base: size,getindex,setindex!,show
include("GaugeField.jl") 
struct SU2Simulation{T<:GaugeField}
    β::Base.RefValue{Float32}
    lattice::T
    iterator::CartesianIndices
    Nx::Int64
    Ny::Int64
    Nz::Int64
    Nt::Int64
    ϵ::Base.RefValue{Float32}
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
    function SU2Simulation(::Type{T},β,Nx,Ny,Nz,Nt,ϵ) where T<:GaugeField
        lattice = T(Nx,Ny,Nz,Nt)
        iterator = getIterator((lattice))
        return new{T}(Ref(Float32(β)),lattice,iterator,Nx,Ny,Nz,Nt,Ref(Float32(ϵ)))
    end
end
function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ,execution::Symbol)
    if execution == :parallel
        return SU2Simulation(GaugeField4DP,β,Nx,Ny,Nz,Nt,ϵ)
    end
    if execution ==:serial
        return SU2Simulation(GaugeField4D,β,Nx,Ny,Nz,Nt,ϵ)
    end
    @assert false "Cant execute in $(execution) ! Use `:serial` for an serial evaluation or `:parallel` for an parallel execution"  

end
function getIterator(lattice ::T) where T<: GaugeField4D
    return CartesianIndices(lattice)
end
function getIterator(lattice::T) where T<: GaugeField4DP
    return CartesianIndices((lattice.:Nx,lattice.:Ny,lattice.:Nz,lattice.:Nt))
end
function simulate!(a::SU2Simulation,rounds::T) where T<:Integer
    @inline metropolis!(a.:lattice,a.:β[],a.:iterator,rounds,a.:ϵ[])
    
end
function Base.show(io::IO, ::MIME"text/plain", a::SU2Simulation) 
    println(io, "T=",a.:β[])
    println(io, "N",a.:Nx,"×",a.:Ny,"×",a.:Nz,"×",a.:Nt,)
    println(io, "ϵ=",a.:ϵ[])
    println(io,typeof(a.:lattice))
    println(io,a.:lattice)
end

# Write your package code here.
include("periodic.jl")
include("Metropolis.jl")
include("stapels.jl")
include("RandomSU2.jl")
include("IO.jl")
include("measurments.jl")
export SU2Simulation, simulate!,save,loadConfig!,measurmentloopSpacial,Polyakovloop
end
