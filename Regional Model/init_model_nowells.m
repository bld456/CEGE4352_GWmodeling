
%NO WELLS
%%%%%%%%%%%%%%%%%%%










base = 237;%m
k = 152.4 ;%m

refPhi = (280-base)^2*.5*152.4; 
refz =  4.6000e+05+ 4.97e+06i;


model = Model();
%%initialize infiltration area and strength


addpath('infiltration');
gamma0 =-.0004 ;%m/day (6 inches per year)
eps = 10^-5;
z_infil_1 = [];
z_infil_1(1)= 440000+ 1i*4960000;
z_infil_1(2)=  490000 + 1i*4960000;
z_infil_1(3)= 490000 + 1i*4990000;
z_infil_1(4)= 440000 + 1i*4990000;
z_infil_1(5)= 440000 + 1i*4960000;  
L = Calculate_Larray(z_infil_1);
Logfac = logfac(z_infil_1);


%add major elements to the model
mississippi = River('Elements/Rivers/miss+mn.csv');
hiawatha = Lake('Elements/Lakes/hiawatha.csv');
nokomis = Lake ('Elements/Lakes/nokomis.csv');
taft = Lake('Elements/Lakes/taft.csv');
mother =Lake('Elements/Lakes/mother.csv');
minnetonka=Lake('Elements/Lakes/minnetonka.csv'); 

mississippi.setPhi(0);

hiawathaPhi = phi_to_Omega_UNC(247.22 - base,k);
nokomisPhi =  phi_to_Omega_UNC(248.09 - base,k);
taftPhi = phi_to_Omega_UNC(248.59 - base,k);
motherPhi =  phi_to_Omega_UNC(248.54 - base,k);
minnetonkaPhi =  phi_to_Omega_UNC(282.08 - base,k);

hiawatha.setPhi(hiawathaPhi);
nokomis.setPhi(nokomisPhi);
taft.setPhi(taftPhi);
mother.setPhi(motherPhi);
minnetonka.setPhi(minnetonkaPhi);

model.addRiver(mississippi);
model.addLake(nokomis);
model.addLake(hiawatha);
model.addLake(mother);
model.addLake(taft);
model.addLake(minnetonka);


b = Populate_b(model, refPhi,gamma0,L,z_infil_1, Logfac,eps,refz); 

%need to keep the strength of minnetonak constant by putting it in the B
%matrix, then move the refrence point around to get the right value along
%lake obundaries. Im close :)
A = Populate_A(model,refz);

s= A\b;
%ContourMe_R_int(475000,490000,100,4960000,4975000,100, @(z)real(Omega_total(z,model,s,gamma0,L,z_infil_1, Logfac,eps)),30);
mississippi.plotElement()
nokomis.plotElement()
hiawatha.plotElement()
taft.plotElement()
mother.plotElement()
minnetonka.plotElement()



%% add a new section where the line sink strengths stay constant 


for i = 1:model.nSinks

model.Sinks(i).sigma = s(i);

end


Ql = zeros(model.nLakes,1);
for i = 1:model.nLakes
    for j = 1:length(model.Lakes(i).LineSinks)
    
    Ql(i) = Ql(i) + model.Lakes(i).LineSinks(j).sigma * model.Lakes(i).LineSinks(j).L;
    end
end




%%incorporate allowing lake levels to change
A = Populate_A_w(model,refz,[]);
b = Populate_b_w(model, refPhi,[],Ql,gamma0,L,z_infil_1, Logfac,eps ,refz);

s2 = A\b;


%check the quality of the refrence point

miss_dif = Omega_to_phi_UNC((Omega_total_w(mississippi.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - mississippi.Phi),152.4)
nokomis_dif =Omega_to_phi_UNC((Omega_total_w(nokomis.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - nokomis.Phi),152.4)
hiawatha_dif =Omega_to_phi_UNC((Omega_total_w(hiawatha.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - hiawatha.Phi),152.4)
taft_dif =Omega_to_phi_UNC((Omega_total_w(taft.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - taft.Phi),152.4)
mother_dif=Omega_to_phi_UNC((Omega_total_w(mother.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - mother.Phi),152.4)
tonka_dif =Omega_to_phi_UNC((Omega_total_w(minnetonka.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps) - minnetonka.Phi),152.4)


%
%ContourMe_R_int(440000,490000,100,4960000,4990000,100, @(z)real(Omega_total_w(z,model,s2,[],gamma0,L,z_infil_1, Logfac,eps)),30);
%Omega_total_w(mississippi.LineSinks(1).mp,model,s2,[],gamma0,L,z_infil_1, Logfac,eps)
% %ContourMe_flow_net(476800,487600 , 400, 4965500, 4976400, 400,@(z)Omega_total_w(z,model,s2,[]),200);
% 
% mississippi.plotElement()
% nokomis.plotElement()
% hiawatha.plotElement()
% taft.plotElement()
% mother.plotElement()