%COMPAIRVISUALY Compair 2 matrices visualy by showing them as images.
%parameters:
%   D,Dh: matrices to be compaired.
function compairVisualy(D,Dh)
    figure(1);
    imshow(D./max(D));
    figure(2);
    imshow(Dh./max(Dh));