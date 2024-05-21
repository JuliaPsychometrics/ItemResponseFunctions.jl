function partial_credit(n; max_score = 1)
    return x -> (x - 1) / (n - 1) * max_score
end
