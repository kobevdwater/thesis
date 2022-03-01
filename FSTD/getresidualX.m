function E = getresidualX(Y,IJK,mode)
    sz = size(Y);
    W = Y(IJK{:});
    Ci = {};
    Wi = {};
    for i=1:length(sz)
        idx = IJK;
        idx{1,i} = 1:sz(i);
        Ci{1,i} = tens2mat(Y(idx{:}),i);
        Wi{1,i} = pinv(tens2mat(W,i));
    end
    %indices: contains last elements of IJK.
    indices = {};
    for i=1:length(sz)
        indices{1,i} = IJK{1,i}(end);
    end
    U = {};
    for i=1:length(sz)
        if i==mode
            U{1,i} = Ci{1,i}*Wi{1,i};
        else
            U{1,i} = Ci{1,i}(indices{1,i},:)*Wi{1,i};
        end
    end
    indices{1,mode} = 1:sz(mode);
    Yf = Y(indices{:});
    E = Yf-lmlragen(U,W);
end