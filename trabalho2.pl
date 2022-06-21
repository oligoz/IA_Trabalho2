resposta(X,Y,Z,File) :- (
						(folha(X), Y = sim, write("Eba acertei!"), nl, inicio(File));
						(folha(X), Y = nao, write("Droga errei :(  Qual animal pensou?"),nl,
							read(W),nl,
							split_string(X," ","?",L), last(L,K),
							format("Qual pergunta devo fazer para distinguir '~a' de '~a'?",[W,K]),nl,
							read(I),nl,
							format("Agora digite qual a resposta certa para '~a' (sim / nao):",[W]),nl,
							read(J),nl,
							write("Obrigado por me ensinar algo novo!"),nl,
							file_to_list(File,List),
							pai(U,X,Z),
							format(string(S),"pai(\"~a\",\"~a\",~a)",[U,X,Z]),
							subtract(List,[S],T),
							rewrite(File, T, X, Z, W, I, J),
							inicio(File)
						)
					), !.

% main
inicio(File) :- consult(File), pergunta("Eh um mamifero?", _, File).

% loop
pergunta(X, Y, File) :-  write(X),nl,
		write('q para sair'),nl,
        write('Nao esqueca de finalizar sua resposta com . ex: sim. ou nao.'),nl,
        read(Z),
        nl,
		(
		resposta(X,Z,Y,File);
			(
				(Z = 'q', write("ate breve!"), !, fail);
				(pai(X, W, Z), pergunta(W, Z, File),!)
			)
		).

file_to_list(FILE,LIST) :- 
   see(FILE), 
   inquire([],R), % gather terms from file
   reverse(R,LIST),
   seen.

inquire(IN,OUT):-
   read(Data), 
   (Data == end_of_file ->   % done
		OUT = IN 
        ;    % more
		(term_string(Data,Conv),
		inquire([Conv|IN],OUT) )) .

primeiro(X,Z, [X|Z]) :- !.

finish_rewrite(L) :- L = [].

rewrite(File, List, X, Z, W, I, J) :- 
	   pai(K,X,Z),
	   inverso(J,O),
	   format(string(S1),"folha(\"Eh um ~a?\")",[W]),
	   format(string(S2),"galho(\"~a\")",[I]),
	   format(string(S3),"pai(\"~a\",\"~a\",~a)",[K,I,Z]),
	   format(string(S4),"pai(\"~a\",\"Eh um ~a?\",~a)",[I,W,J]),
	   format(string(S5),"pai(\"~a\",\"~a\",~a)",[I,X,O]),
	   append([[S1],[S2],[S3],[S4],[S5],List],L),
	   sort(L,Sorted),
	   tell(File),      /* open this file */ 
	   primeiro(First,Resto,Sorted),
	   (
			(
			string(First),
			format("~a.~n",[First])
			);
			(
			term_string(First,Conv),
			format("~a.~n",[Conv])
			)
		),
	   told,
	   (finish_rewrite(Resto); rewrite_cont(File,Resto)),!.

rewrite_cont(File, List) :- 
       append(File),      /* open this file */ 
	   primeiro(First,Resto,List),
	   (
			(
			string(First),
			format("~a.~n",[First])
			);
			(
			term_string(First,Conv),
			format("~a.~n",[Conv])
			)
		),
	   told,
	   (finish_rewrite(Resto); rewrite_cont(File,Resto)), !.
	   
inverso(sim,nao).
inverso(nao,sim).