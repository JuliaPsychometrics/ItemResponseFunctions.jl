using Supposition
using Supposition.Data

# generators
T = Float64
floatgen = Data.Floats{T}(nans = false, infs = true)
positivefloatgen = Data.Floats{T}(nans = false, infs = true, minimum = 0)
unitfloatgen = Data.Floats{T}(nans = false, minimum = 0, maximum = 1)
asymptotegen = map(sort, Data.Vectors(unitfloatgen, min_size = 2, max_size = 2))
thresholdgen = Data.Vectors(floatgen, min_size = 1, max_size = 10)

itempargen = @composed function generate_item_pars(
    a = positivefloatgen,
    b = floatgen,
    cd = asymptotegen,
    e = positivefloatgen,
    t = thresholdgen,
)
    c = cd[1]
    d = cd[2]
    return (; a, b, c, d, e, t = Tuple(t))
end

testgen = Data.Vectors(itempargen, min_size = 1, max_size = 10)

# properties
function irf_is_monotone(M, theta, pars, delta)
    beta = ItemParameters(M, pars)
    x = irf(M, theta, beta, 1)
    y = irf(M, theta + delta, beta, 1)
    return x <= y
end

function irf_approaches_lower_asymptote(M, theta, pars)
    beta = ItemParameters(M, pars)
    prob = irf(M, theta, beta, 1)
    return prob >= beta.c
end

function irf_approaches_upper_asymptote(M, theta, pars)
    beta = ItemParameters(M, pars)
    return irf(M, theta, beta, 1) <= beta.d
end

function irf_probabilities_sum_to_one(M, theta, pars)
    beta = ItemParameters(M, pars)
    probs = irf(M, theta, beta)
    return sum(probs) == 1
end

function iif_is_nonnegative(M, theta, pars)
    beta = ItemParameters(M, pars)
    infos = iif(M, theta, beta)
    event!("iif", infos)
    return all(@. infos >= 0 || infos ≈ 0)
end

function iif_sums_to_total_information(M, theta, pars)
    beta = ItemParameters(M, pars)
    return sum(iif(M, theta, beta)) == information(M, theta, beta)
end

function iif_maximum_at_b(M, theta, pars)
    beta = ItemParameters(M, pars)
    info = iif(M, theta, beta, 1)
    event!("info", info)
    max_info = iif(M, beta.b, beta, 1)
    event!("max_info", max_info)
    return info <= max_info
end

function expected_score_is_monotone(M, theta, pars, delta)
    betas = ItemParameters.(M, pars)
    x = expected_score(M, theta, betas)
    y = expected_score(M, theta + delta, betas)
    return x <= y
end

function expected_score_approaches_minimum_score(M, theta, pars)
    betas = ItemParameters.(M, pars)
    min_score = sum(beta.c for beta in betas)
    score = expected_score(M, theta, betas)
    return score >= min_score
end

function expected_score_approaches_maximum_score(M, theta, pars)
    betas = ItemParameters.(M, pars)
    max_score = sum(beta.d for beta in betas)
    score = expected_score(M, theta, betas)
    return score <= max_score
end

function expected_score_is_additive(M::Type{<:DichotomousItemResponseModel}, theta, pars)
    betas = ItemParameters.(M, pars)
    score = expected_score(M, theta, betas)
    return score == sum(irf(M, theta, beta, 1) for beta in betas)
end

sr = @check expected_score_is_additive(Data.Just(OnePL), floatgen, testgen)

function expected_score_is_additive(M::Type{<:PolytomousItemResponseModel}, theta, pars)
    betas = ItemParameters.(M, pars)
    score = expected_score(M, theta, betas)
    return score == sum(irf(M, theta, beta)' * (1:(length(beta.t)+1)) for beta in betas)
end

function information_is_additive(M, theta, pars)
    betas = ItemParameters.(M, pars)
    info = information(M, theta, betas)
    event!("info", info)
    sum_iif = sum(sum(iif(M, theta, beta)) for beta in betas)
    event!("summed iifs", sum_iif)
    return info == sum_iif
end

function information_is_nonnegative(M, theta, pars)
    betas = ItemParameters.(M, pars)
    info = information(M, theta, betas)
    return info >= 0
end
