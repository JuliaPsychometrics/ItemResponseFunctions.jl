using Test

using ItemResponseFunctions
using ItemResponseFunctions:
    has_discrimination,
    has_upper_asymptote,
    has_lower_asymptote,
    has_stiffness,
    check_pars,
    ItemParameters

using ForwardDiff: Dual

# only do property based testing on julia 1.11 or higher since Supposition.jl only
# supports exporting to @testset in these versions.
# if VERSION >= v"1.11"
include("properties.jl")
# end

@testset "ItemResponseFunctions.jl" begin
    include("utils.jl")
    include("scoring_functions.jl")
    include("item_parameters.jl")
    include("models/one_parameter_logistic.jl")
    include("models/one_parameter_logistic_plus_guessing.jl")
    include("models/two_parameter_logistic.jl")
    include("models/three_parameter_logistic.jl")
    include("models/four_parameter_logistic.jl")
    include("models/five_parameter_logistic.jl")
    # include("models/generalized_partial_credit_model.jl")
    # include("models/partial_credit_model.jl")
    # include("models/rating_scale_model.jl")
    # include("models/generalized_rating_scale_model.jl")
    include("derivatives.jl")
    include("likelihood.jl")
end
