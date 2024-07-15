module ItemResponseFunctions

using AbstractItemResponseModels: Dichotomous, Nominal, checkresponsetype
using DifferentiationInterface:
    AutoForwardDiff, derivative!, value_and_derivative, second_derivative
using DocStringExtensions: SIGNATURES, TYPEDEF, METHODLIST, FIELDS
using LogExpFunctions: logistic, cumsum!, softmax!
using Reexport: @reexport
using SimpleUnPack: @unpack

import ForwardDiff

# AbstractItemResponseModels interface extensions
@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type

export DichotomousItemResponseModel,
    FivePL,
    FiveParameterLogisticModel,
    FourPL,
    FourParameterLogisticModel,
    GPCM,
    GRSM,
    GeneralizedPartialCreditModel,
    GeneralizedRatingScaleModel,
    ItemParameters,
    OnePL,
    OnePLG,
    OneParameterLogisticModel,
    OneParameterLogisticPlusGuessingModel,
    PCM,
    PartialCreditModel,
    PolytomousItemResponseModel,
    RSM,
    RatingScaleModel,
    ThreePL,
    ThreeParameterLogisticModel,
    TwoPL,
    TwoParameterLogisticModel,
    irf!,
    iif!,
    partial_credit,
    derivative_theta,
    derivative_theta!,
    second_derivative_theta,
    second_derivative_theta!

include("model_types.jl")
include("item_parameters.jl")
include("utils.jl")
include("irf.jl")
include("iif.jl")
include("expected_score.jl")
include("information.jl")
include("scoring_functions.jl")
include("derivatives.jl")

include("precompile.jl")

end
