-module(test_kvstorage_helpers).
-include_lib("eunit/include/eunit.hrl").

helpers_test() ->
    ?assertEqual(
        "POST key value",
        kvstorage_helpers:strip(<<"POST key value\r\n">>)),
    ?assertEqual(
        "GET key",
        kvstorage_helpers:strip(<<"GET key\n">>)),
    ?assertEqual(
        "GET key",
        kvstorage_helpers:strip("GET key")).
