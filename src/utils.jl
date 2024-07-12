"""
    $(SIGNATURES)

Append parameters to `beta` based on `M`s traits.
"""
function merge_pars(M::Type{<:ItemResponseModel}, beta)
    pars = deepcopy(beta)
    @unpack b = pars

    if !has_discrimination(M)
        pars = merge(pars, (; a = one(b)))
    end

    if !has_lower_asymptote(M)
        pars = merge(pars, (; c = zero(b)))
    end

    if !has_upper_asymptote(M)
        pars = merge(pars, (; d = one(b)))
    end

    if !has_stiffness(M)
        pars = merge(pars, (; e = one(b)))
    end

    return pars
end

function merge_pars(M::Type{<:Union{OnePL,OnePLG}}, beta::Real)
    return merge_pars(M, (; b = beta))
end

"""
    $(SIGNATURES)

Check the validity of the item parameters `beta`.
"""
function checkpars(M::Type{<:DichotomousItemResponseModel}, beta)
    check_discrimination(M, beta)
    check_lower_asymptote(M, beta)
    check_upper_asymptote(M, beta)
    check_stiffness(M, beta)
    return true
end

function checkpars(M::Type{<:PolytomousItemResponseModel}, beta)
    check_discrimination(M, beta)
    return true
end

function check_discrimination(M, beta)
    @unpack a = beta
    if !has_discrimination(M)
        if a != 1
            err = "discrimination parameter a != 1"
            throw(ArgumentError(err))
        end
    end
    return true
end

function check_lower_asymptote(M, beta)
    @unpack c = beta
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
    return true
end

function check_upper_asymptote(M, beta)
    @unpack c, d = beta
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
end

function check_stiffness(M, beta)
    @unpack e = beta
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
