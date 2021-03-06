function [Omega] =Omega_total(z,Qx0,alpha, s, LS_end,zw,rw,Q)

LS_array = nan(length(s),1);
LS_array(length(LS_array),1) = 1;
Omega= 0;
for m = 1:length(LS_array)-1
   

        
      z1=LS_end(m,1);
      z2=LS_end(m,2);
      Z=Calculate_Z(z,z1,z2);
      L=Calculate_L(z1,z2);
     sink = LS(Z,L);
    %  LS_array(m,1) =  LS(Z,L);
      Omega = Omega + sink * s(m);
end
%Omega = -Qx0*z*exp(-1i*alpha) + dot(LS_array , s,2);

Omega = Omega + s(length(s));

for j=1:numel(zw)
    Omega = Omega +   Omega_well(z,zw(j),rw(j),Q(j));
end
       
end