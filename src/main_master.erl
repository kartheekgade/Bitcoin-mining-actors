-module(main_master).
-export([init_server/1, handleWorkers/2, bitcoinMapping/2, gen_random/2, foldl_len/3, leadingZeros/2]).

-import(string, [concat/2]).
-define(ALPHABET, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0987654321").


%%---- Init_server starts the master node ------
init_server(LeadingZeros) ->
%%  {_,_} = statistics(runtime),
%%  {_,_} = statistics(wall_clock),
  register(masterNode, spawn(main_master, handleWorkers, [LeadingZeros, 0])),

  timer:send_after(50000, whereis(masterNode), {completedMining, self()}),
  register(masterNode1, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode2, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode3, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode4, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode5, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode6, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  register(masterNode7, spawn(main_master, bitcoinMapping, [LeadingZeros, 0])),
  timer:kill_after(50000, whereis(masterNode1)),
  timer:kill_after(50000, whereis(masterNode2)),
  timer:kill_after(50000, whereis(masterNode3)),
  timer:kill_after(50000, whereis(masterNode4)),
  timer:kill_after(50000, whereis(masterNode5)),
  timer:kill_after(50000, whereis(masterNode6)),
  timer:kill_after(50000, whereis(masterNode7)),
  {_,_} = statistics(runtime),
  {_,_} = statistics(wall_clock).
%%  for(8,1,LeadingZeros).

%%  for(0,_,_) ->
%%   [];
%% for(N,Term,LeadingZeros) when N > 0 ->
%%   register(string:concat("masterNode", N) , spawn(main_master, bitcoinMapping(LeadingZeros,0), [LeadingZeros, 0])),
%%   timer:kill_after(50000, whereis(string:concat("masterNode", N))),
%%  [Term|for(N-1,Term,LeadingZeros)].

%%-------------------------------------------

%%----- Crypto hashing -----%%
get_string(Length) ->
  random:seed(erlang:now()),
  AlphaNumeric = string:concat("gade.k;", gen_random(Length, ?ALPHABET)),
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

%%----- Calculating leading zeros ----------
leadingZeros([LeadingZero | RemHash], Zeros) ->

  if
    Zeros == 0 -> found;
    true -> if
              LeadingZero == 48 ->
                leadingZeros(RemHash, Zeros - 1);
              true -> notFound
            end
  end.
%%-----------------------------------------

%%---------- Crypto mining ------------------
bitcoinMapping(ZeroCount, CoinsMined) ->
  [HashString, HashValue] = get_string(8),
  CoinStatus = leadingZeros(HashValue, ZeroCount),

  if
    CoinStatus == found ->

      io:format("Found: ~n"),
      io:format(string:concat(HashString, string:concat(" ", HashValue))),
      io:format("~n"),
      handleWorkers(ZeroCount, CoinsMined + 1);
    true -> bitcoinMapping(ZeroCount, CoinsMined)
  end.
%%------------------------------------------

%%------- It handle's the worker calls and act as a master node ------
handleWorkers(ZeroCount, CoinsMined) ->
  %returnString(ZeroCount),
  % whereis(masterNode) ! {ready_to_mine_server, whereis(masterNode)},
  io:format("Node name is : ~s ~n", [node()]),
  {masterNode, node()} ! {ready_to_mine_server, masterNode},
  receive
    {ready_to_mine, WorkerPID, WorkerNode} ->
%%      io:format("Ready to mine called ~n"),
%%      io:fwrite(" PID of wo : ~p  and node is ~p ~n",[pid_to_list(whereis(WorkerPID)), WorkerNode]),
      {WorkerPID, WorkerNode} ! {startMining, ZeroCount, masterNode, node()},
      handleWorkers(ZeroCount, CoinsMined);

    {coinFound, StringFound, SenderPIDName, SenderNode, ZeroCount} ->
      io:format("Coin found by worker "),
      io:format("~s~n", [StringFound]),
      io:fwrite(" PID : ~p~n", [SenderPIDName]),
      {SenderPIDName, SenderNode} ! {startMining, ZeroCount, masterNode, node()},
      handleWorkers(ZeroCount, CoinsMined);

    {ready_to_mine_server, MasterPIDName} ->
%%      io:fwrite(" Master is mining, Master PID : ~p~n", [pid_to_list(whereis(MasterPIDName))]),
      bitcoinMapping(ZeroCount, CoinsMined);

    {completedMiningFormWorker, CoinsGen, ProcessID} ->
      io:fwrite("Total coins mined by workers ~p", [pid_to_list(ProcessID)]),
      io:format(" is ~w~n", [CoinsGen]),
      handleWorkers(ZeroCount, CoinsMined + CoinsGen);

    {completedMining, ProcessID} ->
      io:fwrite("Total coins mined by  ~p", [pid_to_list(ProcessID)]),
      io:format(" is ~w~n", [CoinsMined]),
      {_,T} = statistics(runtime),
      {_,T2} = statistics(wall_clock),
      timer:sleep(10000),
      CPU_time = T / 1000,
      Run_time = T2 / 2000,
      T3 = CPU_time / Run_time,
      io:format("CPU time: ~p seconds\n", [CPU_time]),
      io:format("Real time: ~p seconds\n", [Run_time]),
      io:format("Ratio is ~p \n", [T3]),
      erlang:exit(self(), normal)
%%  after 25000 ->
%%    {_,CPU_time} = statistics(runtime),
%%    {_,Run_time} = statistics(wall_clock),
%%    timer:sleep(5000),
%%    T = CPU_time/ 1000,
%%    T2 = Run_time / 1000,
%%    T3 = T/ T2,
%%    io:format("CPU time: ~p seconds\n", [T]),
%%    io:format("Real time: ~p seconds\n", [T2]),
%%    io:format("Ratio is ~p \n", [T3]),
%%    erlang:exit(normal)
  end.

%%------------------------------------------------------------------------------------