@testset "RatingScaleModel" begin

    @test has_discrimination(RSM) == false
    @test has_lower_asymptote(RSM) == false
    @test has_upper_asymptote(RSM) == false

    beta = (a = 1.0, b = 0.0, t = randn(2))
    @test irf(RSM, 0.0, beta) == irf(GPCM, 0.0, beta)
    @test irf(RSM, 0.0, beta, 1) == irf(GPCM, 0.0, beta, 1)
    @test iif(RSM, 0.0, beta) == iif(GPCM, 0.0, beta)
    @test iif(RSM, 0.0, beta, 1) == iif(GPCM, 0.0, beta, 1)

    betas = fill(beta, 4)
    @test expected_score(RSM, 0.0, betas) == expected_score(GPCM, 0.0, betas)
    @test information(RSM, 0.0, betas) == information(GPCM, 0.0, betas)
end
