-module(kvstorage_storage).

-export([storage_get/2,
         storage_save/3,
         storage_update/3,
         storage_delete/2]).

-type key()      :: string().
-type value()    :: string().
-type store()    :: atom().

-spec storage_get(key(), store()) -> not_found | {found, value()}.
storage_get(Key, Store) ->
    case Res = ets:lookup(Store, Key) of
        [] ->
            not_found;
        _ ->
            [{_, Value}] = Res,
            {found, Value}
    end.

-spec storage_delete(key(), store()) -> not_found | deleted.
storage_delete(Key, Store) ->
    case ets:lookup(Store, Key) of
        [] ->
            not_found;
        _ ->
            ets:delete(Store, Key),
            deleted
    end.

-spec storage_save(key(), value(), store()) -> 
    created | already_exists.
storage_save(Key, Value, Store) ->
    case ets:lookup(Store, Key) of
        [] ->
            ets:insert_new(Store, {Key, Value}),
            created;
        _ ->
            already_exists
    end.

-spec storage_update(key(), value(), store()) -> not_found | updated.
storage_update(Key, Value, Store) ->
    case ets:lookup(Store, Key) of
        [] ->
            not_found;
        _ ->
            ets:insert(Store, {Key, Value}),
            updated
    end.
