function dis = prunedDTW(a1,a2,w)
    N = min(length(a1),length(a2)); %Chopping longest signal. Might fix this later.
    Ub = 0;
    for i = 1:N
        Ub = Ub+(a1(i)-a2(i))^2;
    end
    if nargin < 3
        w = N;
    end
    sc = 2;ec = 2;
    D = Inf*ones(N,N);
    D(1,1)= 0;
    for i=2:N
        beg = max(sc,i-w);
        en = min(i+w,N);
        smaller_found = false;
        ec_next = i;
        for j = beg:en
            cost = (a1(i)-a2(j))^2;
            D(i,j) = cost + min([D(i-1,j-1),D(i-1,j),D(i,j-1)]);
            %begin pruning criteria
            if D(i,j) > Ub
                if smaller_found == false
                    sc = j+1;
                end
                if j >= ec
                    break;
                end
            else
                smaller_found = true;
                ec_next = j+1;
            end
            %end pruning criteria
        end
        ec = ec_next;
    end
    dis = sqrt(D(N,N));





end