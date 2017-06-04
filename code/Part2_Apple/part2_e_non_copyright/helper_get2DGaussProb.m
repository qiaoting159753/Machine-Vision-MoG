%Apply the Normal distribution formula
function prob = helper_get2DGaussProb(x,mean,var)
    nDim = size(x,1);
    prob = exp(-0.5*((x-mean)') * inv(var) * (x-mean));
    prob = prob/sqrt(det(var) * ((2*pi)^(nDim))); 
end 