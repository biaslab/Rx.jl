export SingleObservable, on_subscribe!, of

"""
    SingleObservable{D}

SingleObservable wraps single value of any type into a synchronous observable

# See also: [`Subscribable`](@ref), [`of`](@ref)
"""
struct SingleObservable{D} <: Subscribable{D}
    value :: D
end

function on_subscribe!(observable::SingleObservable{D}, actor::A) where { A <: AbstractActor{D} } where D
    next!(actor, observable.value)
    complete!(actor)
    return VoidTeardown()
end

"""
    of(x)

Creates a SingleObservable that emits a single value x and then completes.

# Arguments
- `x`: value to be emmited before completion

# Examples

```jldoctest
using Rx

source = of(1)
subscribe!(source, LoggerActor{Int}())
;

# output

[LogActor] Data: 1
[LogActor] Completed

```

"""
of(x::T) where T = SingleObservable{T}(x)
