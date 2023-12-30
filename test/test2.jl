using SU2LatticeQCD, Plots, Statistics,ProgressMeter
@show "starting" 
iter = 1:0.1:2.8
array = zeros(Float64,10_000)
results = zeros(Float64,length(iter))
@show Threads.nthreads()
@showprogress for (j,β) in enumerate(iter)
    sim = SU2Simulation(β,32,32,32,4,0.2,:parallel)
     for i in 1:10_000
        simulate!(sim,1)
        array[i] = measurmentloopSpacial(sim,Polyakovloop,2)
    end
    results[j] = mean(abs,array)
end
display(scatter(iter,results,ylim=(0,0.8)))