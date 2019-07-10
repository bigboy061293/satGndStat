%clc
%clear all
%close all

yagiS11 = sparameters('yagi144Mhz.s1p');
yagiS11.Frequencies = yagiS11.Frequencies/10e8
figure
smithplot(yagiS11)
figure
rfplot(yagiS11)
figure
plot(freqHz,Trc1_S11U);
title('Yagi 144Mhz 6-element 50 Ohm - VSWR')
xlabel('Frequency')
ylabel('Amplitude - dB')
grid on