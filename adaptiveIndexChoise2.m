%ADAPTIVEINDEXCHOISE2 adaptively chose indiches for FSTD2 algorithm.
% Indiches will be chosen based on the approximation error of the
% previously chosen fibers. 
%parameters:
%   Y: Tensor to which FSTD2 is applied.
%   r1,r2: amount of fibers/indices chosen in the corresponding modes.
%returns
%   I,J,K: chosen indices.

%This file is for test purposes only
function [I,J,K] = adaptiveIndexChoise2(Y,r1,r2)
    r = max([r1 r2]);
    [~,j,k] = size(Y);
    J = [randi(j)];K=[randi(k)];
    [~,maxi] = max(abs(Y(:,J(1),K(1))));
    I = [maxi];
    for p=2:r
        if p==2
            ip = I(end);
            D = squeeze(abs(Y(ip,:,:)));
            [~,maxi] = max(D(:));
            [jp,kp] = ind2sub(size(D),maxi);
        else
            D = squeeze(abs(getresidual2(Y,I,J,K,2,ip,0)));
            [~,maxi] = max(D(:));
            [jp,kp] = ind2sub(size(D),maxi);
        end
        if (p<r2)
            J = [J jp];
            K = [K kp];
        end


%         if p == 2
%             ip = I(end);kp=K(end);
%             [~,maxi] = max(abs(Y(ip,:,kp)));
%         else
%             [~,maxi] = max(abs(getresidual(Y,I,J,K,2,ip,kp)));
%         end
%         if (p<r2)
%             J = [J maxi];
%         end
%         jp = maxi;
%         [~,maxi] = max(abs(getresidual(Y,I,J,K,3,ip,jp)));
%         if (p<r3)
%             K = [K maxi];
%         end
%         kp = maxi;
        [~,maxi] = max(abs(getresidual2(Y,I,J,K,1,jp,kp)));
        if (p<r1)
            I = [I maxi];
        end
        ip = maxi;
    end
    %Can I do this less wastefull? If I use if statements, i get a lot of
    %repetition.
    I = I(1:min(r1,length(I)));
    J = J(1:min(r2,length(J)));
    K = K(1:min(r2,length(K)));
end
