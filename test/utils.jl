@testset "utils" begin
    @testset "check_pars" begin
        # all merged pars should pass
        beta = (a = 1.2, b = 0.2, c = 0.1, d = 0.8, e = 1.4, t = zeros(3))
        @test check_pars(OnePL, ItemParameters(OnePL, beta))
        @test check_pars(TwoPL, ItemParameters(TwoPL, beta))
        @test check_pars(ThreePL, ItemParameters(ThreePL, beta))
        @test check_pars(FourPL, ItemParameters(FourPL, beta))
        @test check_pars(FivePL, ItemParameters(FivePL, beta))
        @test check_pars(PCM, ItemParameters(PCM, beta))
        @test check_pars(GPCM, ItemParameters(GPCM, beta))
        @test check_pars(RSM, ItemParameters(RSM, beta))
        @test check_pars(GRSM, ItemParameters(GRSM, beta))

        @test_throws "a != 1" check_pars(OnePL, beta)
        @test_throws "c != 0" check_pars(TwoPL, beta)
        @test_throws "d != 1" check_pars(ThreePL, beta)
        @test_throws "e != 1" check_pars(FourPL, beta)

        @test_throws "c must be in interval (0, 1)" check_pars(
            ThreePL,
            (; a = 1.0, c = -0.2, d = 1.0, e = 1.0),
        )

        @test_throws "d must be in interval (0, 1)" check_pars(
            FourPL,
            (; a = 1.0, c = 0.2, d = 1.2, e = 1.0),
        )

        @test_throws "smaller than upper asymptote" check_pars(
            FourPL,
            (; a = 1.0, c = 0.8, d = 0.2, e = 1.0),
        )

        @test_throws "e must be positive" check_pars(
            FivePL,
            (; a = 1.0, c = 0.0, d = 1.0, e = -1.0),
        )

    end
end
