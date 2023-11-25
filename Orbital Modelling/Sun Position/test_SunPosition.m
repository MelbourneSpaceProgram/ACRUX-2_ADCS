%--------------------------------------------------------------------------
%
% test_SunPosition: Computes solar ephemeris
%
% References:
% Montenbruck O., Gill E.; Satellite Orbits: Models, Methods and 
% Applications; Springer Verlag, Heidelberg; Corrected 3rd Printing (2005).
%
% Montenbruck O., Pfleger T.; Astronomy on the Personal Computer; Springer 
% Verlag, Heidelberg; 4th edition (2000).
%
% Vallado D. A; Fundamentals of Astrodynamics and Applications; McGraw-Hill;
% New York; 3rd edition(2007).
%
% http://ssd.jpl.nasa.gov/?ephemerides
%
% https://celestrak.com/SpaceData/
%
% Last modified:   2019/11/13   Meysam Mahooti
%
%--------------------------------------------------------------------------
clc
clear
format long g

global PC    % Planetary Coefficients
global const % Astronomical Constants

SAT_Const

load DE436Coeff.mat
PC = DE436Coeff;

% Initialize UT1-UTC and TAI-UTC time difference
fid = fopen('eop19620101.txt','r');

%  ----------------------------------------------------------------------------------------------------
% |  Date    MJD      x         y       UT1-UTC      LOD       dPsi    dEpsilon     dX        dY    DAT
% |(0h UTC)           "         "          s          s          "        "          "         "     s 
%  ----------------------------------------------------------------------------------------------------

eopdata = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 inf]);

fclose(fid);

MJD_UTC = Mjday(2019,11,4,12,0,0);

[x_pole,y_pole,UT1_UTC,LOD,dpsi,deps,dx_pole,dy_pole,TAI_UTC] = IERS(eopdata,MJD_UTC,'l');
[UT1_TAI,UTC_GPS,UT1_GPS,TT_UTC,GPS_UTC] = timediff(UT1_UTC,TAI_UTC);

MJD_TT = MJD_UTC + TT_UTC/86400;
MJD_TDB = Mjday_TDB(MJD_TT);

fprintf('\nsolar coordinates derived from the Chebyshev coefficients of ');
fprintf('the Development Ephemeris DE436 [m]\n');
fprintf('Barycentric Dynamical Time (TDB) is used for JPL ephemerides computations\n');
[r_Mercury,r_Venus,r_Earth,r_Mars,r_Jupiter,r_Saturn,r_Uranus, ...
 r_Neptune,r_Pluto,r_Moon,r_Sun] = JPL_Eph_DE436(MJD_TDB);
r_Sun

fprintf('\nsolar coordinates derived from the Chebyshev coefficients of ');
fprintf('the Development Ephemeris DE436 [m]\n');
fprintf('Coordinated Universal Time (UTC) is used for JPL ephemerides computations\n');
[r_Mercury,r_Venus,r_Earth,r_Mars,r_Jupiter,r_Saturn,r_Uranus, ...
 r_Neptune,r_Pluto,r_Moon,r_Sun] = JPL_Eph_DE436(MJD_UTC);
r_Sun

fprintf('high-precision analytic solar coordinates [m]');
rSun = SunPos(MJD_TT)

fprintf('low-precision analytic solar coordinates [m]');
rSun = Sun(MJD_TT)

