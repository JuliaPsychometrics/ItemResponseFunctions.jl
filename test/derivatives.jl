function test_derivatives(M, beta)
    # test against FivePL which uses autodiff
    for theta in randn(10)
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
    end
end
