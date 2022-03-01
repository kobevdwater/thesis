%initialize the workplace with the needed variable.
%loaded variable:
%   Yn: tensor of Amie dataset compairing different persons based on the
%       sensors. Size(Yn) = (n,n,m).
%   Pn: tensor of the Amie dataset compairing different sensors based on
%       the person. Size(Pn) = (m,m,n).
%   info: contains 3 clusterings for the persons in the Amie dataset. 
%       info(1,:): clustering based on person.
%       info(2,:): clustering based on exercise.
%       info(3,:): clustering based on execution type.
if exist('Yn','var') == 0
    load('E:\School\thesis\thesis\data\Y.mat')
    Yn = Y(:,:,:);
    clear Y;
end
if exist('Pn','var') == 0
    load('E:\School\thesis\thesis\data\P.mat');
    Pn = P(:,:,:);
    clear P;
    
end
if exist('info','var') == 0
    load('E:\School\thesis\thesis\data\info.mat');
end
if exist('Xn','var') == 0
    load('E:\School\thesis\thesis\data\X.mat');
    Xn = X(:,:,:,:);
    clear X;
end