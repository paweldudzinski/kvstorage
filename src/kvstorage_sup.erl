%% part of MochiWeb http serv scafold (make app=kvstorage)

-module(kvstorage_sup).

-behaviour(supervisor).

%% External exports
-export([start_link/0, upgrade/0]).

%% supervisor callbacks
-export([init/1]).

-define(CHILD(M, F, P), {M, {M, F, P}, permanent, 2000, worker, [M]}).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

upgrade() ->
    {ok, {_, Specs}} = init([]),

    Old = sets:from_list(
            [Name || {Name, _, _, _} <- supervisor:which_children(?MODULE)]),
    New = sets:from_list([Name || {Name, _, _, _, _, _} <- Specs]),
    Kill = sets:subtract(Old, New),

    sets:fold(fun (Id, ok) ->
                      supervisor:terminate_child(?MODULE, Id),
                      supervisor:delete_child(?MODULE, Id),
                      ok
              end, ok, Kill),

    [supervisor:start_child(?MODULE, Spec) || Spec <- Specs],
    ok.

init([]) ->
    Web = web_specs(kvstorage_web, 8080),
    StorageServer = ?CHILD(kvstorage_server, start_link, []),
    SimpleTCP = ?CHILD(simple_tcp, start_link, [3456]),
    SimpleUDP = ?CHILD(simple_udp, start_link, [8789]),
    Processes = [Web, StorageServer, SimpleTCP, SimpleUDP],
    Strategy = {one_for_one, 10, 10},
       
    {ok, {Strategy, lists:flatten(Processes)}}.

web_specs(Mod, Port) ->
    WebConfig = [{ip, {0,0,0,0}},
                 {port, Port},
                 {docroot, kvstorage_deps:local_path(["priv", "www"])}],
    {Mod, {Mod, start, [WebConfig]}, permanent, 5000, worker, dynamic}.
