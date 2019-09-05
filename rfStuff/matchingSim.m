%https://www.allaboutcircuits.com/tools/l-match-impedance-matching-circuits/
Zan = 28;
%Zin = 50;
L = 120e-6;
RL = 0;
%C = 14.7e-12;
C = linspace(0, 40e-12, 1000);
f = 435e6;
w = 2*pi * f;
Zl = RL + i*w*L;
Zc = 1./(i.*w.*C);
Zin = Zc + Zl*Zan/(Zl+Zan)
plot (C, abs(Zin))
