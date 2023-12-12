function Polyakovloop(x,Nt,lattice)
    return tr(prod(lattice[getDirectionalIndex(x,4,4,k)] for k in 0:(Nt-1)))
    #getDirectionalIndex(CartesianIndex(1,1,1,1,1),4,4,k) for k in 0:3
end