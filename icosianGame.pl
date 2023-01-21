%% ������������ �������� ����� ������, ����� ������������ ������� ���� �� ����
%% ����� ������� ����� ����(����1,����2,����3) ��� ���� 20 ������

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

%% ������� ��������, ������������ ������ ���� ������
icosianGame():-write("�������: "),nl,write("1. ����� ������ �� ���� 20 �������� � ��������� � ��������."),
nl,write("2. ������ �������� ���� ����� ����� ������ ����."),nl,write("����� ������� ������������ � ���� ��������."),
nl,write("������� ����� ������ ����: "), read(S),atom_string(S,SS),
askNextC(SS,SS,0,[],_).

%% ����� ��������� �������
wrMessage(CurC,AV):- nl,write("��������� ������ ��� �����������: "),
nl,pnt(CurC,AV),write(AV),nl,write("�������� ����� ����� �� ���������: ").

%% ���� ��������� ������ �������� ������������� ����������, �������� �� ����
askNextC(_,CurC,_,Visited,_):-atom_string(CurC,CC),pnt(CC,Q),
subm(Q,Visited),write("�����!").

%% ���� ���������� ����������� ������ 19, ������ ���������� ����� � ��� ��������
askNextC(StC,CurC,M,Visited,RV):-M<19,nl,wrMessage(CurC,AV),
readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst),
askNextC(StC,SS,M1,Vst,RV).

%% ��������� ������������ ����
askNextC(StC,CurC,M,Visited,RV):-M=19,nl,write("�� ��������� ���� ����� ��������� � �������� �����, ���� ��� ��������."),
wrMessage(CurC,AV),
read(S),atom_string(S,SS),
insult(S,AV),SS = StC,append(Visited,CurC,RV),
nl,write("�����! �������: "),write(RV).

%% ���� ������������ ���� h., ����� ������ �������� ���������� �������
askNextC(StC,CurC,M,Visited,RV):-findPath(StC,CurC,M,Visited,RV,M), fail.
%% ���������� ������ ����������
askNextC(_,_,_,_,_):-nl,write("������������ ��� ��������� ���� �� ��������� ������� ��������.").

readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst):-write("����: "),read(S), not(S='h'), 
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,S).

%% ���� �������� h, ������� fail, ��� ������� ���������
readCheckMsg(_,_,_,_,_,_,_):- fail,!.

%% ���� ��������� ����� � ����� ���������, �������� � ������ ���������� 
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,S):-insult(S,AV), atom_string(S,SS),append(Visited,[CurC],Vst),
M1 is M+1, not(insult(SS,Vst)).

%% ��� �������� ����� ������� ��������� � ��������� ����� ��������
checkAndAdd(AV,Visited,CurC,M,SS,M1,Vst,_):-nl,write("������������ ����! ����� ���������� ��������� ������� ������������� �� ������� �����, ������� h."),
nl,readCheckMsg(AV,Visited,CurC,M,SS,M1,Vst).

%% �������� ����������� �����
findPath(StC,CurC,M,RV,RV,_):-M=19,pnt(CurC,AV), atom_number(StC,SS),insult(SS,AV), append(RV,[CurC],RR),
nl,write("��������� �������: "),write(RR), nl, !.
findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[H,_,_]),atom_string(H,HH),not(insult(HH,Visited)), 
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).

findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[_,H,_]),atom_string(H,HH),not(insult(HH,Visited)),
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).

findPath(StC,CurC,M,Visited,RV,StM):- M>=StM,M<19,pnt(CurC,[_,_,H]),atom_string(H,HH),not(insult(HH,Visited)),
append(Visited,[CurC],Vst), M1 is M+1, findPath(StC,HH,M1,Vst,RV,StM).





%% �������� �������� �� ��������� ������������� �������
subm([],_):-!.
subm([H|T], X):-insult(H,X),subm(T,X).
%% ����������� �� ������� � ������
insult(X,[H|_]):- X = H.
insult(X,[_|T]):- insult(X,T).