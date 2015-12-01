function [ dT] = dTError( dphi,phi,dtau,tau,du_a,u_a,t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p=1040;            
c=3650;

term1=( (u_a*phi(2,500)) / (p*c) )*( 1-exp(-t/tau) )- ...
( (tau*u_a*phi(2,500)*exp(-t/tau)*t) / (p*c*tau^2) );
term2=( tau*u_a*(1-exp(-t/tau)) ) / (p*c);
term3=( tau*phi(2,500)*(1-exp(-t/tau)) ) / (p*c);

dT=sqrt(term1^2*dtau^2 + term2^2*(phi(2,500)-dphi)^2 + term3^2*du_a^2);

end

