% 7. ѕроверить, что один список получен путем попарного переворота элементов другого.
perevorot([],[]).
perevorot([Head|Tail],List) :- perevorot(Tail,Z), conc(Z,[Head],List). 
conc([],Y,Y).
conc([X|L1],L2,[X|L3]):- conc(L1,L2,L3).