clear all
close all
%https://www.allaboutcircuits.com/tools/l-match-impedance-matching-circuits/
Zan = 18.85 - i*22.65;
%Zin = 50;
%L = 1.42e-8;
L = linspace (1e-10, 1e-6, 1000);
RL = 0;
%C = 14.7e-12;
%C = linspace(0, 400e-12, 1000);
C = 100e-9;
%Ci = linspace(1, 1000, 1000);
f = 435e6;
w = 2*pi * f;
Zl = RL + i.*w.*L;
Zc = 1/(i*w*C);
Zin = Zc + Zl*Zan./(Zl+Zan)
figure
plot (L, abs(Zin))
figure
plot (imag(Zin), abs(Zin))
%figure
%plot (Ci, abs(Zin))