function [v,m,h,n,t,Iinj]=HHstim(I,Iduration,calc_length,I2,gap)

% This is a simulation of the HH model.
% insert I for the current injected in nA, Iduration for the length
% of injection (ms) and length of calculation in ms.
% if desired second stimulation, enter I2 and gap for the timegap in ms
% between first and second stim.

%length of every step (in s) in the euler method
  dt = 0.001;  
%number of steps for the euler method
  steps  = ceil(calc_length/dt);  
%number of steps with injection of I
  Iduration_steps = ceil(Iduration/dt);
  Iinj=zeros(1,steps);
%injection will begin after 5 ms
  Iinj([5/dt]:[Iduration_steps+5/dt])=I;
  gap_steps = ceil(gap/dt);
  if I2>0
    Iinj([(Iduration_steps+5/dt)+gap_steps]:[(Iduration_steps+5/dt)+gap_steps+Iduration_steps])=I2;
  end
%initial values:
  gNa = 120;  
  eNa= 55;
  gK = 36;  
  eK= -72;
  gL= 0.3;  
  eL= -49.42;
  mi=0.065;
  hi=0.6;
  ni=0.32;
  Vm=-60;
  
%first we will prepare our variables for the calculation
  t = (1:steps)*dt;
  v = zeros(steps,1);
  m = zeros(steps,1);
  h = zeros(steps,1);
  n = zeros(steps,1);
% Set initial values for the variables
  v(1)=Vm;
  m(1)=mi;
  h(1)=hi;
  n(1)=ni;
  
%calculation using euler method:
   for i=1:steps-1 
      Ik=(n(i)^4)*gK*(v(i)-eK);
      Ina=(m(i)^3)*gNa*h(i)*(v(i)-eNa);
      Il=gL*(v(i)-eL);
      Itot=Iinj(i)-Il-Ik-Ina; 
      v(i+1)=v(i)+dt*Itot;
      aM = 0.1*(35+v(i))/(1-(exp((-v(i)-35)/10)));
      bM = 4*(exp(-0.0556*(v(i)+60)));
      aH = 0.07*exp(-0.05*(v(i)+60));
      bH = 1/(exp(-0.1*(30+v(i)))+1);
      aN = (0.01*(v(i)+50))/(1-exp((-v(i)-50)/10));
      bN = 0.125*exp((-v(i)-60)/80);
      m(i+1)=m(i)+dt*(aM*(1-m(i))-bM*m(i));
      h(i+1)=h(i)+dt*(aH*(1-h(i))-bH*h(i));
      n(i+1)=n(i)+dt*(aN*(1-n(i))-bN*n(i));
    end
end  