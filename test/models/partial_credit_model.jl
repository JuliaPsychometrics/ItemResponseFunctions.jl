@testset "PartialCreditModel" begin
    beta = (a = 1.0, b = 0.0, t = randn(3))
    @test irf(PCM, 0.0, beta) == irf(GPCM, 0.0, beta)
    @test irf(PCM, 0.0, beta, 1) == irf(GPCM, 0.0, beta, 1)
    @test iif(PCM, 0.0, beta) == iif(GPCM, 0.0, beta)
    @test iif(PCM, 0.0, beta, 1) == iif(GPCM, 0.0, beta, 1)

    betas = fill(beta, 4)
    @test expected_score(PCM, 0.0, betas) == expected_score(GPCM, 0.0, betas)
    @test information(PCM, 0.0, betas) == information(GPCM, 0.0, betas)
end
