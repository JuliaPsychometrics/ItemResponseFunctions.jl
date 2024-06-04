import ForwardDiff

function test_derivatives(M::Type{<:DichotomousItemResponseModel}, beta)
    theta = rand()

    for y in 0:1
        # equivalency to 5PL
        @test derivative_theta(M, theta, beta, y)[1] ≈
              derivative_theta(FivePL, theta, beta, y)[1]
        @test derivative_theta(M, theta, beta, y)[2] ≈
              derivative_theta(FivePL, theta, beta, y)[2]

        @test second_derivative_theta(M, theta, beta, y)[1] ≈
              second_derivative_theta(FivePL, theta, beta, y)[1]
        @test second_derivative_theta(M, theta, beta, y)[2] ≈
              second_derivative_theta(FivePL, theta, beta, y)[2]
        @test second_derivative_theta(M, theta, beta, y)[3] ≈
              second_derivative_theta(FivePL, theta, beta, y)[3]

        # equivalency of methods
        @test derivative_theta(M, theta, beta, y)[1] ≈
              derivative_theta(M, theta, beta)[1][y+1]
        @test derivative_theta(M, theta, beta, y)[2] ≈
              derivative_theta(M, theta, beta)[2][y+1]

        @test second_derivative_theta(M, theta, beta, y)[1] ≈
              second_derivative_theta(M, theta, beta)[1][y+1]
        @test second_derivative_theta(M, theta, beta, y)[2] ≈
              second_derivative_theta(M, theta, beta)[2][y+1]
        @test second_derivative_theta(M, theta, beta, y)[3] ≈
              second_derivative_theta(M, theta, beta)[3][y+1]
    end
end

function test_derivatives(M::Type{<:PolytomousItemResponseModel}, beta)
    theta = rand()

    categories = 1:(length(beta.t)+1)

    for c in categories
        # equivalency of methods
        @test derivative_theta(M, theta, beta, c)[1] ≈
              derivative_theta(M, theta, beta)[1][c]
        @test derivative_theta(M, theta, beta, c)[2] ≈
              derivative_theta(M, theta, beta)[2][c]

        @test second_derivative_theta(M, theta, beta, c)[1] ≈
              second_derivative_theta(M, theta, beta)[1][c]
        @test second_derivative_theta(M, theta, beta, c)[2] ≈
              second_derivative_theta(M, theta, beta)[2][c]
        @test second_derivative_theta(M, theta, beta, c)[3] ≈
              second_derivative_theta(M, theta, beta)[3][c]
    end
end

@testset "derivatives" begin
    @testset "FivePL" begin
        beta = (a = 2.3, b = 0.1, c = 0.1, d = 0.95, e = 0.88)
        test_derivatives(FivePL, beta)
    end

    @testset "FourPL" begin
        beta = (a = 2.3, b = 0.1, c = 0.1, d = 0.95, e = 1)
        test_derivatives(FourPL, beta)
    end

    @testset "ThreePL" begin
        beta = (a = 2.3, b = 0.1, c = 0.1, d = 1, e = 1)
        test_derivatives(ThreePL, beta)
    end

    @testset "TwoPL" begin
        beta = (a = 2.3, b = 0.1, c = 0, d = 1, e = 1)
        test_derivatives(TwoPL, beta)
    end

    @testset "OnePLG" begin
        beta = (a = 1, b = 0.1, c = 0.15, d = 1, e = 1)
        test_derivatives(OnePLG, beta)
    end

    @testset "OnePL" begin
        beta = (a = 1, b = 0.1, c = 0, d = 1, e = 1)
        test_derivatives(OnePL, beta)
        @test all(
            derivative_theta(OnePL, 0.0, 0.1, 1) .≈ derivative_theta(OnePL, 0.0, beta, 1),
        )
        @test all(
            second_derivative_theta(OnePL, 0.0, 0.1, 1) .≈
            second_derivative_theta(OnePL, 0.0, beta, 1),
        )

        @test derivative_theta(OnePL, 0.0, 0.1)[1] == derivative_theta(OnePL, 0.0, beta)[1]
        @test derivative_theta(OnePL, 0.0, 0.1)[2] == derivative_theta(OnePL, 0.0, beta)[2]
    end

    @testset "GPCM" begin
        beta = (a = 1.3, b = 0.0, t = (0.2, -0.2))
        test_derivatives(GPCM, beta)

        # equivalency to 2PL
        beta_poly = (a = 1.2, b = 0.0, t = (-0.2))
        beta_dich = (a = 1.2, b = 0.2)

        derivs_2pl = derivative_theta(TwoPL, 0.0, beta_dich)
        derivs_gpcm = derivative_theta(GPCM, 0.0, beta_poly)
        @test all(derivs_2pl[1] .≈ derivs_gpcm[1])  # probs
        @test all(derivs_2pl[2] .≈ derivs_gpcm[2])  # derivs

        derivs2_2pl = second_derivative_theta(TwoPL, 0.0, beta_dich)
        derivs2_gpcm = second_derivative_theta(GPCM, 0.0, beta_poly)

        @test all(derivs2_2pl[1] .≈ derivs2_gpcm[1])  # probs
        @test all(derivs2_2pl[2] .≈ derivs2_gpcm[2])  # derivs
        @test all(derivs2_2pl[3] .≈ derivs2_gpcm[3])  # second derivs

        @test all(derivs_gpcm[1] .≈ derivs2_gpcm[1])  # probs
        @test all(derivs_gpcm[2] .≈ derivs2_gpcm[2])  # derivs
    end

    @testset "PCM" begin
        beta = (a = 0.23, b = 1.48, t = randn(3))
        test_derivatives(PCM, beta)
    end

    @testset "GRSM" begin
        beta = (a = 0.23, b = 1.48, t = randn(3))
        test_derivatives(GRSM, beta)
    end

    @testset "RSM" begin
        beta = (a = 0.23, b = 1.48, t = randn(3))
        test_derivatives(RSM, beta)
    end
end
