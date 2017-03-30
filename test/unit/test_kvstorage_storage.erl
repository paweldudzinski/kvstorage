-module(test_kvstorage_storage).
-include_lib("eunit/include/eunit.hrl").

kvstorage_storage_test_() ->
	{foreach,
	 fun start/0,
	 fun stop/1,
	 [fun test_storage_get/1,
	  fun test_storage_delete/1,
	  fun test_storage_save/1,
	  fun test_storage_update/1]
	}.
	
start() ->
	ets:new(test_store, [set, named_table]).

stop(TestStore) ->
	ets:delete(TestStore).

test_storage_get(TestStore) ->
	NotFoundResult = kvstorage_storage:storage_get("key", TestStore),
	ets:insert(TestStore, {"key", "value"}),
	FoundResult = kvstorage_storage:storage_get("key", TestStore),
	[?_assertEqual(not_found, NotFoundResult),
	 ?_assertEqual({found, "value"}, FoundResult)].

test_storage_delete(TestStore) ->
	NotFoundResult = kvstorage_storage:storage_delete("key", TestStore),
	ets:insert(TestStore, {"key", "value"}),
	DeletedResult = kvstorage_storage:storage_delete("key", TestStore),
	[?_assertEqual(not_found, NotFoundResult),
	 ?_assertEqual(deleted, DeletedResult)].

test_storage_save(TestStore) ->
	SaveResult = kvstorage_storage:storage_save(
		"key", "value", TestStore),
	FoundResult = kvstorage_storage:storage_get("key", TestStore),
	[?_assertEqual(created, SaveResult),
	 ?_assertEqual({found, "value"}, FoundResult)].

test_storage_update(TestStore) ->
	NotFoundResult = kvstorage_storage:storage_update(
		"key", "x", TestStore),
	SaveResult = kvstorage_storage:storage_save(
		"key", "value", TestStore),
	FoundResult = kvstorage_storage:storage_get("key", TestStore),
	UpdateResult = kvstorage_storage:storage_update(
		"key", "x", TestStore),
	FoundUpdatedResult = kvstorage_storage:storage_get(
		"key", TestStore),
	[?_assertEqual(not_found, NotFoundResult),
	 ?_assertEqual(created, SaveResult),
	 ?_assertEqual({found, "value"}, FoundResult),
	 ?_assertEqual(updated, UpdateResult),
	 ?_assertEqual({found, "x"}, FoundUpdatedResult)].
	




