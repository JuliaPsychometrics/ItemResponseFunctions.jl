```@meta
CurrentModule = ItemResponseFunctions
```

# API

## Models
### Dichotomous response models
```@docs
OneParameterLogisticModel
OneParameterLogisticPlusGuessingModel
TwoParameterLogisticModel
ThreeParameterLogisticModel
FourParameterLogisticModel
FiveParameterLogisticModel
```

### Polytomous response models
```@docs
PartialCreditModel
GeneralizedPartialCreditModel
RatingScaleModel
GeneralizedRatingScaleModel
```

## Functions
### Item Response Functions
```@docs
irf
irf!
iif
expected_score
information
```
### Utilities
```@docs
ItemParameters
derivative_theta
derivative_theta!
likelihood
loglikelihood
partial_credit
second_derivative_theta
second_derivative_theta!
```
