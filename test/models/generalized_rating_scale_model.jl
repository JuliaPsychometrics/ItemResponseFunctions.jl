@testset "GeneralizedRatingScaleModel" begin

    @test has_discrimination(GRSM) == true
    @test has_lower_asymptote(GRSM) == false
    @test has_upper_asymptote(GRSM) == false

    beta = (a = 1.3, b = 0.2, t = randn(4))
    @test irf(GRSM, 0.0, beta) == irf(GPCM, 0.0, beta)
    @test irf(GRSM, 0.0, beta, 1) == irf(GPCM, 0.0, beta, 1)
    @test iif(GRSM, 0.0, beta) == iif(GPCM, 0.0, beta)
    @test iif(GRSM, 0.0, beta, 1) == iif(GPCM, 0.0, beta, 1)

    betas = fill(beta, 4)
    @test expected_score(GRSM, 0.0, betas) == expected_score(GPCM, 0.0, betas)
    @test information(GRSM, 0.0, betas) == information(GPCM, 0.0, betas)
end
