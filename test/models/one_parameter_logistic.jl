@testset "OneParameterLogisticModel" begin
    T = OneParameterLogisticModel
    @testset "irf" begin
        @test irf(T, 0.0, 0.0, 1) == 0.5
        @test irf(T, 0.0, 0.0, 0) == 0.5
        @test irf(T, 0.0, -Inf, 1) == 1.0
        @test irf(T, 0.0, Inf, 1) == 0.0
    end

    @testset "iif" begin
        @test iif(T, 0.0, 0.0, 1) == 0.25
        @test iif(T, 0.0, Inf, 1) == 0.0
        @test iif(T, 0.0, -Inf, 1) == 0.0
    end

    @testset "expected_score" begin
        @test expected_score(T, 0.0, zeros(3)) == 1.5
        @test expected_score(T, 0.0, fill(-Inf, 3)) == 3.0
        @test expected_score(T, 0.0, zeros(3), scoring_function = y -> 2y) == 3.0
    end

    @testset "information" begin
        @test information(T, 0.0, zeros(3)) == 0.75
        @test information(T, 0.0, fill(Inf, 3)) == 0.0
        @test information(T, 0.0, zeros(3), scoring_function = y -> 2y) == 3.0
    end
end
