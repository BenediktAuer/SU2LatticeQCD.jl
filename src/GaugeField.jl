abstract type GaugeField{T,N}<:AbstractArray{T,N} end

struct GaugeField4D<:GaugeField{SU2{ComplexF32},4}
    U::Array{SU2{ComplexF32},5}
    Nx::Int64
    Ny::Int64
    Nz::Int64
    Nt::Int64
    Volume::Int64
    function GaugeField4D(Nx,Ny,Nz,Nt)
        U = ones(SU2{ComplexF32},(Nx,Ny,Nz,Nt,4))
        return new(U,Nx,Ny,Nz,Nt,Nx*Ny*Nz*Nt)
    end
end
struct GaugeField2D<:GaugeField{SU2{ComplexF32},2}
    U::Array{SU2{ComplexF32},3}
    Nx::Int64
    Nt::Int64
    Volume::Int64
  
    @doc  """
    GaugeField2D(Nx,Nt)
    returns a GaugeField with Dimension 2. The underlaying Matrix has the shape (Nx,Nt,μ)    
    GaugeField is periodic 
"""
function GaugeField2D(Nx,Nt)
        U = ones(SU2{ComplexF32},(Nx,Nt,2))
        return new(U,Nx,Nt,Nx*Nt)
    end
end
Base.size(a::I) where I<:GaugeField = @inline Base.size(a.U)
Base.length(a::I) where I<:GaugeField = @inline Base.length(a.U)
Base.IndexStyle(a::I) where I<:GaugeField = @inline Base.IndexStyle(a.U)
Base.getindex(a::I,i::T) where {I<:GaugeField,T<:Integer} = @inline @inbounds getindex(a.U,((i-1)%Base.length(a.U))+1)
Base.getindex(a::I,i::T)  where {I<:GaugeField,T<:CartesianIndex} =  @inline @inbounds getindex(a.U, mod.(i.I, axes(a.U))...)
#TODO: Change key to mod.(i.I, axes(a.U))... for periodic boundary conditions
Base.setindex!(collection::I,value,key) where I<:GaugeField =  @inline Base.setindex!(collection.U,value,key)
