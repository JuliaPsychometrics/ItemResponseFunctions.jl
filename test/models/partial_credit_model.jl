@testset "PartialCreditModel" begin
    beta = (a = 1.0, b = 0.0, t = randn(3))
    @test irf(PCM, 0.0, beta) == irf(GPCM, 0.0, beta)
end
