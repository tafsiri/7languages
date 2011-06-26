-module(day2).
-export([get/2, getOrElse/3, getOrNil/2, getAll/2, usage/0]).
-export([q2/0, q2pencil/0]).
-export([tt1/0]).
-export([fermat/0]).

% 1. Consider a list of keyword-value tuples. Write a function that accepts
% the list and a keyword and returns the associated value for that keyword

get(List, Key) ->
  %filter the list and select the first tuple by destructuring
  [{ MatchKey, MatchVal} | _ ] = lists:filter(fun({K, V}) -> K == Key end, List),
  MatchVal.

getOrElse(List, Key, Default) ->
  %filter the list and select the first tuple by destructuring
  %also replace vars we dont care about with _
  Ans = lists:filter(fun({K, _}) -> K == Key end, List),
  case Ans of
    [] -> Default;
    [{ _, MatchVal} | _ ] -> MatchVal
  end.
  
getOrNil(List, Key) -> getOrElse(List, Key, nil).

getAll(List, Key) ->
  %filter the list and select the first tuple by destructuring
  T = lists:filter(fun({K, _}) -> K == Key end, List),
  %map to the vals
  lists:map(fun({_, V}) -> V end, T).

usage() ->
  L = [{erlang, "a functional language"}, {ruby, "an OO language"}],
  Lan = [ {erlang, "a functional language"}, 
        {ruby, "an OO language"},
        {erlang, "a concurrent language"} ],
  [
  get(L, erlang),  % -> "a functional language"
  getAll(Lan, erlang), % -> ["a functional language","a concurrent language"]
  getOrElse(L, scala, nothing), % -> nothing
  getOrNil(L, io) % -> nil
  ].
  

% 2. Consider a shopping list that looks like [{item, quantity, price}, ...]
% Write a list comprehension that adds the total price of each item i.e. quantity * price

q2() ->
  List = [{pencil, 5, 0.25}, {pen , 3, 1}, {paper, 10, 0.1}],
  [{Item, Quantity, Price, Quantity * Price} || {Item, Quantity, Price} <- List].
  
% [{pencil,5,0.250000,1.25000},
% {pen,3,1,3},
% {paper,10,0.100000,1.00000}]

%just the pencils
q2pencil() ->
  List = [{pencil, 5, 0.25}, {pen , 3, 1}, {paper, 10, 0.1}],
  [{pencil, Quantity, Price, Quantity * Price} || {pencil, Quantity, Price} <- List].

%3 Write a board that takes a tic-tac-toe board presented as a list or tuple
%  Return the current state of the game (winner, no winner yet, tie, incomplete)

tictactoe(Board) ->
  [S11, S12, S13,
  S21, S22, S23,
  S31, S32, S33] = Board,
  
  Rows = [[S11, S12, S13], [S21, S22, S23], [S31, S32, S33]],
  Cols = [[S11, S21, S31], [S12, S22, S32], [S13, S23, S33]],
  Diag = [[S11, S22, S33], [S13, S22, S31]],
  
  Lines = lists:append([Rows, Cols, Diag]),
  
  %look for winners
  HasWinner = fun(Line) ->
    case same(Line) of
      {true, x} -> io:format("Winner is X~n"), true; %print and return true
      {true, o} -> io:format("Winner is O~n"), true;
      {_, _} -> nil, false
    end
  end,
  
  Winners = lists:dropwhile(fun(Line) -> HasWinner(Line) == false end, Lines),
  case Winners of
    [] ->       
      %look for space to play
      case lists:any(fun(S) -> e == S end, lists:flatten(Lines)) of
        true -> io:format("No Winner~n");
        false -> io:format("Tie~n")
      end;
    _ -> done
  end.
  
%check if all vals are the same and return true or false
%as well as the first val in that list    
same(List) ->
  First = lists:nth(1, List),
  {lists:all(fun(X) -> First == X end, List), First}.


%tic-tac-toe driver function
tt1() ->
  B = [x, x, o,
       o, o, e,
       x, o, x],
  tictactoe(B).
    
