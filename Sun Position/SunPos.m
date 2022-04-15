%------------------------------------------------------------------------------
%
% SunPos: Computes the Sun's ecliptical position using analytical series
%
% Input:
%   Mjd_TT    Modified Julian Date (Terrestrial Time)
%
% Output:
%   rSun	  Geocentric position of the Sun (in [m]), referred
%             to the mean equator and equinox of J2000 (EME2000, ICRF)
%
%------------------------------------------------------------------------------
function rSun = SunPos(Mjd_TT)

global const % Astronomical Constants
SAT_Const

global m_c m_s m_C m_S m_dl m_dr m_db m_u m_v T

T   = (Mjd_TT-const.MJD_J2000)/36525; % Julian cent. since J2000
o   = 10;                       % Index offset
dim = 2*o+1;                    % Work array dimension
m_C = zeros(dim,1);
m_S = zeros(dim,1);
m_c = zeros(dim,1);
m_s = zeros(dim,1);

m_dl=0.0; m_dr=0.0; m_db=0.0; % reset perturbations
m_u = 0;  m_v = 0;

% Mean anomalies of planets and mean arguments of lunar orbit [rad]
M2 = const.pi2 * Frac ( 0.1387306 + 162.5485917*T );
M3 = const.pi2 * Frac ( 0.9931266 +  99.9973604*T );
M4 = const.pi2 * Frac ( 0.0543250 +  53.1666028*T ); 
M5 = const.pi2 * Frac ( 0.0551750 +   8.4293972*T );
M6 = const.pi2 * Frac ( 0.8816500 +   3.3938722*T ); 

D = const.pi2 * Frac ( 0.8274 + 1236.8531*T );
A = const.pi2 * Frac ( 0.3749 + 1325.5524*T );      
U = const.pi2 * Frac ( 0.2591 + 1342.2278*T );

% Keplerian terms and perturbations by Venus
PertInit ( M3,0,7, M2,-6,0 );

PeTerm ( 1, 0,0,-0.22,6892.76,-16707.37, -0.54, 0.00, 0.00);
PeTerm ( 1, 0,1,-0.06, -17.35,    42.04, -0.15, 0.00, 0.00);
PeTerm ( 1, 0,2,-0.01,  -0.05,     0.13, -0.02, 0.00, 0.00);
PeTerm ( 2, 0,0, 0.00,  71.98,  -139.57,  0.00, 0.00, 0.00);
PeTerm ( 2, 0,1, 0.00,  -0.36,     0.70,  0.00, 0.00, 0.00);
PeTerm ( 3, 0,0, 0.00,   1.04,    -1.75,  0.00, 0.00, 0.00);
PeTerm ( 0,-1,0, 0.03,  -0.07,    -0.16, -0.07, 0.02,-0.02);
PeTerm ( 1,-1,0, 2.35,  -4.23,    -4.75, -2.64, 0.00, 0.00);
PeTerm ( 1,-2,0,-0.10,   0.06,     0.12,  0.20, 0.02, 0.00);
PeTerm ( 2,-1,0,-0.06,  -0.03,     0.20, -0.01, 0.01,-0.09);
PeTerm ( 2,-2,0,-4.70,   2.90,     8.28, 13.42, 0.01,-0.01);
PeTerm ( 3,-2,0, 1.80,  -1.74,    -1.44, -1.57, 0.04,-0.06);
PeTerm ( 3,-3,0,-0.67,   0.03,     0.11,  2.43, 0.01, 0.00);
PeTerm ( 4,-2,0, 0.03,  -0.03,     0.10,  0.09, 0.01,-0.01);
PeTerm ( 4,-3,0, 1.51,  -0.40,    -0.88, -3.36, 0.18,-0.10);
PeTerm ( 4,-4,0,-0.19,  -0.09,    -0.38,  0.77, 0.00, 0.00);
PeTerm ( 5,-3,0, 0.76,  -0.68,     0.30,  0.37, 0.01, 0.00);
PeTerm ( 5,-4,0,-0.14,  -0.04,    -0.11,  0.43,-0.03, 0.00);
PeTerm ( 5,-5,0,-0.05,  -0.07,    -0.31,  0.21, 0.00, 0.00);
PeTerm ( 6,-4,0, 0.15,  -0.04,    -0.06, -0.21, 0.01, 0.00);
PeTerm ( 6,-5,0,-0.03,  -0.03,    -0.09,  0.09,-0.01, 0.00);
PeTerm ( 6,-6,0, 0.00,  -0.04,    -0.18,  0.02, 0.00, 0.00);
PeTerm ( 7,-5,0,-0.12,  -0.03,    -0.08,  0.31,-0.02,-0.01);

