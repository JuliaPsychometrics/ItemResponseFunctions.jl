@testset "RatingScaleModel" begin
    beta = (a = 1.0, b = 0.0, t = randn(2))
    @test irf(RSM, 0.0, beta) == irf(GPCM, 0.0, beta)
end
