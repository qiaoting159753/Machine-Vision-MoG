function testing()
    %Load the images
    testIapples = cell(4,1);
    testIapples{1} = 'test1.jpg';
    testIapples{2} = 'test1_ground.png';
    testIapples{3} = 'test2.jpg';
    testIapples{4} = 'test2_ground.png';
    
    Input1 = double(imread(  testIapples{1}   )) / 255;
    Ground_Truth1 = double(imread(  testIapples{2}   )) / 255;
    
    Input2 = double(imread(  testIapples{3}   )) / 255;
    Ground_Truth2 = double(imread(  testIapples{4}   )) / 255;
    
    %Calculate the ROC curve.
    helper_ROC_curve(Input1,Ground_Truth1,'test1');
    helper_ROC_curve(Input2,Ground_Truth2,'test2');
    
    %Using the threshold from previous section
    output1 = helper_classify_image(Input1);
    output2 = helper_classify_image(Input2);
    
    threshold = 0.37;
    binary1 = im2bw(output1,threshold);
    binary2 = im2bw(output2,threshold);
    
    imwrite(binary1,'bi_thres_result1.png');
    imwrite(binary2,'bi_thres_result2.png');
end 


