-module(test_kvstorage_server).
-include_lib("eunit/include/eunit.hrl").

init_test() ->
	Result = kvstorage_server:init([]),
	?assertEqual(Result, {ok, store}),
	ets:delete(store).

server_test_() ->
	{foreach,
	 fun start/0,
	 fun stop/1,
	 [fun test_handle_call_get/1,
	  fun test_handle_call_post/1,
	  fun test_handle_call_put/1,
	  fun test_handle_call_delete/1]
	}.

start() ->
	{ok, TestStore} = kvstorage_server:init([]),
	TestStore.

stop(TestStore) ->
	ets:delete(TestStore).

test_handle_call_get(TestStore) ->
	NotFoundResult = kvstorage_server:handle_call(
		{rest, get, "key"}, self(), TestStore),
	ets:insert(TestStore, {"key", "value"}),
	FoundResult = kvstorage_server:handle_call(
		{rest, get, "key"}, self(), TestStore),
	[?_assertEqual(NotFoundResult, {reply, not_found, store}),
	 ?_assertEqual(FoundResult, {reply, {found,"value"}, store})].

test_handle_call_post(TestStore) ->
	SaveResult = kvstorage_server:handle_call(
		{rest, post, "key", "value"}, self(), TestStore),
	[?_assertEqual(SaveResult, {reply, created, store})].

test_handle_call_put(TestStore) ->
	NotFoundResult = kvstorage_server:handle_call(
		{rest, put, "key", "x"}, self(), TestStore),
	ets:insert(TestStore, {"key", "value"}),
	UpdateResult = kvstorage_server:handle_call(
		{rest, put, "key", "x"}, self(), TestStore),
	[?_assertEqual(NotFoundResult, {reply, not_found, store}),
	 ?_assertEqual(UpdateResult, {reply, updated, store})].

test_handle_call_delete(TestStore) ->
	NotFoundResult = kvstorage_server:handle_call(
		{rest, delete, "key"}, self(), TestStore),
	ets:insert(TestStore, {"key", "value"}),
	DeletedResult = kvstorage_server:handle_call(
		{rest, delete, "key"}, self(), TestStore),
	[?_assertEqual(NotFoundResult, {reply, not_found, store}),
	 ?_assertEqual(DeletedResult, {reply, deleted, store})].




