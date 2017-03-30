-module(kvstorage).
-export([start/0, stop/0]).

-spec start() -> ok.
start() ->
    kvstorage_deps:ensure(),
    application:start(crypto),
    application:start(kvstorage).

-spec stop() -> ok.
stop() ->
    application:stop(kvstorage).
