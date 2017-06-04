function output = helper_classify_image(input)
    %Load the parameters from trained
    apple_est = load('apple_GaussEst.mat');
    non_apple_est = load('non_apple_GaussEst.mat');
    prior = load('prior.mat');
    
    apple_est = apple_est.apple_mixGaussEst;
    non_apple_est = non_apple_est.non_apple_mixGaussEst;
    
    %Loop all the pixels in the image
    img_size = size(input);
    output = zeros(img_size(1),img_size(2));
    
    %For each pixel
    for row = 1:img_size(1)
        for column = 1:img_size(2)
            data = input(row,column,:);
            data = squeeze(data);
            %Work out the likelihood for both apple and non-apple
            apple_prob = helper_calGaussProb(data,apple_est);
            non_apple_prob = helper_calGaussProb(data,non_apple_est);
            
            %Work out the posterior based on the likelihoods. The formula
            %is in the report and similar to the practicle 1 in part 1.
            
            posterior = (apple_prob * (prior.prior)) / ((apple_prob * (prior.prior)) + (non_apple_prob * (1 - prior.prior)));
            
            %Write to the new image
            output(row,column) = posterior;
        end
    end
end