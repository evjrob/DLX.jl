# dancing-links-julia
Implementation of algorithm X in Julia

The implementation I took this from can be found [here](https://github.com/apribadi/dancing-links-julia), however, that code does not work any longer and the package looks unmantained. The original Knuth paper can be found [here](https://www.ocf.berkeley.edu/~jchu/publicportal/sudoku/0011047.pdf).

The main point of this package is to easily solve the exact cover problem for sets of strings (though you can use anything really). Say you have a set `X = ["hola", "chao", "niña", "bonita"]`, and a series of subsets: `Y = [["hola", "chao"], ["chao", "hola", "bonita"], ["chao", "bonita"], ["hola", "niña"]]`, and you would like to know which of the subsets in Y cover X exactly, while being non-overlapping.

The interface is a simple as:

```
include("DLX.jl")
using DLX

x = ["hola", "chao", "niña", "bonita"]

y = [["hola", "chao"],
     ["chao", "hola", "bonita"],
     ["chao", "bonita"],
     ["hola", "niña"]]

a = one_hot(x, y)
get_cover(a)
```


