function [ dTd ] = Dalend( pos ,prop,phi,t,F,tL,D)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%1)u_a
%2)u_s (niet de gereduceerde!)
%3)g
%4)p
%5)c
%6)k
%7)w_L
r_0=prop( 7 ); 
z_0=2 / (prop(1) + ((1 - prop(3)) * prop(2))) ;
x=prop(4)*prop(5);
y=prop(6)*(2.4)^2;
z=r_0*pi/(4.8*z_0);


tau=(x/y)*(r_0^2/(1+z^2));

T0=(tau*prop(1)/(prop(4)*prop(5)))*(1-exp(-(tL)/tau)).*phi(pos(2),pos(1));
dTd=T0*exp(-(t-tL-D*F)/tau);


end

