%GETSOLRADMAPPROX: get the approximation of third order slices using solradm.
%parameters:
%   Y: the tensor to cluster.
%   a: samplerate to use in each mode.
function Approx = getSOLRADMapprox(Y,a)
    sz = size(Y);
    r1 = floor(sz(1)*a);
    am = prod(sz(3:end),'all');
    r3 = floor(am*a);
    slices = datasample(1:am,r3,'replace',false);
    Approx = zeros([sz(1),sz(1),r3]);
    for i=1:r3
        slice = slices(i);
        D = Y(:,:,slice);
        Dh = SOLRADM(D,25,r1);
        Dh = Dh+Dh';
        Dh = max(Dh,0);
        Approx(:,:,i) = Dh;
    end
end