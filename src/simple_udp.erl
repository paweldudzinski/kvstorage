-module(simple_udp).

-export([start_link/1, init/1]).

-type udp_port() :: integer().

-spec start_link(udp_port()) -> {ok, pid()}.
start_link(Port) ->
    Pid = spawn_link(?MODULE, init, [Port]),
    register(?MODULE, Pid),
    {ok, Pid}.

-spec init(udp_port()) -> nil.
init(Port) ->
    {ok, Socket} = gen_udp:open(Port, [binary, {active,false}]),
    spawn(fun() -> receive_request(Socket) end),
    timer:sleep(infinity).

-spec receive_request(inet:socket()) -> nil.
receive_request(Socket) ->
    Request = gen_udp:recv(Socket, 0),
    spawn(fun() -> receive_request(Socket) end),
    handle(Request).

-spec handle(binary()) -> binary() | {error, server_down}.
handle(Request) ->
    case Request of
        {ok, {_, _, Message}} ->
            request_handler_tcp:handle(Message);
        _ ->
            {error, server_down}
    end.
