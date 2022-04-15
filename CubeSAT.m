function dstatedt = CubeSAT(t, state)
%Globals
global BI BB lastMagUpdate nextMagUpdate lastSensorUpdate nextSensorUpdate 
global BfieldMeasured pqrMeasured invI m I SunI SunB

x = state(1);
y = state(2);
z = state(3);
xdot = state(4);
ydot = state(5);
zdot = state(6);

% Translational kinematics
vel = [xdot;ydot;zdot];

%Rotational Kinematics
q0123 = state(7:10);
p = state(11);
q = state(12);
r = state(13);
pqr = state(11:13);
PQRMAT = [0 -p -q -r;p 0 r -q;q -r 0 p;r q -p 0];
q0123dot = 1/2*PQRMAT*q0123;

% Gravity model (Assume point mass)
Earth
r = state(1:3);
rho = norm(r);
rhat = r/rho;
Fgrav = -(G*M*m/rho^2)*rhat;

%Using IGRF magnetic field model and Sun sensor model
if t >= lastMagUpdate
    lastMagUpdate = lastMagUpdate + nextMagUpdate;

    %Convert Cartesian into Lat, Lon, Alt
    phiE = 0;
    thetaE = acos(z/rho);
    psiE = atan2(y,x);
    latitude = 90-thetaE*180/pi;
    longditude = psiE*180/pi;

    % IGRF Setup, output in nT so convert to T
    % Usage: [BX, BY, BZ] = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD)
    [BN, BE, BD] = igrf('01-Jan-2000', latitude, longditude, rho/1000, 'geocentric');

    % Convert from NED frame to inertial frame
    BNED = [BN; BE; -BD];  %ECI frame has Down as Up
    BI = (TIB(phiE, thetaE+pi, psiE)*BNED).*1e-9;
    
    % Convert inertial frame to body frame
    BB = TIBquat(q0123)*BI;


    % Get MJD for sun vector
    MJD = Mjday(2000, 1, 1, 0, 0, t);
    
    % Geocentric position of the Sun (in [m]), referred
    % to the mean equator and equinox of J2000 (EME2000, ICRF)
    SunI = SunPos(MJD);
    SunB = TIBquat(q0123)*SunI;
end

% Take sensor measurements and add sensor noise
if t >= lastSensorUpdate
    lastSensorUpdate = lastSensorUpdate + nextSensorUpdate;
    [BfieldMeasured, pqrMeasured] = Sensor(BB,pqr);
end


% Translational Dynamics
F = Fgrav; %ignore solar radiation pressure & aerodynamic drag
accel = F/m;

% Magnetorquer
magnetorquer_params;
current = controls(BfieldMeasured,pqrMeasured);
muB = current*mu;
LMN_magtorquers = cross(muB,BB);

% Rotational Dynamics
H = I*pqr;
pqrdot = invI*(LMN_magtorquers - cross(pqr,H));

% Derivatives vector
dstatedt = [vel;accel;q0123dot;pqrdot];
