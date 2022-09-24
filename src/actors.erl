-module(actors).

-export([init_worker/2, handleServerCalls/3, bitcoinMapping/4]).

-define(ALPHABET, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0987654321").


%%------------ init_worker will start the spawn worker -----
init_worker(ServerPID, ServerNode) ->
  register(workerNodeOne, spawn(actors, handleServerCalls, [ServerPID, ServerNode, 0])),
  {ServerPID, ServerNode} ! {ready_to_mine, workerNodeOne, node()},
  timer:send_after(40000, whereis(workerNodeOne), {completedMining}).
%%-----------------------------------------------------------

%%---------- Worker will handle all the server calls and it's a worker node -----
handleServerCalls(MasterPIDName, MasterNode, CoinsMined) ->

  % Initially send a ping to server indicating worker is available to mine coins

  receive
    {startMining, ZeroCount, MasterPIDName, MasterNode} ->
%%      io:format("Start to mine called ~n"),
%%      ------------------- spwan------
      lists:foreach(
        fun(_) ->
          spawn(actors, bitcoinMapping,[MasterPIDName, MasterNode , ZeroCount, 0])
        end, lists:seq(1, 8)),
      handleServerCalls(MasterPIDName, MasterNode, CoinsMined);
%%      ---------------------------------------
%%      bitcoinMapping(MasterPIDName, MasterNode, ZeroCount, CoinsMined);
    {completedMining} ->
      io:format("Total coins mined"),
      {MasterPIDName, MasterNode} ! {completedMiningFormWorker, CoinsMined, self()}
  end.
%%-----------------------------------------------------------------------------


%----- Crypto hashing -----%%
get_string(Length) ->
  random:seed(erlang:now()),
  AlphaNumeric = string:concat("gade.k; ", gen_random(Length, ?ALPHABET)),
  [AlphaNumeric, io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, AlphaNumeric))])].
%% ------------------------------ %%

%% ---- Random number generator function ----%%
gen_random(Length, Alphabet) when length(Alphabet) > 0 ->
  Arr = array:from_list(Alphabet),
  L = array:size(Arr),
  foldl_len(fun(Acc) ->
    [array:get(rand:uniform(L) - 1, Arr) | Acc]
            end, [], Length).

foldl_len(_F, Accum, 0) ->
  Accum;

foldl_len(F, Accum, N) ->
  foldl_len(F, F(Accum), N - 1).
%% -------------------------------------- %%

%%--------- Leading zeros check --------------
leadingZeros([Head | Tail], Zeros) ->
  %io:format("List is :: ~w ~n" , [[First | Rest]]),
  %io:format("First is :: ~w ~n" , [First]),
  %io:format("LAst is :: ~w ~n" , [Rest]),
  % Comparing with 0 (whose binary value is 48)
  if
    Zeros == 0 -> found;
    true -> if
              Head == 48 ->
                leadingZeros(Tail, Zeros - 1);
              true -> notFound
            end
  end.
%%--------------------------------------

%%----------- Crypto Mining -----------------
bitcoinMapping(ServerPIDName, ServerNode, ZeroCount, CoinsMined) ->
  [HashString, HashValue] = get_string(6),
  CoinStatus = leadingZeros(HashValue, ZeroCount),
  if
    CoinStatus == found ->
      io:format("Found: ~n"),
      Coin = string:concat(HashString, string:concat(" ", HashValue)),
      {ServerPIDName, ServerNode} ! {coinFound, Coin, workerNodeOne, node(), ZeroCount},
      handleServerCalls(ServerPIDName, ServerNode, CoinsMined+1);
    true -> bitcoinMapping(ServerPIDName, ServerNode, ZeroCount, CoinsMined)
  end.
%%--------------------------------------
