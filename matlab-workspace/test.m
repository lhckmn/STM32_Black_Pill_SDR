clear;
close all;
clc;

%% General parameter setup section
fs = 25e3; % Sampling frequency in Hz
duration = 0.1; % Overall sampling duration in s

% Creating a time vector for the duration of the simulation
t = 0:1/fs:duration;

%% Baseband Signal Creation

% Generate a baseband signal with a frequency offset
sig = cos(2 * pi * 9e3 * t); % Simulated baseband signal

bb_fft_N = length(t);
bb_fft_freq = (-bb_fft_N/2:bb_fft_N/2-1)*(fs/bb_fft_N);
bb_fft = fft(sig); %FFT of DCF77 signal with noise
bb_fft = fftshift(bb_fft); %Shifting FFT
bb_fft = bb_fft / bb_fft_N; %Adjusting FFT gain
bb_fft = 20*log10(abs(bb_fft)); %Converting to logarithmic


% Plot the signal
figure;
subplot(2, 1, 1);
plot(t, sig);

subplot(2, 1, 2);
plot(bb_fft_freq, bb_fft);