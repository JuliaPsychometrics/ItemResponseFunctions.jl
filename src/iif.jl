"""
    $(SIGNATURES)
"""
function iif(M::Type{OnePL}, theta::Real, beta::Real, y)
    prob = irf(M, theta, beta, y)
    return prob * (1 - prob)
end

function iif(M::Type{OnePL}, theta, beta, y)
    return iif(FourPL, theta, merge(beta, (a = 1.0, c = 0.0, d = 1.0)), y)
end

# 2PL
function iif(M::Type{TwoPL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; c = 0.0, d = 1.0)), y)
end

# 3PL
function iif(M::Type{ThreePL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; d = 1.0)), y)
end

# 4PL
function iif(M::Type{FourPL}, theta, beta::NamedTuple, y = 1)
    @unpack a, b, c, d = beta
    prob = irf(M, theta, beta, y)

    num = a^2 * (prob - c)^2 * (d - prob)^2
    num == 0 && return num

    denum = (d - c)^2 * prob * (1 - prob)
    info = num / denum

    return info
end
