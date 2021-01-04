clf;
cores=[1;2;4;8;16;32];
times=[22.2451;11.5705;6.0651;3.3683;2.2527;8.5349];
h=plot(cores,times,"linestyle","-","marker","s","markerfacecolor","m");
set(gca,'XTick',cores);
xlim([1,32]);
title("heated-plate-parallel Laufzeitvergleich");
xlabel("Anzahl Threads");
ylabel("Laufzeit in Sekunden");
%print -deps 4.eps