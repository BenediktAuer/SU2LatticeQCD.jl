using SU2LatticeQCD
using  Statistics, BenchmarkTools
Threads.nthreads()

function testfunction(i,execution)
    a = SU2Simulation(2.0,4,4,4,2,0.2,execution)
    res = zeros(Float64,i)
    for j in 1:i
    simulate!(a,100)
    res[j] = measurmentloopSpacial(a,Polyakovloop,2)
    end
    mean(abs,res)
    end

 @benchmark  testfunction(10_000,:parallel)
