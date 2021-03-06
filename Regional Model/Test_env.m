

%include wells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


refPhi = 25*25*.5*10 +1000;
refz =1i*1000;

 model = Model();
  river = River('river1.csv');
 river.setPhi(25*25*.5*10);
  model.addRiver(river);


lake = Lake('lake1.csv');
 model.addLake(lake);
 lake.setPhi(25*25*.5*10 );
% 
% 
% well1 =Well(60,300,300,.3);
% well2 =Well(60,-300,300,.3);
% 
% wells  = Well.empty(2,0);
% wells(1) = well1;
% wells(2) = well2;

%% Lake level cant vary
b = Populate_b(model, refPhi) ;
A = Populate_A(model,refz);
s= A\b;
ContourMe_flow_net(-400,400 , 100, -400, 400, 100, @(z)Omega_total(z,model,s),100);

Omega_total(100*1i,model,s);


%Calculate teh sum of sigmas at each lake
for i = 1:model.nSinks

model.Sinks(i).sigma = s(i);

end


Ql = zeros(model.nLakes,1);
for i = 1:model.nLakes
    for j = 1:length(model.Lakes(i).LineSinks)
    
    Ql(i) = Ql(i) + model.Lakes(i).LineSinks(j).sigma;
    end
end


%% allow lake level to vary

A = Populate_A_w(model,refz,[]);
b = Populate_b_w(model, refPhi,[],Ql);

s2 = A\b;
ContourMe_flow_net(-400,400,100, -400,400,100,@(z)Omega_total_w(z,model,s2,[]),50);

Omega_total_w(1000,model,s2,[]);


lake.plotElement()
river.plotElement()