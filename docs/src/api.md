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
#### Scoring functions
```@docs
partial_credit
```

#### Derivatives
```@docs
derivative_theta
derivative_theta!
second_derivative_theta
second_derivative_theta!
```

#### Item parameters
```@docs
ItemParameters
```
