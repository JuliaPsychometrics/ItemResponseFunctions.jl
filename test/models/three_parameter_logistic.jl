@testset "ThreeParameterLogisticModel" begin
    T = ThreeParameterLogisticModel

    @test has_discrimination(T) == true
    @test has_lower_asymptote(T) == true
    @test has_upper_asymptote(T) == false

    @testset "irf" begin
        beta = (a = 1.5, b = 0.0, c = 0.2)
        @test irf(T, 0.0, beta, 1) ≈ 0.5 + beta.c / 2
        @test irf(T, Inf, beta, 1) == 1.0
        @test irf(T, -Inf, beta, 1) == beta.c
        @test irf(T, 0.0, beta) ≈ [0.5 - beta.c / 2, 0.5 + beta.c / 2]
    end

    @testset "iif" begin
        beta = (a = 1.0, b = 0.0, c = 0.0)
        @test iif(T, 0.0, beta) == [0.125, 0.125]
        @test iif(T, Inf, beta) == [0.0, 0.0]
        @test iif(T, -Inf, beta) == [0.0, 0.0]

        beta = (a = 1.5, b = 0.0, c = 0.25)
        @test iif(T, Inf, beta) == [0.0, 0.0]
        @test iif(T, -Inf, beta) == [0.0, 0.0]
    end

    @testset "expected_score" begin
        beta = (a = 1.0, b = 0.0, c = 0.0)
        betas = fill(beta, 4)
        @test expected_score(T, 0.0, betas) == 2.0
        @test expected_score(T, Inf, betas) == 4.0
        @test expected_score(T, -Inf, betas) == 0.0

        beta = (a = 1.5, b = 0.0, c = 0.3)
        betas = fill(beta, 4)
        @test expected_score(T, 0.0, betas) ≈ (0.5 + betas[1].c / 2) * 4
        @test expected_score(T, Inf, betas) == 4.0
        @test expected_score(T, -Inf, betas) == 0.3 * 4
        @test expected_score(T, 0.0, beta) == irf(T, 0.0, beta, 1)
    end

    @testset "information" begin
        betas = fill((a = 1.0, b = 0.0, c = 0.0), 3)
        @test information(T, 0.0, betas) == 0.25 * 3
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0

        beta = (a = 1.3, b = 0.0, c = 0.2)
        betas = fill(beta, 3)
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0
        @test information(T, 0.0, beta) == sum(iif(T, 0.0, beta, y) for y in 0:1)
    end

    @testset "properties" begin
        M = Data.Just(ThreePL)

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
