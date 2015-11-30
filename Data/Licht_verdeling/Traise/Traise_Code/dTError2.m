function [ dT] = dTError2( phi,du_a,du_s,prop,t )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%1)u_a
%2)u_s (niet de gereduceerde!)
%3)g
%4)p
%5)c
%6)k
%7)w_L
prop(1)=du_a+prop(1);
prop(2)=du_s+prop(2);
r_0=prop( 7 ); 
z_0=2 / (prop(1) + ((1 - prop(3)) * prop(2))) ;
x=prop(4)*prop(5);
y=prop(6)*(2.4)^2;
z=r_0*pi/(4.8*z_0);


tau=(x/y)*(r_0^2/(1+z^2));


dT=(tau*prop(1)/(prop(4)*prop(5)))*(1-exp(-t/tau)).*phi;

end

