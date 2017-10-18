"""
Structure used to store the arrays and convert them to one-hot encoding
"""
struct one_hot
    x::Array{String,1}
    y::Array{Array{String,1}, 1}
    M::Array{Int64, 2} # the actual one-hot matrix

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


"""
`ex::one_hot` type with x and y arrays of strings and M matrix
returns the indicies of the arrays in `ex` which cover `x`
"""
function solve_cover(ex::one_hot)
    f = (ri, ci) -> (ex.M[ri, ci] == 1)
    root = init(size(ex.M)..., f)
    return (search_root(root))
end

"""
Returns the actual cover sets for `ex::one_hot`
"""
function get_cover(ex::one_hot)::Array{Array{Array{String, 1}, 1}, 1}
    cover_sets = solve_cover(ex)
    if length(cover_sets) >0
        return get_cover(ex, cover_sets)
    else
        return (Array{Array{Array{String, 1}, 1}, 1}())
    end
end

# depending on the number of responses return one or multiple

function get_cover(ex::one_hote,
                   sol::Array{Integer,1})::Array{Array{Array{String, 1}, 1}, 1}
    return ([[ex.y[i] for i in sol][1]])
end

function get_cover(ex::one_hot,
                   sol::Array{Array{Integer,1},1})::Array{Array{Array{String, 1}, 1}, 1}
    covers = Array{Array{Array{String, 1}, 1}, 1}()
    for covs in sol # iterate over each cover solution
        sets = Array{Array{String, 1}, 1}()
        for j in covs # iterate for sets in each solution
            sets = vcat(sets, [ex.y[j]])
        end
        covers = vcat(covers, [sets])
    end
    return (covers)
end
