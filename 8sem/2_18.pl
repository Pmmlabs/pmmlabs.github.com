% Второе задание по Прологу, номер 18. Может ли указанное число быть получено из заданного массива чисел с помощью операции +,-,* и /. Каждое из исходных чисел может использоваться не более одного раза.

% Вызов: ?-solve([1,2,3],6) ответ ДА, потому что 1+2+3=6.

% Длина списка
len([], 0) :- !.
len([_|L], N) :- len(L, N1), N is N1+1.

% Генерация нулей zeros(List, Count)
zeros([], 0) :- !.
zeros([0|L], N) :- N1 is N-1, zeros(L, N1).

% eval(Znak,A,B,Result) Вычисление суммы или разности
eval(0,A,B,Res) :- ! , Res is A + B.	%	+
eval(1,A,B,Res) :- ! , Res is A - B.	%	-

% Выисление произведения и деления
calc_mul(X,[H|T],Znaki,Res) :- Z is X*H, calc([Z|T],Znaki,Res).
calc_div(_,[0|_],_,_) :- !, fail.
calc_div(X,[H|T],Znaki,Res) :- Z is X/H, calc([Z|T],Znaki,Res).

% calc(ListOfDigits,Znaki,Result) Вычисление выражения, заданного числами ListOfDigits и знаками Znaki
calc([X],[],X) :- !.
calc([H_List|T_List], [2|T_Znaki], Res) :- calc_mul(H_List,T_List,T_Znaki,Res), !.
calc([H_List|T_List], [3|T_Znaki], Res) :- calc_div(H_List,T_List,T_Znaki,Res), !.
calc([H_List|T_List], [H_Znaki|T_Znaki], Res) :- calc(T_List, T_Znaki, Res1), eval(H_Znaki,H_List,Res1,Res).

% Следующая перестановка inc_list(Input, Output)
inc_list([3], _) :- !, fail.
inc_list([X],[Output]) :- !, Output is X + 1.
inc_list([H_In|T_In],[H_Out|T_Out]) :- (H_Out is H_In, inc_list(T_In,T_Out), !) ;
					(inc_list([H_In],[H_Out]), len(T_In,LengthOfT_In), zeros(T_Out,LengthOfT_In)).  
% Проверка всех комбинаций
combi(List,Znaki,Res) :- calc(List,Znaki,Res), !, write(Znaki).
combi(List,Znaki,Res) :- inc_list(Znaki, Znaki2), combi(List,Znaki2,Res).

solve(List, Res) :- len(List,LengthOfList), Z is LengthOfList-1, zeros(ZeroList,Z), combi(List,ZeroList,Res).
