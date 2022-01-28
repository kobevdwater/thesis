%initialize the workplace with the needed variable.

if exist('Yn','var') == 0
    load('/home/kobe/Documents/school/MATLAB/thesis/data/Yn.mat')
    Yn = Yn(:,:,:);
end
if exist('Pn','var') == 0
    load('/home/kobe/Documents/school/MATLAB/thesis/data/P.mat');
    Pn = P(:,:,:);
    clear P;
    
end
if exist('info','var') == 0
    load('/home/kobe/Documents/school/MATLAB/thesis/amie/info.mat');
end