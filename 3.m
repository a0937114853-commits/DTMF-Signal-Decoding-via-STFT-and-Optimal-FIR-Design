








clear; close all;clc;

omega_c = 0.35*pi;
omega_s = 0.4*pi;
xc = cos(omega_c);
xs = cos(omega_s);
tol = 1e-6;


%omega_init = [0.05 0.12 0.17 omega_c/pi omega_s/pi 0.48 0.7 0.92 1]*pi;

%omega_init = [0.03 0.05 0.12 0.17 0.26 omega_c/pi omega_s/pi 0.5 0.65 0.7 0.92 1]*pi;
%omega_init = [0.03 0.05 0.12 0.14 0.17 0.26 0.30 omega_c/pi omega_s/pi 0.5 0.65 0.7 0.75 0.81 0.92 1]*pi;

omega_init = omega_init(:);
L = length(omega_init)-2;
x_current = sort(cos(omega_init));
x_prev = zeros(size(x_current));
iternum = 1;
fprintf('--- Start Parks-McClellan Iteration ---\n');
while max(abs(x_prev - x_current)) > tol
    BigMatrix = zeros(L+2, L+2);
    for kk = 1:L+1
        BigMatrix(:, kk) = x_current.^(kk-1);
    end
    BigMatrix(:, end) = ((-1).^(0:L+1))';

    Hd = (x_current >= xc) * 1 + (x_current <= xs) * 0;
    tmpCoeff = BigMatrix \ Hd;
    delta = abs(tmpCoeff(end));

    
    figure(1);
    xx = -1.05:0.01:1.05;
    yy = polyval(tmpCoeff(L+1:-1:1), xx);
    plot(xx, yy, 'LineWidth', 2); hold on;
    line([xc 1], [1 1], 'color', 'r');
    line([-1 xs], [0 0], 'color', 'r');
    title(sprintf('Iteration %d, Delta = %0.4f', iternum, delta));
    xlim([-1.05 1.05]); pause(0.1); hold off;

    
    dydxCoeff = tmpCoeff(2:end-1) .* (1:L)';
    x_new = sort(real(roots(dydxCoeff(end:-1:1))));

    
    if x_new(1) < -1, x_new(1) = -1; x_new = [x_new; 1];
    elseif x_new(end) > 1, x_new(end) = 1; x_new = [-1; x_new];
    else
        if abs(polyval(tmpCoeff(L+1:-1:1), -1)) > abs(polyval(tmpCoeff(L+1:-1:1), 1))
            x_new = [-1; x_new]; else, x_new = [x_new; 1];
        end
    end
    x_new = sort([x_new; xc; xs]);
    x_prev = x_current;
    x_current = x_new;
    iternum = iternum + 1;
end 
fprintf('收斂完成！總迭代次數: %d\n', iternum - 1);







W = myChebyPol(L);
a = tmpCoeff(1:end-1);
b = W\a;
h = [1/2*b(end:-1:2); b(1); 1/2*b(2:end)];
figure(2); freqz(h); title('Final FIR Filter Frequency Response');
















clear; close all;clc;

omega_c = 0.35*pi;
omega_s = 0.4*pi;
xc = cos(omega_c);
xs = cos(omega_s);
tol = 1e-6;


omega_init = [0.05 0.12 0.17 omega_c/pi omega_s/pi 0.48 0.7 0.92 1]*pi;


