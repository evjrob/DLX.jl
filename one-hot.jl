struct one_hot
    x::Array{String,1}
    y::Array{Array{String,1}, 1}
    M::Array{Int64, 2}

    function one_hot(x::Array{String, 1}, y::Array{Array{String,1}, 1})
        M = fill(0,length(y),length(x))
        x = sort(x)
        y = [sort(e) for e in y]

        for (j, sset) in enumerate(y)
            for (i, e) in enumerate(x)
                if e in sset
                    M[j,i]=1
                end
            end
        end
        new(x, y, M)
    end
end

function solve_cover(ex::one_hot)
    f = (ri, ci) -> (ex.M[ri, ci] == 1)
    root = init(size(ex.M)..., f)
    return (search_root(root))
end

function get_cover(ex::one_hot)
    cover_sets = solve_cover(ex)
    return ([ex.y[i] for i in cover_sets][1])
end
