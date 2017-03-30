-module(request_handler_tcp).

-export([handle/1, prepare_request/1]).

-type method() :: string().

-spec handle(binary()) -> binary().
handle(Req) ->
    {ok, Method, Params} = prepare_request(Req),    
    case Result = get_from_storage({Method, Params}) of
        {found, Value} ->
            X = Value;
        _ ->
            X = atom_to_list(Result)
    end,
    list_to_binary(X ++ <<"\r\n">>).

-spec prepare_request(binary()) -> {ok, string(), list()}.
prepare_request(Req) ->
    [Method|Params] = string:tokens(kvstorage_helpers:strip(Req), " "),
    {ok, Method, Params}.

-spec get_from_storage(method()) -> {found, string()} | atom().
get_from_storage({Method, Params}) ->
    case {Method, Params} of 
        {"GET", [Key]} ->
            {ok, Result} = kvstorage_server:kv_get(Key);
        {"POST", [Key, Value]} ->
            {ok, Result} = kvstorage_server:kv_post(Key, Value);
        {"PUT", [Key, Value]} ->
            {ok, Result} = kvstorage_server:kv_put(Key, Value);
        {"DELETE", [Key]} ->
            {ok, Result} = kvstorage_server:kv_delete(Key);
        _ ->
            Result = bad_request
    end,
    Result.
