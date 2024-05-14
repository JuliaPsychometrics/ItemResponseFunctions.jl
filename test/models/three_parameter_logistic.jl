@testset "ThreeParameterLogisticModel" begin
    T = ThreeParameterLogisticModel

    @testset "irf" begin
        beta = (a = 1.5, b = 0.0, c = 0.2)
        @test irf(T, 0.0, beta) ≈ 0.5 + beta.c / 2
        @test irf(T, Inf, beta) == 1.0
        @test irf(T, -Inf, beta) == beta.c
    end

    @testset "iif" begin
        beta = (a = 1.0, b = 0.0, c = 0.0)
        @test iif(T, 0.0, beta) == 0.25
        @test iif(T, Inf, beta) == 0.0
        @test iif(T, -Inf, beta) == 0.0

        beta = (a = 1.5, b = 0.0, c = 0.25)
        @test iif(T, Inf, beta) == 0.0
        @test iif(T, -Inf, beta) == 0.0
    end

    @testset "expected_score" begin
        betas = fill((a = 1.0, b = 0.0, c = 0.0), 4)
        @test expected_score(T, 0.0, betas) == 2.0
        @test expected_score(T, Inf, betas) == 4.0
        @test expected_score(T, -Inf, betas) == 0.0

        betas = fill((a = 1.5, b = 0.0, c = 0.3), 4)
        @test expected_score(T, 0.0, betas) ≈ (0.5 + betas[1].c / 2) * 4
        @test expected_score(T, Inf, betas) == 4.0
        @test expected_score(T, -Inf, betas) == 0.3 * 4
    end

    @testset "information" begin
        betas = fill((a = 1.0, b = 0.0, c = 0.0), 3)
        @test information(T, 0.0, betas) == 0.25 * 3
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0

        betas = fill((a = 1.3, b = 0.0, c = 0.2), 3)
        @test information(T, Inf, betas) == 0.0
        @test information(T, -Inf, betas) == 0.0
    end
end
