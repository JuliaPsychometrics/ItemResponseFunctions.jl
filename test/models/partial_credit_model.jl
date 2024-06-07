@testset "PartialCreditModel" begin

    @test has_discrimination(PCM) == false
    @test has_lower_asymptote(PCM) == false
    @test has_upper_asymptote(PCM) == false

    @testset "irf" begin
        # equivalent to GPCM for a = 1
        beta = (a = 1.0, b = 0.0, t = randn(3))
        @test irf(PCM, 0.0, beta) == irf(GPCM, 0.0, beta)
        @test irf(PCM, 0.0, beta, 1) == irf(GPCM, 0.0, beta, 1)

        # equivalent to 1PL for dichotomous items
        beta = (a = 1.12, b = 0.0, t = 0.0)
        for theta in rand(10)
            @test irf(PCM, theta, beta, 1) ≈ irf(OnePL, theta, beta, 0)
            @test irf(PCM, theta, beta, 2) ≈ irf(OnePL, theta, beta, 1)
        end
    end

    @testset "iif" begin
        # equivalent to GPCM for a = 1
        beta = (a = 1.0, b = 0.0, t = randn(3))
        @test iif(PCM, 0.0, beta) == iif(GPCM, 0.0, beta)
        @test iif(PCM, 0.0, beta, 1) == iif(GPCM, 0.0, beta, 1)

        # equivalent to 1PL for dichotomous items
        beta = (a = 1.12, b = 0.0, t = 0.0)
        for theta in rand(10)
            @test iif(PCM, theta, beta, 1) ≈ iif(OnePL, theta, beta, 0)
            @test iif(PCM, theta, beta, 2) ≈ iif(OnePL, theta, beta, 1)
        end
    end

    @testset "expected_score" begin
        # equivalent to GPCM for a = 1
        beta = (a = 1.0, b = 0.0, t = randn(3))
        betas = fill(beta, 4)
        @test expected_score(PCM, 0.0, betas) == expected_score(GPCM, 0.0, betas)

        # equivalent to 1PL for dichotomous items
        beta = (a = 1.4, b = 0.3, t = 0.0)
        betas = fill(beta, 4)
        @test expected_score(PCM, 0.0, betas, scoring_function = partial_credit(2)) ≈
              expected_score(OnePL, 0.0, betas)
    end

    @testset "information" begin
        # equivalent to GPCM for a = 1
        beta = (a = 1.0, b = 0.0, t = randn(3))
        betas = fill(beta, 4)
        @test information(PCM, 0.0, betas) == information(GPCM, 0.0, betas)

        # equivalent to 1PL for dichotomous items
        beta = (a = 1.4, b = 0.3, t = 0.0)
        betas = fill(beta, 4)
        @test information(PCM, 0.0, betas) ≈ information(OnePL, 0.0, betas)
    end

end
