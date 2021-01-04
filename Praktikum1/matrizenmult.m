clf;
cores=[1; 2; 4; 8; 16; 32];
times=[0.193926; 0.103533; 0.050293; 0.026104; 0.013637; 0.018740];
seq=[0.0123552500,0.0123552500,0.0123552500,0.0123552500,0.0123552500];
h=plot(cores,times,"linestyle","-","marker","s","markerfacecolor","m");
xlim([1,32]);
set(gca,'XTick',cores);
title("Matrizenmultiplikation Laufzeitvergleich");
xlabel("Anzahl Threads");
ylabel("Laufzeit in Sekunden");
%print -deps 6.eps