% 4. Проверить, является ли дерево бинарным.
% X  tree root
ordtree_member(X,tr(X,_,_)):-!. 

% X - left
ordtree_member(X,tr(K,L,_)):-
        X<K,!,
        ordtree_member(X,L).  

% X - right
ordtree_member(X,tr(K,_,R)):-
        X>K,!,
        ordtree_member(X,R). 

% Example : ordtree_member(8, tr(5, tr(3,nil, nil), tr(8, tr(6,nil,nil), tr(9,nil,nil)))).
% Answer : Yes