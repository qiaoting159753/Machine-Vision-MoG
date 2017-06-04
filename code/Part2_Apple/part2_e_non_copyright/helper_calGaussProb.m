function prob = helper_calGaussProb (data,mixGaussEst)
    prob = 0;
    %Weighted sum of the probability from each hidden variable to work out the overall
    %probability
    for i = 1:mixGaussEst.k
        gausspdf = helper_get2DGaussProb(data,mixGaussEst.mean(:,i),mixGaussEst.cov(:,:,i));
        prob = prob + (mixGaussEst.weight(i) * gausspdf); 
    end
end