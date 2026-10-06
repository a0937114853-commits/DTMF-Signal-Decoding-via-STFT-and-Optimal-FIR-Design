



%%
clear; close all; clear sound; clc;

%%2(a)
phonenum = [1 2 3 4 5 6 7 8 9 0];
numdigit = length(phonenum); 
tonelen = 0.2;
tonegap = 0.3;
ramplen = 0.01;
fs = 8000;
dt = 1/fs;
A1 = 0.5; 
A2 = 0.5;
total_samples = round(fs * (numdigit * tonelen + (numdigit - 1) * tonegap));
y = zeros(total_samples, 1);
tt = dt:dt:ramplen;
tt = tt(:);
win = [sin(tt/ramplen*pi/2).^2; ones(round(tonelen*fs-2*ramplen*fs), 1); ...
    sin(tt(end:-1:1)/ramplen*pi/2)];
t_start = 0;
tt_tone = dt:dt:tonelen;
tt_tone = tt_tone(:);

for kk = 1:length(phonenum)
    digit = phonenum(kk);
    switch digit
        case 1, f1 = 697; f2 = 1209;
        case 2, f1 = 697; f2 = 1336;
        case 3, f1 = 697; f2 = 1477;
        case 4, f1 = 770; f2 = 1209;
        case 5, f1 = 770; f2 = 1336;
        case 6, f1 = 770; f2 = 1477;
        case 7, f1 = 852; f2 = 1209;
        case 8, f1 = 852; f2 = 1336;
        case 9, f1 = 852; f2 = 1477;
        case 0, f1 = 941; f2 = 1336;
    end
    
    y_thistone = (A1*sin(2*pi*f1*tt_tone) + A2*sin(2*pi*f2*tt_tone)).*win;
    
    
    idx_start = round(t_start * fs) + 1;
    idx_end = idx_start + length(y_thistone) - 1;
    

    y(idx_start:idx_end) = y_thistone;
    
    t_start = t_start + tonelen + tonegap;
end

soundsc(y, fs);



filename = 'phonenum_tones.wav';
audiowrite(filename, y, fs);

fprintf('檔案已儲存為: %s\n', filename);






%% plot the spectrogram(Hann)
winlen = 0.0055;
L = winlen*fs;
win = hann(L+1);


win = win(1:end-1);
[S,freqs,~] = spectrogram(y,win,0,2048);

numframes = size(S,2);
timeind = 0:winlen:(numframes-1)*winlen;
waterfall(freqs/(2*pi)*fs,timeind,abs(S)')
    set(gca,XDir="reverse",View=[30 75])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")


%% plot the spectrogram(Rectangular)
winlen = 0.0031;
L = round(winlen*fs);
win = ones(L+1,1);


win = win(1:end-1);
[S,freqs,~] = spectrogram(y,win,0,2048);

numframes = size(S,2);
timeind = 0:winlen:(numframes-1)*winlen;
waterfall(freqs/(2*pi)*fs,timeind,abs(S)')
    set(gca,XDir="reverse",View=[30 75])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")




%% plot the spectrogram(Blackman)
winlen = 0.0065;
L = winlen*fs;
win = blackman(L+1);

win = win(1:end-1);
[S,freqs,~] = spectrogram(y,win,0,2048);

numframes = size(S,2);
timeind = 0:winlen:(numframes-1)*winlen;
waterfall(freqs/(2*pi)*fs,timeind,abs(S)')
    set(gca,XDir="reverse",View=[30 75])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")

























%%2(b)
[x, fs] = audioread('unknown_phonenum.wav');

%
winlen = 0.02;
L = round(winlen * fs);
win = hann(L+1); win = win(1:end-1);


[S, freqs, t] = spectrogram(x, win, 0, 2048, fs);

figure;
waterfall(freqs, t, abs(S)');
set(gca, 'XDir', 'reverse', 'View', [30 75]);
xlabel('Frequency (Hz)');
ylabel('Time (s)');
zlabel('Magnitude');
title('Spectrogram of unknown\_phonenum.wav');






































%%method1
[x, fs] = audioread('unknown_phonenum.wav');

target_time = 3.6; 

start_idx = round(target_time * fs);
window_size = round(0.05 * fs);
segment = x(start_idx : start_idx + window_size);

NFFT = 2048;
f = (0:NFFT-1) * (fs / NFFT);
spec = abs(fft(segment, NFFT));


[pks, locs] = findpeaks(spec(1:NFFT/2), 'SortStr', 'descend', 'NPeaks', 2);
f_peaks = sort(f(locs));

figure;
plot(f(1:NFFT/2), 20*log10(spec(1:NFFT/2)+eps));
hold on;
plot(f_peaks, 20*log10(pks+eps), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
title(['Spectrum at t = ', num2str(target_time), 's']);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
grid on;
legend('Spectrum', 'Detected Peaks');

fprintf('At t=%.2fs, Detected F1=%.0fHz, F2=%.0fHz\n', ...
    target_time, f_peaks(1), f_peaks(2));

















%% 1. 讀取並分析 unknown_phonenum.wav
[x, fs] = audioread('unknown_phonenum.wav');

% 設定觀測參數 (使用較長窗口以確保解析度)
winlen = 0.02; 
L = round(winlen * fs);
% 使用 Hann 視窗進行 STFT
[S, freqs, t] = spectrogram(x, hann(L), round(L*0.8), 2048, fs);

% 2. 繪製 3D Waterfall 圖
figure('Color', 'w');
% 使用 20*log10 讓背景更乾淨，峰值更突出
waterfall(freqs, t, 20*log10(abs(S)' + eps));
set(gca, 'XDir', 'reverse', 'View', [30 75]);
xlabel('Frequency (Hz)');
ylabel('Time (s)');
zlabel('Magnitude (dB)');
title('Spectrogram of unknown\_phonenum.wav');
colormap jet;

%% 3. 自動解碼 (加入去抖動邏輯，濾除初始雜訊)
low_freqs = [697, 770, 852, 941];
high_freqs = [1209, 1336, 1477];
keypad = [1 2 3; 4 5 6; 7 8 9; -1 0 -1];

detected_digits = [];
last_digit = -1;
consecutive_count = 0;

fprintf('--- Start Decoding ---\n');
for col = 1:length(t)
    % 找出該時間段能量最強的兩個峰值
    [pks, locs] = findpeaks(abs(S(:, col)), 'SortStr', 'descend', 'NPeaks', 2);
    if length(locs) < 2, continue; end
    f_peaks = sort(freqs(locs));

    [~, r] = min(abs(low_freqs - f_peaks(1)));
    [~, c] = min(abs(high_freqs - f_peaks(2)));

    % 若偵測到合理的 DTMF 對
    if r <= 4 && c <= 3 && keypad(r, c) ~= -1
        current_digit = keypad(r, c);

        if current_digit == last_digit
            consecutive_count = consecutive_count + 1;
        else
            % 只有當一個數字穩定出現超過 3 次時，才認定是有效輸入
            % 這能有效過濾掉瞬態雜訊與切換瞬間的錯誤偵測
            if consecutive_count > 3 
                detected_digits = [detected_digits, last_digit];
            end
            last_digit = current_digit;
            consecutive_count = 1;
        end
    end
end
% 補上最後一個偵測到的數字
if consecutive_count > 3, detected_digits = [detected_digits, last_digit]; end

fprintf('--- Final Detected Phone Number: %s ---\n', num2str(detected_digits));














