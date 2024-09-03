clear all
close all
clc

%% Written by Josh Kah for the Melbourne Space Program
% Feel free to ask questions on slack / jkah@melbournespace.com.au

% needs https://au.mathworks.com/matlabcentral/fileexchange/72873-simulink-xbox-controller-xinput-api

%% Constants

% motor loop time constant
tau_motor_loop = 1; % Guess, need to check / calculate this

% Mass moment of inertia of the flywheels
% Moment of For 20mNms momentum storage @5000 RPM = 523.59 rad/s:
I_rw_zz = 0.02 / 523.59;

% Mass moment of inertia of the whole satellite 
% assuming homogeneus density for a 3U, 5kg satellite:
I_xx = 0.0416666666667;
I_yy = 0.0416666666667;
I_zz = 0.00833333333333;

I_s = [I_xx 0 0;
        0 I_yy 0;
        0 0 I_zz];

inv_I_s = inv(I_s);



%% Gains

% gain for the Gibb's vector error ( x, y, z axis quaternion error)
K_p_base = 10;


axis_ratio = I_xx/I_zz;

K_p = [K_p_base*axis_ratio 0 0;
       0 K_p_base*axis_ratio 0;
       0 0 K_p_base];

% gain for the angular rate error (x, y, z axis)
K_pd_base = 50;

K_pd = [K_pd_base*axis_ratio 0 0;
        0 K_pd_base*axis_ratio 0;
        0 0 K_pd_base];