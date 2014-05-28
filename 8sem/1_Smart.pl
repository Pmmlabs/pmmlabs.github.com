gener(_, K, List, _, Pos, ListOfLists, Result ) :- K=Pos, append(ListOfLists, [List],Result ).

gener(N, K, List, Last, Pos, ListOfLists , ResultList ) :- 
	N>Last, K>Pos,
	NextLast is Last + 1, 
	NextPos is Pos + 1,
	gener(N, K, List, NextLast, Pos,ListOfLists, ResultList1),
	gener(N, K, [Last|List], Last, NextPos,ResultList1, ResultList).

gener(N, K, List, Last, Pos, ListOfLists , ResultList ) :- 
	K>Pos, N=Last,  
	NextPos is Pos + 1, 
	gener(N, K, [Last|List], Last, NextPos,ListOfLists, ResultList).

gen(N, K, ResultList) :- gener(N,K, [] , 1, 0, [], ResultList).
