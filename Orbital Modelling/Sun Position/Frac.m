%--------------------------------------------------------------------------
% 
%  Frac: Fractional part of a number (y=x-[x])
%
% Last modified:   2015/08/12   M. Mahooti
%
%--------------------------------------------------------------------------
function [res] = Frac(x)

res = x-floor(x);

