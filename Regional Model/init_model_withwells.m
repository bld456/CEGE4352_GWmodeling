

%include wells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


model = Model();
 river = River('river1.csv');
river.setPhi(0);
 model.addRiver(river);


lake = Lake('lake1.csv');
model.addLake(lake);
lake.setPhi (100);



A = Populate_A(model,1000);
b = Populate_b(model,1000);











s = A\b;
ContourMe_flow_net(-400,400,100, -400,400,100,@(z)Omega_total(z,model,s),500);

Q = zeros(model.nLakes,1);

%%%set teh phiM in each line sync element using the s matrix
%%% calculate Q for each lake
%proceed to finish this, still need the heads at each spot, and to finish
%populating A

lake.plotElement()
river.plotElement()



%%%turn on wells


well1 =Well(60,300,300,.3);
well2 =Well(60,-300,300,.3);

wells  = Well.empty(2,0);
wells(1) = well1;
wells(2) = well2;
