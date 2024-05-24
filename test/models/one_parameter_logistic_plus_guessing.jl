@testset "OneParameterLogisticPlusGuessingModel" begin
    T = OneParameterLogisticPlusGuessingModel

    @test has_discrimination(T) == false
    @test has_lower_asymptote(T) == true
    @test has_upper_asymptote(T) == false

    @testset "irf" begin
        @test irf(T, 0.0, (; b = 0.0, c = 0.0), 1) == 0.5
        @test irf(T, 0.0, (; b = 0.0, c = 0.0), 0) == 0.5
        @test irf(T, -Inf, (; b = 0.0, c = 0.0), 1) == 0.0
        @test irf(T, Inf, (; b = 0.0, c = 0.0), 1) == 1.0

        @test irf(T, -Inf, (; b = 0.0, c = 0.2), 1) == 0.2
        @test irf(T, Inf, (; b = 0.0, c = 0.2), 1) == 1.0
    end

    @testset "iif" begin
        beta = (b = 0.0, c = 0.0)
        @test iif(T, 0.0, beta, 1) == 0.25
        @test iif(T, -Inf, beta, 1) == 0.0
        @test iif(T, Inf, beta, 1) == 0.0

        beta = (b = 0.0, c = 0.1)
        @test iif(T, -Inf, beta, 1) == 0.0
        @test iif(T, Inf, beta, 1) == 0.0
    end

    @testset "expected_score" begin
        beta = (b = 0.0, c = 0.2)
        betas = fill(beta, 10)
        @test expected_score(T, 0.0, betas) ≈ 0.6 * 10
        @test expected_score(T, -Inf, betas) ≈ 0.2 * 10
        @test expected_score(T, Inf, betas) ≈ 1.0 * 10
    end

    @testset "information" begin
        beta = (b = 0.0, c = 0.25)
        betas = fill(beta, 5)
        @test information(T, -Inf, betas) == 0.0
        @test information(T, Inf, betas) == 0.0
    end
end
