using SU2LatticeQCD
using Test, Statistics

    @testset "parallel sweeps" begin
        # Write your tests here.
        a = SU2Simulation(2.0,4,4,4,2,0.2)
        @show Threads.nthreads()
        res = mean(abs,simulate!(a,10_000,100, MetropolisParallel(), Polyakovloop, 2))
        @show res
        @test  res≈0.44 atol=0.02
        # @btime testfunction(10_000)
    end
@testset "serial execution" begin
    # Write your tests here.
    a = SU2Simulation(2.0,4,4,4,2,0.2)
    res = mean(abs,simulate!(a,10_000,100, MetropolisSerial(), Polyakovloop, 2))
    @show res
    
    @test  res ≈0.44 atol=0.02
    # @btime testfunction(10_000)
end
@testset "performance Test" begin
    a = SU2Simulation(2.0,4,4,4,2,0.2)
    res = simulate!(a,10_000,100, MetropolisParallel(), Polyakovloop, 2)

    @show mean(abs,res)
    time =@elapsed simulate!(a,10_000,100, MetropolisParallel(), Polyakovloop, 2)
    @show time
    @test time ≈ 8.908902 atol=0.5
end
@testset "Acceptrate" begin
    a = SU2Simulation(2.0,4,4,4,2,0.2)
    simulate!(a,10,10, MetropolisAcceptRate())
    println(getAcceptRate(a))
end
