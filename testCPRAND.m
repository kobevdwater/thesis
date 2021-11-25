retries = 1;
rrange = 1:50;
results = zeros(1,length(rrange));
sr = zeros(retries,length(rrange));
%Y = DistanceTensorP();

%Y.setSlice(1);
for i=1:retries
    tic;
    for j=1:length(rrange)
        [l,Ah] = CPRAND(X,rrange(j),rrange(j)*10);
        %[ld,Ahd] = CPRAND(X,rrange(j),500,true);
        Ah{1,1} = Ah{1,1}.*l;
        Ahd{1,1} = Ahd{1,1}.*ld;
        Yh = cpdgen(Ah);
        %Yhd = cpdgen(Ahd);
        %for k=1:length(Yh)
        %    Yh(k,k,:) = 0;
        %    Yhd(k,k,:) = 0;
        %end
        results(1,j) = results(1,j) + frob(X-Yh)/frob(X);
        %results(2,j) = results(2,j)+ frob(X-Yhd)/frob(X);
    end
    toc
end