#Not needed
function apply_periodic_boundary_conditions(index::CartesianIndex, dimensions::NTuple{N, Int}) where N
    new_indices = CartesianIndex(ntuple(i -> mod(index[i] - 1, dimensions[i]) + 1, N))
    return new_indices
end