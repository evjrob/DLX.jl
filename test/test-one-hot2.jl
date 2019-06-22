include("../src/DLX.jl")
using DLX

## in the case when there is no solution

x = ["hola", "chao", "niña", "bonita", "fea"]

y = [["hola", "chao"],
     ["chao", "hola", "bonita"],
     ["chao", "bonita"],
     ["hola", "niña"]]

a = one_hot(x, y)
get_cover(a)

println(get_cover(a))

