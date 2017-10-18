module DLX

include("one-hot.jl")

import Base.*

export search_root, init, solve_cover, get_cover, one_hot

abstract type Left end
abstract type Right end
abstract type Up end
abstract type Down end

next(::Type{Left},  it) = it.left
next(::Type{Right}, it) = it.right
next(::Type{Up},    it) = it.up
next(::Type{Down},  it) = it.down

mutable struct Linked{T}
    first
    sentinel
end

Base.start{T}(iter::Linked{T}) = iter.first
Base.done{T}(iter::Linked{T}, state) = (state == iter.sentinel)
Base.next{T}(iter::Linked{T}, state) = (state, next(T, state))

function circular(T, head)
    Linked{T}(next(T, head), head)
end

abstract type ColumnHead end
abstract type RowHead end

mutable struct Root <: RowHead
    left
    right
    function Root()
        self = new()
        self.left = self.right = self
        self
    end
end

mutable struct Column <: ColumnHead
    right
    left
    up
    down
    size
    ci
    function Column(ci)
        self = new()
        self.ci = ci
        self.size = 0
        self.left = self.right = self.up = self.down = self
        self
    end
end

mutable struct Row
    head
    ri
    function Row(ri)
        self = new()
        self.ri = ri
        self.head = nothing
        self
    end
end

function push(head::ColumnHead, it)
    head.up.down = it
    it.up = head.up
    it.down = head
    head.up = it
end

function push(head::Column, it)
    invoke(push, Tuple{ColumnHead, Any}, head, it)
    head.size += 1
end

function push(head::RowHead, it) 
    head.left.right = it
    it.left = head.left
    it.right = head
    head.left = it
end

function push(row::Row, it)
    if row.head == nothing
        row.head = it
    else
        invoke(push, Tuple{RowHead, Any}, row.head, it)
    end
end

mutable struct Node <: RowHead
    left
    right
    up
    down
    row
    col
    function Node(row, col)
        self = new()
        self.row = row
        self.col = col
        self.left = self.right = self.up = self.down = self
        self
    end
end

function init(nrows, ncols, is_constraint)
    root = Root()
    for ci in 1:ncols
        push(root, Column(ci))
    end

    for ri in 1:nrows
        row = Row(ri)
        for (ci, col) in enumerate(circular(Right, root))
            if !is_constraint(ri, ci)
                continue
            end

            it = Node(row, col)
            push(row, it)
            push(col, it)
        end
    end

    root
end

function search_root(root)::Array{Array{Integer, 1}, 1}
    results = Array{Array{Integer, 1}, 1}()
    rows = []

    function search_root_(root, rows, n)
        if root.right == root
            push!(results, copy(rows))
            return
        end
        col = choose_column(root)
        cover(col)
        res =[]
        for row in circular(Down, col)
            push!(rows, row.row.ri)
            for j in circular(Right, row)
                cover(j.col)
            end
            search_root_(root, rows, n + 1)
            for j in circular(Left, row)
                uncover(j.col)
            end
            pop!(rows)
        end
        uncover(col)
        return
    end
    search_root_(root, rows, 0)

    return(results)
end
    
function cover(col)
    col.right.left = col.left
    col.left.right = col.right
    for i in circular(Down, col)
        for j in circular(Right, i)
            j.down.up = j.up
            j.up.down = j.down
            j.col.size -= 1
        end
    end
end

function uncover(col)
    for i in circular(Up, col)
        for j in circular(Left, i)
            j.col.size += 1
            j.down.up = j
            j.up.down = j
        end
    end
    col.right.left = col
    col.left.right = col
end

function choose_column(root)
    root.right
end

end # module DLX
