function Polyakovloop(lattice,x,Nt)
    return 1/2*tr(prod(lattice[getDirectionalIndex(x,4,4,k)] for k in 0:(Nt-1)))
    #getDirectionalIndex(CartesianIndex(1,1,1,1,1),4,4,k) for k in 0:3
    #TODO: Anpassen an neue getDirectionalIndex function
end

function PolyakovloopSquared(lattice,x,Nt)
    product = prod(lattice[getDirectionalIndex(x,4,4,k)] for k in 0:(Nt-1))
    return 1/2*tr(product*product)
    #getDirectionalIndex(CartesianIndex(1,1,1,1,1),4,4,k) for k in 0:3
    #TODO: Anpassen an neue getDirectionalIndex function
end


 """
    measurmentloopSpacial(array,a,func,vargs...)
calculates the mean of the observable `func` over the spacial components of the lattice.
`vargs` are the extra arguments of `func`.
The only implemented function `func` is `Polyakovloop`.

"""
# measurmentloopSpacial(a,func,vargs...) = _measurmentloopSpacial(a.:lattice,func,vargs...)
# function _measurmentloopSpacial(lattice,func,vargs...)
#     iter =CartesianIndices((axes(lattice,1),axes(lattice,2),axes(lattice,3),1,1))
#     array =zeros(Float64,length(iter))
#     for (i,cartidx) in enumerate(iter)
#         array[i] = func(lattice,cartidx,vargs...)
#     end
#     return mean(array)
# end
measurmentloopSpacial(a,func,vargs...) = _measurmentloopSpacial(a.:lattice,func,vargs...)
function _measurmentloopSpacial(lattice,func,vargs...)
    iter =CartesianIndices((axes(lattice,1),axes(lattice,2),axes(lattice,3),1,1))
    abs(ThreadsX.sum(func(lattice,cartidx,vargs...) for cartidx in iter)/length(iter))
end
measurmentloopSpacial2(a,func,vargs...) = _measurmentloopSpacial2(a.:lattice,func,vargs...)
function _measurmentloopSpacial2(lattice,func,vargs...)
    iter =CartesianIndices((axes(lattice,1),axes(lattice,2),axes(lattice,3),1,1))
    abs2(ThreadsX.sum(func(lattice,cartidx,vargs...) for cartidx in iter)/length(iter))

end