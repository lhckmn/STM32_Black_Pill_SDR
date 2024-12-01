clear;
close all;
clc;

%% General parameter setup section

f_zf = 15e3; %Intermediate frequency in Hz
f_lo = f_zf - 800;

f_s = 48e3; %Sampling frequency in Hz
duration = 0.01; %Overall sampling duration in s (duration of the simulation)

%Creating a time vector for the duration of the simulation
t = 0:1/f_s:duration;


baseband_sig = cos(2*pi*f_zf*t);
sig_s1 = bandpass(baseband_sig, [14e3 16e3], f_s);

sig_s2 = sig_s1 .* cos(2*pi*f_lo*t);

output = lowpass(sig_s2, 3e3, f_s);

%sig_i = baseband_sig;
%sig_q = imag(hilbert(baseband_sig));
%output = 0.5*(sig_i + sig_q);

figure
subplot(5,1,1);
plot(t, baseband_sig);

subplot(5,1,2);
plot(t, sig_s1);

subplot(5,1,3);
plot(t, sig_s2);

subplot(5,1,4);
plot(t, output);

bb_fft_N = length(t);
bb_fft_freq = (-bb_fft_N/2:bb_fft_N/2-1)*(f_s/bb_fft_N);
bb_fft = fft(baseband_sig); %FFT of DCF77 signal with noise
bb_fft = fftshift(bb_fft); %Shifting FFT
bb_fft = bb_fft / bb_fft_N; %Adjusting FFT gain
bb_fft = 20*log10(abs(bb_fft)); %Converting to logarithmic
subplot(5,1,5);
plot(bb_fft_freq, bb_fft);