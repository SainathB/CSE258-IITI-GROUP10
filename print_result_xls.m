function print_result_xls(varargin,filename,path)
%input should be in the form varargin={[1 2 3] [4 5 6];'a' 'b'} and path='give the path where to print the matrices'
% example of command run is following
% print_result_xls({d R K ALPHA CR B A; 'Thickness' 'Refractive Index' 'Attenuation Coeff' 'Absorption Coeff' 'CR' 'B' 'A'},'TiO2-132-2 sccm_simulated',path)

warning off all
s=size(varargin);
n=s(2); % no. of matrices to be saved
save1=pwd;
cd (path)
for i=1:n
    matrix=varargin{1,i};
name=varargin{2,i};
%    save(name,'matrix','-ascii');

xlswrite(filename,matrix,name);
end 
cd (save1)
