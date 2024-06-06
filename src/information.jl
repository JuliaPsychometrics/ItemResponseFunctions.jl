"""
    $(SIGNATURES)

Calculate the test information of an item response mode `M` at the ability value `theta`
given a vector of item parameters `betas`. The values of betas are considered item
parameters for different items.

The test information is calculated from the models [`iif`](@ref) function. For details on
how to pass item parameters to [`iif`](@ref), see the respective function documentation.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> information(OnePL, 0.0, zeros(6))
1.5

julia> betas = fill((; b = 0.0), 6);

julia> information(OnePL, 0.0, betas)
1.5
```

### 2 Parameter Logistic Model
```jldoctest
julia> betas = fill((; a = 1.2, b = 0.4), 4);

julia> information(TwoPL, 0.0, betas)
1.3601401228069936
```

### 3 Parameter Logistic Model
```jldoctest
julia> betas = fill((; a = 1.5, b = 0.5, c = 0.2), 4);

julia> information(ThreePL, 0.0, betas)
1.1021806599852655
```

### 4 Parameter Logistic Model
```jldoctest
julia> betas = fill((; a = 0.5, b = 1.4, c = 0.13, d = 0.94), 6);

julia> information(FourPL, 0.0, betas)
0.20178122985757524
```
"""
function information(
    M::Type{<:DichotomousItemResponseModel},
    theta,
    betas::AbstractVector;
    scoring_function::F = one,
) where {F}
    info = zero(theta)

    for beta in betas
        info += information(M, theta, beta; scoring_function)
    end

    return info
end

function information(
    M::Type{<:DichotomousItemResponseModel},
    theta,
    beta::Union{<:Real,NamedTuple};
    scoring_function::F = one,
) where {F}
    info = zero(theta)
    pars = merge_pars(M, beta)

    for y in 0:1
        info += _iif(M, theta, pars, y; scoring_function)
    end

    return info
end

# polytomous models
function information(
    M::Type{<:PolytomousItemResponseModel},
    theta,
    betas::AbstractVector;
    scoring_function::F = identity,
) where {F}
    info = zero(theta)
    for beta in betas
        info += information(M, theta, beta; scoring_function)
    end
    return info
end

function information(
    M::Type{<:PolytomousItemResponseModel},
    theta::T,
    beta::NamedTuple;
    scoring_function::F = identity,
) where {T<:Real,F}
    infos = zeros(T, length(beta.t) + 1)
    return _information!(M, infos, theta, beta; scoring_function)
end

function _information!(
    M::Type{<:PolytomousItemResponseModel},
    infos,
    theta,
    beta::NamedTuple;
    scoring_function::F = identity,
) where {F}
    iif!(M, infos, theta, beta; scoring_function)
    return sum(infos)
end
