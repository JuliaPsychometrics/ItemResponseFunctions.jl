@testset "OneParameterLogisticModel" begin
    T = OneParameterLogisticModel

    @test has_discrimination(T) == false
    @test has_lower_asymptote(T) == false
    @test has_upper_asymptote(T) == false

    @testset "irf" begin
        @test irf(T, 0.0, 0.0, 1) == 0.5
        @test irf(T, 0.0, 0.0, 0) == 0.5
        @test irf(T, 0.0, -Inf, 1) == 1.0
        @test irf(T, 0.0, Inf, 1) == 0.0

        @test irf(T, 0.0, 0.0) == [0.5, 0.5]
        @test irf(T, -Inf, 0.0) == [1.0, 0.0]
        @test irf(T, Inf, 0.0) == [0.0, 1.0]

        beta = (; b = 0.0)
        @test irf(T, 0.0, beta, 1) == 0.5
        @test irf(T, 0.0, beta, 0) == 0.5
        @test irf(T, -Inf, beta, 1) == 0.0
        @test irf(T, Inf, beta, 1) == 1.0

        @test irf(T, 0.0, beta) == [0.5, 0.5]
        @test irf(T, -Inf, beta) == [1.0, 0.0]
        @test irf(T, Inf, beta) == [0.0, 1.0]
    end

    @testset "iif" begin
        @test iif(T, 0.0, 0.0) == [0.125, 0.125]
        @test iif(T, 0.0, Inf) == [0.0, 0.0]
        @test iif(T, 0.0, -Inf) == [0.0, 0.0]

        for y in 0:1
            @test iif(T, 0.0, 0.0, y) == 0.125
            @test iif(T, 0.0, Inf, y) == 0.0
            @test iif(T, 0.0, -Inf, y) == 0.0
        end

        beta = (; b = 0.0)
        @test iif(T, 0.0, beta) == [0.125, 0.125]
        @test iif(T, Inf, beta) == [0.0, 0.0]
        @test iif(T, -Inf, beta) == [0.0, 0.0]

        for y in 0:1
            @test iif(T, 0.0, beta, y) == 0.125
            @test iif(T, Inf, beta, y) == 0.0
            @test iif(T, -Inf, beta, y) == 0.0
        end
    end

    @testset "expected_score" begin
        @test expected_score(T, 0.0, zeros(3)) == 1.5
        @test expected_score(T, 0.0, fill(-Inf, 3)) == 3.0

        betas = fill((; b = 0.0), 3)
        @test expected_score(T, 0.0, betas) == 1.5
        @test expected_score(T, Inf, betas) == 3.0
        @test expected_score(T, 0.0, betas; scoring_function = x -> 2x) == 3.0

        @test expected_score(T, 0.0, 0.0) == irf(T, 0.0, 0.0, 1)
    end

    @testset "information" begin
        @test information(T, 0.0, zeros(3)) == 0.75
        @test information(T, 0.0, fill(Inf, 3)) == 0.0

        betas = fill((; b = 0.0), 3)
        @test information(T, 0.0, betas) == 0.25 * 3
        @test information(T, Inf, betas) == 0.0

        @test information(T, 0.0, 0.0) == sum(iif(T, 0.0, 0.0, y) for y in 0:1)
    end
end
