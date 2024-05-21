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
1.3601401228069934
```

### 3 Parameter Logistic Model
```jldoctest
julia> betas = fill((; a = 1.5, b = 0.5, c = 0.2), 4);

julia> information(ThreePL, 0.0, betas)
1.102180659985265
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
    theta::T,
    betas::AbstractVector,
) where {T<:Real}
    info = zero(T)

    for beta in betas
        info += iif(M, theta, beta, 1)
    end

    return info
end

function information(
    M::Type{<:PolytomousItemResponseModel},
    theta,
    beta;
    scoring_function::F = identity,
) where {F}
    return iif(M, theta, beta; scoring_function)
end

function information(
    M::Type{<:PolytomousItemResponseModel},
    theta::T,
    betas::AbstractVector;
    scoring_function::F = identity,
) where {T<:Real,F}
    info = zero(T)
    for beta in betas
        info += information(M, theta, beta; scoring_function)
    end
    return info
end
