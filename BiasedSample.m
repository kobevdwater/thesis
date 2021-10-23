function [Xsmal, I,J,K] = BiasedSample(X,sr)

    sz = size(X);
    Ssz = ceil(sz.*sr);
    I = randperm(sz(1),Ssz(1));
    J = randperm(sz(2),Ssz(2));
    K = randperm(sz(3),Ssz(3));
    Xsmal = X(I,J,K);

    
end