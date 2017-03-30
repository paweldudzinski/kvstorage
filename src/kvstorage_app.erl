%% @author Mochi Media <dev@mochimedia.com>
%% @doc Callbacks for the kvstorage application.

-module(kvstorage_app).

-behaviour(application).
-export([start/2,stop/1]).

start(_Type, _StartArgs) ->
    kvstorage_deps:ensure(),
    kvstorage_sup:start_link().

stop(_State) ->
    ok.
