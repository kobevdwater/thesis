%Test the different sampling based decompositions on there ability to
%reconstruct the tensor. Measures the frob. norm of the difference between
%the tensors ifo the samplerate
%Tests on 3 different tensors: 
%   Y1: a tensor of size (100,100,100) constructed from a random tensor
%       decomposition with core of size (10,10,10).
%   Y2: a tensor of size(100,100,100) for which 
%       Y2(i,j,k) = 1/sqrt(i^2+j^2+k2).
%   Y3: the Y tensor of the amie dataset.
% Tensors 1 and 2 are based on the tensors used in: 
%   Generalizing the column–row matrix decomposition
%   to multi-way arrays by Caiafa and Cichocki
function approxReconstructionTest(Yn,methods,retries,sinterval)

%Construction of Y1 and Y2
[U,G] = lmlra_rnd([100,100,100],[10,10,10]);
Y1 = lmlragen(U,G);
Y2 = zeros(100,100,100);
for i=1:100
    for j=1:100
        for k=1:100
            Y2(i,j,k) = 1/sqrt((i^2+j^2+k^2));
        end
    end
end
% Ys = {Y1,Y2,Yn};
Ys = {Yn};
Ynames = ["Y1","Y2","Yn"];
result = zeros(length(Ys),length(sinterval),length(methods),retries);

for y = 1:length(Ys)
    Y = Ys{y};
    nrm = frob(Y);
    for si = 1:length(sinterval)
        for i=1:retries
            for m=1:length(methods)
                Approx = getApproxReconstruction(methods(m),Y,sinterval(si));
                result(y,si,m,i) = frob((Y-Approx))/frob(Y);
            end
        end
    end
end
mean = sum(result,4)./retries;
for i=1:length(Ys)
    figure;title(Ynames(i));
    loglog(sinterval,squeeze(mean(i,:,:)));
    legend(methods);
end