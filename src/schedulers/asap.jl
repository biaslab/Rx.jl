export AsapScheduler

import Base: show, similar

"""
    AsapScheduler

`AsapScheduler` executes scheduled actions as soon as possible and does not introduce any additional logic.
`AsapScheduler` is a default scheduler for almost all observables.
"""
struct AsapScheduler <: AbstractScheduler end

Base.show(io::IO, ::AsapScheduler) = print(io, "AsapScheduler()")

Base.similar(::AsapScheduler) = AsapScheduler()

makeinstance(::Type, ::AsapScheduler) = AsapScheduler()

instancetype(::Type, ::Type{<:AsapScheduler}) = AsapScheduler

scheduled_subscription!(source, actor, instance::AsapScheduler) = on_subscribe!(source, actor, instance)

scheduled_next!(actor, value, ::AsapScheduler) = on_next!(actor, value)
scheduled_error!(actor, err, ::AsapScheduler)  = on_error!(actor, err)
scheduled_complete!(actor, ::AsapScheduler)    = on_complete!(actor)
