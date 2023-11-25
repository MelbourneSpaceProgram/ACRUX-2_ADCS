function Vec = Polar(Az, Elev, r)

% Az  : azimuth of vector
% Elev: altitude of vector
% r   : norm of vector

Vec = zeros(3,1);
cosEl = cos(Elev);
Vec(1) = r * cos(Az) * cosEl;
Vec(2) = r * sin(Az) * cosEl;
Vec(3) = r * sin(Elev);