% Perturbations by Mars 
PertInit ( M3,1,5, M4,-8,-1 );

PeTerm ( 1,-1,0,-0.22,   0.17,    -0.21, -0.27, 0.00, 0.00);
PeTerm ( 1,-2,0,-1.66,   0.62,     0.16,  0.28, 0.00, 0.00);
PeTerm ( 2,-2,0, 1.96,   0.57,    -1.32,  4.55, 0.00, 0.01);
PeTerm ( 2,-3,0, 0.40,   0.15,    -0.17,  0.46, 0.00, 0.00);
PeTerm ( 2,-4,0, 0.53,   0.26,     0.09, -0.22, 0.00, 0.00);
PeTerm ( 3,-3,0, 0.05,   0.12,    -0.35,  0.15, 0.00, 0.00);
PeTerm ( 3,-4,0,-0.13,  -0.48,     1.06, -0.29, 0.01, 0.00);
PeTerm ( 3,-5,0,-0.04,  -0.20,     0.20, -0.04, 0.00, 0.00);
PeTerm ( 4,-4,0, 0.00,  -0.03,     0.10,  0.04, 0.00, 0.00);
PeTerm ( 4,-5,0, 0.05,  -0.07,     0.20,  0.14, 0.00, 0.00);
PeTerm ( 4,-6,0,-0.10,   0.11,    -0.23, -0.22, 0.00, 0.00);
PeTerm ( 5,-7,0,-0.05,   0.00,     0.01, -0.14, 0.00, 0.00);
PeTerm ( 5,-8,0, 0.05,   0.01,    -0.02,  0.10, 0.00, 0.00);

% Perturbations by Jupiter
PertInit ( M3,-1,3, M5,-4,-1 );

PeTerm (-1,-1,0, 0.01,   0.07,     0.18, -0.02, 0.00,-0.02);
PeTerm ( 0,-1,0,-0.31,   2.58,     0.52,  0.34, 0.02, 0.00);
PeTerm ( 1,-1,0,-7.21,  -0.06,     0.13,-16.27, 0.00,-0.02);
PeTerm ( 1,-2,0,-0.54,  -1.52,     3.09, -1.12, 0.01,-0.17);
PeTerm ( 1,-3,0,-0.03,  -0.21,     0.38, -0.06, 0.00,-0.02);
PeTerm ( 2,-1,0,-0.16,   0.05,    -0.18, -0.31, 0.01, 0.00);
PeTerm ( 2,-2,0, 0.14,  -2.73,     9.23,  0.48, 0.00, 0.00);
PeTerm ( 2,-3,0, 0.07,  -0.55,     1.83,  0.25, 0.01, 0.00);
PeTerm ( 2,-4,0, 0.02,  -0.08,     0.25,  0.06, 0.00, 0.00);
PeTerm ( 3,-2,0, 0.01,  -0.07,     0.16,  0.04, 0.00, 0.00);
PeTerm ( 3,-3,0,-0.16,  -0.03,     0.08, -0.64, 0.00, 0.00);
PeTerm ( 3,-4,0,-0.04,  -0.01,     0.03, -0.17, 0.00, 0.00);

% Perturbations by Saturn
PertInit ( M3,0,2, M6,-2,-1 );

