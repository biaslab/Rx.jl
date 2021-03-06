module RocketPendingSubjectTest

using Test
using Rocket

@testset "PendingSubject" begin

    println("Testing: PendingSubject")

    @testset begin
        subject1 = PendingSubject(Int)
        @test eltype(subject1) === Int

        subject2 = PendingSubject(Float64)
        @test eltype(subject2) === Float64
    end

    @testset begin
        subject = PendingSubject(Int)

        actor1 = keep(Int)
        actor2 = keep(Int)
        actor3 = keep(Int)

        subscription1 = subscribe!(subject, actor1)

        next!(subject, 0)
        next!(subject, 1)

        subscription2 = subscribe!(subject, actor2)

        next!(subject, 3)
        next!(subject, 4)

        unsubscribe!(subscription1)

        next!(subject, 5)
        next!(subject, 6)

        complete!(subject)

        unsubscribe!(subscription2)

        @test actor1.values == [ ]
        @test actor2.values == [ 6 ]
        @test actor3.values == [ ]

        subscription3 = subscribe!(subject, actor3)

        @test actor1.values == [ ]
        @test actor2.values == [ 6 ]
        @test actor3.values == [ 6 ]

    end

    @testset begin
        subject = PendingSubject(Int)

        actor1 = keep(Int)
        actor2 = keep(Int)

        values = Int[]
        source = from(1:5) |> tap(d -> push!(values, d))

        subscription1 = subscribe!(subject, actor1)
        subscription2 = subscribe!(subject, actor2)

        subscribe!(source, subject)

        @test values        == [ 1, 2, 3, 4, 5 ]
        @test actor1.values == [ 5 ]
        @test actor2.values == [ 5 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)
    end

    @testset begin
        subject = PendingSubject(Int)

        values      = []
        errors      = []
        completions = []

        actor = lambda(
            on_next     = (d) -> push!(values, d),
            on_error    = (e) -> push!(errors, e),
            on_complete = ()  -> push!(completions, 0)
        )

        subscribe!(subject, actor)

        @test values      == [ ]
        @test errors      == [ ]
        @test completions == [ ]

        error!(subject, "err")

        @test values      == [ ]
        @test errors      == [ "err" ]
        @test completions == [ ]

        subscribe!(subject, actor)

        @test values      == [ ]
        @test errors      == [ "err", "err" ]
        @test completions == [ ]

    end

    @testset begin
        subject_factory = PendingSubjectFactory()
        subject = create_subject(Int, subject_factory)

        actor1 = keep(Int)
        actor2 = keep(Int)

        values = Int[]
        source = from(1:5) |> tap(d -> push!(values, d))

        subscription1 = subscribe!(subject, actor1)
        subscription2 = subscribe!(subject, actor2)

        subscribe!(source, subject)

        @test values        == [ 1, 2, 3, 4, 5 ]
        @test actor1.values == [ 5 ]
        @test actor2.values == [ 5 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)
    end

    @testset begin
        subject1 = PendingSubject(Int)
        subject2 = similar(subject1)

        @test subject1 !== subject2
        @test typeof(subject2) <: Rocket.PendingSubjectInstance
        @test eltype(subject2) === Int

        actor1 = keep(Int)
        actor2 = keep(Int)

        subscription1 = subscribe!(subject1, actor1)
        subscription2 = subscribe!(subject2, actor2)

        @test subscription1 !== subscription2

        next!(subject1, 1)

        @test actor1.values == [ ]
        @test actor2.values == [ ]

        next!(subject2, 2)

        @test actor1.values == [ ]
        @test actor2.values == [ ]

        complete!(subject1)

        @test actor1.values == [ 1 ]
        @test actor2.values == [ ]

        complete!(subject2)

        @test actor1.values == [ 1 ]
        @test actor2.values == [ 2 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)
    end

end

end
