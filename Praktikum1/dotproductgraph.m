clf;
%cores=[0; 1; 2; 4; 8; 16];
cores=[1; 2; 4; 8; 16];
%times10k=[0.0001988710; 0.0001934560; 0.0002446170; 0.0001602480; 0.0001656810; 0.0002108910];
%times1m=[0.0009928840; 0.0009494740; 0.0010139560; 0.0005876160; 0.0003811760; 0.0003835690];
%times10m=[0.0123552500; 0.0122590400; 0.0083849640; 0.0051476630; 0.0048374750; 0.0052699860];
times10m=[0.0122590400; 0.0083849640; 0.0051476630; 0.0048374750; 0.0052699860];
seq=[0.0123552500,0.0123552500,0.0123552500,0.0123552500,0.0123552500];
%times=[times10k, times1m, times10m]
%h=bar(times, "stacked");
%h=bar(times10m);
h=plot(cores,times10m,"linestyle","-","marker","s","markerfacecolor","m",cores,seq);
set(gca,'XTick',cores);
xlim([1,16]);
%plot(cores,seq);
title("dotpruduct Laufzeitvergleich");
labels=["sequentiell"; "1"; "2"; "4"; "8"; "16"];
xlabel("Anzahl Threads");
ylabel("Laufzeit in Sekunden");
legend(h,"10m","sequentiell")
%set(gca, "XTick", 1:6, "XTickLabel", labels)
%legend(h, "10k", "1m", "10m" );
%print -deps dotproductgraph.eps