function dy = HHode( t, y, input)
Vm = y(1,1); 
n = y(2,1);
m = y(3,1);
h = y(4,1);
if t>=5 && t<=85.5
    inputI = input(1);
else
    inputI = 0;
end
gNa = 120; 
gK = 36; 
gL = 0.3;
ENa = 55; 
EK = -72; 
EL = -49.42; 
aN = (0.01*(Vm+50))/(1-exp(-(Vm+50)/10));
bN = 0.125*exp(-(Vm+60)/80);
aM = 0.1*(Vm+35)/(1-exp(-(Vm+35)/10));
bM = 4*exp(-0.0556*(Vm+60));
aH = 0.07*exp(-0.05*(Vm+60));
bH = 1/(1+exp(-0.1*(Vm+30)));
dVm =(-gNa*m^3*h*(Vm-ENa)-gK*n^4*(Vm-EK)-gL*(Vm-EL)+inputI);
dn = aN*(1-n)-bN*n;
dm = aM*(1-m)-bM*m;
dh = aH*(1-h)-bH*h;
dy = [dVm; dn; dm; dh];
end