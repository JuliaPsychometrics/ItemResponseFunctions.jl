@testset "FourParameterLogisticModel" begin
    T = FourParameterLogisticModel

    @test has_discrimination(T) == true
    @test has_lower_asymptote(T) == true
    @test has_upper_asymptote(T) == true

    @testset "irf" begin
        beta = (a = 1.0, b = 0.0, c = 0.0, d = 1.0)
        @test irf(T, 0.0, beta, 1) == 0.5
        @test irf(T, Inf, beta, 1) == 1.0
        @test irf(T, -Inf, beta, 1) == 0.0
        @test irf(T, 0.0, beta) == [0.5, 0.5]

        beta = (a = 1.5, b = 0.0, c = 0.2, d = 0.8)
        @test irf(T, 0.0, beta, 1) == 0.5
        @test irf(T, Inf, beta, 1) == 0.8
        @test irf(T, -Inf, beta, 1) == 0.2
        @test irf(T, 0.0, beta) == [0.5, 0.5]
    end

    @testset "iif" begin
        beta = (a = 1.0, b = 0.0, c = 0.0, d = 1.0)
        @test iif(T, 0.0, beta) == [0.125, 0.125]
        @test iif(T, Inf, beta) == [0.0, 0.0]
        @test iif(T, -Inf, beta) == [0.0, 0.0]

        beta = (a = 2.1, b = 0.2, c = 0.2, d = 0.95)
        @test iif(T, Inf, beta) == [0.0, 0.0]
        @test iif(T, -Inf, beta) == [0.0, 0.0]
    end

    @testset "expected_score" begin
        betas = fill((a = 1.0, b = 0.0, c = 0.0, d = 1.0), 6)
        @test expected_score(T, 0.0, betas) == 3.0
        @test expected_score(T, Inf, betas) == 6.0
        @test expected_score(T, -Inf, betas) == 0.0

        beta = (a = 1.0, b = 0.0, c = 0.1, d = 0.6)
        betas = fill(beta, 6)
        @test expected_score(T, 0.0, betas) ≈ (beta.c + (beta.d - beta.c) / 2) * 6
        @test expected_score(T, Inf, betas) ≈ betas[1].d * 6
        @test expected_score(T, -Inf, betas) ≈ betas[1].c * 6
        @test expected_score(T, 0.0, beta) == irf(T, 0.0, beta, 1)
    end

    @testset "information" begin
        betas = fill((a = 1.0, b = 0.0, c = 0.0, d = 1.0), 3)
        @test information(T, 0.0, betas) == 0.25 * 3
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0

        beta = (a = 1.2, b = 0.3, c = 0.1, d = 0.88)
        betas = fill(beta, 3)
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0
        @test information(T, 0.0, beta) == sum(iif(T, 0.0, beta, y) for y in 0:1)
    end

    @testset "properties" begin
        M = Data.Just(FourPL)

        @check irf_is_monotone(M, floatgen, itempargen, positivefloatgen)
        @check irf_approaches_lower_asymptote(M, floatgen, itempargen)
        @check irf_approaches_upper_asymptote(M, floatgen, itempargen)
        @check irf_probabilities_sum_to_one(M, floatgen, itempargen)

        @check iif_is_nonnegative(M, floatgen, itempargen)
        @check iif_sums_to_total_information(M, floatgen, itempargen)
        @check iif_maximum_at_b(M, floatgen, itempargen)

        @check expected_score_is_monotone(M, floatgen, testgen, positivefloatgen)
        @check expected_score_approaches_minimum_score(M, floatgen, testgen)
        @check expected_score_approaches_maximum_score(M, floatgen, testgen)
        @check expected_score_is_additive(M, floatgen, testgen)

        @check information_is_additive(M, floatgen, testgen)
        @check information_is_nonnegative(M, floatgen, testgen)
    end
end
