@testset "FiveParameterLogisticModel" begin
    T = FivePL

    @test has_discrimination(T) == true
    @test has_lower_asymptote(T) == true
    @test has_upper_asymptote(T) == true
    @test has_stiffness(T) == true

    @testset "properties" begin
        M = Data.Just(FivePL)

        @check irf_is_monotone(M, floatgen, itempargen, positivefloatgen)
        @check irf_approaches_lower_asymptote(M, floatgen, itempargen)
        @check irf_approaches_upper_asymptote(M, floatgen, itempargen)
        @check irf_probabilities_sum_to_one(M, floatgen, itempargen)

        @check expected_score_is_monotone(M, floatgen, testgen, positivefloatgen)
        @check expected_score_approaches_minimum_score(M, floatgen, testgen)
        @check expected_score_approaches_maximum_score(M, floatgen, testgen)
        @check expected_score_is_additive(M, floatgen, testgen)
    end
end
