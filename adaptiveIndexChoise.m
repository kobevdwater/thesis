function [I,J,K] = adaptiveIndexChoise(Y,r)
    [i,j,k] = size(Y);
    J = [randi(j)];K=[randi(k)];
    %J = [1];K=[3];
    [~,maxi] = max(abs(Y(:,J(1),K(1))));
    I = [maxi];
    for p=2:r
        if p == 2
            ip = I(end);kp=K(end);
            [~,maxi] = max(abs(Y(ip,:,kp)));
        else
            ip = I(end); kp =K(end);
            [~,maxi] = max(abs(getresidual(Y,I,J,K,2,ip,kp)));
        end
        J = [J maxi];
        ip = I(end); jp= J(end);
        [~,maxi] = max(abs(getresidual(Y,I,J,K,3,ip,jp)));
        K = [K maxi];
        jp = J(end);kp = K(end); 
        [~,maxi] = max(abs(getresidual(Y,I,J,K,1,jp,kp)));
        I = [I maxi];
    end
end
