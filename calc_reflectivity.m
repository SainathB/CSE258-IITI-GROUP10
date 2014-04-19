function R_final= calc_reflectivity(d_store,n_store,alpha_store,ref_sub)
%function is used to calculate reflectivity of a high reflectance coating
%d_store-thicknessof various layers of the coating starting from the one on
%top
%n_store-refractive index corresponding to each layer
%alpha_store-absorption coefficient corresponding to each layer
%ref_sub-refractive index of substrate
%n_store,alpha_store and ref_sub are for a particular lambda
I0=100;
R_temp=[];
It=0;
Ir=0;
x=numel(d_store);
for i=1:x+1
    if i==1
        Ir=((n_store(i)-1)^2/(n_store(i)+1)^2)*I0;   %refractive index of air is taken as 1
        It=I0-Ir;
        It=It*exp(-1*alpha_store(i)*d_store(i));
        R_temp(i)=Ir;
    elseif i==x+1
        Ir=((n_store(i-1)-ref_sub)^2/(n_store(i-1)+ref_sub)^2)*It;
        It=It-Ir;
        R_temp(i)=Ir;
    else
        Ir=((n_store(i)-n_store(i-1))^2/((n_store(i)+n_store(i-1))^2))*It;
        It=It-Ir;
        It=It*exp(-1*alpha_store(i)*d_store(i));
        R_temp(i)=Ir;
    end
end
R_num=numel(R_temp);
R=[];
for j=1:R_num
    if j==1
        R(j)=R_temp(j);
    elseif j==2
        R(j)=R_temp(j);
        R(j)=R(j)*exp(-1*alpha_store(1)*d_store(1));
        R(j)=R(j)-((1-n_store(1))^2/(n_store(1)+1)^2)*R(j);
    else
        R(j)=R_temp(j);
        for k=j:-1:3
            R(j)=R(j)*exp(-1*alpha_store(k-1)*d_store(k-1));
            R(j)=R(j)-((n_store(k-2)-n_store(k-1))^2/(n_store(k-2)+n_store(k-1))^2)*R(j);
        end
         R(j)=R(j)*exp(-1*alpha_store(1)*d_store(1));
         R(j)=R(j)-((1-n_store(1))^2/(1+n_store(1))^2)*R(j);
    end
    
end
R_final=sum(R);
end

