%clc
%clear all
%close all

yagiS11 = sparameters('435fail1.s1p');
yagiS11.Frequencies = yagiS11.Frequencies
figure
smithplot(yagiS11)
figure
rfplot(yagiS11)
%figure
%plot(freqHz,Trc1_S11U);
%title('Yagi 144Mhz 6-element 50 Ohm - VSWR')
%xlabel('Frequency')
%ylabel('Amplitude - dB')
grid on