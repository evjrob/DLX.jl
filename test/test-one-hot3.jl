include("../src/DLX.jl")
using DLX

# in the case there is no solution without overlap

x = ["hola", "chao", "niña", "bonita"]

y = [["hola", "chao"],
     ["chao", "hola", "bonita"],
     ["chao", "bonita", "niña"],
     ["hola", "niña"]]

a = one_hot(x, y)
get_cover(a)

println(get_cover(a))
