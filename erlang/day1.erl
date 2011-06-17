-module(day1).
-export([count_words/1]).
-export([upto/1]).
-export([printRet/1]).


% 1. Write a function that uses recursion to count the number of words in a string
list_len([]) -> 0;
list_len(Input) ->
  [H | Tail] = Input,
  1 + list_len(Tail).

count_words(Input) -> 
  {Status, Res} = regexp:split(Input, " "),
  list_len(Res).

% 2. Write a function that uses recursion to count to ten

upto(Val, Target) when Val < Target -> %Guard is used to limit the terminating case
  io:fwrite("~w~n",[Val]), %Print out val
  upto(Val + 1, Target);
upto(Target, Target) -> 
  io:fwrite("~w~n",[Target]). 

%Note upto/1 and upto/2 are completely diff functions
upto(Target) ->
  upto(0, Target).
  
% 3. Write a function that uses matching to selectively print 'success'
%    or 'error:message' given input of the form {error, Message} or success

printRet({error, Msg}) -> io:fwrite("error:~s~n",[Msg]);
printRet(success) -> io:fwrite("success~n").
