using ItemResponseFunctions
using Documenter

DocMeta.setdocmeta!(
    ItemResponseFunctions,
    :DocTestSetup,
    :(using ItemResponseFunctions);
    recursive = true,
)

makedocs(;
    checkdocs = :exported,
    modules = [ItemResponseFunctions],
    authors = "Philipp Gewessler",
    sitename = "ItemResponseFunctions.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://juliapsychometrics.github.io/ItemResponseFunctions.jl",
        edit_link = "main",
        repolink = "https://github.com/JuliaPsychometrics/ItemResponseFunctions.jl/blob/{commit}{path}#{line}",
        assets = String[],
    ),
    pages = ["Home" => "index.md", "API" => "api.md"],
    plugins = [],
)

deploydocs(;
    repo = "github.com/JuliaPsychometrics/ItemResponseFunctions.jl",
    devbranch = "main",
)
