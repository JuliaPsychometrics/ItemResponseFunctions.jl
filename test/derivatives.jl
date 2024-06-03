import ForwardDiff

function test_derivatives(M, beta)
    theta = rand()

    # test against FivePL which uses autodiff
    for y in 0:1
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
    end
end

@testset "derivatives" begin
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
    end

    @testset "GPCM" begin
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
end
