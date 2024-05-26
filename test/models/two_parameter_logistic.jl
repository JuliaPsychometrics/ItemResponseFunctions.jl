@testset "TwoParameterLogisticModel" begin
    T = TwoParameterLogisticModel

    @test has_discrimination(T) == true
    @test has_lower_asymptote(T) == false
    @test has_upper_asymptote(T) == false

    @testset "irf" begin
        @test irf(T, 0.0, (a = 1.5, b = 0.0), 1) == 0.5
        @test irf(T, Inf, (a = 1.5, b = 0.0), 1) == 1.0
        @test irf(T, -Inf, (a = 1.5, b = 0.0), 1) == 0.0
        @test irf(T, 0.0, (a = 1.5, b = 0.0)) == [0.5, 0.5]
    end

    @testset "iif" begin
        @test iif(T, 0.0, (a = 1.0, b = 0.0)) == [0.125, 0.125]
        @test iif(T, Inf, (a = 1.0, b = 0.0)) == [0.0, 0.0]
        @test iif(T, -Inf, (a = 1.0, b = 0.0)) == [0.0, 0.0]
        @test iif(T, 0.0, (a = 1.5, b = 0.0), 1) == 1.5^2 * 0.125
    end

    @testset "expected_score" begin
        beta = (a = 2.0, b = 0.0)
        betas = fill(beta, 5)
        @test expected_score(T, 0.0, betas) == 2.5
        @test expected_score(T, Inf, betas) == 5.0
        @test expected_score(T, -Inf, betas) == 0.0
        @test expected_score(T, 0.0, beta) == irf(T, 0.0, beta, 1)
    end

    @testset "information" begin
        beta = (a = 1.5, b = 0.0)
        betas = fill(beta, 5)
        @test information(T, 0.0, betas) == 1.5^2 * 0.25 * 5
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0
        @test information(T, 0.0, beta) == sum(iif(T, 0.0, beta, y) for y in 0:1)
    end
end
