% This program calculates the frequency vs current plot

ImpCurAll = 0:0.01:0.09 %Stores all the current values
ImpCurAll = [ImpCurAll 0.1:0.05:0.9] %grading has been done to improve performance
threshold = 10; %threshold that determines an AP
count = zeros(size(ImpCurAll)(2))(1); % stores the firing rate or frequency

for outeriter = 1:size(ImpCurAll)(2);
	%Calculate the charachteristics of a particular current
	ImpCur = ImpCurAll(outeriter);
	gkmax=.36;
	vk=-77; 
	gnamax=1.20;
	vna=50; 
	gl=0.003;
	vl=-54.387; 
	cm=.01; 
	dt=0.01;
	niter=50000;
	t=(1:niter)*dt;
	iapp=ImpCur*ones(1,niter);
	v=-64.9964;
	m=0.0530;
	h=0.5960;
	n=0.3177;

	gnahist=zeros(1,niter);
	gkhist=zeros(1,niter);
	vhist=zeros(1,niter);
	mhist=zeros(1,niter);
	hhist=zeros(1,niter);
	nhist=zeros(1,niter);

	for iter=1:niter
  	gna=gnamax*m^3*h; 
  	gk=gkmax*n^4; 
  	gtot=gna+gk+gl;
  	vinf = ((gna*vna+gk*vk+gl*vl)+ iapp(iter))/gtot;
  	tauv = cm/gtot;
  	v=vinf+(v-vinf)*exp(-dt/tauv);
  	alpham = 0.1*(v+40)/(1-exp(-(v+40)/10));
  	betam = 4*exp(-0.0556*(v+65));
  	alphan = 0.01*(v+55)/(1-exp(-(v+55)/10));
  	betan = 0.125*exp(-(v+65)/80);
  	alphah = 0.07*exp(-0.05*(v+65));
  	betah = 1/(1+exp(-0.1*(v+35)));
  	taum = 1/(alpham+betam);
  	tauh = 1/(alphah+betah);
  	taun = 1/(alphan+betan);
  	minf = alpham*taum;
  	hinf = alphah*tauh;
  	ninf = alphan*taun;
  	m=minf+(m-minf)*exp(-dt/taum);
  	h=hinf+(h-hinf)*exp(-dt/tauh);
  	n=ninf+(n-ninf)*exp(-dt/taun);
  	vhist(iter)=v; mhist(iter)=m; hhist(iter)=h; nhist(iter)=n;
	end

	%Calculates the peaks
	[pks loc] = findpeaks(vhist,"DoubleSided");
	pks1 = [];
	loc1 = [];
	for iter  = 1:length(pks)
		if(pks(iter)>threshold)
 			pks1 = [pks1 pks(iter)];
 			loc1 = [loc1 loc(iter)];
		end
	end
	count(outeriter) = length(pks1)	

end
%Calculates the threshold currents and prints it accoringly
I_1 = 0;
I_2 = 0;
I_3 = 0;
for iter = 1:(length(count)-1)
	if count(iter+1)>0 && count(iter)==0 && I_1==0
		I_1 = ImpCurAll(iter)
	elseif count(iter+1)>3 && count(iter)<=3 && I_2==0
		I_2 = ImpCurAll(iter)
	elseif count(iter+1)<=3 && count(iter)>3 && I_3==0
		I_3 = ImpCurAll(iter+1)
	end
end

%plots the graph
figure(1)
plot(ImpCurAll,count);
hold on
plot(I_1*ones(1+max(count)),0:max(count),'r');
plot(I_2*ones(1+max(count)),0:max(count),'g');
plot(I_3*ones(1+max(count)),0:max(count),'b');
title('frequency vs current')
hold off


