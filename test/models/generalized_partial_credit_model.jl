@testset "GeneralizedPartialCreditModel" begin

    @test has_discrimination(GPCM) == true
    @test has_lower_asymptote(GPCM) == false
    @test has_upper_asymptote(GPCM) == false

    @testset "irf" begin
        beta = (a = 1.0, b = 0.0, t = zeros(3))
        @test length(irf(GPCM, 0.0, beta)) == length(beta.t) + 1
        @test sum(irf(GPCM, 0.0, beta)) ≈ 1.0
        @test irf(GPCM, 0.0, beta) == fill(0.25, 4)
        @test irf(GPCM, -Inf, beta) == [1.0, 0.0, 0.0, 0.0]
        @test_broken irf(GPCM, Inf, beta) == [0.0, 0.0, 0.0, 1.0]  # issues with Inf in softmax!
        @test irf(GPCM, 1e16, beta) == [0.0, 0.0, 0.0, 1.0]

        @test irf(GPCM, 0.0, beta, 1) == 0.25
        @test irf(GPCM, -Inf, beta, 1) == 1.0
        @test irf(GPCM, -Inf, beta, 4) == 0.0

        # equivalent to 2PL for dichotomous items
        beta = (a = 0.87, b = -0.25, t = 0.0)
        @test irf(GPCM, 0.0, beta, 1) ≈ irf(TwoPL, 0.0, beta, 0)
        @test irf(GPCM, 0.0, beta, 2) ≈ irf(TwoPL, 0.0, beta, 1)
    end

    @testset "iif" begin
        beta = (a = 1.3, b = 0.4, t = zeros(2))
        @test_broken iif(GPCM, Inf, beta) == 0.0  # produces NaN
        @test iif(GPCM, 1e16, beta) == [0.0, 0.0, 0.0]
        @test iif(GPCM, -Inf, beta) == [0.0, 0.0, 0.0]

        @test iif(GPCM, 1e16, beta, 1) == 0.0
        @test iif(GPCM, -Inf, beta, 1) == 0.0

        # equivalent to 2PL for dichotomous items
        beta = (a = 0.87, b = 0.22, t = 0.0)
        @test iif(GPCM, 0.0, beta, 1) ≈ iif(TwoPL, 0.0, beta, 0)
        @test iif(GPCM, 0.0, beta, 2) ≈ iif(TwoPL, 0.0, beta, 1)
    end

    @testset "expected_score" begin
        beta = (a = 1.0, b = 0.0, t = zeros(2))
        betas = fill(beta, 6)
        @test expected_score(GPCM, 0.0, betas) == 2.0 * 6
        @test expected_score(GPCM, -Inf, betas) == 1.0 * 6
        @test_broken expected_score(GPCM, Inf, betas) == 3.0 * 6  # produces NaN
        @test expected_score(GPCM, 1e16, betas) == 3.0 * 6

        # equivalent to 2PL for dichotomous items
        beta = (a = 1.3, b = 0.4, t = 0.0)
        betas = fill(beta, 3)
        @test expected_score(GPCM, 0.0, betas, scoring_function = partial_credit(2)) ≈
              expected_score(TwoPL, 0.0, betas)
    end

    @testset "information" begin
        beta = (a = 1.0, b = 0.0, t = zeros(2))
        betas = fill(beta, 6)
        @test information(GPCM, -Inf, betas) == 0.0
        @test_broken information(GPCM, Inf, betas) == 0.0  # produces NaN
        @test information(GPCM, 1e16, betas) == 0.0

        # equivalent to 2PL for dichotomous items
        beta = (a = 0.3, b = 0.4, t = 0.0)
        betas = fill(beta, 4)
        @test information(GPCM, 0.0, betas, scoring_function = partial_credit(2)) ≈
              information(TwoPL, 0.0, betas)
    end
end
