function Xhat = ParCube(X,F,sr)
    [Si,Sj,Sk] = size(X);
    [Xsmal,I,J,K] = BiasedSample(X,sr);
    Us = cpd(Xsmal,F);
    Ah = zeros(Si,F);Bh = zeros(Sj,F);Ch = zeros(Sk,F);
    Ah(I,:) = Us{1,1}; Bh(J,:) = Us{1,2}; Ch(K,:) = Us{1,3};
    U = {Ah,Bh,Ch};
    Xhat = cpdgen(U);

end


    