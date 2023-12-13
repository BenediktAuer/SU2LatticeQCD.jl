module SU2LatticeQCD
using EfficentSU2,LinearAlgebra,Random,Statistics
import Base: size,getindex,setindex!,show
include("GaugeField.jl") 
struct SU2Simulation
    β::Base.RefValue{Float32}
    lattice::GaugeField4D
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
    function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ)
        lattice = GaugeField4D(Nx,Ny,Nz,Nt)
        iterator = CartesianIndices(lattice)
        return new(Ref(Float32(β)),lattice,iterator,Nx,Ny,Nz,Nt,Ref(Float32(ϵ)))
    end
end
function simulate!(a::SU2Simulation,rounds::T) where T<:Integer
    @inline metropolis!(a.:lattice,a.:β[],a.:iterator,rounds,a.:ϵ[])
    
end
function Base.show(io::IO, ::MIME"text/plain", a::SU2Simulation) 
    println(io, "T=",a.:β[])
    println(io, "N",a.:Nx,"×",a.:Ny,"×",a.:Nz,"×",a.:Nt,)
    println(io, "ϵ=",a.:ϵ[])
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
