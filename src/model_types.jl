abstract type DichotomousItemResponseModel <: ItemResponseModel end

response_type(::Type{<:DichotomousItemResponseModel}) = Dichotomous

abstract type OneParameterLogisticModel <: DichotomousItemResponseModel end
const OnePL = OneParameterLogisticModel

abstract type TwoParameterLogisticModel <: DichotomousItemResponseModel end
const TwoPL = TwoParameterLogisticModel

abstract type ThreeParameterLogisticModel <: DichotomousItemResponseModel end
const ThreePL = ThreeParameterLogisticModel

"""
    $(TYPEDEF)

An abstract representation of a 4 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = c_j + (d_j - c_j)\\mathrm{logistic}(a_j(\\theta_i - b_j))``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `c`: the lower asymptote
- `d`: the upper asymptote

"""
abstract type FourParameterLogisticModel <: DichotomousItemResponseModel end
const FourPL = FourParameterLogisticModel
