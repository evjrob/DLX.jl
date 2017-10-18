include("../DLX.jl")
using DLX

function test()
    ex = [0 0 1 0 1 1 0
          1 0 0 1 0 0 1
          0 1 1 0 0 1 0
          1 0 0 1 0 0 0
          0 1 0 0 0 0 1
          0 0 0 1 1 0 1]
    f = (ri, ci) -> (ex[ri, ci] == 1)
    root = init(size(ex)..., f)
    return (search_root(root))
end

print(test())
