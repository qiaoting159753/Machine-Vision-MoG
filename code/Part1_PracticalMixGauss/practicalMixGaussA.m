function r=practicalMixGaussA

%This project explores fitting simple parametric models to visual data.
%The goal of this part of the project is to fit one Gaussian model to the
%data for skin and another Gaussian to non-skin pixels, and use this to 
% find the posterior probability that each pixel in an image is skin.
%The aim of part B is to fit a mixture of 
%Gaussians model to one dimensional data. The aim of part C is to fit a 
%mixture of Gaussians model to the RGB data.
%The aim of Part D is to apply what we've learned to real data.

%You should use this template for your code and fill in the missing 
%sections marked "TO DO". 

% -----------------------------------
% PLEASE NOTE: When implementing equations, you should only be using 
% "simple" Matlab commands, such as mean(). Even for cov(), you should 
% implement it yourself to show that you know what the function is doing. 
% (You will find times when you can check your function that way, but 
% beware, there are sometimes subtle implementation details that differ 
% between the vanilla equation and Matlab's version.)
% -----------------------------------

%load in test image and ground truth.  Your goal is to segment this image
%to recover the ground truth
im = imread('bob_small.jpeg');
load('bob_GroundTruth_small.mat','gt');

%display test image and ground truth;
close all;
figure; set(gcf,'Color',[1 1 1]);
subplot(1,3,1); imagesc(im); axis off; axis image;
subplot(1,3,2); imagesc(gt); colormap(gray); axis off; axis image;
drawnow;

%load in training data - contains two variables each of size 3 x 10000
%Each column contains RGB values from one pixel in training data
load('RGBSkinNonSkin','RGBSkin','RGBNonSkin');


%fit Gaussian model for skin data
%TO DO - fill in this routine (it's below, at the bottom of this file)
%Find the normal distribution model to describe the skin data. The fitted
%parameter will be used to discriminate the new data points.
[meanSkin covSkin] = fitGaussianModel(RGBSkin);

%fit Gaussian model for non-skin data
%TO DO - fill in this routine (below)
%Find the normal distribution model to describe the non-skin data.The fitted
%parameter will be used to discriminate the new data points.
[meanNonSkin covNonSkin] = fitGaussianModel(RGBNonSkin);

%let's define priors for whether the pixel is skin or non skin
priorSkin = 0.3;
priorNonSkin = 0.7;

%now run through the pixels in the image and classify them as being skin or
%non skin - we will fill in the posterior
[imY imX imZ] = size(im);

posteriorSkin = zeros(imY,imX);

for (cY = 1:imY); 
    fprintf('Processing Row %d\n',cY);     
    for (cX = 1:imX);          
        %extract this pixel data
        thisPixelData = squeeze(double(im(cY,cX,:)));
        %calculate likelihood of this data given skin model
        %TO DO - fill in this routine (below)
        
        %Using the normal distribution model with trained parameters to
        %find the skin likelihhod of new data. (Pr(x|theta)).
        likeSkin = calcGaussianProb(thisPixelData,meanSkin,covSkin);
        %calculate likelihood of this data given non skin model
        
        %Using the normal distribution model with trained parameters to
        %find the non-skin likelihhod of new data. (Pr(x|theta)).
        likeNonSkin = calcGaussianProb(thisPixelData,meanNonSkin,covNonSkin);
        
        %TO DO (c):  calculate posterior probability from likelihoods and 
        %priors using BAYES rule. Replace this: 
        
        %pr(w = 1|x) = pr(x|theta) * pr(w = 1) / pr(x|w = 0)pr(w = 0) +
        %pr(x|x = 1)pr(x = 1)
        posteriorSkin(cY,cX) = (likeSkin * priorSkin)/(likeSkin*priorSkin+likeNonSkin*priorNonSkin);
    end;
end;

%draw skin posterior
clims = [0, 1];
subplot(1,3,3); imagesc(posteriorSkin, clims); colormap(gray); axis off; axis image;
%set(gca, 'clim', [0, 1]);
end
%==========================================================================
%==========================================================================

%the goal of this routine is to evaluate a Gaussian likleihood
%TO DO (b) - fill in this routine
%Applying the normal distribution formula to calculate the probability of
%data point 'belong' to this Gaussian.

function like = calcGaussianProb(data,gaussMean,gaussCov)
    gaussMean = gaussMean';
    first = exp(-0.5*(data-gaussMean)' * inv(gaussCov)*(data-gaussMean));
    like = first/(((2*pi)^(size(data,1)/2))*det(gaussCov)^(1/2));
end
 
%==========================================================================
%==========================================================================

%the goal of this routine is to return the mean and covariance of a set of
%multidimensaional data.  It is assumed that each column of the 2D array
%data contains a single data point.  The mean vector should be a 3x1 vector
%with the mean RGB value.  The covariance should be a 3x3 covariance
%matrix. See the note at the top, which explains that using mean() is ok,
%but please compute the covariance yourself.

function [meanData covData] = fitGaussianModel(data)
    [nDim nData] = size(data);
    meanData = zeros(1,nDim);
     
    %Calculate the mean value
    for i = 1:nDim
        meanData(i) = mean(data(i,:));
    end
    
    %Substract with mean value
    for j = 1:nDim
        data(j,:) = data(j,:) - meanData(j);
    end
    
    covData = zeros(nDim);
    
    %row index
    for k = 1:nDim
        %column index
        for l = 1:nDim
            covData(k,l) = data(k,:) * (data(l,:)')/nData;
        end
    end
end


%calculate mean of data.  You can do this using the MATLAB command 'mean'
%calculate covariance of data.  You should do this yourself to ensure you
%understand how.  Check you have the right answer by comparing with the
%matlab command 'cov'.




