%initialize the workplace with the tensors created for the Amie dataset.
% If the needed tensors are not found in the files, they will be created.
% This might take a while.
% Will not overload any variable in the workspace. If a variable with the
% name already exists, this vatiable will not be changed.
% For loading the 4d tensors, you need split.hdf which contians the
% split data. This data is not included in the dataset.
%loaded variable:
%   Yn: tensor of Amie dataset compairing different persons based on the
%       sensors. Size(Yn) = (n,n,m).
%   Pn: tensor of the Amie dataset compairing different sensors based on
%       the person. Size(Pn) = (m,m,n).
%   info: contains 3 clusterings for the persons in the Amie dataset. 
%       info(1,:): clustering based on person.
%       info(2,:): clustering based on exercise.
%       info(3,:): clustering based on execution type.
%used variables.
%   Use4D: use the 4 dimentional versions of Yn and Pn where the different
%       times series are split in 8 repetitions.
%   location: location of folder of the tensors in the file-system.
%   amieLoc: location of the amie-dataset.

if exist('Use4D','var') == 0
    Use4D = false;
end
if Use4D expsz = 4; else expsz = 3; end

if exist('location','var') == 0
    location = "./data/";
end

if exist('amieLoc','var') == 0
    amieLoc = './datasets/Amie/';
end



%loading Yn
if exist('Yn','var') == 0 || length(size(Yn)) ~= expsz
    if Use4D
        path = location + "Y4.mat";
        if isfile(path)
            load(path);
        else
            f = waitbar(0,"building Y4 tensor");
            Y = DTAmieY4(amieLoc);
            for i=1:size(Y,3)
                waitbar(i/size(Y,3),f);
                Y(:,:,i,:);
            end
            save(path,'Y4');
            close(f);
        end
        Yn = Y(:,:,:,:);
    else
        path = location + "Y.mat";
        if isfile(path)
            load(path);
        else
            f = waitbar(0,"building Y tensor");
            Y = DTAmieY(amieLoc);
            for i=1:length(Y,3)
                waitbar(i/size(Y,3),f);
                Y(:,:,i);
            end
            save(path,'Y');
            close(f);
        end
        Yn = Y(:,:,:);
    end
    clear Y;
end

%loading Pn;
if exist('Pn','var') == 0 || length(size(Pn)) ~= expsz
    if Use4D
        path = location+ "P4.mat";
        if isfile(path)
            load(path);
        else
            f = waitbar(0,"building P4 tensor");
            P = DTAmieP4(amieLoc);
            for i=1:size(P,3)
                waitbar(i/size(P,3),f);
                P(:,:,i,:);
            end
            save(path,'P4');
            close(f);
        end
        Pn = P(:,:,:,:);
    
    else
        path = location+"P.mat";
        if isfile(path)
            load(path);
        else
            f = waitbar(0,"building P tensor");
            P = DTAmieP(amieLoc);
            for i=1:size(P,3)
                waitbar(i/size(P,3),f);
                P(:,:,i);
            end
            save(path,'P');
        end
        Pn = P(:,:,:);
    end
    clear P;
end

%loading info
if exist('info','var') ==0
    load('E:\School\thesis\thesis\data\info.mat');
    %     removing unused data
        info(:,152) = [];
        info(:,151) = [];
        info(:,71) = [];
        info(:,36) = [];
        info(:,7) = [];
        info = info(:,1:180);
end


%loading Xn
if exist('Xn','var') == 0
    path = location + "X.mat";
    if isfile(path)
        load(path);
    else
        f = waitbar(0,"building X tensor");
        X = DTAmieXp(amieLoc);
        for i=1:length(3)
            waitbar(i/size(X,3),f);
            X(:,:,i,:);
        end
        close(f);
        save(path,'X');
    end
    Xn = X(:,:,:,:);
    clear X;
end
clear Use4D;
clear location;
clear amieLoc;
clear path;