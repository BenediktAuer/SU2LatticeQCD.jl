using SU2LatticeQCD
using Test, Statistics
function testfunction(i,execution)
    a = SU2Simulation(2.0,4,4,4,2,0.2,execution)
    res = zeros(Float64,i)
    for j in 1:i
    simulate!(a,100)
    res[j] = measurmentloopSpacial(a,Polyakovloop,2)
    end
    mean(abs,res)
    end
    function testfunctionP(i,execution)
        a = SU2Simulation(2.0,4,4,4,2,0.2,execution)
        res = zeros(Float64,i)
        for j in 1:i
        simulate!(a,100)
        res[j] = measurmentloopSpacialP(a,Polyakovloop,2)
        end
        mean(abs,res)
        end
    @testset "parallel sweeps" begin
        # Write your tests here.
        @show Threads.nthreads()
        res = testfunction(10_000,:parallel)
        @show res
        @test  res≈0.44 atol=0.02
        # @btime testfunction(10_000)
    end
    @testset "parallel sweeps and measurment" begin
        # Write your tests here.
        res = testfunctionP(10_000,:parallel)
        @show res
        @test  res ≈0.44 atol=0.02
        # @btime testfunction(10_000)
    end
@testset "serial execution" begin
    # Write your tests here.
    res = testfunction(10_000,:serial)
    @show res
    @test  res ≈0.44 atol=0.02
    # @btime testfunction(10_000)
end