@testset "GeneralizedPartialCreditModel" begin
    @testset "irf" begin
        beta = (a = 1.0, b = 0.0, t = zeros(3))
        @test length(irf(GPCM, 0.0, beta)) == length(beta.t) + 1
        @test sum(irf(GPCM, 0.0, beta)) ≈ 1.0
        @test irf(GPCM, 0.0, beta) == fill(0.25, 4)
        @test irf(GPCM, -Inf, beta) == [1.0, 0.0, 0.0, 0.0]
        @test irf(GPCM, Inf, beta) == [0.0, 0.0, 0.0, 1.0]
    end

    @testset "iif" begin

    end

    @testset "expected_score" begin

    end

    @testset "information" begin

    end
end
