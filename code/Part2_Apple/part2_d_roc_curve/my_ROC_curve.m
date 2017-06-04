function [min_value,min_thres] = my_ROC_curve()
    testIapples = cell(2,1);
    
    testIapples{1} = 'Bbr98ad4z0A-ctgXo3gdwu8-original.jpg';
    testIapples{2} = 'Bbr98ad4z0A-ctgXo3gdwu8-original.png';

    Input = double(imread(  testIapples{1}   )) / 255;
    Ground_Truth = double(imread(  testIapples{2}   )) / 255;

    dimens = size(Input);
    dimens2 = size(Ground_Truth);
    
    %Input and Ground_Truth must have same dimention
    if dimens ~= dimens2 
        return
    end
    
    %Binarlize the Ground Truth Image
    Ground_Truth = rgb2gray(Ground_Truth);
    Ground_Truth = im2bw(Ground_Truth,0);
    
    %define the number of thresholds between 0 to 1
    num_threshold = 100;
    
    %Vector used to store the TP,FP,TN,FN value for all thresholds
    TPA = zeros(1,num_threshold+1);
    FPA = zeros(1,num_threshold+1);
    TNA = zeros(1,num_threshold+1);
    FNA = zeros(1,num_threshold+1);
    
    %The posterior image 
    result_image = helper_classify_image(Input);
    
    %100 threshold
    for i = 0:num_threshold
        %Thresholding the image       
        bi_image = im2bw(result_image,i*(1/num_threshold));
        %For each pixel
        for row = 1:dimens(1)
            for column = 1:dimens(2)
                %True positive: result is the same as ground truth
                if (bi_image(row,column) ==1) && (Ground_Truth(row,column) == 1)
                    TPA(i+1) = TPA(i+1) + 1;
                end
                
                %False Positive: result is positive, but it is wrong
                if (bi_image(row,column) == 1) && (Ground_Truth(row,column) == 0)
                    FPA(i+1) = FPA(i+1) + 1;
                end
                
                %True Negative: The result is negative, the ground truth is
                %negative as well.
                if (bi_image(row,column) == 0) && (Ground_Truth(row,column) == 0)
                    TNA(i+1) = TNA(i+1) + 1;
                end
                
                %False Negative: The result is negative, the ground truth
                %is positive. 
                if (bi_image(row,column) == 0) && (Ground_Truth(row,column) == 1)
                    FNA(i+1) = FNA(i+1) + 1;
                end
            end
        end
    end
    
    %Calculate the true positive rate and false positive rate.
    TPRA = TPA ./ (TPA + FNA);
    FPRA = FPA ./ (FPA + TNA);
        
    %Plot the ROC curve
    figure
    plot(FPRA,TPRA);title('ROC_Curve');
        
    distance = ones(1,num_threshold);
    %Find the best threshold. Euclidean distance to the left top corner was used here.
    for i=1:(num_threshold+1)
        distance(1,i) = FPRA(1,i)^2 + (1-TPRA(1,i))^2;
    end

    [min_value, min_thres] = min(distance);
    min_thres = min_thres - 1;
    save('threshold.mat','min_thres');
    save('min_value.mat','min_value');
    
    %Display the result
    figure
    binary_img = im2bw(result_image,min_thres * (1/num_threshold));
    imshow(binary_img);
    imwrite(binary_img,'result.png');
end