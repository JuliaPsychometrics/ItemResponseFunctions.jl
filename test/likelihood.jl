@testset "likelihood" begin
    betas = [(; b = 0.0) for _ in 1:4]
    @test likelihood(OnePL, Inf, betas, ones(length(betas))) == 1.0
    @test likelihood(OnePL, -Inf, betas, ones(length(betas))) == 0.0

    @test likelihood(OnePL, Inf, betas, zeros(length(betas))) == 0.0
    @test likelihood(OnePL, -Inf, betas, zeros(length(betas))) == 1.0

    @test loglikelihood(OnePL, Inf, betas, ones(length(betas))) == 0.0
    @test loglikelihood(OnePL, -Inf, betas, ones(length(betas))) == -Inf
end
