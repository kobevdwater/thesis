function [I,J,K] = adaptiveIndexChoise(Y,r1,r2,r3)
    r = max([r1 r2 r3]);
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
            [~,maxi] = max(abs(getresidual(Y,I,J,K,2,ip,kp)));
        end
        if (length(J) < r)
            J = [J maxi];
        end
        jp = maxi;
        [~,maxi] = max(abs(getresidual(Y,I,J,K,3,ip,jp)));
        if (length(K) < r)
            K = [K maxi];
        end
        kp = maxi;
        [~,maxi] = max(abs(getresidual(Y,I,J,K,1,jp,kp)));
        if (length(I)< r)
            I = [I maxi];
        end
        ip = maxi;
    end
    %Can I do this less wastefull? If I use if statements, i get a lot of
    %repetition.
    I = I(1:r1);
    J = J(1:r2);
    K = K(1:r3);
end
