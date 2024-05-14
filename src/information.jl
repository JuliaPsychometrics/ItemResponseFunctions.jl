"""
    $(SIGNATURES)

Calculate the test information of an item response mode `M` at the ability value `theta`
given a vector of item parameters `betas`. The values of betas are considered item
parameters for different items.

The test information is calculated from the models [`iif`](@ref) function. For details on
how to pass item parameters to [`iif`](@ref), see the respective function documentation.
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
