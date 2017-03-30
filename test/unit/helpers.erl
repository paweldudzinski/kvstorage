-module(helpers).

-export([make_request/2]).

make_request(Method, Path) ->
    Request = mochiweb_request:new(rfc1123, Method, Path, {1, 1},
        mochiweb_headers:make([{"Content-Type", "text/html"}])),
    Request.
