module SU2LatticeQCD
using EfficentSU2,LinearAlgebra,Random,Statistics,ThreadsX, StaticArrays
import Base: size,getindex,setindex!,show
include("GaugeField.jl") 
include("Acceptens.jl")

struct SU2Simulation{T<:GaugeField}
    β::Base.RefValue{Float32}
    lattice::T
    Nx::Int64
    Ny::Int64
    Nz::Int64
    Nt::Int64
    ϵ::Base.RefValue{Float32}
    acceptRate::AcceptMeasurment
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
    # function SU2Simulation(::Type{T},β,Nx,Ny,Nz,Nt,ϵ) where T<:GaugeField
    #     lattice = T(Nx,Ny,Nz,Nt)
    #     iterator = getIterator((lattice))
    #     return new{T}(Ref(Float32(β)),lattice,iterator,Nx,Ny,Nz,Nt,Ref(Float32(ϵ)))
    # end
        function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ)
            lattice = GaugeField4D(Nx,Ny,Nz,Nt)
            return new{GaugeField4D}(Ref(Float32(β)),lattice,Nx,Ny,Nz,Nt,Ref(Float32(ϵ)),AcceptMeasurment())
        end
        
end

# function SU2Simulation(β,Nx,Ny,Nz,Nt,ϵ,execution::Symbol)
    
#     if execution == :parallel
#         return SU2Simulation(GaugeField4DP,β,Nx,Ny,Nz,Nt,ϵ)
#     end
#     if execution ==:serial
#         return SU2Simulation(GaugeField4D,β,Nx,Ny,Nz,Nt,ϵ)
#     end
#     @assert false "Cant execute in $(execution) ! Use `:serial` for an serial evaluation or `:parallel` for an parallel execution"  

# end

# function simulate!(a::SU2Simulation,rounds::T) where T<:Integer
#     @inline metropolis!(a.:lattice,a.:β[],a.:iterator,rounds,a.:ϵ[])
    
# end
include("Algo.jl")

function simulate!(a::K,sweeps::T,rounds::T, algo::N) where {K<:SU2Simulation,T<:Integer,N<:AbstractAlgo}
    iterator = getIterator(N,a)
    func =algo.func
    for _ in 1:sweeps

    @inline func(a.:lattice,a.:β[],iterator,rounds,a.:ϵ[],a.acceptRate)::Nothing
    end
    
end
function simulate!(a::K,sweeps::T,rounds::T, algo::N, measurment::Function, args...) where {K<:SU2Simulation,T<:Integer,N<:AbstractAlgo}
    iterator = getIterator(N,a)
    func = algo.func
    res= zeros(sweeps)
    for i in 1:sweeps
     @inline func(a.:lattice,a.:β[],iterator,rounds,a.:ϵ[])::Nothing
     @inbounds res[i] = measurmentloopSpacial(a,measurment,args...)
    end
    return res
end

function Base.show(io::IO, ::MIME"text/plain", a::SU2Simulation) 
    println(io, "T=",a.:β[])
    println(io, "N",a.:Nx,"×",a.:Ny,"×",a.:Nz,"×",a.:Nt,)
    println(io, "ϵ=",a.:ϵ[])
    println(io,typeof(a.:lattice))
    println(io,a.:lattice)
end

# Write your package code here.

include("AcceptensUtil.jl")
include("periodic.jl")
include("MetropolisUtils.jl")
include("stapels.jl")
include("RandomSU2.jl")
include("IO.jl")
include("measurments.jl")
export SU2Simulation, simulate!,save,loadConfig!,measurmentloopSpacial,Polyakovloop,measurmentloopSpacialP,AcceptMeasurment,resetAcceptMeasurment,getAcceptRate,MetropolisSerial,MetropolisParallel,MetropolisAcceptRate
end
