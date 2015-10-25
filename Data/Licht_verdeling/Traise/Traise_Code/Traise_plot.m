
%-------Setup-------

Traise_Setup_Data;
t=[0.001,0.01,0.1]; %times to evaluate[s]
path=LD; %path
%positions in tissue
    filename_R=[fullfile(path,'MCML_Data_FR_r')];
    filename_Z=[fullfile(path,'MCML_Data_FR_z')];
    r=csvread(filename_R);  %radial position[mm]
    z=csvread(filename_Z);  %axial position[mm]

%-------Inistiations-
m=1;%index for figures
k=1; %index for the protocols
dT=zeros( 1000, 1000 , length(t) );
prop=[0 0 g p c k 0];           %anisotropy factor;tissue density,
                                %specific heat,thermal diffusivity
%-------PLOT---------
for i = 1: length(L); 
    for j=1:length(NA)
        
        
            %make figure
     %--------Data Collection--------------

        %read in fluence rate
         n_L=L(i); n_NA=NA(j); n_d=d(j);                
         datafile_name = ['MCML_Data_FR_L_' num2str(n_L) '_NA_'...
             num2str(n_NA) '_d_' num2str(n_d)];
         phi=csvread(fullfile(path,datafile_name)); %[kW/m^2]
            phi=phi.*10^3; %[W/m^2]

        %define tissue properties
         prop(1)=u_a(i);    %absorption coefficient [m^-1]
         prop(2)=u_s(i);    %scattering coefficient [m^-1]
         prop(7)=w_L(j);    %1:e^ radius [m]

      %--------Calculation--------------  
      for l=1:length(t)
          fig=figure(m);  
        %calculate temperature raise
         dT(:,:,k,l)=Traise_Data(prop,phi,t(l)); 
      
      %--------Plot--------------

       % plot temperature raise (color) (K)                               
         imagesc(r,z,dT(:,:,k,l)); c=colorbar; 

       %labels  
            title({'Temperature increase';['$\lambda=$' num2str(n_L)...
                ', NA=' num2str(n_NA) ', d=' num2str(n_d),'t:' num2str(t(l))]},...
                'interpreter', 'LaTex');
            xlabel('r [mm]', 'interpreter', 'LaTex'); 
            ylabel('z [mm]', 'interpreter', 'LaTex');
            c.Label.String= '$dT$ [$K$]';
            c.Label.FontSize=20;
            c.Label.Interpreter='latex';
        
        %scaling    
            if j==1
                xlim([-0.3,0.3]);ylim([0,0.6]);
            elseif j==2
                xlim([-1,1]);ylim([0,1.5]);
            end   
          
          m=m+1 ;
           
      end
      csvwrite('tempIn',dT(:,:,k,1));
      dT(493,2,k,:)
      squeeze(dT(493,2,k,:))
      fig=figure(m);
       plot(t,squeeze(dT(500,1,k,:)));
     m=m+1;
     k=k+1;

    end
  end 