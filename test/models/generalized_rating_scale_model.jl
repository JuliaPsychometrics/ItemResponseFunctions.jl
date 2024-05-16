@testset "GeneralizedRatingScaleModel" begin
    beta = (a = 1.3, b = 0.2, t = randn(4))
    @test irf(GRSM, 0.0, beta) == irf(GPCM, 0.0, beta)
end
