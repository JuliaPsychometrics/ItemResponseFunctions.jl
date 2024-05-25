using PrecompileTools: @setup_workload, @compile_workload

@setup_workload begin
    models = [OnePL, OnePLG, TwoPL, ThreePL, FourPL, FivePL, PCM, GPCM, RSM, GRSM]
    beta = (a = 1.0, b = 0.0, c = 0.0, d = 1.0, e = 1.0, t = zeros(3))
    betas = fill(beta, 3)

    @compile_workload begin
        for model in models
            irf(model, 0.0, beta, 1)
            irf(model, 0.0, beta)
            iif(model, 0.0, beta, 1)
            iif(model, 0.0, beta)
            expected_score(model, 0.0, betas)
            information(model, 0.0, betas)
        end
    end
end
