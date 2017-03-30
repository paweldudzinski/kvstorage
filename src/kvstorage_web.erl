-module(kvstorage_web).

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, _) ->
    "/" ++ Path = Req:get(path),
    try
        case Req:get(method) of
            Method when Method =:= 'GET'; Method =:= 'HEAD' ->
                case Path of
                   [] ->
                        {ok, Result} = request_handler_http:handle_get(Req),
                        response_handler:handle(Req, Result);
                    _ ->
                        http_responses:not_found(Req)
                end;
            'POST' ->
                case Path of
                    [] ->
                        {ok, Result} = request_handler_http:handle_post(Req),
                        response_handler:handle(Req, Result);
                    _ ->
                       http_responses:not_found(Req)
                end;
            'PUT' ->
                case Path of
                    [] ->
                        {ok, Result} = request_handler_http:handle_put(Req),
                        response_handler:handle(Req, Result);
                    _ ->
                        http_responses:not_found(Req)
                end;
            'DELETE' ->
                case Path of
                    [] ->
                        {ok, Result} = request_handler_http:handle_delete(Req),
                        response_handler:handle(Req, Result);
                    _ ->
                        http_responses:not_found(Req)
                end;
            _ ->
                Req:respond({405, [], []})
        end
    catch
        Type:What ->
            Report = ["web request failed",
                      {path, Path},
                      {type, Type}, {what, What},
                      {trace, erlang:get_stacktrace()}],
            error_logger:error_report(Report),
            Req:respond({500, [{"Content-Type", "text/plain"}],
                         "request failed, sorry\n"})
    end.

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.
