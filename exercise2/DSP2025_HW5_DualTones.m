% ASAS 2021 Hw5 create quiz example
%
% This script create a sequence of telephone-line dual-tones
clear; close all; clear sound;

phonenum = [5 7 1 3 1 5 1];
numdigit = length(phonenum); % how many digit
tonelen = 0.2; % sec
tonegap = 0.3; % sec
ramplen = 0.01; % sec
fs = 8000;
dt = 1/fs;
A1 = 0.5; % amplitudes of two tones, respectively
A2 = 0.5;
y = zeros(fs*(numdigit*tonelen + (numdigit-1)*tonegap),1);
tt = dt:dt:ramplen;
tt = tt(:);
win = [sin(tt/ramplen*pi/2).^2; ones(tonelen*fs-2*ramplen*fs,1);...
    sin(tt(end:-1:1)/ramplen*pi/2)];
t_start = 0;
tt_tone = dt:dt:tonelen;
tt_tone = tt_tone(:);

for kk = 1:length(phonenum)
    digit = phonenum(kk);
    switch digit
        case 1
            f1 = 697; f2 = 1209;
        case 2
            f1 = 697; f2 = 1336;
        case 3
            f1 = 697; f2 = 1477;
        case 4
            f1 = 770; f2 = 1209;
        case 5
            f1 = 770; f2 = 1336;
        case 6
            f1 = 770; f2 = 1477;
        case 7
            f1 = 852; f2 = 1209;
        case 8
            f1 = 852; f2 = 1336;
        case 9
            f1 = 852; f2 = 1477;
        case 0
            f1 = 941; f2 = 1336;
    end
    
    y_thistone = (A1*sin(2*pi*f1*tt_tone) + A2*sin(2*pi*f2*tt_tone)).*win;
    y(t_start*fs+1:(t_start + tonelen)*fs) = y_thistone;
    t_start = t_start + tonelen + tonegap;
end

soundsc(y,fs);





%% plot the spectrogram
winlen = 0.02; % sec
L = winlen*fs;
win = hann(L+1); % Hann window
% win = ones(L+1,1); % Rectangular window
% win = blackman(L+1);

win = win(1:end-1);
[S,freqs,~] = spectrogram(y,win,0,2048);

numframes = size(S,2);
timeind = 0:winlen:(numframes-1)*winlen;
waterfall(freqs/(2*pi)*fs,timeind,abs(S)')
    set(gca,XDir="reverse",View=[30 75])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")