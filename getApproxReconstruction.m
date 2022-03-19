function Approx = getApproxReconstruction(method,Y,samplerate)
    sz = size(Y);
    switch method
        case "FSTD"
            r = floor(sqrt(samplerate*prod(sz,'all')/(sum(sz,'all'))));
            [W,Cn] = FSTDX(Y,r);
            Approx = lmlragen(Cn,W);
        case "ParCube"
            U = ParCube(Y,samplerate^(1/3),"intact",false,"distance",false);
            Approx = cpdgen(U);
        case "MACH"
            [G,U] = MACH_HOSVD(Y,40,samplerate);
            Approx = lmlragen(U,G);
        case "Tucker"
%             sz = size(Y)
            [U,G] = mlsvd(Y,[25,25,25]);
            Approx = lmlragen(U,G);

        otherwise
            warning('unexpected method name '+ method)
    end
end
