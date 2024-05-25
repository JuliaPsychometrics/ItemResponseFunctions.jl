"""
    $(SIGNATURES)

Append parameters to `beta` based on `M`s traits.
"""
function merge_pars(M::Type{<:ItemResponseModel}, beta)
    pars = deepcopy(beta)

    if !has_discrimination(M)
        pars = merge(pars, (; a = 1.0))
    end

    if !has_lower_asymptote(M)
        pars = merge(pars, (; c = 0.0))
    end

    if !has_upper_asymptote(M)
        pars = merge(pars, (; d = 1.0))
    end

    if !has_stiffness(M)
        pars = merge(pars, (; e = 1.0))
    end

    return pars
end

"""
    $(SIGNATURES)

Check the validity of the item parameters `beta`.
"""
function checkpars(M::Type{<:ItemResponseModel}, beta)
    @unpack a, c, d, e = beta
    # discriminatino
    if !has_discrimination(M)
        if a != 1
            err = "discrimination parameter a != 1"
            throw(ArgumentError(err))
        end
    end

    # asymptotes
    if has_lower_asymptote(M)
        if c < 0 || c > 1
            err = "lower asymptote c must be in interval (0, 1)"
            throw(ArgumentError(err))
        end
    else
        if c != 0
            err = "lower asymptote c != 0"
            throw(ArgumentError(err))
        end
    end

    if has_upper_asymptote(M)
        if d < 0 || d > 1
            err = "upper asymptote d must be in interval (0, 1)"
            throw(ArgumentError(err))
        end

        if c > d
            err = "lower asymptote c must be smaller than upper asymptote d"
            throw(ArgumentError(err))
        end
    else
        if d != 1
            err = "upper asymptote d != 1"
            throw(ArgumentError(err))
        end
    end

    # stiffness
    if has_stiffness(M)
        if e < 0
            err = "stiffness parameter e must be positive"
            throw(ArgumentError(err))
        end
    else
        if e != 1
            err = "stiffness parameter e != 1"
            throw(ArgumentError(err))
        end
    end

    return true
end
