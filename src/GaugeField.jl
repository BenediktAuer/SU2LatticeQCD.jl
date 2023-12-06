abstract type GaugeField{T,N}<:AbstractArray{T,N} end

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
        U = ones(SU2{ComplexF32},(Nt,Nx,2))
        print(U)
        return new(U,Nt,Nx,Nx*Nt)
    end
end
Base.size(a::I) where I<:GaugeField = @inline Base.size(a.U)
Base.IndexStyle(a::I) where I<:GaugeField = @inline Base.IndexStyle(a.U)

Base.getindex(a::I,i)  where {I<:GaugeField} =  @inline @inbounds getindex(a.U, mod.(i.I, axes(a.U))...)
#TODO: Change key to mod.(i.I, axes(a.U))... for periodic boundary conditions
Base.setindex!(collection::I,value,key) where I<:GaugeField =  @inline Base.setindex!(collection.U,value,key)
