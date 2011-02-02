fib(0,0).
fib(1,1).
fib(X, Ans) :- Xm1 is X - 1 ,Xm2 is X - 2 ,
               fib(Xm1, Sub1), fib(Xm2, Sub2), 
               Ans is Sub1 + Sub2.

fact(0,1).
fact(Num, Ans) :- Nm is Num - 1,
                  fact(Nm, Sub),
                  Ans is Num * Sub.
                  

rev([Head|[]], [Head]). % rev of a single element list is the list
%Note append will not work with non list parameters, remember to put Head in []
rev([Head|Tail], Ans) :- rev(Tail, Sub), 
                         append(Sub, [Head], Ans).

% the semicolon ; is an OR. commas, are AND
min([Head|[Head2|[]]], Ans) :- Head @< Head2, Ans is Head; Head2 @=< Head, Ans is Head2.
min([Head|Tail], Ans) :- min(Tail, Sub),
                         Ans is min(Head, Sub).

max([Head|[Head2|[]]], Ans) :- Head @> Head2, Ans is Head; Head2 @>= Head, Ans is Head2.
max([Head|Tail], Ans) :- max(Tail, Sub),
                         Ans is max(Head, Sub).
                         

/*The following is a pretty hacky way of sorting. The first solution that satisfies
 ysort will be correct, however it will continue to generate an infinite number 
 of (incorrect and longer) solutions. lsub also generates multiple answers, only the
 first one is correct. I don't have enough understanding of prolog at the moment to 
 figure out why it continues to generate answers*/
lsub([], Minus, []).
lsub([Minus|[]], Minus, []).
lsub([Head|[]], Minus, [Head]).
lsub([Minus|Tail], Minus, Tail).
lsub([Head|Tail], Minus, Ans) :- lsub(Tail, Minus, Sub),
                                 append([Head], Sub, Ans).

/* Overall, it is closest to an insertion sort, it finds the smallest element of the 
source list puts it at the head of the target list and continues building the list
in this fashion. */
ysort([], []).
ysort([Head|[]], [Head]).
ysort(List, Ans) :- min(List, CurrMin),
                    lsub(List, CurrMin, Rest),
                    ysort(Rest, Sub),
                    append([CurrMin], Sub, Ans).