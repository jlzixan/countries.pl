% IMPORTANT: country data imported must in the format of:
% country(name,region,happiness_rank,happiness_score,gdp_per_capita,family,
%         life_expectancy,freedom,government_corruption,generosity,dystopia_residual)


% Ind is individual noun phrase is referring to
% A noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional modifying phrase:
noun_phrase(T0,T4,Ind) :-
    det(T0,T1,Ind),
    adjectives(T1,T2,Ind),
    noun(T2,T3,Ind),
    mp(T3,T4,Ind).

% Determiners (articles) are ignored in this oversimplified example.
% They do not provide any extra constraints.
det([the | T],T,_).
det([a | T],T,_).
det(T,T,_).

% adjectives(T0,T1,Ind) is true if
% T0-T1 is an adjective is true of Ind
adjectives(T0,T2,Ind) :-
    adj(T0,T1,Ind),
    adjectives(T1,T2,Ind).
adjectives(T,T,_).

% An optional modifying phrase / relative clause is either
% a relation (verb or preposition) followed by a noun_phrase or
% 'that' followed by a relation then a noun_phrase or
% nothing
mp(T0,T2,Subject) :-
    reln(T0,T1,Subject,Object),
    noun_phrase(T1,T2,Object).
mp([that|T0],T2,Subject) :-
    reln(T0,T1,Subject,Object),
    noun_phrase(T1,T2,Object).
mp(T,T,_).

% DICTIONARY
adj([happy | T],T,Obj) :- happy(Obj).
adj([wealthy | T],T,Obj) :- wealthy(Obj).
adj([high,gdp | T],T,Obj) :- wealthy(Obj).

noun([country | T],T,Obj) :- country(Obj,_,_,_,_,_,_,_,_,_,_).
noun([X | T],T,X) :- country(X,_,_,_,_,_,_,_,_,_,_).
noun([region | T],T,Obj) :- country(_,Obj,_,_,_,_,_,_,_,_,_).

reln([the,region,of | T],T,O1,O2) :- country(O2,O1,_,_,_,_,_,_,_,_,_).
reln([the,continent,of | T],T,O1,O2) :- country(O2,O1,_,_,_,_,_,_,_,_,_).
reln([country,is,in | T],T,01,O2) :- country(01,O2,_,_,_,_,_,_,_,_,_).
reln([the,gdp,of | T],T,_01,O2) :- country(O2,_,_,_01,_,_,_,_,_,_,_).
reln([the,family,score,of | T],T,_01,O2) :- country(O2,_,_,_,_01,_,_,_,_,_,_).
% reln([the,life,expectancy,of | T],T,_01,O2) :- country(O2,_,_,_,_,_01,_,_,_,_).
% reln([the,government,score,of | T],T,_01,O2) :- country(O2,_,_,_,_,_,_01,_,_,_).
% reln([the,corruption,score,of | T],T,_01,O2) :- country(O2,_,_,_,_,_,_,_01,_,_).
% reln([the,generosity,score,of | T],T,_01,O2) :- country(O2,_,_,_,_,_,_,_,_01,_).
% reln([the,dystopia,residual,score,of | T],T,_01,O2) :- country(O2,_,_,_,_,_,_,_,_,_01).

% question(Question,QR,Object) is true if Query provides an answer about Object to Question
question([is | T0],T2,Obj) :-
    noun_phrase(T0,T1,Obj),
    mp(T1,T2,Obj).
question([what,is | T0], T1, Obj) :-
    mp(T0,T1,Obj).
question([what,is | T0],T1,Obj) :-
    noun_phrase(T0,T1,Obj).
question([who,is | T0],T1,Ind) :-
    adjectives(T0,T1,Ind).
question([what | T0],T2,Obj) :-
    noun_phrase(T0,T1,Obj),
    mp(T1,T2,Obj).

% ask(Q,A) gives answer A to question Q
ask(Q,A) :-
    question(Q,[],A).


%  The Database of Facts to be Queried

happy(X):-
    country(X,_,B,_,_,_,_,_,_,_,_),
    B =< 5.

wealthy(X):-
    country(X,_,_,_,C,_,_,_,_,_,_),
    C >= 1.5.

/* Try the following queries:
?- ask([what,is,a,country],A).
?- ask([who,is,happy],A).
?- ask([what,is,a,happy,country],A).
?- ask([what,is,a,wealthy,country],A).
?- ask([what,is,a,high,gdp,country],A).
?- ask([what,is,the,region,of,chile],A).
?- ask([what,is,the,continent,of,canada],A).
?- ask([what,is,the,gdp,of,argentina],A).
?- ask([what,is,the,family,score,of,argentina],A).

% Does not work yet [WIP]
?- ask([what,country,is,in,north_america],A).
?- ask([what,is,a,country,that,is,the,region,of,western_europe],A).
?- ask([what,is,a,country,that,is,in,the,same,region,as,the,region,of,denmark],A).
?- ask([what,is,the,gdp,of,a,country,that, in,the,region,western_europe],A).
?- ask([what,country,is,in,the,region,north_america],A).
*/
