%Initialise
clear
clc
close all
tic
global BxI ByI BzI lastMagUpdate nextMagUpdate lastSensorUpdate nextSensorUpdate

% Based on ECI frame of earth
Earth

%ICs for postiion and velocity
altitude = 600e3;  %Approximate orbit altitude of CubeSAT in meters
inclination = 45*pi/180;   %Change orbit inclination here, 0 is equitorial

x0 = R + altitude;
y0 = 0;
z0 = 0;
semi_major_axis = norm([x0,y0,z0]);   %Circular orbit
vcirc = sqrt(mu/semi_major_axis);
xdot0 = 0;
ydot0 = vcirc*cos(inclination);
zdot0 = vcirc*sin(inclination);

%ICs for attitude and angular velocity
phi0 = 0;
theta0 = 0; 
psi0 = 0;
ptp0 = [phi0;theta0;psi0];
q0123_0 = EulerAngles2Quaternions(ptp0); %Express in quarternions to avoid singularities

%Angular velocities (body frame)
p0 = 0.01;
q0 = 0.08;
r0 = 0.05;

state = [x0;y0;z0;xdot0;ydot0;zdot0;q0123_0;p0;q0;r0];



%Orbital period (Assume circular orbit)
period = 2*pi*sqrt(semi_major_axis^3/mu); %Kepler's third law
num_orbits = 1;
tfinal = period*num_orbits;
timestep = 1; %Determines how often the RK4 model is called
tout = 0:timestep:tfinal;
stateout = zeros(length(tout), length(state));
%tspan = [0;period*num_orbits];

%Integrate EOM
%[tout, stateout] = ode45(@CubeSAT, tspan, stateinitial);


%Initialise vectors then loop through stateout to extract magnetic field
BxIout = 0*length(stateout);
ByIout = BxIout;
BzIout = BxIout;
nextMagUpdate = 100; %determines how often the IGRF model is called
lastMagUpdate = 0;

%Sensor Parameters
lastSensorUpdate = 0;
nextSensorUpdate = 1;
sensor_params


%Convert to Teslas
for idx = 1:length(tout)
    % save current state
    stateout(idx,:) = state';
    
    %Runge-Kutta 4 function calls
    k1 = CubeSAT(tout(idx), state);
    k2 = CubeSAT(tout(idx)+timestep/2, state+k1*timestep/2);
    k3 = CubeSAT(tout(idx)+timestep/2, state+k2*timestep/2);
    k4 = CubeSAT(tout(idx)+timestep, state+k3*timestep);
    phi_RK = 1/6*(k1 + 2*k2 + 2*k3 + k4);
    state = state + phi_RK*timestep;

    %dstatedt = CubeSAT(tout(idx), stateout(idx,:)');
    BxIout(idx) = BxI;
    ByIout(idx) = ByI;
    BzIout(idx) = BzI;
end

%State Vector
xout = stateout(:,1);
yout = stateout(:,2);
zout = stateout(:,3);
q0123out = stateout(:,7:10);
ptpout = Quaternions2EulerAngles(q0123out);
pqrout = stateout(:,11:13);

%Plot orbit
[X,Y,Z] = sphere;
X = X*R;
Y = Y*R;
Z = Z*R;

fig = figure();
plot3(xout,yout,zout, 'LineWidth', 3)
grid on
hold on
surf(X,Y,Z);
axis equal

%Plot magnetic field and the norm
fig2 = figure();
plot(tout,BxIout, 'LineWidth', 2)
hold on
grid on
plot(tout,ByIout, 'LineWidth', 2)
plot(tout,BzIout, 'LineWidth', 2)
xlabel('Time (sec)');
ylabel('Magnetic Field (T)');
legend('x','y','z');

fig3 = figure();
Bnorm = sqrt(BxIout.^2 + ByIout.^2 + BzIout.^2);
plot(tout, Bnorm, 'LineWidth', 2)
xlabel('Time (sec)');
ylabel('Magnetic Field Magnitude (T)');
grid on

%Plot Euler Angles in degrees
ptpout_deg = ptpout.*(180/pi);
fig4 = figure();
plot(tout, ptpout_deg, 'LineWidth', 2)
grid on
xlabel('Time (sec)');
ylabel('Angles (deg)');

%Plot Angular Velocity
fig5 = figure();
plot(tout, pqrout, 'LineWidth', 2)
grid on
xlabel('Time (sec)');
ylabel('Angular Velocity (rad/s)');

toc