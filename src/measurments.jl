function Polyakovloop(lattice,x,Nt)
    return tr(prod(lattice[getDirectionalIndex(x,4,4,k)] for k in 0:(Nt-1)))
    #getDirectionalIndex(CartesianIndex(1,1,1,1,1),4,4,k) for k in 0:3
end

 measurmentloop!(array,a,func,vargs...) = _measurmentloop(array,a.:lattice,func,vargs...)
function _measurmentloop(array,lattice,func,vargs...)
    zero(Float64,length())
    for (i,cartidx) in enumerate(CartesianIndices((axes(lattice,1),axes(lattice,2),axes(lattice,3),1,1)))
        array[i] = func(lattice,cartidx,vargs...)
    end
end