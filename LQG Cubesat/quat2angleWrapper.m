function [Phi] = quat2angleWrapper(q)

[psi, theta, phi] = quat2angle(q');

Phi = [phi, theta, psi];