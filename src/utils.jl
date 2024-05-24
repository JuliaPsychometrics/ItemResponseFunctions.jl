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

    if !has_asymmetry(M)
        pars = merge(pars, (; e = 1.0))
    end

    return pars
end
