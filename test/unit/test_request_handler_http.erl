-module(test_request_handler_http).
-include_lib("eunit/include/eunit.hrl").

handle_get_test() ->
    Req = helpers:make_request("GET", "/?key=value"),
    meck:new(request_handler_http),
    meck:expect(request_handler_http, handle_get, fun(_) -> {ok, "value"} end),
    Result = request_handler_http:handle_get(Req),
    ?assertEqual(Result, {ok, "value"}),
    ?assert(meck:validate(request_handler_http)),
    meck:unload(request_handler_http).

handle_delete_test() ->
    Req = helpers:make_request("GET", "/?key=value"),
    meck:new(request_handler_http),
    meck:expect(request_handler_http, handle_get, fun(_) -> {ok, deleted} end),
    Result = request_handler_http:handle_get(Req),
    ?assertEqual(Result, {ok, deleted}),
    ?assert(meck:validate(request_handler_http)),
    meck:unload(request_handler_http).

handle_post_test() ->
    Req = helpers:make_request("GET", "/?key=value&value=value"),
    meck:new(request_handler_http),
    meck:expect(request_handler_http, handle_get, fun(_) -> {ok, created} end),
    Result = request_handler_http:handle_get(Req),
    ?assertEqual(Result, {ok, created}),
    ?assert(meck:validate(request_handler_http)),
    meck:unload(request_handler_http).

handle_put_test() ->
    Req = helpers:make_request("GET", "/?key=value&value=value"),
    meck:new(request_handler_http),
    meck:expect(request_handler_http, handle_get, fun(_) -> {ok, updated} end),
    Result = request_handler_http:handle_get(Req),
    ?assertEqual(Result, {ok, updated}),
    ?assert(meck:validate(request_handler_http)),
    meck:unload(request_handler_http).
