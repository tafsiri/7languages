% 1. Monitor the translator service and restart it if it dies. 
%    (this is pretty much directly from the book)

-module(day3).
-export([loop/0, translate/2]).
-export([watch/0]).

% the translator service 

loop() ->
  %loop and wait for words to translate
  receive
    {From, "casa"} ->
      From ! "house",
      loop();
    
    {From, "mesa"} ->
      From ! "table",
      loop();
    
    {From, _} ->
      From ! "No habla that much espangnol",
      exit("I Quit! ")
  end.

% Utility function to get return val from translator  
  
translate(Translator, Word) ->
  Translator ! {self(), Word}, %send the caller of translate and the word to translate
  receive
    %immediately enter a receive loop to get the response back
    Translation -> Translation
  end.
  


%the monitor
    
watch() ->
  process_flag(trap_exit, true),
  receive
    new ->
      io:format("Creating the translation service~n"),
      register(translator, spawn_link(fun loop/0)),
      watch();
      
    {'EXIT', From, Reason} ->
      io:format("The translator ~p exited with the reason ~p", [From, Reason]),
      io:format("Restarting the translator~n"),
      self() ! new,
      watch()
      
  end.

%
% Usage
%
% c("day3.erl").
% M = spawn(fun day3:watch/0).
% M ! new.
% day3:translate(translator, "casa").
% day3:translate(translator, "banjo").
% day3:translate(translator, "mesa").