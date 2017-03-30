-module(test_request_handler_tcp).
-include_lib("eunit/include/eunit.hrl").

prepare_request_test() ->
	GETok = <<"GET key\r\n">>,
	ResultGETok = request_handler_tcp:prepare_request(GETok),
	?assertEqual(ResultGETok, {ok,"GET",["key"]}),
	
	DELETEok = <<"DELETE key\r\n">>,
	ResultDELETEok = request_handler_tcp:prepare_request(DELETEok),
	?assertEqual(ResultDELETEok, {ok,"DELETE",["key"]}),
	
	POSTok = <<"POST key value\r\n">>,
	ResultPOSTok = request_handler_tcp:prepare_request(POSTok),
	?assertEqual(ResultPOSTok, {ok,"POST",["key","value"]}),
	
	PUTok = <<"PUT key value\r\n">>,
	ResultPUTok = request_handler_tcp:prepare_request(PUTok),
	?assertEqual(ResultPUTok, {ok,"PUT",["key","value"]}),
	
	Malformed = <<"WHAT IS IT?\r\n>>">>,
	MalformedResult = request_handler_tcp:prepare_request(Malformed),
	?assertMatch({ok, _, _}, MalformedResult).
