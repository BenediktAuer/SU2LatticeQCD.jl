using SU2LatticeQCD
using  Statistics, BenchmarkTools
Threads.nthreads()

function testfunction(i,execution)
    a = SU2Simulation(2.0,4,4,4,2,0.2,execution)
    res = zeros(Float64,i)
    for i in 1:i
    simulate!(a,100)
    res[i] = measurmentloopSpacialP(a,Polyakovloop,2)
    end
    mean(abs,res)
end

 testfunction(10_000,:parallel)
isapprox(a, 0.44, atol=0.02)