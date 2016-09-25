%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Grundlegende Definitionen zur Wahrscheinlichkeitsrechnung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      o Die Ergebnismenge Ω(Ergebnisraum) enthält alle Ergebnisse eines
%        Zufallsexperimentes.  Die Anzahl der Ergebnisse in bezeichnet Ω
%        man als dessen Mächtigkeit.   Es gilt: |Ω|=n
%
%      o Jede Teilmenge der Ergebnismenge Ω bezeichnet man als ein
%        Ereignis E. 
%
%      o Wenn man dasselbe Zufallsexperiment mehrfach hintereinander
%        ausführt, so bezeichnet man es als ein mehrstufiges
%        Zufallsexperiment (beispielsweise mehrfaches Würfeln). Die
%        Ergebnismenge Ω besteht dann aus der Menge aller möglichen
%        Ereignisse.
%
%      o Ein Gegenereignis ist die Menge aller Ergebnisse, die nicht
%        zum Ereignis gehören.


%% Zufallsexperiment:   Einmal Würfeln
% Ergebnismenge Ω:     
omega = [1:1:6]
% Mächtigkeit |Ω| = 6:     Weil 6 flächen
mo = size(omega,2)

%% Zufallsexperiment:   Zweimal Würfeln
% Ergebnismenge Ω:     
w1=[1:1:6];
w2=[1:1:6];
omega = [   w1+w2*(w2==1)';...
            w1+w2*(w2==2)';...
            w1+w2*(w2==3)';...
            w1+w2*(w2==4)';...
            w1+w2*(w2==5)';...
            w1+w2*(w2==6)']

% Mächtigkeit |Ω| = 6:     
mo = size(w1,2)*size(w2,2)


%%  REGELN
%
%     o Die Wahrscheinlichkeit eines Ereignisses liegt zwischen 0 und
%       1: 0 ≤ P(E) ≤1. Die Anzahl der günstigen Ereignisse ist immer
%       kleiner oder gleich der Anzahl der möglichen Ereignisse.
%     o Summenregel für zwei Ergebnisse eines Zufallsexperimentes x1
%       und x2: P({x1 ,x2})=P({x1})+P({x2}) 
%     o Das sichere Ereignis hat die Wahrscheinlichkeit 1: P(Ω)=1 
%     o Das unmögliche Ereignis hat die Wahrscheinlichkeit 0: P(∅)=0
%     o Die Wahrscheinlichkeit des Gegenereignisses ist: 1-P(E) 
%     o Für dieVereinigung zweier Ereignisse gilt: 
%           P(E1∪E2 ) =P (E1) + P(E2 ) - P( E1 ∩E2 ) ≤ P (E1) + P( E2 ) 
%     o Additionssatz: Sind die Mengen unvereinbar, also 
%       P( E1∩E2 ) =∅, dann gilt: 
%       P(E1∪E2 ) = P (E1) + P( E2 )
%% 
%% 

