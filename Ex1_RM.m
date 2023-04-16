%for this script, HHstim is a function that stimulates HH model with an
%input of a current injection and the length of the injection in time. the
%function starts the injection by default after 5ms.
%% Q1
%to answer question 1, let's inject a current of 15nA into the system with
%a duration of 0.5ms, and let's view a timeframe of 30ms.
[v,m,h,n,t,Iinj]=HHstim(15,0.5,30,0,0);

%now we can plot a voltage-time series:
figure(1)
    plot(t,v);
    xlabel('Time');
    ylabel('Membrane Potential (mV)');
    title('Voltage time series');
    hold on
    plot(t,Iinj);
    legend('Potential','Current Injected(nA)')
    
%now we can plot the dynamics of the variables during the action potential.   
figure(2)
    sgtitle('Dynamics of Variables')
    subplot(3,2,1)
    plot(h,v);
    xlabel('H');
    ylabel('V');
    title('H vs V'); 
    xlim([0 1]);
    hold on
    subplot(3,2,2)
    plot(t,h);
    xlabel('Time');
    ylabel('H');
    ylim([0 1]);
    title('H vs Time'); 
    hold on
    
    subplot(3,2,3)
    plot(m,v);
    xlabel('M');
    ylabel('V');
    title('M vs V'); 
    xlim([0 1]);
    hold on
    subplot(3,2,4)
    plot(t,m);
    xlabel('Time');
    ylabel('M');
    ylim([0 1]);
    title('M vs Time'); 
    hold on
    
    subplot(3,2,5)
    plot(n,v);
    xlabel('N');
    ylabel('V');
    title('N vs V'); 
    xlim([0 1]);
    hold on
    subplot(3,2,6)
    plot(t,n);
    xlabel('Time');
    ylabel('N');
    title('N vs Time'); 
    ylim([0 1]);

figure(3)
    sgtitle('Dynamics of Variables')
    plot(v,[h,m,n]);
    xlabel('V');
    ylabel('Relative Activation');
    hold on
    legend('H','M','N')
   
    
%we can see in general that M and N increase during the action potential,
%and H decreases during the action potential. this can be viewed in fig 2.
%h is at the peak of it's activation around -60mv which is the resting
%state. m increases while the action potential builds up and peaks
%around the timing of the of the action potential's peak. n reaches
%maximum a bit after m, around the decrease slope of membrane potential after the
%action potential's peak.

%% Q2
% we will make a loop to calculate when the value of v reaches a positive
% value (i.e action potential). for this we will start the loop from 0nA of
% current, in jumps of 0.1 until the loop finds a range of v that is more than 60. 

for i=0:0.1:50
    [v,m,h,n,t,Iinj]=HHstim(i,150,200,0,0);
    if range(v)>60
        break
    end
end
Imin=i

% we can see that the minimum current injection required for an action
% potential is 2.3nA (given a 150ms injection). therefore an injection of
% 2.2 or less will not result in action potential.

%% Q3 (can take 20s)
% we will inject a rising current from Imin (2.3nA) until Imin+15 for 150ms
% in a timeframe of 200ms. lets see what happens:
exist Imin;
if ans==0
 Imin=2.3;
end

counter=0;
a=0;
for i=Imin:0.05:Imin+15
    counter=counter+1;
    [v,m,h,n,t,Iinj]=HHstim(i,150,200,0,0);
    current(counter)=i;
    peakcount=findpeaks(v);
    logpeaks=peakcount>20;
    peakcount=peakcount(logpeaks);
    peaks(counter)=length(peakcount);
    if peaks(counter)>1 && peaks(counter)==peaks(counter-1) 
        peaks(counter)=NaN;
        current(counter)=NaN;
        a=peaks(counter-1);
    end
    if peaks(counter)==a 
        peaks(counter)=NaN;
        current(counter)=NaN;
    end
    if counter>2 && peaks(counter)==1 && peaks(counter-1)==1
        peaks(counter-1)=NaN;
        current(counter-1)=NaN;
    end
        
end

current=rmmissing(current);
peaks=rmmissing(peaks);

figure(4)
plot(current,peaks,'-*','MarkerEdgeColor','r');
hold on
xlabel('Current (nA)');
ylabel('# of peaks');
title('Rate of Peaks'); 

%we can see that the rate bursts up at around an injection of 6nA, and then
%slowly decreases the rate to an almost linear like section after 10nA.


%% Q4
%to prove the refractory period, we need to show that two pulses that are
%above the threshold will not yield two spikes, unless they have enough
%time between them. 
%first, let's inject two pulses and see if it yields two spikes:
[v,m,h,n,t,Iinj]=HHstim(15,0.5,30,15,12);
figure(5);
    sgtitle('Time Gap Between Pulses in Refractory Period')
    subplot(2,1,1)
    plot(t,v);
    xlabel('Time');
    ylabel('Membrane Potential');
    title('Voltage time series'); 
    hold on
    plot(t,Iinj);
    legend('Potential','Current')
%now lets space out the pulses and hope we can yield two spikes:
[v,m,h,n,t,Iinj]=HHstim(15,0.5,30,15,17);
    subplot(2,1,2)
    plot(t,v);
    xlabel('Time');
    ylabel('Membrane Potential');
    title('Voltage time series'); 
    hold on
    plot(t,Iinj);
    legend('Potential','Current','Location','north')    

%we can see that two pulses of the same strength at the beginning 
%did not cause two spikes because they were too close to each other. then 
%the same pulses were spaced out more and did cause two spikes. this proves
%that there is a refractory period.

%now let's try to overcome it. we will take the variables used in the
%second graph, and try to increase the second pulse's strength:
figure(6)
[v,m,h,n,t,Iinj]=HHstim(15,0.5,30,15,12);
    subplot(2,1,1)
    plot(t,v);
    xlabel('Time');
    ylabel('Membrane Potential');
    title('Voltage time series'); 
    hold on
    plot(t,Iinj);
    legend('Potential','Current')
[v,m,h,n,t,Iinj]=HHstim(15,0.5,30,45,12);
    sgtitle('Pulse Strength Overcomes Refractory Period')
    subplot(2,1,2)
    plot(t,v);
    xlabel('Time');
    ylabel('Membrane Potential');
    title('Voltage time series'); 
    hold on
    plot(t,Iinj);
    legend('Potential','Current')
    
% we can see that a stronger pulse creates a second spike and we overcame
%the refractory period.

%% Q5
%let's compare ode 45 model with HHstim:

%ode45
Vm0 = -60;
n0 = 0.32;
m0 = 0.065;
h0 = 0.6;
Injection = 15;
dt = [0 120];
y0 = [Vm0 n0 m0 h0];
[t,y]=ode45(@(t,y) HHode(t,y,[Injection]),dt,y0);   
figure(7);
hold on;
plot(t,y(:,1));
plot(t,Injection*(t>=5 & t<=85));

%HHstim
[v,m,h,n,t,Iinj]=HHstim(15,80,120,0,0);
plot(t,v);
plot(t,Iinj);
title('HH Models Comparison');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
legend('ode45 V','ode45 I', 'HHstim V', 'HHstim I');
xlim([0 120]);
hold off

%we can see that both models yielded an almost identical result in the
%graph.
