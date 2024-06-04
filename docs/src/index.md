# ItemResponseFunctions.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliapsychometrics.github.io/ItemResponseFunctions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliapsychometrics.github.io/ItemResponseFunctions.jl/dev/)
[![Build Status](https://github.com/juliapsychometrics/ItemResponseFunctions.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/juliapsychometrics/ItemResponseFunctions.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/juliapsychometrics/ItemResponseFunctions.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/juliapsychometrics/ItemResponseFunctions.jl)

[ItemResponseFunctions.jl](https://github.com/juliapsychometrics/ItemResponseFunctions.jl) implements basic functions for Item Response Theory models. It is built based on the interface designed in [AbstractItemResponseModels.jl](https://github.com/JuliaPsychometrics/AbstractItemResponseModels.jl).

## Installation
You can install ItemResponseFunctions.jl from the General package registry:

```julia
] add ItemResponseFunctions
```

## Usage
ItemResponseFunctions.jl exports the following functions for Item Response Theory models: 

- `irf`: The item response function 
- `iif`: The item information function 
- `expected_score`: The expected score / test response function
- `information`: The test information function

Calling the function requires a model type `M`, a person ability `theta` and item parameters `beta`.  
For a simple 1-Parameter Logistic model, 

```julia
using ItemResponseFunctions

beta = (; b = 0.5)

irf(OnePL, 0.0, beta, 1)
iif(OnePL, 0.0, beta, 1)
```

evaluates the item response function and item information function for response `y` at ability value `0.0` for an item with difficulty `0.5`.

Given an array of item parameters (a test) and an ability value, the test response function and test information can be calculated by

```julia
betas = [
    (; b = -0.3),
    (; b = 0.25),
    (; b = 1.0),
]

expected_score(OnePL, 0.0, betas)
information(OnePL, 0.0, betas)
```
