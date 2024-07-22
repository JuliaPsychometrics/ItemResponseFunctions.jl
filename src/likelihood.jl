"""
    $(SIGNATURES)

Evaluate the likelihood of an item response model `M` at `theta`, given item parameters
`betas` and response pattern `responses`.

Items are assumed to be independent. Then, the likelihood function is defined as,

``
L(\\boldsymbol{u} | \\theta, \\boldsymbol{\\beta}) = \\prod_{j=1}^J P(Y_j = y | \\theta, \\boldsymbol{\\beta}_j)
``

See also [`loglikelihood`](@ref).
"""
function likelihood(M::Type{<:ItemResponseModel}, theta, betas, responses)
    L = one(theta)

    for (beta, y) in zip(betas, responses)
        L *= irf(M, theta, beta, y)
    end

    return L
end

"""
    $(SIGNATURES)

Evaluate the log-likelihood of an item response model `M` at `theta`, given item parameters
`betas` and response pattern `responses`,

See also [`likelihood`](@ref).
"""
function loglikelihood(M::Type{<:ItemResponseModel}, theta, betas, responses)
    return log(likelihood(M, theta, betas, responses))
end
