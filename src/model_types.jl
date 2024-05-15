"""
    $(TYPEDEF)

An abstract type representing an item response model with dichotomous responses.
"""
abstract type DichotomousItemResponseModel <: ItemResponseModel end

response_type(::Type{<:DichotomousItemResponseModel}) = Dichotomous

"""
    $(TYPEDEF)

An abstract representation of a 1 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = \\mathrm{logistic}(\\theta_i - b_j)``

The item parameter `beta` can be passed as a number or a destructurable object with the
following fields:

- `b`: the item difficulty (location)

**Alias:** `OnePL`
"""
abstract type OneParameterLogisticModel <: DichotomousItemResponseModel end
const OnePL = OneParameterLogisticModel

"""
    $(TYPEDEF)

An abstract representation of a 2 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = \\mathrm{logistic}(a_j(\\theta_i - b_j))``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)

**Alias:** `TwoPL`
"""
abstract type TwoParameterLogisticModel <: DichotomousItemResponseModel end
const TwoPL = TwoParameterLogisticModel

"""
    $(TYPEDEF)

An abstract representation of a 3 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = c_j + (1 - c_j)\\cdot\\mathrm{logistic}(a_j(\\theta_i - b_j))``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `c`: the lower asymptote

**Alias:** `ThreePL`
"""
abstract type ThreeParameterLogisticModel <: DichotomousItemResponseModel end
const ThreePL = ThreeParameterLogisticModel

"""
    $(TYPEDEF)

An abstract representation of a 4 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = c_j + (d_j - c_j)\\cdot\\mathrm{logistic}(a_j(\\theta_i - b_j))``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `c`: the lower asymptote
- `d`: the upper asymptote

**Alias:** `FourPL`
"""
abstract type FourParameterLogisticModel <: DichotomousItemResponseModel end
const FourPL = FourParameterLogisticModel

"""
    $(TYPEDEF)

An abstract type representing a Generalized Partial Credit Model with an item category
response function given by

``P(Y_{ij} = y,| \\theta_i, \\boldsymbol{\\beta}_j) =
    \\frac{\\exp \\sum_{s=1}^y (a_j (\\theta_i - b_j + t_{js}))}
    {1 + \\sum_{k=1}^{K_j} \\exp \\sum_{s=1}^k (a_j (\\theta_i - b_j + t_{js}))}``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `t`: a vector of threshold parameters

**Alias:** `GPCM`
"""
abstract type GeneralizedPartialCreditModel <: ItemResponseModel end
const GPCM = GeneralizedPartialCreditModel

"""
    $(TYPEDEF)

An abstract type representing a Partial Credit Model with an item category response function
given by

``P(Y_{ij} = y,| \\theta_i, \\boldsymbol{\\beta}_j) =
    \\frac{\\exp \\sum_{s=1}^y (\\theta_i - b_j + t_{js})}
    {1 + \\sum_{k=1}^{K_j} \\exp \\sum_{s=1}^k (\\theta_i - b_j + t_{js})}``

The item parameters `beta` must be a destructurable object with the following fields:

- `b`: the item difficulty (location)
- `t`: a vector of threshold parameters

**Alias:** `PCM`
"""
abstract type PartialCreditModel <: ItemResponseModel end
const PCM = PartialCreditModel

"""
    $(TYPEDEF)

An abstract type representing a Rating Scale Model with an item category response function
given by

``P(Y_{ij} = y,| \\theta_i, \\boldsymbol{\\beta}_j) =
    \\frac{\\exp \\sum_{s=1}^y (\\theta_i - b_j + t_{s})}
    {1 + \\sum_{k=1}^{K_j} \\exp \\sum_{s=1}^k (\\theta_i - b_j + t_{s})}``

The item parameters `beta` must be a destructurable object with the following fields:

- `b`: the item difficulty (location)
- `t`: a vector of threshold parameters

**Alias:** `RSM`
"""
abstract type RatingScaleModel <: ItemResponseModel end
const RSM = RatingScaleModel
