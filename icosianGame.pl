%% пользователь выбирает точку начала, затем предлагается выбрать одну из трех
%% нужно хранить связи Ключ(знач1,знач2,знач3) для всех 20 вершин

pnt("1",[2,5,6]).
pnt("2",[1,7,3]).
pnt("3",[2,8,4]).
pnt("4",[3,9,5]).
pnt("5",[1,4,10]).
pnt("6",[1,11,12]).
pnt("7",[2,12,13]).
pnt("8",[3,13,14]).
pnt("9",[4,14,15]).
pnt("10",[5,11,15]).
pnt("11",[6,10,16]).
pnt("12",[6,7,17]).
pnt("13",[7,8,18]).
pnt("14",[8,9,19]).
pnt("15",[9,10,20]).
pnt("16",[11,17,20]).
pnt("17",[12,16,18]).
pnt("18",[13,17,19]).
pnt("19",[14,18,20]).
pnt("20",[15,16,19]).

%% Главный предикат, инициирующий работу всей логики
icosianGame():-write("Правила: "),nl,write("1. Нужно пройти по всем 20 вершинам и вернуться в исходную."),
nl,write("2. Нельзя посетить одну точку более одного раза."),nl,write("Карта городов представлена в виде картинки."),
nl,write("Введите город начала пути: "), read(S),atom_string(S,SS),
askNextC(SS,SS,0,[],_).

%% Вывод доступных городов
wrMessage(CurC,AV):- nl,write("Доступные города для перемещения: "),
nl,pnt(CurC,AV),write(AV),nl,write("Выберите любой город из доступных: ").

%% Если доступные города являются подмножеством посещенных, сообщить об этом
askNextC(_,CurC,_,Visited,_):-atom_string(CurC,CC),pnt(CC,Q),
subm(Q,Visited),write("Тупик!").

%% Пока количество перемещений меньше 19, запрос очередного ввода и его проверка
askNextC(StC,CurC,M,Visited,RV):-M<19,nl,wrMessage(CurC,AV),
readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst),
askNextC(StC,SS,M1,Vst,RV).

%% Обработка завершающего шага
askNextC(StC,CurC,M,Visited,RV):-M=19,nl,write("На последнем шаге нужно вернуться в исходную точку, если это возможно."),
wrMessage(CurC,AV),
read(S),atom_string(S,SS),
insult(S,AV),SS = StC,append(Visited,CurC,RV),
nl,write("Успех! Маршрут: "),write(RV).

%% Если пользователь ввел h., будет вызван предикат автопоиска решений
askNextC(StC,CurC,M,Visited,RV):-findPath(StC,CurC,M,Visited,RV,M), fail.
%% Завершение работы автопоиска
askNextC(_,_,_,_,_):-nl,write("Представлены все возможные пути из заданного заранее маршрута.").

readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst):-write("Ввод: "),read(S), not(S='h'), 
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,S).

%% Если введенно h, вернуть fail, что вызовет автопоиск
readCheckMsg(_,_,_,_,_,_,_):- fail,!.

%% Если указанный город в числе доступных, добавить в список посещенных 
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,S):-insult(S,AV), atom_string(S,SS),append(Visited,[CurC],Vst),
M1 is M+1, not(insult(SS,Vst)).

%% При неверном вводе вывести сообщение и запросить новые значения
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,_):-nl,write("Некорректный ввод! Чтобы попытаться построить маршрут автоматически из текущей точки, введите h."),
nl,readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst).

%% Алгоритм прохождения графа
findPath(StC,CurC,M,RV,RV,_):-M=19,pnt(CurC,AV), atom_number(StC,SS),insult(SS,AV), append(RV,[CurC],RR),
nl,write("Найденный маршрут: "),write(RR), nl, !.
findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[H,_,_]),atom_string(H,HH),not(insult(HH,Visited)), 
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).

findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[_,H,_]),atom_string(H,HH),not(insult(HH,Visited)),
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).

findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[_,_,H]),atom_string(H,HH),not(insult(HH,Visited)),
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).





%% проверка является ли множество подмножеством другого
subm([],_):-!.
subm([H|T], X):-insult(H,X),subm(T,X).
%% встречается ли элемент в списке
insult(X,[H|_]):- X = H.
insult(X,[_|T]):- insult(X,T).