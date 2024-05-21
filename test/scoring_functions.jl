@testset "scoring functions" begin
    @testset "partial_credit" begin
        f = partial_credit(3)
        @test f(1) == 0.0
        @test f(2) == 0.5
        @test f(3) == 1.0

        f = partial_credit(3; max_score = 2)
        @test f(1) == 0.0
        @test f(2) == 0.5 * 2
        @test f(3) == 1.0 * 2
    end
end
