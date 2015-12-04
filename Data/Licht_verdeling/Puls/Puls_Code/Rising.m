function [ dTs ] = Rising( pos,prop,phi,t,h)
%Rising Calculates the temperature increase during the pulse
    %This function uses the solution of the bioheat equation to calculate
    %the temperature increase in the tissue on positon [pos(1), pos(2)]. 
    %It use the fluence rate phi en the properties in prop
    %prop(1)=u_a        absorpion coefficient [m^-1]
    %prop(2)=u_s        scattering coefficient [m^-1]
    %prop(3)=g          anisotropy factor [unitless]
    %prop(4)=p          tissue density [kg/m^3] 
    %prop(5)=c          specific heat [J/(kg*K)]
    %prop(6)=k          thermal diffusivity [W/(m*K)]
    %prop(7)=w_L        1/e^ radius [m] 
    %du_a ans du_s are the errors on the absorption and scattering
    %coefficient
    %h is the time-window indes
r_0=prop(7); 
z_0=2 / (prop(1) + ((1 - prop(3)) * prop(2))) ;
x=prop(4)*prop(5);
y=prop(6)*(2.4)^2;
z=r_0*pi/(4.8*z_0);

tau=(x/y)*(r_0^2/(1+z^2));
dTss=((tau*prop(1))/x);

dTs=dTss*(1-exp(-(t-((h-1)*prop(9)) )/tau))*phi(pos(1),pos(2));
end

