"""
    $(TYPEDEF)

A struct representing item parameters for an item response model.

## Fields
$(FIELDS)

## Examples
```jldoctest
julia> pars = ItemParameters(TwoPL, a = 1.5, b = 0.0)
ItemParameters{TwoParameterLogisticModel, 0, Float64}(1.5, 0.0, 0.0, 1.0, 1.0, ())

julia> ItemParameters(OnePL, pars)
ItemParameters{OneParameterLogisticModel, 0, Float64}(1.0, 0.0, 0.0, 1.0, 1.0, ())
```
"""
struct ItemParameters{M<:ItemResponseModel,N,T<:Real}
    "the item discrimination"
    a::T
    "the item difficulty (location)"
    b::T
    "the lower asymptote"
    c::T
    "the upper asymptote"
    d::T
    "the item stiffness"
    e::T
    "a tuple of threshold parameters"
    t::NTuple{N,T}
    function ItemParameters(
        model::Type{<:ItemResponseModel},
        a,
        b,
        c,
        d,
        e,
        t::NTuple{N,T},
    ) where {N,T}
        a = has_discrimination(model) ? a : one(b)
        c = has_lower_asymptote(model) ? c : zero(b)
        d = has_upper_asymptote(model) ? d : one(d)
        e = has_stiffness(model) ? e : one(b)

        check_discrimination(model, a)
        check_lower_asymptote(model, c)
        check_upper_asymptote(model, c, d)
        check_stiffness(model, e)

        beta = promote(a, b, c, d, e)

        return new{model,N,eltype(beta)}(beta..., t)
    end
end

function ItemParameters(
    M::Type{<:ItemResponseModel};
    b,
    a = one(b),
    c = zero(b),
    d = one(b),
    e = one(b),
    t = (),
)
    beta = promote(a, b, c, d, e)
    return ItemParameters(M, beta..., Tuple(t))
end

function ItemParameters(M::Type{<:ItemResponseModel}, beta::ItemParameters)
    @unpack a, b, c, d, e, t = beta
    return ItemParameters(M, a, b, c, d, e, t)
end

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

function check_discrimination(M::Type{<:ItemResponseModel}, a)
    if !has_discrimination(M)
        if a != 1
            err = "discrimination parameter a != 1"
            throw(ArgumentError(err))
        end
    else
        return true
    end
end

function check_lower_asymptote(M::Type{<:ItemResponseModel}, c)
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

function check_upper_asymptote(M::Type{<:ItemResponseModel}, c, d)
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

function check_stiffness(M::Type{<:ItemResponseModel}, e)
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
