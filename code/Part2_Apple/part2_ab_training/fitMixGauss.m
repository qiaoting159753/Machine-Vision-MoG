function mixGaussEst = fitMixGauss(apple,k)
    [nDim,nData] = size(apple);
    postHidden = zeros(k, nData);
    
    %initial MoG parameters
    k = 3;
    mixGaussEst.d = nDim;
    mixGaussEst.k = k;
    mixGaussEst.weight = (1/k)*ones(1,k);
    mixGaussEst.mean = randn(nDim,k);
    
    for cGauss =1:k
        mixGaussEst.cov(:,:,cGauss) = (0.5+1.5*rand(1))*eye(nDim,nDim);
    end;
    
    logLike = getMixGaussLogLike(apple,mixGaussEst);
    fprintf('Log Likelihood Iter 0 : %4.3f\n',logLike);
    
    %Iteration 20 times to fit the MoG model
    nIter = 20;
    for cIter = 1:nIter
        %Expectation step
        %Update the responsibility for each data points.
        for cData = 1:nData
            weighted_pr = zeros(1,mixGaussEst.k);
            for i = 1:mixGaussEst.k
                weighted_pr(i) = mixGaussEst.weight(i) * get2DGaussProb(apple(:,cData),mixGaussEst.mean(:,i),mixGaussEst.cov(:,:,i));
            end
        
            total = sum(weighted_pr);
        
            for j = 1:mixGaussEst.k
                postHidden(j,cData) = weighted_pr(j)/total;
            end
        end
        
        %Maximization Step
        for cGauss = 1:k
            %Update the model parameters.
            mixGaussEst.weight(cGauss) = sum(postHidden(cGauss,:))/sum(postHidden(:));
            mixGaussEst.mean(:,cGauss) = (postHidden(cGauss,:)*apple')'/sum(postHidden(cGauss,:));
            temp = zeros(nDim,cData);
        
            for index_a = 1:nData
                temp(:,index_a) = apple(:,index_a) - mixGaussEst.mean(:,cGauss);
            end
        
            product = zeros(nDim,nDim);
        
            for index_b = 1:nData
                my_temp = postHidden(cGauss,index_b) * temp(:,index_b) * (temp(:,index_b))';
                product = product + my_temp;
            end
        
            product = product/(sum(postHidden(cGauss,:)));
        
            mixGaussEst.cov(:,:,cGauss) = product;
        end
        
        %calculate the log likelihood
        logLike = getMixGaussLogLike(apple,mixGaussEst);
        fprintf('Log Likelihood Iter %d : %4.3f\n',cIter,logLike);
        
    end
end