@testset "ItemParameters" begin
    # default construction
    pars = ItemParameters(OnePL, b = 0.0)
    @test pars.a == 1.0
    @test pars.b == 0.0
    @test pars.c == 0.0
    @test pars.d == 1.0
    @test pars.e == 1.0
    @test pars.t == ()

    # default values should match typeof(beta.b)
    for T in [Float16, Float32, Float64]
        pars = ItemParameters(OnePL, zero(T))
        @test pars.a isa T
        @test pars.b isa T
        @test pars.c isa T
        @test pars.d isa T
        @test pars.e isa T
    end

    # construction from tuple
    beta_tuple = (a = 1.2, b = 0.2, c = 0.4)

    pars = ItemParameters(OnePL, beta_tuple)
    @test pars.a == 1.0
    @test pars.b == beta_tuple.b
    @test pars.c == 0.0

    pars = ItemParameters(ThreePL, beta_tuple)
    @test pars.a == beta_tuple.a
    @test pars.b == beta_tuple.b
    @test pars.c == beta_tuple.c

    # construction from Real
    pars = ItemParameters(FourPL, 1.3)
    @test pars.b == 1.3
end
