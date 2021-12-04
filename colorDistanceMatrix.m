function M = colorDistanceMatrix(D,cl)
    [sz,~] = size(D);
    M = zeros(sz,sz,3);
    [I,J,K,L] = D.parseIndices({1:1000,1:1000});

    for x=1:sz
        for y=x:sz
            if (K(x)==L(y))
                if (cl(x)==cl(y))
                    M(x,y,2) = 1;
                    M(y,x,2) = 1;
                end
            elseif (I(x)==J(y))
                if (cl(x)==cl(y))
                    M(x,y,3) = 1;
                    M(y,x,3) = 1;
                end
            elseif (cl(x)==cl(y))
                M(x,y,1) = 1;
                M(y,x,1) = 1;
            end
        end
    end
end