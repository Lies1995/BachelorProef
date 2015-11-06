function [ dTd ] = Dalend( pos ,prop,phi,t,D)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
%1)u_a
%2)u_s (niet de gereduceerde!)
%3)g
%4)p
%5)c
%6)k
%7)w_L
%8) pulse length [s]
%9)time between pulses[s]

r_0=prop( 7 ); 
z_0=2 / (prop(1) + ((1 - prop(3)) * prop(2))) ;
x=prop(4)*prop(5);
y=prop(6)*(2.4)^2;
z=r_0*pi/(4.8*z_0);


tau=(x/y)*(r_0^2/(1+z^2));



dTss=((tau*prop(1))/x)*phi(pos(1),pos(2));
T0=dTss*(1-exp(-prop(8)/tau));

dTd=T0*exp(-(t-prop(8)-D*prop(9))/tau);
end