PeTerm ( 0,-1,0, 0.00,   0.32,     0.01,  0.00, 0.00, 0.00);
PeTerm ( 1,-1,0,-0.08,  -0.41,     0.97, -0.18, 0.00,-0.01);
PeTerm ( 1,-2,0, 0.04,   0.10,    -0.23,  0.10, 0.00, 0.00);
PeTerm ( 2,-2,0, 0.04,   0.10,    -0.35,  0.13, 0.00, 0.00);

% Difference of Earth-Moon-barycentre and centre of the Earth
m_dl = m_dl +  6.45*sin(D) - 0.42*sin(D-A) + 0.18*sin(D+A)...
        +  0.17*sin(D-M3) - 0.06*sin(D+M3);

m_dr = m_dr + 30.76*cos(D) - 3.06*cos(D-A) + 0.85*cos(D+A)...
        -  0.58*cos(D+M3) + 0.57*cos(D-M3);

m_db = m_db + 0.576*sin(U);

% Long-periodic perturbations
m_dl = m_dl + 6.40 * sin ( const.pi2*(0.6983 + 0.0561*T) )...
        + 1.87 * sin ( const.pi2*(0.5764 + 0.4174*T) )...
        + 0.27 * sin ( const.pi2*(0.4189 + 0.3306*T) )...
        + 0.20 * sin ( const.pi2*(0.3581 + 2.4814*T) );

% Ecliptic coordinates ([rad],[AU])
l = const.pi2 * Frac ( 0.7859453 + M3/(const.pi2) + ...
               ( (6191.2+1.1*T)*T + m_dl ) / 1296.0e3 );
r = 1.0001398 - 0.0000007 * T + m_dr * 1.0e-6;
b = m_db / const.Arcs;

rSun = Polar(l,b,r);  % Position vector

rSun = const.AU*(EclMatrix(Mjd_TT)*PrecMatrix(const.MJD_J2000,Mjd_TT))'*rSun;

end

% Set time, mean anomalies and index range
function [] = PertInit(M, I_min, I_max, m, i_min, i_max)

global m_c m_s m_C m_S

o = 11;         % Index offset

% cosine and sine of multiples of M
m_C(o)=1.0; m_C(o+1)=cos(M); m_C(o-1)=+m_C(o+1);
m_S(o)=0.0; m_S(o+1)=sin(M); m_S(o-1)=-m_S(o+1);

for i=1:I_max-1
    [m_C(o+i+1), m_S(o+i+1)] = AddThe(m_C(o+i),m_S(o+i),m_C(o+1),m_S(o+1));
end

for i=-1:-1:I_min+1
    [m_C(o+i-1), m_S(o+i-1)] = AddThe(m_C(o+i),m_S(o+i),m_C(o-1),m_S(o-1));
end

% cosine and sine of multiples of m
m_c(o)=1.0; m_c(o+1)=cos(m); m_c(o-1)=+m_c(o+1);
m_s(o)=0.0; m_s(o+1)=sin(m); m_s(o-1)=-m_s(o+1);

for i=1:i_max-1
    [m_c(o+i+1), m_s(o+i+1)] = AddThe(m_c(o+i),m_s(o+i),m_c(o+1),m_s(o+1));
end

for i=-1:-1:i_min+1
    [m_c(o+i-1), m_s(o+i-1)] = AddThe(m_c(o+i),m_s(o+i),m_c(o-1),m_s(o-1));
end

end

% Sum-up perturbations in longitude, radius and latitude
function [] = PeTerm (I, i, iT, dlc, dls, drc, drs, dbc, dbs)

global m_c m_s m_C m_S m_dl m_dr m_db m_u m_v T

o = 11;         % Index offset

if ( iT == 0 )
    [m_u, m_v] = AddThe(m_C(o+I),m_S(o+I),m_c(o+i),m_s(o+i));
else
    m_u = m_u * T; m_v = m_v * T;
end

m_dl = m_dl + ( dlc*m_u + dls*m_v );
m_dr = m_dr + ( drc*m_u + drs*m_v );
m_db = m_db + ( dbc*m_u + dbs*m_v );

end

