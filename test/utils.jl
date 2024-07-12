@testset "utils" begin
    @testset "merge_pars" begin
        # default values should match typeof(beta.b)
        for T in [Float16, Float32, Float64]
            pars = merge_pars(OnePL, zero(T))
            @test pars.a isa T
            @test pars.b isa T
            @test pars.c isa T
            @test pars.d isa T
            @test pars.e isa T
        end
    end

    @testset "checkpars" begin
        # all merged pars should pass
        beta = (a = 1.2, b = 0.2, c = 0.1, d = 0.8, e = 1.4, t = zeros(3))
        @test checkpars(OnePL, merge_pars(OnePL, beta))
        @test checkpars(TwoPL, merge_pars(TwoPL, beta))
        @test checkpars(ThreePL, merge_pars(ThreePL, beta))
        @test checkpars(FourPL, merge_pars(FourPL, beta))
        @test checkpars(FivePL, merge_pars(FivePL, beta))
        @test checkpars(PCM, merge_pars(PCM, beta))
        @test checkpars(GPCM, merge_pars(GPCM, beta))
        @test checkpars(RSM, merge_pars(RSM, beta))
        @test checkpars(GRSM, merge_pars(GRSM, beta))

        @test_throws "a != 1" checkpars(OnePL, beta)
        @test_throws "c != 0" checkpars(TwoPL, beta)
        @test_throws "d != 1" checkpars(ThreePL, beta)
        @test_throws "e != 1" checkpars(FourPL, beta)

        @test_throws "c must be in interval (0, 1)" checkpars(
            ThreePL,
            (; a = 1.0, c = -0.2, d = 1.0, e = 1.0),
        )

        @test_throws "d must be in interval (0, 1)" checkpars(
            FourPL,
            (; a = 1.0, c = 0.2, d = 1.2, e = 1.0),
        )

        @test_throws "smaller than upper asymptote" checkpars(
            FourPL,
            (; a = 1.0, c = 0.8, d = 0.2, e = 1.0),
        )

        @test_throws "e must be positive" checkpars(
            FivePL,
            (; a = 1.0, c = 0.0, d = 1.0, e = -1.0),
        )

    end
end
