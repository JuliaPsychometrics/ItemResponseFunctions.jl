using BenchmarkTools
using ItemResponseFunctions

const SUITE = BenchmarkGroup()

models = [OnePL, TwoPL, ThreePL, FourPL, FivePL, PCM, GPCM, RSM, GRSM]

function make_pars(; nthresholds = 3)
    a = rand() * 2
    b = randn()
    c = rand() * 0.5
    d = rand() * 0.5 + 0.5
    e = 1 + rand() * 0.5
    t = randn(nthresholds)
    return (; a, b, c, d, e, t)
end

for model in models
    m = string(model)
    SUITE[m] = BenchmarkGroup()

    SUITE[m]["irf"] = @benchmarkable(
        irf($model, theta, beta, $1),
        evals = 10,
        samples = 1000,
        setup = (theta = randn(); beta = make_pars())
    )

    SUITE[m]["iif"] = @benchmarkable(
        iif($model, theta, beta, $1),
        evals = 10,
        samples = 1000,
        setup = (theta = randn(); beta = make_pars())
    )

    SUITE[m]["expected_score"] = @benchmarkable(
        expected_score($model, theta, betas),
        evals = 10,
        samples = 1000,
        setup = (theta = randn(); betas = [make_pars() for _ in 1:20])
    )

    SUITE[m]["information"] = @benchmarkable(
        information($model, theta, betas),
        evals = 10,
        samples = 1000,
        setup = (theta = randn(); betas = [make_pars() for _ in 1:20])
    )
end
