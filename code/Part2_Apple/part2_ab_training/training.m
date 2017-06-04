function training()

    % Note that cells are accessed using curly-brackets {} instead of parentheses ().
    Iapples = cell(3,1);
    Iapples{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.jpg';
    Iapples{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.jpg';
    Iapples{3} = 'apples/bobbing-for-apples.jpg';

    IapplesMasks = cell(3,1);
    IapplesMasks{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.png';
    IapplesMasks{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.png';
    IapplesMasks{3} = 'apples/bobbing-for-apples.png';

    %Extract the data.
    apple = [];
    non_apple = [];
    
    %For each images pairs
    for iImage = 1:3
        curI = double(imread(  Iapples{iImage}   )) / 255;
        curImask = imread(  IapplesMasks{iImage}   );
        curImask = curImask(:,:,2) > 128;
        
        for row = 1: size(curI,1)
            for column = 1:size(curI,2)
                if curImask(row,column) == 1
                    apple = [apple,curI(row,column,:)];
                else
                    non_apple = [non_apple,curI(row,column,:)];
                end
            end
        end
    end 
    
    %Tide up the training set data
    apple = (squeeze(apple))';
    non_apple = (squeeze(non_apple))';
    
    num_apple = size(apple,2);
    num_non_apple = size(non_apple,2);
    
    %Work out the prior
    prior = num_apple / (num_apple + num_non_apple);
    
    %Fitting the Mixture of Gaussian model
    apple_mixGaussEst = helper_fitMixGauss(apple,3);
    non_apple_mixGaussEst = helper_fitMixGauss(non_apple,3);
    
    %Save the MoG parameters and priors.
    save('apple_GaussEst.mat','apple_mixGaussEst');
    save('non_apple_GaussEst.mat','non_apple_mixGaussEst');
    save('prior.mat','prior');
end
