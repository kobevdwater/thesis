function Approx = getApproxReconstruction(method,Y,samplerate)
    sz = size(Y);
    switch method
        case "FSTD"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTD(Y,r);
            Approx = lmlragen(Cn,W);
        case "FSTDY"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDY(Y,r);
            Approx = lmlragen(Cn,W); 
        case "FSTDX"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDX(Y,r);
            Approx = lmlragen(Cn,W);
        case "FSTDZ"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDZ(Y,r);
            Approx = lmlragen(Cn,W);
        case "ParCube10"
            U = ParCube(Y,samplerate^(1/3),"intact",false,"distance",false,"k",10);
            Approx = cpdgen(U);
        case "MACH10"
            [G,U] = MACH_HOSVD(Y,10,samplerate);
            Approx = lmlragen(U,G);
        case "ParCube20"
            U = ParCube(Y,samplerate^(1/3),"intact",false,"distance",false,"k",20);
            Approx = cpdgen(U);
        case "MACH20"
            [G,U] = MACH_HOSVD(Y,20,samplerate);
            Approx = lmlragen(U,G);
        case "Tucker"
%             sz = size(Y)
            [U,G] = mlsvd(Y,[45,45,45]);
            Approx = lmlragen(U,G);


        otherwise
            warning('unexpected method name '+ method)
    end
end
