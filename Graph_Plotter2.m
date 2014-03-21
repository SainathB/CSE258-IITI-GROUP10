file=fopen('sample_data.txt','r');
y=fscanf(file,'%f');
len=length(y);
Wavelength=[];
Transmission=[];
j=1;
l=1;
 for i=1:len
    
    if mod(i,2)
       Wavelength(j)=y(i);
       j=j+1;
    else
        Transmission(l)=y(i);
        l=l+1;
    end;    
    
end;
plot(Wavelength,Transmission);
