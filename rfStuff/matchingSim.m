clear all
close all
%https://www.allaboutcircuits.com/tools/l-match-impedance-matching-circuits/
Zan = 18.85 - i*22.65;
%Zin = 50;
L = 1.42e-8;
RL = 0;
%C = 14.7e-12;
C = linspace(0, 400e-12, 1000);
Ci = linspace(1, 1000, 1000);
f = 435e6;
w = 2*pi * f;
Zl = RL + i*w*L;
Zc = 1./(i.*w.*C);
Zin = Zc + Zl*Zan/(Zl+Zan)
figure
plot (C, abs(Zin))
%figure
%plot (imag(Zin), abs(Zin))
figure
plot (Ci, abs(Zin))