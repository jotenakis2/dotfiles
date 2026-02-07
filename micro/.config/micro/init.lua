function init()
    linter.makeLinter("nixfmt", "nix", "nixfmt", {"%f"}, "%f:%l:%c: %m")
end
