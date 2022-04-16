function SSEmean = ExactTest(k,T,Td,Tp,Methods,options)
    arguments
        k; T; Td; Tp
        Methods;
        options.retries {mustBeInteger,mustBeNonzero, mustBePositive} = 1
        options.Rrange = false
        options.expected = false
        options.Tm = false
        options.amount {mustBeInteger,mustBeNonzero, mustBePositive} = 10
        options.show = true
    end
    if options.Rrange
        Rrange = options.Rrange;
    else
        Rrange = floor(linspace(5,30,options.amount));
    end
%     SSEmean = SSEPrTest(k,T,Td,Tp,Methods,@getExactClusters,Rrange,'retries',options.retries,'Tm',options.Tm,'amount',options.amount,'show',options.show,'expected',options.expected,'precompDecomp',true);
    SSEmean = SSEPrTest(k,T,Td,Tp,Methods,@getExactClusters,Rrange,'retries',options.retries,'Tm',options.Tm,'amount',options.amount,'show',options.show,'expected',options.expected);

%     expected = options.expected;
%     Tm = options.Tm;
%     sz = size(Td);
%     am = prod(sz(3:end),'all');
%     
%     PrResults = zeros(2,length(Rrange),length(Methods),options.retries);
%     SSEResults = zeros(length(Rrange),length(Methods),options.retries);
%     decomp = {};
%     decomp.Y = T;
%     decomp.P = Tp;
%     if sum(Tm,'all')
%         SSEx = zeros(length(sinterval),2);
%         Ex = ["Expected","FromMatrix"];
%     else
%         SSEx = zeros(length(sinterval),1);
%         Ex = ["Expected"];
%     end
%     if expected
%         [pr,rc] = BCubed(expected,expected);
%         PrResults(:,:,1,:) = PrResults(:,:,1,:) + [pr;rc];
%         for j=1:am
%             D= T(:,:,j);
%             nrm = norm(D);
%             SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(expected,D)/nrm;
%             
%         end
%     elseif useTm
%         Methods(1) = 'FromMatrix';
%         Clusters = spectralClustering(Tm,k,'isDist',true);
%         for j=1:am
%             D= T(:,:,j);
%             nrm = norm(D);
%             SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(Clusters,D)/nrm; 
%         end
%     else    
%         Methods(1) = "Matrix";
%         for j=1:am
%             D= T(:,:,j);
%             nrm = norm(D);
%             MatrixClusters = spectralClustering(D,k,"isDist",true);
%             SSEResults(:,1,:) = SSEResults(:,1,:) + calculateSSE(MatrixClusters,D)/nrm; 
%         end
%     end
%     for r = 1:length(Rrange)
%         r
%         R = Rrange(r);
%         rank = ones(size(sz)).*R;
%         [U,G] = mlsvd(T,rank);
%         [Up,Gp] = mlsvd(Tp,rank);
%         decomp.U = U;
%         decomp.G = G;
%         decomp.Gp = Gp;
%         decomp.Up = Up;
%         C = cpd(T,R);
%         decomp.C = C;
%     
%         for ret=1:retries
%             for m=2:length(Methods)
%                 Clusters = getExactClusters(Methods(m),decomp,k);
%                 if expected
%                     [pr,rc] = BCubed(Clusters,expected);
%                     PrResults(:,r,m,ret) = PrResults(:,r,m,ret) + [pr;rc];
%                 end
%                 for j = 1:am
%                     D = T(:,:,j);
%                     nrm = norm(D);
%                     SSEResults(r,m,ret) = SSEResults(r,m,ret)+calculateSSE(Clusters,D)/nrm;
%                 end
%             end
%         end
%     end
%     meanSSE = sum(SSEResults,3)./retries;
%     if expected
%         MeanPr = sum(PrResults,4)./retries;
%         figure('Name','Precision');
%         hold on
%         plot(Rrange,squeeze(MeanPr(1,:,1)),'o');
%         plot(Rrange,squeeze(MeanPr(1,:,2:end)));
%         legend(Methods);
%         figure('Name','Recall');
%         hold on;
%         plot(Rrange,squeeze(MeanPr(2,:,1)),'o');
%         plot(Rrange,squeeze(MeanPr(2,:,2:end)));
%         legend(Methods);
%         hold off;
%     end
%     figure('Name',"SSE"); hold on;
%     plot(Rrange,meanSSE(:,1),'o');
%     plot(Rrange,meanSSE(:,2:end));
%     legend(Methods);

end