omega_init = omega_init(:);
L = length(omega_init)-2;
x_current = sort(cos(omega_init));
x_prev = zeros(size(x_current));
iternum = 1;
fprintf('--- Start Parks-McClellan Iteration ---\n');
while max(abs(x_prev - x_current)) > tol
    BigMatrix = zeros(L+2, L+2);
    for kk = 1:L+1
        BigMatrix(:, kk) = x_current.^(kk-1);
    end
    BigMatrix(:, end) = ((-1).^(0:L+1))';

    Hd = (x_current >= xc) * 1 + (x_current <= xs) * 0;
    tmpCoeff = BigMatrix \ Hd;
    delta = abs(tmpCoeff(end));

    
    figure(1);
    xx = -1.05:0.01:1.05;
    yy = polyval(tmpCoeff(L+1:-1:1), xx);
    plot(xx, yy, 'LineWidth', 2); hold on;
    line([xc 1], [1 1], 'color', 'r');
    line([-1 xs], [0 0], 'color', 'r');
    title(sprintf('Iteration %d, Delta = %0.4f', iternum, delta));
    xlim([-1.05 1.05]); pause(0.1); hold off;

    
    dydxCoeff = tmpCoeff(2:end-1) .* (1:L)';
    x_new = sort(real(roots(dydxCoeff(end:-1:1))));

    
    if x_new(1) < -1, x_new(1) = -1; x_new = [x_new; 1];
    elseif x_new(end) > 1, x_new(end) = 1; x_new = [-1; x_new];
    else
        if abs(polyval(tmpCoeff(L+1:-1:1), -1)) > abs(polyval(tmpCoeff(L+1:-1:1), 1))
            x_new = [-1; x_new]; else, x_new = [x_new; 1];
        end
    end
    x_new = sort([x_new; xc; xs]);
    x_prev = x_current;
    x_current = x_new;
    iternum = iternum + 1;
end 
fprintf('收斂完成！總迭代次數: %d\n', iternum - 1);



















































clear; close all; clc;

% 設定 omega_c 的掃描範圍
omega_c_range = linspace(0.35*pi, 0.44*pi, 20);
final_deltas = zeros(1, length(omega_c_range));
iternum_results = zeros(1, length(omega_c_range));

for kk = 1:length(omega_c_range)
    omega_c = omega_c_range(kk);
    omega_s = 0.45*pi; 
    xc = cos(omega_c);
    xs = cos(omega_s);
    tol = 1e-6;

    omega_init = [0.05 0.12 0.17 omega_c/pi omega_s/pi 0.48 0.7 0.92 1]*pi;
    omega_init = omega_init(:);
    L = length(omega_init)-2;
    x_current = sort(cos(omega_init));
    x_prev = zeros(size(x_current)) + 999; 

    iternum = 0;

    while max(abs(x_prev - x_current)) > tol
        iternum = iternum + 1;

        BigMatrix = zeros(L+2, L+2);
        for i = 1:L+1
            BigMatrix(:, i) = x_current.^(i-1);
        end
        BigMatrix(:, end) = ((-1).^(0:L+1))';

        Hd = (x_current >= xc) * 1 + (x_current <= xs) * 0;
        tmpCoeff = BigMatrix \ Hd;
        delta = abs(tmpCoeff(end));

        dydxCoeff = tmpCoeff(2:end-1) .* (1:L)';
        x_new = sort(real(roots(dydxCoeff(end:-1:1))));

        if x_new(1) < -1, x_new(1) = -1; x_new = [x_new; 1];
        elseif x_new(end) > 1, x_new(end) = 1; x_new = [-1; x_new];
        else
            if abs(polyval(tmpCoeff(L+1:-1:1), -1)) > abs(polyval(tmpCoeff(L+1:-1:1), 1))
                x_new = [-1; x_new]; else, x_new = [x_new; 1];
            end
        end
        x_new = sort([x_new; xc; xs]);
        x_prev = x_current;
        x_current = x_new;

        if iternum > 100, break; end 
    end

    final_deltas(kk) = delta;
    iternum_results(kk) = iternum+1; 
end

% 分開繪圖
figure('Name', 'Delta vs omega_c');
plot(omega_c_range/pi, final_deltas, '-o', 'LineWidth', 1.5);
xlabel('\omega_c/\pi'); ylabel('\delta'); 
title('Delta vs \omega_c'); grid on;

figure('Name', 'Iterations vs omega_c');
plot(omega_c_range/pi, iternum_results, '-s', 'LineWidth', 1.5);
xlabel('\omega_c/\pi'); ylabel('Iterations'); 
title('Iterations vs \omega_c'); grid on;





