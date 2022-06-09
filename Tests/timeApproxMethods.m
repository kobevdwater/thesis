function result = timeApproxMethods(methods,Ys,rs,dim,options)
    arguments
        methods;Ys;rs;dim;
        options.retries = 1;
        options.normalize = false;
    end
    
    assert(length(Ys) == 1 || length(rs) == 1,"You can not vary the samplerate and the tensors at the same time.");
    result = zeros(length(methods),max(length(Ys),length(rs)));
    Rs = ones(length(Ys),length(rs));
    if options.normalize
        lengths = arrayfun(@(x) length(Ys{1,x}),1:length(Ys));
        dims = arrayfun(@(x) length(size(Ys{1,x})),1:length(Ys));
        Rs = rs*(lengths(1)./lengths).^dims.*Rs';
    else
        Rs = rs.*Rs';
%         Rs = Rs';
    end
    
    for i=1:length(methods)
        Y = Ys{1,1};
        [~] = getApproxSim(methods(i),Rs(1,1),Y,dim);
    end

    for ret =1:options.retries    
        for i=1:length(methods)
            for j=1:length(Ys)
                for k=1:length(rs)
                    Y = Ys{1,j};
                    tic
                        [~] = getApproxSim(methods(i),Rs(k,j),Y,dim);
                    result(i,max(j,k)) = result(i,max(j,k))+toc;
                end
            end
        end
    end
    if (length(Ys) > 1)
        lengths = arrayfun(@(x) size(Ys{1,x},1),1:length(Ys));
        if lengths(1) == lengths(2)
            lengths = arrayfun(@(x) length(size(Ys{1,x})),1:length(Ys));
        end
        bar(categorical(lengths),result');
    else
        bar(rs,result');
    end
    legend(methods);

