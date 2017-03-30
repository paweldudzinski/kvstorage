-module(response_handler).

-export([handle/2]).

-type req()       :: tuple().
-type result()    :: atom() | {found, string()}.

-spec handle(req(), result()) -> tuple().
handle(Req, Result) ->
    case Result of
        not_found ->
            http_responses:not_found(Req);
        {found, Value} ->
            http_responses:ok(Req, Value);
        created ->
            http_responses:created(Req);
        already_exists ->
            http_responses:already_exists(Req);
        updated ->
            http_responses:updated(Req);
        deleted ->
            http_responses:deleted(Req)
    end.
