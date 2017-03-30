-module(kvstorage_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0,
         kv_get/1,
         kv_post/2,
         kv_put/2,
         kv_delete/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
    
kv_get(Key) ->
    Result = gen_server:call(?SERVER, {rest, get, Key}),
    {ok, Result}.

kv_delete(Key) ->
    Result = gen_server:call(?SERVER, {rest, delete, Key}),
    {ok, Result}.

kv_post(Key, Value) ->
    Result = gen_server:call(?SERVER, {rest, post, Key, Value}),
    {ok, Result}.
    
kv_put(Key, Value) ->
    Result = gen_server:call(?SERVER, {rest, put, Key, Value}),
    {ok, Result}.
    

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    {ok, ets:new(store, [set, named_table])}.

handle_call({rest, get, Key}, _From, Store) ->
    Result = kvstorage_storage:storage_get(Key, Store),
    {reply, Result, Store};

handle_call({rest, post, Key, Value}, _From, Store) ->
    Result = kvstorage_storage:storage_save(Key, Value, Store),
    {reply, Result, Store};

handle_call({rest, put, Key, Value}, _From, Store) ->
    Result = kvstorage_storage:storage_update(Key, Value, Store),
    {reply, Result, Store};

handle_call({rest, delete, Key}, _From, Store) ->
    Result = kvstorage_storage:storage_delete(Key, Store),
    {reply, Result, Store};
  
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

