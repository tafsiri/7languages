% Parallel map function

-module(pmap).
-export([pmap/2, timesTwo/1]).

% Basically follows the implementation at http://montsamu.blogspot.com/2007/02/erlang-parallel-map-and-parallel.html
% i couldn't quite figure out the gather step myself (though i did get quite close!).

pmap(Function, List) ->
  S = self(),
  Pids = lists:map(fun(El) ->
                    spawn(fun() -> execute(S, Function, El) end) #%spawn a process for each element
                   end, 
                   List),
  %gather the results of the processes (in order) into a list
  gather(Pids).

% Execute the function and send the result back to the receiver
execute(Recv, Function, Element) ->
  Recv ! {self(), Function(Element)}.

gather([]) ->
  [];
gather([H|T]) ->
  receive
      {H, Ret} ->
        [Ret|gather(T)]
  end.  

%test function for pmap
timesTwo(N) ->
  N * 2.

% Usage
% pmap:pmap(fun pmap:timesTwo/1, [1,2,3,4,5,6,7,8,9]).