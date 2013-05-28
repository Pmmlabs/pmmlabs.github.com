% 8. Проверить, что все элементы списка различны.
% Вызов: is_different([1,2,3,4]).

% проверка, является ли элемент Х элементом списка
member(X, [X|_]) :- !.
member(X, [_|T]) :- member(X, T).

is_different([]) :- !.
is_different([H|T]) :- not(member(H,T)), is_different(T).