function [ dT ] = Traise_Data(prop,phi)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here 
%1)u_a
%2)u_s (niet de gereduceerde!)
%3)g
%4)p
%5)c
%6)k
%7)w_L
r_0=prop( 7 ); 
z_0=(2 / ( prop( 1 ) + ( 1 - prop( 3 ) )* prop( 2 ) ) );

tau=( prop( 4 ) * prop( 5 ) / ( prop( 6 ) * 2.40 ^ 2 ) ) * ( r_0 ^ 2 / ( 1 + (r_0 ^ 2 / ( 1.5 * z_0 ) ^ 2) ) );
t=3*tau;
dT=( ( tau .* prop( 1 ) .* phi ) ./ ( prop( 4 ) * prop( 5 ) ) ) * ( 1 - exp( - t / tau ) );

end
