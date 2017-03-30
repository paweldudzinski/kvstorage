%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc kvstorage.

-module(kvstorage).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the kvstorage server.
start() ->
    kvstorage_deps:ensure(),
    ensure_started(crypto),
    application:start(kvstorage).


%% @spec stop() -> ok
%% @doc Stop the kvstorage server.
stop() ->
    application:stop(kvstorage).
