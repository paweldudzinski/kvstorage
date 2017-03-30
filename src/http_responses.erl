-module(http_responses).

-include("include/macros.hrl").

-export([not_found/1,
		 ok/2,
		 created/1,
		 already_exists/1,
		 updated/1,
		 deleted/1]).

-type req() 	:: tuple().
-type result()	:: string().

-spec ok(req(), result()) -> string().
ok(Req, Result) ->
	Req:respond({?OK, ?HEADERS, Result}).

-spec created(req()) -> string().
created(Req) ->
	Req:respond({?CREATED, ?HEADERS, "created"}).

-spec updated(req()) -> string().
updated(Req) ->
	Req:respond({?OK, ?HEADERS, "updated"}).

-spec deleted(req()) -> string().
deleted(Req) ->
	Req:respond({?NO_CONTENT, ?HEADERS, ""}).

-spec not_found(req()) -> string().
not_found(Req) ->
	Req:respond({?NOT_FOUND, ?HEADERS, "not_found"}).

-spec already_exists(req()) -> string().
already_exists(Req) ->
	Req:respond({?CONFLICT, ?HEADERS, "already_exists"}).
	
