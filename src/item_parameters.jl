"""
    $(TYPEDEF)
"""
struct ItemParameters{M<:ItemResponseModel,N,T}
    a::T
    b::T
    c::T
    d::T
    e::T
    t::NTuple{N,T}
    function ItemParameters(M, a, b, c, d, e, t::NTuple{N,T}) where {N,T}
        a = has_discrimination(M) ? a : one(b)
        c = has_lower_asymptote(M) ? c : zero(b)
        d = has_upper_asymptote(M) ? d : one(d)
        e = has_stiffness(M) ? e : one(b)
        t = response_type(M) == Dichotomous ? () : t

        check_discrimination(M, a)
        check_lower_asymptote(M, c)
        check_upper_asymptote(M, c, d)
        check_stiffness(M, e)

        beta = promote(a, b, c, d, e)
        return new{M,length(t),eltype(beta)}(beta..., t)
    end
end

function ItemParameters(M; b, a = one(b), c = zero(b), d = one(b), e = one(b), t = ())
    beta = promote(a, b, c, d, e)
    return ItemParameters(M, beta..., Tuple(t))
end

ItemParameters(M::Type{<:ItemResponseModel}, beta::ItemParameters) = beta
ItemParameters(M::Type{<:ItemResponseModel}, beta::NamedTuple) = ItemParameters(M; beta...)
ItemParameters(M::Type{<:ItemResponseModel}, beta::Real) = ItemParameters(M; b = beta)

"""
    $(SIGNATURES)

Check the validity of the item parameters `beta`.
"""
function check_pars(M::Type{<:DichotomousItemResponseModel}, beta)
    @unpack a, c, d, e = beta
    check_discrimination(M, a)
    check_lower_asymptote(M, c)
    check_upper_asymptote(M, c, d)
    check_stiffness(M, e)
    return true
end

function check_pars(M::Type{<:PolytomousItemResponseModel}, beta)
    @unpack a = beta
    check_discrimination(M, a)
    return true
end

function check_discrimination(M, a)
    if !has_discrimination(M)
        if a != 1
            err = "discrimination parameter a != 1"
            throw(ArgumentError(err))
        end
    end
    return true
end

function check_lower_asymptote(M, c)
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

function check_upper_asymptote(M, c, d)
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

function check_stiffness(M, e)
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
