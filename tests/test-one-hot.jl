include("../DLX.jl")
using DLX

x = ["hola", "chao", "niña", "bonita"]

y = [["hola", "chao"],
     ["chao", "hola", "bonita"],
     ["chao", "bonita"],
     ["hola", "niña"]]

a = one_hot(x, y)

for arr in get_cover(a)
    println(arr)
end
