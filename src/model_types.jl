"""
    $(TYPEDEF)

An abstract type representing an item response model with dichotomous responses.
"""
abstract type DichotomousItemResponseModel <: ItemResponseModel end

response_type(::Type{<:DichotomousItemResponseModel}) = Dichotomous

"""
    $(TYPEDEF)

An abstract type representing an item response model with polytomous responses.
"""
abstract type PolytomousItemResponseModel <: ItemResponseModel end

response_type(::Type{<:PolytomousItemResponseModel}) = Nominal

has_stiffness(::Type{<:PolytomousItemResponseModel}) = false
has_lower_asymptote(::Type{<:PolytomousItemResponseModel}) = false
has_upper_asymptote(::Type{<:PolytomousItemResponseModel}) = false

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

has_discrimination(::Type{OnePL}) = false
has_lower_asymptote(::Type{OnePL}) = false
has_upper_asymptote(::Type{OnePL}) = false
has_stiffness(::Type{OnePL}) = false

"""
    $(TYPEDEF)

An abstract representation of the 1 Parameter Logistic + Guessing Model with an item
response function given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = c + (1 - c) \\cdot \\mathrm{logistic}(\\theta_i - b_j)``

The item parameters `beta` must be a destructurable object with the following fields:

- `b`: the item difficulty (location)
- `c`: the lower asymptote

**Alias:** `OnePLG`
"""
abstract type OneParameterLogisticPlusGuessingModel <: DichotomousItemResponseModel end
const OnePLG = OneParameterLogisticPlusGuessingModel

has_discrimination(::Type{OnePLG}) = false
has_lower_asymptote(::Type{OnePLG}) = true
has_upper_asymptote(::Type{OnePLG}) = false
has_stiffness(::Type{OnePLG}) = false

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

has_discrimination(::Type{TwoPL}) = true
has_lower_asymptote(::Type{TwoPL}) = false
has_upper_asymptote(::Type{TwoPL}) = false
has_stiffness(::Type{TwoPL}) = false

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

has_discrimination(::Type{ThreePL}) = true
has_lower_asymptote(::Type{ThreePL}) = true
has_upper_asymptote(::Type{ThreePL}) = false
has_stiffness(::Type{ThreePL}) = false

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

has_discrimination(::Type{FourPL}) = true
has_lower_asymptote(::Type{FourPL}) = true
has_upper_asymptote(::Type{FourPL}) = true
has_stiffness(::Type{FourPL}) = false

"""
    $(TYPEDEF)

An abstract representation of a 5 Parameter Logistic Model with an item response function
given by

``P(Y_{ij}=1|\\theta_i,\\boldsymbol{\\beta}_j) = c_j + (d_j - c_j)\\cdot\\mathrm{logistic}(a_j(\\theta_i - b_j))^{e_j}``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `c`: the lower asymptote
- `d`: the upper asymptote
- `e`: the item stiffness

**Alias:** `FivePL`
"""
abstract type FiveParameterLogisticModel <: DichotomousItemResponseModel end
const FivePL = FiveParameterLogisticModel

has_discrimination(::Type{FivePL}) = true
has_lower_asymptote(::Type{FivePL}) = true
has_upper_asymptote(::Type{FivePL}) = true
has_stiffness(::Type{FivePL}) = true

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
abstract type GeneralizedPartialCreditModel <: PolytomousItemResponseModel end
const GPCM = GeneralizedPartialCreditModel

has_discrimination(::Type{GPCM}) = true

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
abstract type PartialCreditModel <: PolytomousItemResponseModel end
const PCM = PartialCreditModel

has_discrimination(::Type{PCM}) = false

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
abstract type RatingScaleModel <: PolytomousItemResponseModel end
const RSM = RatingScaleModel

has_discrimination(::Type{RSM}) = false

"""
    $(TYPEDEF)

An abstract type representing a Generalized Rating ScaleModel with an item category
response function given by

``P(Y_{ij} = y,| \\theta_i, \\boldsymbol{\\beta}_j) =
    \\frac{\\exp \\sum_{s=1}^y (a_j (\\theta_i - b_j + t_{s}))}
    {1 + \\sum_{k=1}^{K_j} \\exp \\sum_{s=1}^k (a_j (\\theta_i - b_j + t_{s}))}``

The item parameters `beta` must be a destructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `t`: a vector of threshold parameters

**Alias:** `GRSM`
"""
abstract type GeneralizedRatingScaleModel <: PolytomousItemResponseModel end
const GRSM = GeneralizedRatingScaleModel

has_discrimination(::Type{GRSM}) = true
