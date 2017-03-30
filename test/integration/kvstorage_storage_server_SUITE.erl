-module(kvstorage_storage_server_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([test_storage_server_empty/1,
		 test_storage_server_create/1,
		 test_storage_server_update/1,
		 test_storage_server_delete/1]).

all() -> [test_storage_server_empty,
		  test_storage_server_create,
		  test_storage_server_update,
		  test_storage_server_delete].

init_per_suite(Config) ->
	application:start(crypto),
    application:start(kvstorage),
    Config.
    
end_per_suite(_Config) ->
    ok.
    
test_storage_server_empty(_Config) ->
	{ok, not_found} = kvstorage_server:kv_get("key"),
	{ok, not_found} = kvstorage_server:kv_delete("key"),
	{ok, not_found} = kvstorage_server:kv_put("key", "value").

test_storage_server_create(_Config) ->
	{ok, created} = kvstorage_server:kv_post("key", "value"),
	{ok, {found, "value"}} = kvstorage_server:kv_get("key").

test_storage_server_update(_Config) ->
	{ok, already_exists} = kvstorage_server:kv_post("key", "value"),
	{ok, {found, "value"}} = kvstorage_server:kv_get("key"),
	{ok, updated} = kvstorage_server:kv_put("key", "value2"),
	{ok, {found, "value2"}} = kvstorage_server:kv_get("key").

test_storage_server_delete(_Config) ->
	{ok, {found, "value2"}} = kvstorage_server:kv_get("key"),
	{ok, deleted} = kvstorage_server:kv_delete("key"),
	{ok, not_found} = kvstorage_server:kv_get("key").
