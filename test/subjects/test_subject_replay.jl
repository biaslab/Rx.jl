module RocketReplaySubjectTest

using Test
using Rocket

@testset "ReplaySubject" begin

    println("Testing: ReplaySubject")

    @testset begin
        subject1 = ReplaySubject(Int, 1)
        @test eltype(subject1) === Int

        subject2 = ReplaySubject(Float64, 1)
        @test eltype(subject2) === Float64
    end

    @testset begin
        subject = ReplaySubject(Int, 2)

        actor1 = keep(Int)
        actor2 = keep(Int)

        next!(subject, -2);
        next!(subject, -1);

        subscription1 = subscribe!(subject, actor1)

        next!(subject, 0);
        next!(subject, 1);

        subscription2 = subscribe!(subject, actor2)

        next!(subject, 3);
        next!(subject, 4);

        unsubscribe!(subscription1);

        next!(subject, 5);
        next!(subject, 6);

        unsubscribe!(subscription2);

        @test actor1.values == [ -2, -1, 0, 1, 3, 4 ]
        @test actor2.values == [  0,  1, 3, 4, 5, 6 ]
    end

    @testset begin
        subject = ReplaySubject(Int, 2)

        actor1 = keep(Int)
        actor2 = keep(Int)

        values = Int[]
        source = from(1:5) |> tap(d -> push!(values, d))

        subscription1 = subscribe!(subject, actor1)
        subscription2 = subscribe!(subject, actor2)

        subscribe!(source, subject)

        @test values        == [ 1, 2, 3, 4, 5 ]
        @test actor1.values == [ 1, 2, 3, 4, 5 ]
        @test actor2.values == [ 1, 2, 3, 4, 5 ]

        actor3 = keep(Int)

        subscription3 = subscribe!(subject, actor3)

        @test actor3.values == [ 4, 5 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)
        unsubscribe!(subscription3)
    end

    @testset begin
        subject = ReplaySubject(Int, 2)

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
        subject_factory = ReplaySubjectFactory(2)
        subject = create_subject(Int, subject_factory)

        actor1 = keep(Int)
        actor2 = keep(Int)

        values = Int[]
        source = from(1:5) |> tap(d -> push!(values, d))

        subscription1 = subscribe!(subject, actor1)
        subscription2 = subscribe!(subject, actor2)

        subscribe!(source, subject)

        @test values        == [ 1, 2, 3, 4, 5 ]
        @test actor1.values == [ 1, 2, 3, 4, 5 ]
        @test actor2.values == [ 1, 2, 3, 4, 5 ]

        actor3 = keep(Int)

        subscription3 = subscribe!(subject, actor3)

        @test actor3.values == [ 4, 5 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)
    end

    @testset begin
        subject1 = ReplaySubject(Int, 2)
        subject2 = similar(subject1)

        @test subject1 !== subject2
        @test typeof(subject2) <: Rocket.ReplaySubjectInstance
        @test eltype(subject2) === Int

        actor1 = keep(Int)
        actor2 = keep(Int)

        next!(subject1, 1)
        next!(subject1, 2)

        subscription1 = subscribe!(subject1, actor1)
        subscription2 = subscribe!(subject2, actor2)

        @test subscription1 !== subscription2
        @test actor1.values == [ 1, 2 ]
        @test actor2.values == [  ]

        next!(subject1, 3)

        @test actor1.values == [ 1, 2, 3 ]
        @test actor2.values == [  ]

        next!(subject2, 2)

        @test actor1.values == [ 1, 2, 3 ]
        @test actor2.values == [ 2 ]

        unsubscribe!(subscription1)
        unsubscribe!(subscription2)

        subject3 = similar(subject2)

        @test subject2 !== subject3
        @test typeof(subject3) <: Rocket.ReplaySubjectInstance
        @test eltype(subject3) === Int

        actor3 = keep(Int)

        subscription3 = subscribe!(subject3, actor3)

        @test actor3.values == []

        unsubscribe!(subscription3)
    end

end

end
