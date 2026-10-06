% EE3660 Intro to DSP
% An attempt to implement the Parks-McClellan algorithm from scratch
% Yi-Wen Liu
% May 2025
clear; close all;
omega_c = 0.35*pi;
omega_s = 0.4*pi;
xc = cos(omega_c);
xs = cos(omega_s);
omega_init = [0.05 0.12 0.17 omega_c/pi omega_s/pi 0.48 0.7 0.92 1]*pi;
%omega_init = [0.03 0.05 0.12 0.17 0.26 omega_c/pi omega_s/pi 0.5 0.65 0.7 0.92 1]*pi; % L+2 frequencies
omega_init = omega_init(:);
L = length(omega_init)-2;
x_init = cos(omega_init);
x_prev = zeros(size(x_init));

x_current = sort(x_init);
tol = 1e-4; 
    
BigMatrix = zeros(L+2,L+2);
Hd = zeros(L+2,1);
iternum = 1;

while max(abs(x_prev-x_current)) > tol
    for kk = 1:L+1
        BigMatrix(:,kk) = x_current.^(kk-1);
    end
    BigMatrix(:,end) = ((-1).^(0:L+1))';
    for kk = 1:L+2
        if x_current(kk) >= xc % passband
            Hd(kk) = 1;
        elseif x_current(kk) <= xs % stopband
            Hd(kk) = 0;
        end
    end
    tmpCoeff = BigMatrix\Hd;
    delta = abs(tmpCoeff(end));

    figure(1);
    xx = -1.05:0.01:1.05;
    xthispower = ones(size(xx));
    yy = tmpCoeff(1)*ones(size(xx)); % constant term
    for kk = 1:L
        xthispower = xthispower.*xx;
        yy = yy + tmpCoeff(kk+1)*xthispower;
    end
    plot(xx,yy,'LineWidth',2); hold on;
    %plot(xx+0.05,yy,'LineWidth',2); hold on;
    line([xc 1],[1 1],'color','r');
    line([-1 xs],[0 0],'color','r');
    line([xc 1],[1+delta 1+delta],'linestyle','--','color','r');
    line([xc 1],[1-delta 1-delta],'linestyle','--','color','r');
    line([-1 xs],[delta, delta],'linestyle','--','color','r');
    line([-1 xs],[-delta, -delta],'linestyle','--','color','r');
    title(sprintf('Iteration %d, Delta = %0.4f',iternum,delta));
    xlabel('x=cos\omega');
    ylabel('A(x)');
    xlim([-1.05 1.05])
    setFontSizeForAll(14);
    pause;
    hold off;
    % Find L extrema of y(x) by identifying g(x) = dy/dx first.
    power = 1:L; power = power(:);
    dydxCoeff = tmpCoeff(power+1).*power; % a1 + (2*a2)x + (3*a3)x^2+...+(L*a_L)x^(L-1)
    % Find locations where 1st derivative vanishes
    x_new = roots(dydxCoeff(end:-1:1));
    % 2026/06/08 update
    x_new = real(x_new);
    x_new = sort(x_new);

    % Decide whether to include endpoints (that is x=1 and -1)
    if x_new(1) < -1
        x_new(1) = -1;
        x_new = [x_new; 1];
    elseif x_new(end)>1
        x_new(end) = 1;
        x_new = [-1; x_new];
    else 
        % Need to decide which of the end point to include. 
        % Choose the one with the larger error.
        err_at_1 = sum(tmpCoeff(1:L+1))-1;
        err_at_minus1 = sum(tmpCoeff(1:L+1).*(-1).^(0:L)');
        if abs(err_at_minus1) > abs(err_at_1)
            x_new = [-1;x_new];
        else
            x_new = [x_new; 1];
        end
    end
    x_new = [x_new; xc; xs];
    x_new = sort(x_new);
    x_prev = x_current;
    x_current = x_new;
    iternum = iternum + 1;
end 

W = myChebyPol(L);
a = tmpCoeff(1:end-1);
b = W\a;
h = [1/2*b(end:-1:2); b(1); 1/2*b(2:end)];
figure(2)
freqz(h)
setFontSizeForAll(14)