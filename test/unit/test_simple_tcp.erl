-module(test_simple_tcp).
-include_lib("eunit/include/eunit.hrl").

start_link_test() ->
    {ok, Pid} = simple_tcp:start_link(5000),
    ?assert(is_pid(Pid)),
    ?assertEqual(
        erlang:process_info(Pid, registered_name),
        {registered_name,simple_tcp}).
