%% @author Mochi Media <dev@mochimedia.com>
%% @copyright kvstorage Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the kvstorage application.

-module(kvstorage_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for kvstorage.
start(_Type, _StartArgs) ->
    kvstorage_deps:ensure(),
    kvstorage_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for kvstorage.
stop(_State) ->
    ok.
