using BenchmarkTools
using ItemResponseFunctions

SUITE["OnePL"] = BenchmarkGroup()

SUITE["OnePL"]["irf"] = @benchmarkable(
    irf(OnePL, theta, beta, $1),
    evals = 10,
    samples = 1000,
    setup = (theta = randn(), beta = ItemParameters(OnePL, b = randn()))
)
