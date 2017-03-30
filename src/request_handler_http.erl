-module(request_handler_http).

-export([handle_get/1, handle_post/1, handle_put/1, handle_delete/1]).

-type req() :: tuple().

-spec handle_get(req()) -> {ok, string()} | {ok, atom()}.
handle_get(Req) ->
	[{"key", Key}] = Req:parse_qs(),
    kvstorage_server:kv_get(Key).

-spec handle_delete(req()) -> {ok, atom()}.
handle_delete(Req) ->
	[{"key", Key}] = Req:parse_qs(),
    kvstorage_server:kv_delete(Key).

-spec handle_post(req()) -> {ok, atom()}.
handle_post(Req) ->
	[{"key", Key},{"value", Value}] = Req:parse_qs(),
	kvstorage_server:kv_post(Key, Value).

-spec handle_put(req()) -> {ok, atom()}.
handle_put(Req) ->
	[{"key", Key},{"value", Value}] = Req:parse_qs(),
	kvstorage_server:kv_put(Key, Value).
