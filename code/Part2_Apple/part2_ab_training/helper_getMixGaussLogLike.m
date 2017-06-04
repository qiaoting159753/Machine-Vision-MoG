function logLike = getMixGaussLogLike(data,mixGaussEst)
%find total number of data items
nData = size(data,2);

%initialize log likelihoods
logLike = 0;

%run through each data item
for(cData = 1:nData)
    thisData = data(:,cData);    
    %---------------------------------------------------------------------TO DO - calculate likelihood of this data point under mixture of
    %Gaussians model. Replace this
    like = 0;
    for i = 1:mixGaussEst.k
        like = like + mixGaussEst.weight(i) * get2DGaussProb(thisData,mixGaussEst.mean(:,i),mixGaussEst.cov(:,:,i));
    end
    %add to total log like
    logLike = logLike+log(like);        
end;