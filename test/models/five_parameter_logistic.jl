@testset "FiveParameterLogisticModel" begin
    T = FivePL

    @test has_discrimination(T) == true
    @test has_lower_asymptote(T) == true
    @test has_upper_asymptote(T) == true
    @test has_asymmetry(T) == true
end
