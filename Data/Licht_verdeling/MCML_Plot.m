
%-------Setup-------
Setup_Data
file_path=LD;                                                %Choose what path to use
%LD=Lies Deceuninck, HV=Hannelore Verhoeven

%-------PLOT-------
k=1;
  for i = 1: length(L); 
    for j=1:length(NA)
        
        fig=figure(k);                                      %make figure
        set(fig, 'Position', [10 1000 1400 500]);           
        
             n_L=L(i); n_NA=NA(j); n_d=d(j);                %Specifying data
             [r,z,fRate]=MCML_Data(n_L,n_NA,n_d,file_path); %Calculation Fluence rate   
             fRateData(:,:,k)=fRate;                        %store data fluence rate
               
             subplot(1,2,1)                                 %Plot Fluence Rate (color) (mW/mm^)
             imagesc(r,z,fRate); c=colorbar;                  
                title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ', d=' char(n_d)]},'interpreter', 'LaTex');
                xlabel('r [mm]', 'interpreter', 'LaTex'); 
                ylabel('z [mm]', 'interpreter', 'LaTex');
                c.Label.String= '$\phi$ [$\frac{mW}{mm^2}$]';
                c.Label.FontSize=20;
                c.Label.Interpreter='latex';
                
                
             subplot(1,2,2)                                 %Plot Fluence Rate (height) (mW/mm^)
             plot(z,fRate(:,501)) 
                title({'Fluence Rate';['$\lambda=$' char(n_L) ', NA=' ...
                    char(n_NA) ', d=' char(n_d)]},'interpreter', 'LaTex');
                xlabel('z [mm]', 'interpreter', 'LaTex'); 
                ylabel('$\phi$ [$\frac{mW}{mm^2}$]', 'interpreter', 'LaTex'); 
                
               if j==1 
                   xlim([0,10]);ylim([0,100]);
               elseif j==2 
                   xlim([0,10]);ylim([0,0.2]);   
               end
               
         k=k+1;
        
    end
  end 
 
