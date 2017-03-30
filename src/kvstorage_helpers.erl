-module(kvstorage_helpers).

-export([strip/1]).

-spec strip(string()) -> string().
strip(Val) ->
	re:replace(Val, "(^\\s+)|(\\s+$)", "", [global,{return,list}]).
