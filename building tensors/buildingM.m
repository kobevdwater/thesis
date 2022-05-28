%Building M: tensor containing the ozon data based on the longitude and
%latitude from 1970 to 2022. 
% removing poles because of lots of missing data, and because a lot of data
% is similar for a large range of longitudes.
% Builds 3 tensors:
%   Mo: compairs longitudes. Mo(i,j,k) = d(a_ki,a_kj)
%   Ma: compairs latitudes. Ma(i,j,k) = d(a_ik,a_jk)
%   where   a_ij = timeseries at position i,j (latitude, longitude).
%           d: distance function. Here the Euclidian distance is used.
%   Mt: data tensor. Mt(i,j,k): ozon at position (i,j) at time k.
%used dataset:
%   Van der A, R. J., Allaart, M. A. F., and Eskes, H. J.,
%   Multi-Sensor Reanalysis (MSR) of total ozone, version 2.
%   Dataset. Royal Netherlands Meteorological Institute (KNMI), 2015.
%   doi:10.21944/temis-ozone-msr2
%used software:
%   John D'Errico (2022). 
%       inpaint_nans (https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans), 
%       MATLAB Central File Exchange. Retrieved March 11, 2022.
function [Mo,Ma,Mt] = buildingM()
    Dat = ncread('.\datasets\Ozon\MSR-2.nc','Average_O3_column');
    %removing poles
    Dat = Dat(:,6:355,:);
    %removing NaN with a script from:  John D'Errico (2022). 
    %   inpaint_nans (https://www.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans), 
    %   MATLAB Central File Exchange. Retrieved March 11, 2022.
    for i= 1:size(Dat,1)
        for j=1:size(Dat,2)
            Dat(i,j,:) = inpaint_nans(Dat(i,j,:));
        end
    end
    sz = size(Dat);
    szo = [sz(1),sz(1),sz(2)];
    sza = [sz(2),sz(2),sz(1)];
   
    %building Mo: compairing longitudes.
    Mo = zeros(szo);
    for k=1:szo(3)
        for i=1:szo(1)
            a1 = squeeze(Dat(i,k,:));
            for j=1:szo(2)
                a2 = squeeze(Dat(j,k,:)); 
                Mo(i,j,k) = norm(a1-a2);
            end
        end
    end
    
    %building Ma: compairing latitudes.
    Ma = zeros(sza);
    for k=1:sza(3)
        for i=1:sza(1)
            a1 = squeeze(Dat(k,i,:));
            for j=1:sza(2)
                a2 = squeeze(Dat(k,j,:));
                Ma(i,j,k) = norm(a1-a2);
            end
        end
    end
    Mt = Dat;
end