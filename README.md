# Reactive extensions library for Julia

Rx.jl is a Julia package for reactive programming using Observables, to make it easier to work with asynchronous data.

In order to achieve best performance and convenient API Rx.jl combines [Observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), [Actor model](https://en.wikipedia.org/wiki/Actor_model) and [Functional programming](https://en.wikipedia.org/wiki/Functional_programming).

Inspired by [RxJS](https://github.com/ReactiveX/rxjs) and [ReactiveX](https://github.com/ReactiveX) community.

Rx.jl has been designed with a focus on performance and modularity.

The essential concepts in Rx.jl are:

- __Observable__: represents a collection of future messages (data or/and events).
- __Actor__: is an object that knows how to react on incoming messages delivered by the __Observable__.
- __Subscription__: represents a teardown logic which might be useful for cancelling the execution of an __Observable__.
- __Operators__: are objects that enable a functional programming style to dealing with collections with operations like `map`, `filter`, `reduce`, etc.
- __Subject__: the way of multicasting a message to multiple Observers.

## Documentation

A full documentation is available at ???

It is also possible to build a documentation locally. Just use

```bash
$ julia make.jl
```

in the `docs/` directory to build local version of the documentation.

## First example

Normally you use an arrays for processing some data.

```Julia
for value in array_of_values
    doSomethingWithMyData(value)
end
```

In Rx.jl you will use an observable.

```Julia
subscription = subscribe!(source_of_values, LambdaActor{TypeOfData}(
    on_next  = (data)  -> doSomethingWithMyData(data),
    on_error = (error) -> doSomethingWithAnError(error),
    complete = ()      -> println("Completed! You deserve some coffee man")
))
```

At some point of time you may decide to stop listening for new messages.

```Julia
unsubscribe!(subscription)
```

| Tip | Do not use lambda functions for real computations as it lacks of performance. Use an Actor based approach instead. |
| --- | - |

## Actors

To process messages from an observable you have to define an Actor that know how to react on incoming messages.

```Julia
struct MyActor <: Rx.Actor{Int} end

Rx.on_next!(actor::MyActor, data::Int) = doSomethingWithMyData(data)
Rx.on_error!(actor::MyActor, error)    = doSomethingWithAnError(error)
Rx.on_complete!(actor::MyActor)        = println("Completed!")
```

Actor can also have its own local state

```Julia
struct StoreActor{D} <: Rx.Actor{}
    values::Array{D, 1}

    StoreActor{D}() where D = new(Array{D, 1}())
end

Rx.on_next!(actor::StoreActor{D}, data::D) where D = push!(actor.values, data)
Rx.on_error!(actor::StoreActor, error)             = doSomethingWithAnError(error)
Rx.on_complete!(actor::StoreActor)                 = println("Completed: $(actor.values)")
```

For debugging purposes you can use a general `LambdaActor` actor.

## Operators

What makes Rx.jl powerful is its ability to help you process, transform and modify the messages flow through your observables using __Operators__.

```Julia
squared_int_values = source_of_int_values |> map(Int, (d) -> d ^ 2)
subscribe!(squared_int_values, LambdaActor{Int}(
    on_next = (data) -> println(data)
))
```

You can also use a special macro which is defined for some operators to produce an optimized versions of some operations on observables without using the callbacks.

```Julia
@CreateMapOperator("Squared", Int, Int, (d) -> d ^ 2)
squared_int_values = source_of_int_values |> SquaredMapOperator()
```

Here some performance comparison of using different approaches with Observable of 1000 integers and `StoreActor`.

|      | Using regular array | Using macro generated map operator | Using lambda based map operator |
|------|---------------------|------------------------------------|---------------------------------|
| Time |6.908 μs (11 allocations: 24.33 KiB)|7.244 μs (15 allocations: 24.41 KiB) KiB)|80.367 μs (2483 allocations: 62.98 KiB)|
