% 13. Ќахождение минимального пути на графе.

% path(Vertex0, Vertex, Path, Dist) выполн€етс€, если Path - кратчайший путь от  Vertex0 до  Vertex, 
% и если длина этого пути Dist. 
path(Vertex0, Vertex, Path, Dist):-
  dijkstra(Vertex0, Ss),
  member(s(Vertex,Dist,Path), Ss), !.

%¬ызов алгоритма ƒейкстры. Vertex - начальна€ вершина, Ss - найденные кратчайшие пути
dijkstra(Vertex, Ss):-
  create(Vertex, [Vertex], Ds),
  dijkstra_1(Ds, [s(Vertex,0,[])], Ss).


dijkstra_1([], Ss, Ss).
dijkstra_1([D|Ds], Ss0, Ss):-
  best(Ds, D, S),
  delete([D|Ds], [S], Ds1),
  S=s(Vertex,Distance,Path),
  reverse([Vertex|Path], Path1),
  merge(Ss0, [s(Vertex,Distance,Path1)], Ss1),
  create(Vertex, [Vertex|Path], Ds2),
  delete(Ds2, Ss1, Ds3),
  incr(Ds3, Distance, Ds4),
  merge(Ds1, Ds4, Ds5),
  dijkstra_1(Ds5, Ss1, Ss).
 
% create(Start, Path, Edges) выполн€етс€, если Edges - набор структур s(Vertex,Distance, Path),
% содержащий, дл€ каждой вершины Vertex доступной от вершины Start, рассто€ние Distance 
% от вершины Vertex и соответствующий путь Path.—писок упор€дочен по вершинам.
create(Start, Path, Edges):-
  setof(s(Vertex,Edge,Path), e(Start,Vertex,Edge), Edges), !.
create(_, _, []).
  
% best(Edges, Edge0, Edge) выпол€нетс€, если Edge - элемент Edges, списка структур
% s(Vertex, Distance, Path), содержащих кратчайшее рассто€ние Distance.  
% Edge0 представл€ет собой верхнюю границу.
best([], Best, Best).
best([Edge|Edges], Best0, Best):-
  shorter(Edge, Best0), !,
  best(Edges, Edge, Best).
best([_|Edges], Best0, Best):-
  best(Edges, Best0, Best).

% поиск более короткого пути
shorter(s(_,X,_), s(_,Y,_)) :- X < Y.

% delete(Xs, Ys, Zs) выполн€етс€, если Xs, Ys и Zs - списки структур s(Vertex, Distance, Path) 
% упор€доченных по вершинам Vertex, и Zs - результат удалени€ из Xs
% елементов, имеющих такие вершины Vertex, как и в списке Ys.
delete([], _, []). 
delete([X|Xs], [], [X|Xs]):-!. 
delete([X|Xs], [Y|Ys], Ds):-
  eq(X, Y), !, 
  delete(Xs, Ys, Ds). 
delete([X|Xs], [Y|Ys], [X|Ds]):-
  lt(X, Y), !, delete(Xs, [Y|Ys], Ds). 
delete([X|Xs], [_|Ys], Ds):-
  delete([X|Xs], Ys, Ds). 
  
% merge(Xs, Ys, Zs) выпл€нетс€, если Zs это результат сли€ни€ Xs и Ys, где Xs,
% Ys и Zs - списки структур s(Vertex, Distance, Path).  ≈сли элемент в Xs имеет такую же вершину Vertex как и элемент
% в Ys, элемент с более коротким рассто€нием попадет в Zs.
merge([], Ys, Ys). 
merge([X|Xs], [], [X|Xs]):-!. 
merge([X|Xs], [Y|Ys], [X|Zs]):-
  eq(X, Y), shorter(X, Y), !, 
  merge(Xs, Ys, Zs).
merge([X|Xs], [Y|Ys], [Y|Zs]):-
  eq(X, Y), !, 
  merge(Xs, Ys, Zs).
merge([X|Xs], [Y|Ys], [X|Zs]):-
  lt(X, Y), !, 
  merge(Xs, [Y|Ys], Zs).
merge([X|Xs], [Y|Ys], [Y|Zs]):-
  merge([X|Xs], Ys, Zs).

%проверка, имеют ли две данные структуры s одинаковые вершины
eq(s(X,_,_), s(X,_,_)).  

%выполн€етс€, если терм X меньше терма Y (упор€дочивание по алфавиту)
lt(s(X,_,_), s(Y,_,_)):-X @< Y.

% incr(Xs, Incr, Ys) выпол€нетс€, если Xs и Ys  списки структур s(Vertex, Distance, Path), 
% единственна€ разница в том, что значение Distance в Ys больше чем в Xs на величину Incr
incr([], _, []).  
incr([s(V,D1,P)|Xs], Incr, [s(V,D2,P)|Ys]):-
  D2 is D1 + Incr,
  incr(Xs, Incr, Ys).

%показываем, что если есть путь из вершины X в Y, то есть путь из Y в X.
e(X, Y, Z):-dist(X, Y, Z).
e(X, Y, Z):-dist(Y, X, Z).

%задаем рассто€ни€
dist(1,2,3).
dist(1,3,2).
dist(2,5,6).
dist(5,8,3).
dist(8,9,7).
dist(9,10,1).
dist(3,4,5).
dist(3,6,1).
dist(4,5,2).
dist(4,8,2).
dist(4,7,10).
dist(7,9,5).
dist(6,7,4).
dist(7,10,7).
