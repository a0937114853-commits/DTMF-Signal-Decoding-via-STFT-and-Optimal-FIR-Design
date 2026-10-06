% myChebyPol: calculating the Chebyshev polynomials
% 
% W = myChebyPol(N) returns an (N+1)x(N+1) matrix, in which the (m+1)th column is
% the mth-order Chebyshev polynomial defined as 
% T_m(x) = w(1,m+1) + w(2,m+1)x + w(3,m+1)x^2 +... +w(m+1,m+1)x^N
% 
% Used by EE5630 DSP HW7: Optimal FIR design
% Yi-Wen Liu
% Dec. 2021
function W = myChebyPol(N)
W = zeros(N+1,N+1);
W(1,1) = 1; % T_0(x) = 1
W(2,2) = 1; % T_1(x) = x
for m = 2:N
    W(1:m+1,m+1) = 2*([0;W(1:m,m)]) - W(1:m+1,m-1); 
        % This line means T_{m+1}(x) = 2x * T_m(x) - T_{m-1}(x) 
end
return