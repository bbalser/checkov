# Used by "mix format"
[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [where: :*],
  export: [
    locals_without_parens: [where: :*]
  ]
]
