using SU2LatticeQCD,BenchmarkTools
a = SU2Simulation(5.0f0,4,4,4,2,0.1)

simulate!(a,1)
print(a)
pf = open("test.txt","w")
for i in eachindex(a.:lattice)
    print(pf,i)
    print(pf,"  ")
    println(pf,a.:lattice[i])
end
close(pf)
@benchmark simulate!($a,$100)