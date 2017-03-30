-module(test_response_handler).
-include_lib("eunit/include/eunit.hrl").
-include("include/macros.hrl").

handle_test() ->
	GetRequest = helpers:make_request("GET", "/?key=value"),

	meck:new(http_responses),
	meck:expect(http_responses, not_found,
		fun(_) -> {?NOT_FOUND, ?HEADERS, "not_found"} end),
	meck:expect(http_responses, ok,
		fun(_, Result) -> {?OK, ?HEADERS, Result} end),
	meck:expect(http_responses, created,
		fun(_) -> {?CREATED, ?HEADERS, "created"} end),
	meck:expect(http_responses, updated,
		fun(_) -> {?OK, ?HEADERS, "updated"} end),
	meck:expect(http_responses, deleted,
		fun(_) -> {?NO_CONTENT, ?HEADERS, "deleted"} end),
	meck:expect(http_responses, already_exists,
		fun(_) -> {?CONFLICT, ?HEADERS, "already_exists"} end),

	NotFoundResult = response_handler:handle(GetRequest, not_found),
	OkResult = response_handler:handle(GetRequest, {found, "value"}),
	CreatedResult = response_handler:handle(GetRequest, created),
	UpdatedResult = response_handler:handle(GetRequest, updated),
	DeletedResult = response_handler:handle(GetRequest, deleted),
	AlreadyExistsResult = response_handler:handle(GetRequest, already_exists),

	?assertEqual(NotFoundResult ,{?NOT_FOUND, ?HEADERS, "not_found"}),
	?assertEqual(OkResult ,{?OK, ?HEADERS, "value"}),
	?assertEqual(CreatedResult ,{?CREATED, ?HEADERS, "created"}),
	?assertEqual(UpdatedResult ,{?OK, ?HEADERS, "updated"}),
	?assertEqual(DeletedResult ,{?NO_CONTENT, ?HEADERS, "deleted"}),
	?assertEqual(
		AlreadyExistsResult ,{?CONFLICT, ?HEADERS, "already_exists"}),

	?assert(meck:validate(http_responses)),
	meck:unload(http_responses).
	
