module Rocket

include("utils.jl")
include("helpers/mstorage.jl")

include("teardown.jl")
include("teardown/void.jl")

include("scheduler.jl")
include("actor.jl")
include("subscribable.jl")
include("operator.jl")
include("subject.jl")

include("schedulers/asap.jl")
include("schedulers/async.jl")
include("schedulers/threads.jl")
include("schedulers/pending.jl")
include("schedulers/postponed.jl")

include("actor/function.jl")
include("actor/lambda.jl")
include("actor/logger.jl")
include("actor/void.jl")
include("actor/sync.jl")
include("actor/keep.jl")
include("actor/buffer.jl")
include("actor/server.jl")
include("actor/test.jl")

include("subjects/subject.jl")
include("subjects/behavior.jl")
include("subjects/replay.jl")
include("subjects/pending.jl")
include("subjects/recent.jl")

@generate_subscribe! Subject AbstractSubject
@generate_subscribe! BehaviorSubjectInstance AbstractSubject
@generate_subscribe! ReplaySubjectInstance AbstractSubject
@generate_subscribe! PendingSubjectInstance AbstractSubject
@generate_subscribe! RecentSubjectInstance AbstractSubject

include("observable/generate.jl")
include("observable/single.jl")
include("observable/array.jl")
include("observable/iterable.jl")
include("observable/faulted.jl")
include("observable/never.jl")
include("observable/completed.jl")
include("observable/proxy.jl")
include("observable/timer.jl")
include("observable/interval.jl")
include("observable/function.jl")
include("observable/file.jl")
include("observable/network.jl")
include("observable/combined.jl")
include("observable/combined_updates.jl")
include("observable/collected.jl")
include("observable/race.jl")
include("observable/merged.jl")
include("observable/concat.jl")
include("observable/lazy.jl")
include("observable/connectable.jl")
include("observable/scheduled.jl")
include("observable/defer.jl")
include("observable/zipped.jl")

include("operators/map.jl")
include("operators/map_to.jl")
include("operators/reduce.jl")
include("operators/scan.jl")
include("operators/filter.jl")
include("operators/filter_type.jl")
include("operators/find.jl")
include("operators/find_index.jl")
include("operators/some.jl")
include("operators/count.jl")
include("operators/enumerate.jl")
include("operators/take.jl")
include("operators/take_until.jl")
include("operators/first.jl")
include("operators/last.jl")
include("operators/tap.jl")
include("operators/tap_on_subscribe.jl")
include("operators/tap_on_complete.jl")
include("operators/sum.jl")
include("operators/max.jl")
include("operators/min.jl")
include("operators/delay.jl")
include("operators/uppercase.jl")
include("operators/lowercase.jl")
include("operators/to_array.jl")
include("operators/tuple_with.jl")
include("operators/switch_map.jl")
include("operators/switch_map_to.jl")
include("operators/merge_map.jl")
include("operators/concat_map.jl")
include("operators/concat_map_to.jl")
include("operators/exhaust_map.jl")
include("operators/multicast.jl")
include("operators/ref_count.jl")
include("operators/publish.jl")
include("operators/share.jl")
include("operators/catch_error.jl")
include("operators/rerun.jl")
include("operators/safe.jl")
include("operators/noop.jl")
include("operators/default_if_empty.jl")
include("operators/error_if_empty.jl")
include("operators/debounce_time.jl")
include("operators/skip_next.jl")
include("operators/skip_error.jl")
include("operators/skip_complete.jl")
include("operators/schedule_on.jl")
include("operators/async.jl")
include("operators/parallel.jl")
include("operators/discontinue.jl")
include("operators/with_latest.jl")
include("operators/ignore.jl")
include("operators/start_with.jl")
include("operators/accumulated.jl")
include("operators/pairwise.jl")

include("extensions/observable/single.jl")

end # module
