-module(simple_tcp).

-export([start_link/1, init/1]).

-type tcp_port() :: integer().

-spec start_link(tcp_port()) -> {ok, pid()}.
start_link(Port) ->
    Pid = spawn_link(?MODULE, init, [Port]),
    register(?MODULE, Pid),
    {ok, Pid}.

-spec init(tcp_port()) -> nil.
init(Port) ->
    {ok, Listen} = gen_tcp:listen(Port, [binary, {active, true}]),
    spawn(fun() -> accept(Listen) end),
    timer:sleep(infinity).

-spec accept(inet:socket()) -> nil.
accept(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    spawn(fun() -> accept(Listen) end),
    handle(Socket).

-spec handle(inet:socket()) -> nil.
handle(Socket) ->
    receive
        {tcp, Socket, Request} ->
            Response = request_handler_tcp:handle(Request),
            gen_tcp:send(Socket, Response),
            handle(Socket);
        {tcp_closed, Socket} ->
            gen_tcp:close(Socket)
    end.
