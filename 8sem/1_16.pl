% 16. Сгенерировать список, содержащий суммы первых N элементов указанного ряда.
gen(N,El) :- El is 2*N.

%adding element at the end of the list
add_tail(X,[],[X]).
add_tail(X,[A|L1],[A|L2]) :- add_tail(X,L1,L2).

%reversing list
reverse([],[]).
reverse([X|L], RevL) :- reverse(L,RevL1), add_tail(X,RevL1,RevL).

%generating list consisted of sum
summ_n_elem(0,0,[]).
summ_n_elem(N,A,[A|L]) :- summ_n_elem(N1,A1,L),
                            N is N1+1,
                            gen(N,E),
                            A is A1+E.

%generating list consisted of sum. Main
summ_n_elem(N,L) :- reverse(L,L1),summ_n_elem(N,Tmp,L1),reverse(L1,L).


% for example: summ_n_elem(5,RES)
% answer : RES = [2,6,12,20,30]