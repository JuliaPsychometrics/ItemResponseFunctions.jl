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
    repo = "https://github.com/p-gw/ItemResponseFunctions.jl/blob/{commit}{path}#{line}",
    sitename = "ItemResponseFunctions.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://p-gw.github.io/ItemResponseFunctions.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md", "API" => "api.md"],
    plugins = [],
)

deploydocs(; repo = "github.com/p-gw/ItemResponseFunctions.jl", devbranch = "main")
